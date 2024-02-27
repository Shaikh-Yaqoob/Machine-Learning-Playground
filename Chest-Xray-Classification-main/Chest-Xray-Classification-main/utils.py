import tarfile
import os
import random
import numpy as np
from tqdm import tqdm
import torch
from torchvision import transforms as T
from torchmetrics import Accuracy, ConfusionMatrix, AUROC
import matplotlib as mpl
mpl.rcParams["text.usetex"]=True
import matplotlib.pyplot as plt
from models import build_model
from sklearn.metrics import roc_auc_score


def untar_chestxray14(path_to_directory, output_directory):
    """
    Args:
        path_to_directory (str): path/to/tar/files
        output_directory (str): path/to/unatr
    """
    data_dir_list = os.listdir(path_to_directory)
    for file_name in tqdm(data_dir_list):
        if file_name.endswith(".tar.gz"):
            file_path = os.path.join(path_to_directory, file_name)
            with tarfile.open(file_path, "r") as tar:
                tar.extractall(path=output_directory)


def seed_it_all(seed=1234):
    """ Attempt to be Reproducible """
    os.environ['PYTHONHASHSEED'] = str(seed)
    random.seed(seed)
    np.random.seed(seed)
    torch.manual_seed(seed)
    torch.backends.cudnn.deterministic = True
    torch.backends.cudnn.benchmark = False
seed_it_all()

def my_transform(normalize, crop_size=224, resize=224, mode="train", test_augment=False):
    """Apply transforms on each sets

    Args:
        normalize (str): define the normalization based on which data | imagenet or chestx-ray or None
        crop_size (int, optional): crop size for random crop. Defaults to 208.
        resize (int, optional): resize all image to this size. Defaults to 224.
        mode (str, optional): select the transforms mode that applies on which data. Defaults to "train".
        test_augment (bool, optional): Whethere apply augmentation on test set or not. Defaults to False.
    """
    transformations_list = []

    if normalize.lower() == "imagenet":
        normalize = T.Normalize([0.485, 0.456, 0.406], [0.229, 0.224, 0.225])
    elif normalize.lower() == "chestx-ray":
        normalize = T.Normalize([0.5056, 0.5056, 0.5056], [0.252, 0.252, 0.252])
    elif normalize.lower() == "none":
        normalize = None
    else:
        print("mean and std for [{}] dataset do not exist!".format(normalize))
        exit(-1)
    if mode == "train":
        transformations_list.append(T.Resize((resize, resize)))
#         transformations_list.append(T.RandomResizedCrop(crop_size, scale=(0.8, 1.0)))
        transformations_list.append(T.RandomHorizontalFlip())
        transformations_list.append(T.RandomRotation(7))
        transformations_list.append(T.ToTensor())
        if normalize is not None:
            transformations_list.append(normalize)
    elif mode == "val":
        transformations_list.append(T.Resize((resize, resize)))
        transformations_list.append(T.CenterCrop(crop_size))
        transformations_list.append(T.ToTensor())
        if normalize is not None:
            transformations_list.append(normalize)
    elif mode == "test":
        if test_augment:
            transformations_list.append(T.Resize((resize, resize)))
            transformations_list.append(T.TenCrop(crop_size))
            transformations_list.append(
                T.Lambda(lambda crops: torch.stack([T.ToTensor()(crop) for crop in crops])))
            if normalize is not None:
                transformations_list.append(T.Lambda(lambda crops: torch.stack([normalize(crop) for crop in crops])))
        else:
            transformations_list.append(T.Resize((resize, resize)))
            transformations_list.append(T.CenterCrop(crop_size))
            transformations_list.append(T.ToTensor())
            if normalize is not None:
                transformations_list.append(normalize)
                
    transformsList = T.Compose(transformations_list)

    return transformsList


class AverageMeter(object):
    """Computes and stores the average and current value"""
    def __init__(self):
        self.reset()

    def reset(self):
        self.val = 0
        self.avg = 0
        self.sum = 0
        self.count = 0

    def update(self, val, n=1):
        self.val = val
        self.sum += val * n
        self.count += n
        self.avg = self.sum / self.count


def train_one_epoch(args, model, train_loader, loss_fn, optimizer, epoch=None):
    model.train()
    loss_train = AverageMeter()
    if not args.dataset_name == "JSRT":
        acc_train = Accuracy(task="multilabel", num_labels=args.num_classes).to(args.device)
    else:
        acc_train = Accuracy(task="multiclass", num_classes=args.num_classes).to(args.device)
        
    with tqdm(train_loader, unit="batch") as tepoch:
        for inputs, targets in tepoch:
            if epoch is not None:
                tepoch.set_description(f"Epoch {epoch}")
            inputs = inputs.to(args.device, dtype=torch.float)
            targets = targets.to(args.device, dtype=torch.float)

            optimizer.zero_grad()
            outputs = model(inputs)
            # print(outputs, outputs.shape, outputs.dtype)
            # print(targets, targets.shape, targets.dtype)
            loss = loss_fn(outputs, targets)
            loss.backward()
            optimizer.step()
            

            loss_train.update(loss.item())
            acc_train(outputs, targets.int())
            tepoch.set_postfix(loss=loss_train.avg, 
                               accuracy=100.*acc_train.compute().item())
    return model, loss_train.avg, acc_train.compute().item()


