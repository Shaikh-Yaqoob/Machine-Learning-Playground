import argparse
import logging
import os
import numpy as np
import sys
from pathlib import Path
from tqdm import tqdm
import pandas as pd

import medmnist
from medmnist import INFO
import torch
import torch.nn as nn
import torch.optim as optim
from torch.utils.data import random_split, DataLoader
from torchvision import transforms as T
from torchvision.utils import make_grid

import matplotlib as mpl
mpl.rcParams["text.usetex"] = True
import matplotlib.pyplot as plt

from dataloader import ChestXray14, JSRT
from models import build_model
from utils import seed_it_all, train_one_epoch, validation, save_checkpoint, my_transform
from utils import plot_performance, test_model, test_classification, metric_AUROC

from torchinfo import summary
from sklearn.metrics import accuracy_score



parser = argparse.ArgumentParser()
parser.add_argument("--dataset_name", type=str, default="ChestMNIST",
                    help="ChestXray14|JSRT|ChestMNIST")
parser.add_argument("--model_name", type = str, default="resnet18", 
                    help="swin_base|swin_tiny|resnet18|resnet50")
parser.add_argument("--isinit", type=bool, default=True,
                    help="False for Random| True for ImageNet")
parser.add_argument("--normalization", type=str, default="imagenet", 
                    help="how to normalize data (imagenet|chestx-ray)")
parser.add_argument('--num_classes', type=int,
                    default=14, help='number of labels')
parser.add_argument('--output_dir', type=str,
                    help='output dir')
parser.add_argument('--max_epochs', type=int, default=2,
                    help='maximum epoch number to train')
parser.add_argument('--batch_size', type=int, default=24,
                    help='batch_size per gpu')
parser.add_argument('--base_lr', type=float,  default=0.01,
                    help='classification network learning rate')
parser.add_argument('--img_size', type=int, default=224,
                    help='input patch size of network input')
parser.add_argument('--seed', type=int, default=1234,
                    help='random seed')
parser.add_argument("--exp_name", type=str, default="test",
                    help="experiment name")
parser.add_argument("--num_trial", type=int, default=2,
                    help="number of trials")
parser.add_argument("--device", type=str, default="cuda",
                    help="cpu|cuda")
parser.add_argument("--train_list", type=str, default=None,
                    help="file for training list")
parser.add_argument("--val_list", type=str, default=None,
                    help="file for validation list")
parser.add_argument("--test_list", type=str, default=None,
                    help="file for test list")
parser.add_argument("--in_chans", type=int, default=1, 
                    help="input data channel numbers")
parser.add_argument("--dataset_path", type=str, default="./images",
                    help="dataset path")

args = parser.parse_args()


