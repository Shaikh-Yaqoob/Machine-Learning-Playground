import os
import numpy as np
import torch
from PIL import Image
from torch.utils.data import Dataset


class ChestXray14(Dataset):
    def __init__(self, images_path="./images", list_path="./", num_class=14, transform=None):
        self.img_list = []
        self.img_label = []
        self.transform = transform

        with open(list_path, "r") as file:
            for line in file.readlines():
                lineItems = line.split()
                imagePath = os.path.join(images_path, lineItems[0])
                imageLabel = lineItems[1:num_class + 1]
                imageLabel = [int(i) for i in imageLabel]
                self.img_list.append(imagePath)
                self.img_label.append(imageLabel)
    
    def __getitem__(self, idx):
        imagePath = self.img_list[idx]
        imageData = Image.open(imagePath).convert('RGB')
        imageLabel = torch.FloatTensor(self.img_label[idx])
        
        if self.transform != None:
            imageData = self.transform(imageData)
            
        return imageData, imageLabel
    
    def __len__(self,):
        return len(self.img_list)


class JSRT(Dataset):
    def __init__(self,):
        pass
    def __getitem__(self, ):
        pass
    def __len__(self,):
        pass
