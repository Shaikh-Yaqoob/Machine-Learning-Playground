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
% This script receives RGB images for training as input parameter and 
% separates the defects (spots) marked by an expert. It is a first step for 
% the extraction of color features with the objective of training a defect 
% classifier for fruits.
% This script is an intermediate step prior to obtaining numerical values 
% and is responsible for image preprocessing. From color images, it generates 
% binary images that will serve as masks for the extraction of color 
% characteristics of defects in fruits.
%
% Este script, recibe como parámetro de entrada imágenes RGB para entrenamiento 
% y separa los defectos (manchas) marcados por un experto. Es un primer paso 
% para la extracción de características de color con el ojetivo de entrenar 
% un clasificador de defectos para frutas.
% Este script, es un paso intermedio previo a la obtención de valores números, 
% se encarga de del preprocesado de imágenes. A partir de imágenes a color, 
% genera imágenes binarias que servirán como máscaras para la extracción de 
% características de color de defectos en las frutas.
%
%
% Usage:
% MainSegMarkExp.m
%
%

%% Initial parameter setting
clc; clear all; close all;
 
%% Setting script operating parameters
HOME=fullfile('C:','Users','Usuari','development','orange_classification');
mainPath=fullfile(HOME,'OrangeResults','byDefects','PSMet2','SegMarkExp');
configurationPath=fullfile(mainPath,'conf');
outputPath=fullfile(mainPath,'tmpToLearn'); % temporal data folder
configurationFile=fullfile(configurationPath,'20170916configuracion.xml'); % For initial coordinates in image processing
%TODO archivoCalibracion=fullfile(configurationPath,'20170916calibracion.xml'); % to indicate to the user in the final part the calibration
imageExtension='*.jpg';

%% Image processing settings
objectAreaBR=5000; % Area value to filter silhouettes and object detection (granulometry).
% Setting thresholds for LAB colour space values, % background thresholding
% parameters
LchannelMin = 0.0; LChannelMax = 96.653; AChannelMin = -23.548; AChannelMax = 16.303; BChannelMin = -28.235; BChannelMax = -1.169; 

%% Setting up the directory folder structure
% original dataset
pathImages=fullfile(HOME,'OrangeResults','inputToLearn');
pathImagesMasks=fullfile(HOME,'OrangeResults','inputMarked');
% pre-training dataset
pathImagesTraining=fullfile(HOME,'OrangeResults','inputTraining');

  
%% Definition of rectangles according to numbering
% Fila1=readConfiguration('Fila1', configurationFile);
% FilaAbajo=readConfiguration('FilaAbajo', configurationFile);

% Rectangle 1 downside
rectangle1_Y=readConfiguration('Cuadro1_lineaGuiaInicialFila', configurationFile);
rectangle1_X=readConfiguration('Cuadro1_lineaGuiaInicialColumna', configurationFile);
rectangle1_H=readConfiguration('Cuadro1_espacioFila', configurationFile);
rectangle1_W=readConfiguration('Cuadro1_espacioColumna', configurationFile);

% Rectangle 2 left side
rectangle2_Y=readConfiguration('Cuadro2_lineaGuiaInicialFila', configurationFile);
rectangle2_X=readConfiguration('Cuadro2_lineaGuiaInicialColumna', configurationFile);
rectangle2_H=readConfiguration('Cuadro2_espacioFila', configurationFile);
rectangle2_W=readConfiguration('Cuadro2_espacioColumna', configurationFile);

% Rectangle 3 center
rectangle3_Y=readConfiguration('Cuadro3_lineaGuiaInicialFila', configurationFile);
rectangle3_X=readConfiguration('Cuadro3_lineaGuiaInicialColumna', configurationFile);
rectangle3_H=readConfiguration('Cuadro3_espacioFila', configurationFile);
rectangle3_W=readConfiguration('Cuadro3_espacioColumna', configurationFile);

% Rectangle 4 right side
rectangle4_Y=readConfiguration('Cuadro4_lineaGuiaInicialFila', configurationFile);
rectangle4_X=readConfiguration('Cuadro4_lineaGuiaInicialColumna', configurationFile);
rectangle4_H=readConfiguration('Cuadro4_espacioFila', configurationFile);
rectangle4_W=readConfiguration('Cuadro4_espacioColumna', configurationFile);

