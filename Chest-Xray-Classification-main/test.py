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


from dataloader import ChestXray14, JSRT
# from dataloader_v2 import ChestXray14
from utils import seed_it_all, my_transform

from utils import test_classification

from torchmetrics.classification import MultilabelAccuracy
from torchmetrics.functional.classification import multilabel_auroc


parser = argparse.ArgumentParser()
parser.add_argument("--dataset_name", type=str, default="ChestXray14",
                    help="ChestXray14|JSRT|ChestMNIST")
parser.add_argument("--model_name", type = str, default="resnet18", 
                    help="swin_base|swin_tiny|resnet18|resnet50")
parser.add_argument("--init", type=str, default="ImageNet",
                    help="False for Random| True for ImageNet")
parser.add_argument("--normalization", type=str, default="imagenet", 
                    help="how to normalize data (imagenet|chestx-ray)")
parser.add_argument("--num_classes", type=int,
                    default=14, help='number of labels')
parser.add_argument("--output_dir", type=str,
                    help='output dir')
parser.add_argument("--epochs", type=int, default=50,
                    help='maximum epoch number to train')
parser.add_argument("--batch_size", type=int, default=24,
                    help='batch_size per gpu')
parser.add_argument("--img_size", type=int, default=224,
                    help='input patch size of network input')
parser.add_argument("--seed", type=int, default=1234,
                    help='random seed')
parser.add_argument("--exp_name", type=str, default="exper",
                    help="experiment name")
parser.add_argument("--num_trial", type=int, default=5,
                    help="number of trials")
parser.add_argument("--device", type=str, default="cuda",
                    help="cpu|cuda")
parser.add_argument("--train_list", type=str, default="./Xray14_train_official.txt",
                    help="file for training list")
parser.add_argument("--val_list", type=str, default="./Xray14_val_official.txt",
                    help="file for validation list")
parser.add_argument("--test_list", type=str, default="./Xray14_test_official.txt",
                    help="file for test list")
parser.add_argument("--in_chans", type=int, default=3, 
                    help="input data channel numbers")
parser.add_argument("--dataset_path", type=str, default="/cabinet/reza/datasets/NIH_Chest_X_rays/images/",
                    help="dataset path")
parser.add_argument("--valid_start_epoch", type=int, default=79,
                    help="the validation process starts from this epoch")

# Optimizer
parser.add_argument("--opt", type=str, default="sgd",
                    help="Optimizer")
parser.add_argument("--lr", type=float,  default=1e-2,
                    help='classification network learning rate')
parser.add_argument("--opt-eps", default=1e-8, type=float, metavar='EPSILON',
                    help='Optimizer Epsilon')
parser.add_argument("--opt-betas", default=None, type=float, nargs='+', metavar='BETA',
                    help='Optimizer Betas (default: None, use opt default)')
parser.add_argument("--clip-grad", type=float, default=None, metavar='NORM',
                    help='Clip gradient norm (default: None, no clipping)')
parser.add_argument("--momentum", type=float, default=0.9, metavar='M',
                    help='SGD momentum')
parser.add_argument("--weight-decay", type=float, default=0.0,
                    help='weight decay')


# Learning rate schedule parameters
parser.add_argument("--sched", default='cosine', type=str, metavar='SCHEDULER',
                    help='LR scheduler (default: "cosine"')
parser.add_argument("--lr-noise", type=float, nargs='+', default=None, metavar='pct, pct',
                    help='learning rate noise on/off epoch percentages')
parser.add_argument("--lr-noise-pct", type=float, default=0.67, metavar='PERCENT',
                    help='learning rate noise limit percent')
parser.add_argument("--lr-noise-std", type=float, default=1.0, metavar='STDDEV',
                    help='learning rate noise std-dev')
parser.add_argument("--warmup-lr", type=float, default=1e-6, metavar='LR',
                    help='warmup learning rate')
parser.add_argument("--min-lr", type=float, default=1e-5, metavar='LR',
                    help='lower lr bound for cyclic schedulers that hit 0')
parser.add_argument("--decay-epochs", type=float, default=30, metavar='N',
                    help='epoch interval to decay LR')
parser.add_argument("--warmup-epochs", type=int, default=20, metavar='N',
                    help='epochs to warmup LR, if scheduler supports')
parser.add_argument("--cooldown-epochs", type=int, default=10, metavar='N',
                    help='epochs to cooldown LR at min_lr, after cyclic schedule ends')
parser.add_argument("--decay-rate", "--dr", type=float, default=0.5, metavar='RATE',
                    help='LR decay rate')

# Early stopping
parser.add_argument("--patience", default=10, type=int,
                    help="num of patient epoches")

args = parser.parse_args()