def validation(args, model, test_loader, loss_fn):
    model.eval()
    with torch.no_grad():
        loss_valid = AverageMeter()
        if not args.dataset_name == "JSRT":
            acc_valid = Accuracy(task="multilabel", num_labels=args.num_classes).to(args.device)
        else:
            acc_valid = Accuracy(task="multiclass", num_classes=args.num_classes).to(args.device)
        for i, (inputs, targets) in enumerate(test_loader):
            inputs = inputs.to(args.device, dtype=torch.float)
            targets = targets.to(args.device, dtype=torch.float)
            
            outputs = model(inputs)
            loss = loss_fn(outputs, targets)

            loss_valid.update(loss.item())
            acc_valid(outputs, targets.int())
    return loss_valid.avg, acc_valid.compute().item()


def plot_performance(args, loss_train_hist, loss_valid_hist, acc_train_hist, acc_valid_hist, epoch_counter):
    fig, ax1 = plt.subplots(figsize=(8, 4))

    ax1.set_title("Acc and Loss", fontsize=14)
    ax1.set_xlabel("Epoch", fontsize=14)
    ax1.set_ylabel("Loss", fontsize=14, color="black")
    ax1.plot(range(epoch_counter), loss_train_hist, lw=2, color="deepskyblue", label="Train Loss")
    ax1.plot(range(epoch_counter), loss_valid_hist, lw=2, color="yellow", label="Validation Loss")

    for label in ax1.get_yticklabels():
        label.set_color("black")

    ax2 = ax1.twinx()
    ax2.set_ylabel("Accuracy", fontsize=16, color="green")

    ax2.plot(range(epoch_counter), acc_train_hist, lw=2, color="turquoise", label="Train Acc")
    ax2.plot(range(epoch_counter), acc_valid_hist, lw=2, color="red", label='Validation Acc')
    for label in ax2.get_yticklabels():
        label.set_color("green")

    ax1.legend(loc='upper center')
    ax2.legend(loc='upper left')
    ax1.grid()
    
    fig.savefig(f"{str(args.plot_path)}", dpi=800)

def save_checkpoint(state, filename='model'):
    torch.save(state, filename + '.pth.tar')



def test_model(args, model, checkpoint, test_loader):
    model = build_model(args)
    # print(model)

    modelCheckpoint = torch.load(checkpoint)
    state_dict = modelCheckpoint['state_dict']
    for k in list(state_dict.keys()):
        if k.startswith('module.'):
            state_dict[k[len("module."):]] = state_dict[k]
            del state_dict[k]

    msg = model.load_state_dict(state_dict)
    assert len(msg.missing_keys) == 0
    print("=> loaded pre-trained model '{}'".format(checkpoint))
    
    model.to(args.device)
    model.eval()

    all_predictions = []
    all_targets = []

    with torch.no_grad():
        for inputs, targets in test_loader:
            inputs = inputs.to(args.device, dtype=torch.float)
            targets = targets.to(args.device, dtype=torch.float)
            outputs = model(inputs)

            predictions = torch.sigmoid(outputs)  # Apply sigmoid activation for multi-label classification
            
            all_predictions.append(predictions)
            all_targets.append(targets)

    all_predictions = torch.cat(all_predictions, dim=0)
    all_targets = torch.cat(all_targets, dim=0)
    
    accuracy = Accuracy(task="multilabel", num_labels=args.num_classes).to(args.device)
    # accuracy_value = accuracy(torch.round(all_predictions), all_targets)
    accuracy_value = accuracy(all_predictions, all_targets)
    
    # Calculate confusion matrix
    confusion_matrix = ConfusionMatrix(task="multilabel", num_labels=args.num_classes).to(args.device)
    confusion_matrix_value = confusion_matrix(torch.round(all_predictions), all_targets)
    # confusion_matrix_value = confusion_matrix(all_predictions, all_targets)
    
    auroc_mean = AUROC(task="multilabel", num_labels=args.num_classes, average="macro", thresholds=None)
    # auroc_ = AUROC(task="multilabel", num_labels=args.num_classes, average=None, thresholds=None)
    auroc_mean_value = auroc_mean(all_predictions, all_targets)
    
    return accuracy_value, confusion_matrix_value, auroc_mean_value


def test_classification(args, checkpoint, data_loader_test, ):
    model = build_model(args)
    # print(model)

    modelCheckpoint = torch.load(checkpoint)
    state_dict = modelCheckpoint['state_dict']
    for k in list(state_dict.keys()):
        if k.startswith('module.'):
            state_dict[k[len("module."):]] = state_dict[k]
            del state_dict[k]

    msg = model.load_state_dict(state_dict)
    assert len(msg.missing_keys) == 0
    print("=> loaded pre-trained model '{}'".format(checkpoint))
    
    model.to(args.device)
    model.eval()
    
    y_test = torch.FloatTensor().cuda()
    p_test = torch.FloatTensor().cuda()

    with torch.no_grad():
        for _, (samples, targets) in enumerate(tqdm(data_loader_test)):
            targets = targets.cuda()
            y_test = torch.cat((y_test, targets), 0)

            if len(samples.size()) == 4:
                bs, c, h, w = samples.size()
                n_crops = 1
            elif len(samples.size()) == 5:
                bs, n_crops, c, h, w = samples.size()

            varInput = torch.autograd.Variable(samples.view(-1, c, h, w).cuda())

            out = model(varInput)
            if args.dataset_name == "JSRT":
                out = torch.softmax(out,dim = 1)
            else:
                out = torch.sigmoid(out)
            outMean = out.view(bs, n_crops, -1).mean(1)
            p_test = torch.cat((p_test, outMean.data), 0)

    return y_test, p_test


def metric_AUROC(target, output, nb_classes=14):
    outAUROC = []

    target = target.cpu().numpy()
    output = output.cpu().numpy()

    for i in range(nb_classes):
        outAUROC.append(roc_auc_score(target[:, i], output[:, i]))

    return outAUROC