%% Loading rectangles into memory to be fast
% Definition of a rectangle region
%[X,Y,W,H] top-left corner X,Y; W=horizontal width, H= vertical height
% * ---------> X
% |  (x,y)-----|
% |  |         |
% |  |------ W,H
% |
% Y
% V

rectangleList=[rectangle1_X, rectangle1_Y, rectangle1_W, rectangle1_H;
    rectangle2_X, rectangle2_Y, rectangle2_W, rectangle2_H;
    rectangle3_X, rectangle3_Y, rectangle3_W, rectangle3_H;
    rectangle4_X, rectangle4_Y, rectangle4_W, rectangle4_H;
    0,0,0,0
    ];

% Temporal data folder hierarchy
% 
%|__/HOME/DATASET/
%   |__/sFrutas
%   |__/ROIDefC
%   |__/ROIDefBin
%   |__/ROICalyxC
%   |__/ROICalyxBin
%   |__/MROI
%   |__/MRM
%   |__/MDefColor
%   |__/MDefBin
%   |__/MCalyxColor
%   |__/MCalyxBin
%   |__/ISFrutas
%   |__/IROI
%   |__/IRM
%   |__/IBR
%   |__/cDefectos
%   |__/cCalyx
%

%% Cleaning temporal files
% TODO: Create a script for definition of a folder hierarchy
% tmpToLearn/
fprintf('Cleaning old images \n');
delete(fullfile(outputPath,'sFrutas',imageExtension));
delete(fullfile(outputPath,'ROIDefC',imageExtension));
delete(fullfile(outputPath,'ROIDefBin',imageExtension));
delete(fullfile(outputPath,'ROICalyxC',imageExtension));
delete(fullfile(outputPath,'ROICalyxBin',imageExtension));
delete(fullfile(outputPath,'MROI',imageExtension));
delete(fullfile(outputPath,'MRM',imageExtension));
delete(fullfile(outputPath,'MDefColor',imageExtension));
delete(fullfile(outputPath,'MDefBin',imageExtension));
delete(fullfile(outputPath,'MCalyxColor',imageExtension));
delete(fullfile(outputPath,'MCalyxBin',imageExtension));
delete(fullfile(outputPath,'ISFrutas',imageExtension));
delete(fullfile(outputPath,'IROI',imageExtension));
delete(fullfile(outputPath,'IRM',imageExtension));
delete(fullfile(outputPath,'IBR',imageExtension));
delete(fullfile(outputPath,'cDefectos',imageExtension));
delete(fullfile(outputPath,'cCalyx',imageExtension));

%% Reading training folder with images. Iterates over training images (masks)
imageList=dir(fullfile(pathImagesTraining,imageExtension));
imageNameP='imageNameP';
listSize=size(imageList);
imageCount=listSize(1);
for n=1:imageCount
    fprintf('\n Separating regions marked manually for training -> %s \n',imageList(n).name);    
    imageNameP=imageList(n).name;
    %It is used to separate the marks made by experts, who segmented the defects in the fruits with blue color. At the same time, the original images are available, in order to obtain real characteristics of the defects in the fruits.
    ProcessMarks(pathImages, pathImagesTraining, outputPath, imageNameP, rectangleList, objectAreaBR, LchannelMin, LChannelMax, AChannelMin, AChannelMax, BChannelMin, BChannelMax )
    %Creates binary images, and colour segmented images
    ExtractMarkedRegions(pathImages, outputPath, imageNameP)
    % enable this for debug
    %if n==1
    %    break;
    %end;
end %

%% Printing summary report
fprintf('---------\n');
fprintf('Summary report \n');
fprintf('---------\n');
fprintf('The regions marked (masks) by the expert have been separated. \n');
fprintf('Temporal images obtained with this process can be analyzed in %s \n', outputPath);
fprintf('A total of %i images have been analyzed \n', imageCount);
fprintf('You must run the process to extract data from temporal images called "MainSegMarkExpExtraction.m"! \n');