if __name__ == "__main__":
    
    if args.device == "cuda":
        args.device = "cuda" if torch.cuda.is_available() else "cpu"
    
    args.dataset_name == "ChestXray14"
    
    seed_it_all(args.seed)
    train_set = ChestXray14(images_path=args.dataset_path, list_path=args.train_list, num_class=args.num_classes, 
                            transform=my_transform(normalize=args.normalization, mode="train"))
    val_set = ChestXray14(images_path=args.dataset_path, list_path=args.val_list, num_class=args.num_classes, 
                            transform=my_transform(normalize=args.normalization, mode="val"))
    test_set = ChestXray14(images_path=args.dataset_path, list_path=args.test_list, num_class=args.num_classes, 
                            transform=my_transform(normalize=args.normalization, mode="test"))

    train_loader = DataLoader(dataset=train_set, batch_size=24, shuffle=True)
    val_loader = DataLoader(dataset=val_set, batch_size=24, shuffle=False)
    test_loader = DataLoader(dataset=test_set, batch_size=24, shuffle=False)
    
    # model_names = ["swin_tiny", "resnet18", "resnet50", "swin_base"]
    # init_weights = ["ImageNet", "Random"]

    args.model_name = "swin_tiny"
    args.init = "ImageNet"
    print(f"\n\nRunning model {args.model_name} with {args.init} weights.\n")
    args.exp_name = "exper"
    args.exp_name = args.model_name + "_" + args.init + "_" + args.exp_name
    model_path = Path("./Models").joinpath(args.dataset_name, args.exp_name)
    output_path = Path("./Outputs").joinpath(args.dataset_name, args.exp_name)
    model_path.mkdir(parents=True, exist_ok=True)
    output_path.mkdir(parents=True, exist_ok=True)
    

    accuracy = []
    mean_auc_all_runs = []
    
    idx = 0
    
    experiment = args.exp_name + "_run_" + str(idx+1)
    save_model_path = model_path.joinpath(experiment)
    
    print ("start testing.....")
    log_file_results = output_path.joinpath(f"results_run_{str(idx+1)}.log")
    logger2 = logging.getLogger("results_logger")
    logger2.setLevel(logging.INFO)
    formatter = logging.Formatter("[%(asctime)s.%(msecs)03d] %(message)s",
                                    datefmt="%Y-%m-%d %H:%M:%S")
    test_handler = logging.FileHandler(str(log_file_results), mode="a")
    test_handler.setFormatter(formatter)
    logger2.addHandler(test_handler)
    
    saved_model = model_path.joinpath(f"{experiment}.pth.tar")
    
    y_test, p_test = test_classification(args, str(saved_model), test_loader)
    print(y_test.dtype, p_test.dtype, y_test.shape, p_test.shape)
    
    mla_acc_indv = MultilabelAccuracy(num_labels=args.num_classes, average=None).to(args.device)
    mla_acc = MultilabelAccuracy(num_labels=args.num_classes).to(args.device)
    individual_acc = mla_acc_indv(p_test, y_test).cpu().numpy()
    acc = mla_acc(p_test, y_test).cpu().numpy()
    
    print(">>{}: ACC_ClassWise = {}\n".format(experiment, np.array2string(individual_acc, precision=4, separator='\t')))
    logger2.info("{}: ACC_ClassWise = {}\n".format(experiment, np.array2string(individual_acc, precision=4, separator='\t')))
    print(">>{}: ACC_All_Classes = {}\n".format(experiment, np.array2string(acc, precision=4, separator='\t')))
    logger2.info("{}: ACC_All_Classes = {}\n".format(experiment, np.array2string(acc, precision=4, separator='\t')))
    
    auroc_mean = multilabel_auroc(p_test, y_test, num_labels=args.num_classes,
                                average="macro").cpu().numpy()
    auroc_individual = multilabel_auroc(p_test, y_test, num_labels=args.num_classes,
                                average=None).cpu().numpy()
    
        
    print(">>{}: AUC_ClassWise = {}".format(experiment, np.array2string(auroc_individual, precision=4, separator=',')))
    logger2.info("{}: AUC_ClassWise = {}\n".format(experiment, np.array2string(auroc_individual, precision=4, separator='\t')))
    
    print(">>{}: AUC_All_Classes = {:.4f}".format(experiment, auroc_mean))
    logger2.info("{}: AUC_All_Classes = {:.4f}\n".format(experiment, auroc_mean))

    accuracy.append(acc.tolist())
    mean_auc_all_runs.append(auroc_mean.tolist())
    
    accuracy = np.array(accuracy)
    mean_auc_all_runs = np.array(mean_auc_all_runs)

    print(">> All trials on all classes: ACC  = {}".format(np.array2string(accuracy, precision=4, separator=',')))
    logger2.info("All trials on all classes: ACC  = {}\n".format(np.array2string(accuracy, precision=4, separator='\t')))
    print(">> Mean ACC over All trials: = {:0.4f}".format(np.mean(accuracy)))
    logger2.info("Mean ACC over All trials = {:0.4f}\n".format(np.mean(accuracy)))
    print(">> ACC_STD over All trials:  = {:0.4f}".format(np.std(accuracy)))
    logger2.info("ACC_STD over All trials:  = {:0.4f}\n".format(np.std(accuracy)))

    print(">> All trials on all classes: AUC  = {}".format(np.array2string(mean_auc_all_runs, precision=4, separator=',')))
    logger2.info("All trials on all classes: AUC  = {}\n".format(np.array2string(mean_auc_all_runs, precision=4, separator='\t')))
    print(">> Mean AUC over All trials: = {:0.4f}".format(np.mean(mean_auc_all_runs)))
    logger2.info("Mean AUC over All trials = {:0.4f}\n".format(np.mean(mean_auc_all_runs)))
    print(">> AUC_STD over All trials:  = {:0.4f}".format(np.std(mean_auc_all_runs)))
    logger2.info("AUC_STD over All trials:  = {:0.4f}\n".format(np.std(mean_auc_all_runs)))

    for handler  in logger2.handlers:
        handler.close()
        logger2.removeHandler(handler)
