%
% Project: AUTOMATIC CLASSIFICATION OF ORANGES BY SIZE AND DEFECTS USING 
% COMPUTER VISION TECHNIQUES
%
% Author: Juan Carlos Miranda. https://github.com/juancarlosmiranda/
% Date: 2018
% Update:  December 2023
%
% Description:
%
% Training and Test Set Builder
% Starting from a data set with images taken with a camera, it randomly 
% divides the files to create test and training sets.
% The initial dataset, for each image, has an RGB image and its 
% corresponding binary mask marked by an expert. That is, the original 
% 001.jpg corresponds to a binary mask 001.jpg marked by the expert.
%
% Creador de conjuntos de entrenamiento y pruebas
% A partir de un conjunto de datos con imágenes tomadas con una cámara, 
% divide reparte al azar los arhivos para creat conjuntos de pruebas y de entrenamiento.
% El dataset inicial, por cada imágenes se cuenta con una imagen RGB y su 
% correspondiente máscara binaria marcada por un experto. Es decir 
% 001.jpg original tiene correspondencia con una máscara binaria 001.jpg 
% marcada por el experto.

% INPUT: DATSET with images and masks
% OUTPUT: Daataset with images for test and training in folders.

% Use:
% 
% Configure DATASET
% MainSetCreator.m
% 

%% Initial parameter setting
clc; clear all; close all;

% IMPORTANT!!! CONFIGURE HERE THE MAIN FOLDER FOR YOUR PROJECT
HOME=fullfile('C:','Users','Usuari','development','orange_classification');
mainPath=fullfile(HOME,'OrangeResults','byDefects','PSMet2','SetCreator');
outputPath=fullfile(mainPath,'output');

%% Definition of script operating parameters
trainingRatio=70;
imageExtension='*.jpg';

%% dataset hierarchy
%|__/DATASET/
%       |__/inputToLearn/ -> RGB images
%       |__/inputMarked/ -> RGB images with masks
%
%|__/PREPROCESSED_DATASET/
%       |__/inputTest -> folder with images for tests
%       |__/inputTraining -> folder with images for training.


%% Defining the directory structure
% original dataset
pathImages=fullfile(HOME,'OrangeResults','inputToLearn'); % imagenes originales, inputMarked imagenes marcadas por experto DATASET
pathImagesMasks=fullfile(HOME,'OrangeResults','inputMarked');
% pre-training dataset
pathImagesTest=fullfile(HOME,'OrangeResults','inputTest');
pathImagesTraining=fullfile(HOME,'OrangeResults','inputTraining');


% gets a ist with filenames 
imageList=dir(fullfile(pathImages,imageExtension));
[tableDSTraining, tableDSTest]=SplitImageSet( imageList, trainingRatio, mainPath, outputPath);


%% Deleteing old files to create a new dataset for test and training
% test files
testFiles=fullfile(pathImagesTest,imageExtension);
delete(testFiles);
% training files
trainingFiles=fullfile(pathImagesTraining,imageExtension);
delete(trainingFiles);


copyDirectory( tableDSTest, pathImages, pathImagesTest); % copying RGB images for test
copyDirectory( tableDSTraining, pathImagesMasks, pathImagesTraining); % copying images of masks for training
%% -------------------------------------------------------------------