if __name__ == "__main__":
    
    args.init = "ImageNet" if args.isinit else "Random"
    args.exp_name = args.model_name + "_" + args.init + "_" + args.exp_name
    model_path = Path("./Models").joinpath(args.dataset_name, args.exp_name)
    output_path = Path("./Outputs").joinpath(args.dataset_name, args.exp_name)
    model_path.mkdir(parents=True, exist_ok=True)
    output_path.mkdir(parents=True, exist_ok=True)
    
    seed_it_all(args.seed)
    
    if args.device == "cuda":
        args.device = "cuda" if torch.cuda.is_available() else "cpu"
    
    if args.dataset_name == "ChestMNIST":
        data_flag = args.dataset_name.lower()
        info = INFO[data_flag]
        task = info["task"]
        n_channels = info['n_channels']
        n_classes = len(info['label'])
        samples = info["n_samples"]
        DataClass = getattr(medmnist, info["python_class"])
        print(DataClass)

        size = 224
        data_transform = T.Compose([
            T.ToTensor(),
            T.Normalize(mean=[.5], std=[.5]),
            T.Resize((size, size))
        ])
        train_set = DataClass(split="train", transform=data_transform ,download=True)
        val_set = DataClass(split="val", transform=data_transform, download=True)
        test_set = DataClass(split="test", transform=data_transform, download=True)
        
        
        _, mini_train_set = random_split(val_set, (0.8, 0.2))
        print(len(mini_train_set))
        train_loader = DataLoader(dataset=mini_train_set, batch_size=16, shuffle=True)
        data, label = next(iter(train_loader))
        
        img_grid = make_grid(data, nrow=8, normalize=True).permute(1, 2, 0)
        plt.figure(figsize=(12, 6))
        plt.imshow(img_grid)
        plt.axis('off')
        plt.savefig("RandomSamples.pdf", dpi=800)
        
        ## Model
        torch.cuda.empty_cache()
        model = build_model(args)
        model = model.to(args.device)
        # summury = summary(model=model,
        #         input_size=data.shape,
        #         col_names=["input_size", "output_size", "num_params", "trainable"],
        #         col_width=18,
        #         row_settings=["var_names"]
        # )
        # print(summary)
        
        
        optimizer = optim.SGD(model.parameters(), lr=args.base_lr, momentum=0.9)
        loss_fn = nn.BCEWithLogitsLoss()
        accuracy = []
        mean_auc = []

        for idx in range(args.num_trial):
            print (f"Run: {idx+1}")
            experiment = args.exp_name + "_run_" + str(idx+1)
            save_model_path = model_path.joinpath(experiment)
            args.plot_path = model_path / (experiment+ ".pdf")
            # print(str(args.plot_path))
            
            log_file = model_path.joinpath(f"run_{str(idx+1)}.log")
            # print(log_file)
            logging.basicConfig(filename=log_file, level=logging.INFO, filemode='w',
                            format='[%(asctime)s.%(msecs)03d] %(message)s', datefmt='%H:%M:%S')
            # logging.getLogger().addHandler(logging.StreamHandler(sys.stdout))
            logging.info(str(args))
            
            loss_train_hist = []
            loss_valid_hist = []
            acc_train_hist = []
            acc_valid_hist = []
            best_loss_valid = torch.inf
            epoch_counter = 0
            for epoch in range(epoch_counter, args.max_epochs):
                model, loss_train, acc_train = train_one_epoch(args, 
                                                               model, 
                                                               train_loader,
                                                               loss_fn,
                                                               optimizer)
                logging.info(f"Epoch:{epoch+1}, TrainLoss:{loss_train:0.4f}, TrainAcc:{acc_train:0.4f}")
                
                print("start validation.....")
                loss_valid, acc_valid = validation(args, model, train_loader, loss_fn)
                logging.info(f"Epoch:{epoch+1}, ValidLoss:{loss_valid:0.4f}, ValidAcc:{acc_valid:0.4f}")
                # print(f"Epoch:{epoch+1}, ValidLoss = {loss_valid:0.4f}, ValidAcc = {acc_valid:0.4f}")
                
                loss_train_hist.append(loss_train)
                loss_valid_hist.append(loss_valid)
                acc_train_hist.append(acc_train)
                acc_valid_hist.append(acc_valid)
                
                if loss_valid < best_loss_valid:
                    save_checkpoint({
                    'epoch': epoch + 1,
                    'lossMIN': best_loss_valid,
                    'state_dict': model.state_dict(),
                    'optimizer': optimizer.state_dict(),
                    # 'scheduler': lr_scheduler.state_dict()
                    }, filename=str(save_model_path))
                    
                    # torch.save(model, f'model.pt')
                    best_loss_valid = loss_valid
                    print('Model Saved!')
                    
                epoch_counter += 1
                
            plot_performance(args, loss_train_hist, loss_valid_hist,
                             acc_train_hist, acc_valid_hist, epoch_counter)
            
            print ("start testing.....")
            output_file = os.path.join(output_path, args.exp_name + "_results.txt")
            saved_model = model_path.joinpath(f"{experiment}.pth.tar")
            
            # acc, confusion_matrix, auroc = test_model(args, model, str(saved_model), train_loader)
        #     print(f">>{experiment}: ACC = {acc:0.4f}")
        #     accuracy.append(acc)
        #     print(f">>{experiment}: AUC = {auroc:0.4f}")
        #     mean_auc.append(auroc)
    
        # mean_auc = np.array(mean_auc)
        # print(f">> All trials: mAUC  = {np.array2string(mean_auc, precision=4, separator=',')}")
        # logging.info("All trials: mAUC  = {}\n".format(np.array2string(mean_auc, precision=4, separator='\t')))
        # print(f">> Mean AUC over All trials: = {np.mean(mean_auc):0.4f}")
        # logging.info("Mean AUC over All trials = {:.4f}\n".format(np.mean(mean_auc)))
        # print(f">> STD over All trials:  = {np.std(mean_auc):0.4f}")
        # logging.info("STD over All trials:  = {:.4f}\n".format(np.std(mean_auc)))
        
            y_test, p_test = test_classification(args, str(saved_model), train_loader)
            
            if args.dataset_name == "RSNAPneumonia":
                acc = accuracy_score(np.argmax(y_test.cpu().numpy(),axis=1),np.argmax(p_test.cpu().numpy(),axis=1))
                print(">>{}: ACCURACY = {}".format(experiment,acc))
                logging.info("{}: ACCURACY = {}\n".format(experiment, np.array2string(np.array(acc), precision=4, separator='\t')))
                accuracy.append(acc)
            individual_results = metric_AUROC(y_test, p_test, args.num_classes)
            
            print(">>{}: AUC = {}".format(experiment, np.array2string(np.array(individual_results), precision=4, separator=',')))
            logging.info("{}: AUC = {}\n".format(experiment, np.array2string(np.array(individual_results), precision=4, separator='\t')))
            
            mean_over_all_classes = np.array(individual_results).mean()
            print(">>{}: AUC = {:.4f}".format(experiment, mean_over_all_classes))
            logging.info("{}: AUC = {:.4f}\n".format(experiment, mean_over_all_classes))

            mean_auc.append(mean_over_all_classes)

        mean_auc = np.array(mean_auc)
        print(">> All trials: mAUC  = {}".format(np.array2string(mean_auc, precision=4, separator=',')))
        logging.info("All trials: mAUC  = {}\n".format(np.array2string(mean_auc, precision=4, separator='\t')))
        print(">> Mean AUC over All trials: = {:0.4f}".format(np.mean(mean_auc)))
        logging.info("Mean AUC over All trials = {:0.4f}\n".format(np.mean(mean_auc)))
        print(">> STD over All trials:  = {:0.4f}".format(np.std(mean_auc)))
        logging.info("STD over All trials:  = {:0.4f}\n".format(np.std(mean_auc)))



    elif args.dataset_name == "ChestXray14":
        train_set = ChestXray14(images_path="./images", list_path=args.train_list, num_class=args.num_classes, 
                                transform=my_transform(normalize=args.normalization, mode="train"))
        val_set = ChestXray14(images_path="./images", list_path=args.val_list, num_class=args.num_classes, 
                              transform=my_transform(normalize=args.normalization, mode="val"))
        test_set = ChestXray14(images_path="./images", list_path=args.test_list, num_class=args.num_classes, 
                               transform=my_transform(normalize=args.normalization, mode="test"))

        train_loader = DataLoader(dataset=train_set, batch_size=24, shuffle=True)
        val_loader = DataLoader(dataset=val_set, batch_size=24, shuffle=False)
        test_loader = DataLoader(dataset=test_set, batch_size=24, shuffle=False)
    
    elif args.dataset_name == "JSRT":
        pass
    
    else:
        print(f"Not implemented for {args.dataset_name} dataset.")
        raise Exception("Please provide correct dataset name to load!")
