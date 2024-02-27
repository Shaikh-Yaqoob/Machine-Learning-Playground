import argparse
import logging
import os
import numpy as np
import sys
from pathlib import Path
from tqdm import tqdm
import pandas as pd


import torch
import torch.nn as nn
import torch.optim as optim


from timm.scheduler import create_scheduler
from timm.optim import create_optimizer


from models import build_model
from utils import train_one_epoch, validation, save_checkpoint
from utils import plot_performance, test_classification, metric_AUROC

from torchmetrics.classification import MultilabelAccuracy
from torchmetrics.functional.classification import multilabel_auroc


def run_experiments(args, train_loader, val_loader, test_loader, model_path, output_path):

    accuracy = []
    mean_auc_all_runs = []

    for idx in range(args.num_trial):
        torch.cuda.empty_cache()
        model = build_model(args)
        model = model.to(args.device)
        
        # optimizer = optim.SGD(model.parameters(), lr=args.base_lr, momentum=0.9)
        optimizer = create_optimizer(args, model)        
        lr_scheduler, _ = create_scheduler(args, optimizer)       
        loss_fn = nn.BCEWithLogitsLoss()
        
        print (f"Run: {idx+1}\nstart training....")
        experiment = args.exp_name + "_run_" + str(idx+1)
        save_model_path = model_path.joinpath(experiment)
        args.plot_path = output_path / (experiment+ ".pdf")
        
        log_file_train = output_path.joinpath(f"run_{str(idx+1)}.log")
        logger1 = logging.getLogger("training_logger")
        logger1.setLevel(logging.INFO)  
        formatter = logging.Formatter("[%(asctime)s.%(msecs)03d] %(message)s",
                                      datefmt="%Y-%m-%d %H:%M:%S")    
        train_handler = logging.FileHandler(str(log_file_train), mode="a")
        train_handler.setFormatter(formatter)
        logger1.addHandler(train_handler)
        logger1.info(str(args))
        
        loss_train_hist = []
        loss_valid_hist = []
        acc_train_hist = []
        acc_valid_hist = []
        best_loss_valid = torch.inf
        epoch_counter = 0
        patience_counter = 0
        
        for epoch in range(epoch_counter, args.epochs):
            model, loss_train, acc_train = train_one_epoch(args, 
                                                            model, 
                                                            train_loader,
                                                            loss_fn,
                                                            optimizer)
            logger1.info(f"Run:{idx+1}-Epoch:{epoch+1}, TrainLoss:{loss_train:0.4f}, TrainAcc:{acc_train:0.4f}",
                         exc_info=True)
            
            loss_train_hist.append(loss_train)
            acc_train_hist.append(acc_train)
            
            print("start validation.....")
            loss_valid, acc_valid = validation(args, model, val_loader, loss_fn)
            logger1.info(f"Run:{idx+1}-Epoch:{epoch+1}, ValidLoss:{loss_valid:0.4f}, ValidAcc:{acc_valid:0.4f}", 
                         exc_info=True)
            

            loss_valid_hist.append(loss_valid)
            acc_valid_hist.append(acc_valid)
        
            if loss_valid < best_loss_valid:
                save_checkpoint({
                'epoch': epoch + 1,
                'lossMIN': best_loss_valid,
                'state_dict': model.state_dict(),
                'optimizer': optimizer.state_dict(),
                'scheduler': lr_scheduler.state_dict()
                }, filename=str(save_model_path))
                
                best_loss_valid = loss_valid
                print('Model Saved!')
                patience_counter = 0    
            else:
              print(f"Epoch {epoch+1}: val_loss did not improve from {best_loss_valid}")
              patience_counter += 1
          
            if patience_counter > args.patience:
                print("Early Stopping")
                for handler  in logger1.handlers:
                    handler.close()
                    logger1.removeHandler(handler)
                break
            
            epoch_counter += 1
            
        for handler  in logger1.handlers:
                handler.close()
                logger1.removeHandler(handler)
            
        plot_performance(args, loss_train_hist, loss_valid_hist, 
                         acc_train_hist, acc_valid_hist, epoch_counter)
        
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