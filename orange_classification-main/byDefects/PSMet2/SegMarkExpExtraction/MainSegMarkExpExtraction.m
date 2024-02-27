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
%{
Generates files with geometric and color characteristics (values
numerical) for defects and calyx in fruits. The numerical values are
used to obtain data on: color, texture and geometry of the
defects and calyx.

This script assumes that there was a previous processing, in which
images from color marks drawn by an expert. For which the
preprocessing to generate images of defects and calyx in fruits
It can be done with the "MainSegMarkExp.m" program.

Each image in a base directory has subimages of regions and
silhouette images. Example:
* 001.jpg is the main image, there are images of regions R1..R4
for defects and in turn there are specific images for their silhouettes
of defects.

Genera archivos con características geométricas y de color (valores 
numéricos) para  defectos y calyx en frutas. Los valores numéricos son 
utilizados para obtener datos de: color, textura y geometria de los 
defectos y calyx.

Este script asume que hubo un procesamiento previo, en el cual se generaron
imágenes desde marcas en colores dibujadas por un experto. Por lo cual el 
procesado previo para generar imágenes de defectos y calyx en frutas 
puede hacerse con el programa "MainSegMarkExp.m".

Cada imagen en un directorio base, cuenta con sub imágenes de regiones e 
imágenes de siluetas. Ejemplo:
* 001.jpg es la imagen principal, existen imágenes de las regiones R1..R4
para lo defectos y a su vez exiten imágenes específicas para sus siluetas
de defectos.

%}
% Usage:
% MainSegMarkExpExtraction.m
%


%% Initial parameter setting
clc; clear all; close all;
 
%% Defining the directory structure
HOME=fullfile('C:','Users','Usuari','development','orange_classification');
mainPath=fullfile(HOME,'OrangeResults', 'byDefects','PSMet2','SegMarkExpExtraction');
% Takes as input images generated in a previous step with MainSegMarkExp.m
inputPath=fullfile(HOME,'OrangeResults','byDefects','PSMet2','SegMarkExp');
pathImagesTraining=fullfile(HOME,'OrangeResults','inputTraining');
outputPath=fullfile(inputPath,'tmpToLearn'); % temporal data folder
imageFormat='.jpg';
imageFilter=strcat('*',imageFormat);

%% Definicion de variables para resguardo de defectos y calyx
pathcDefectos=fullfile(outputPath,'cDefectos'); %defectos en color
pathDefBinary=fullfile(outputPath,'MDefBin'); % binary defects masks with background removed in regions 1..4
 
pathColourCalyx=fullfile(outputPath,'cCalyx'); % to keep the calyx in colour
pathBinaryCalyx=fullfile(outputPath,'MCalyxBin'); % binary calyx masks with background removed in regions 1..4

% color de defectos para las regiones R1..R4
suffixDefects1=strcat('_soC1',imageFormat);
suffixDefects2=strcat('_soC2',imageFormat);
suffixDefects3=strcat('_soC3',imageFormat);
suffixDefects4=strcat('_soC4',imageFormat);
  
% siluetas defectos para las regiones R1..R4
suffixDefBin1=strcat('_DEFB1',imageFormat);
suffixDefBin2=strcat('_DEFB2',imageFormat);
suffixDefBin3=strcat('_DEFB3',imageFormat);
suffixDefBin4=strcat('_DEFB4',imageFormat);

% COLOR DE CALYX
suffixCalyxColor1=strcat('_CALC1',imageFormat);
suffixCalyxColor2=strcat('_CALC2',imageFormat);
suffixCalyxColor3=strcat('_CALC3',imageFormat);
suffixCalyxColor4=strcat('_CALC4',imageFormat);
  
% BINARIO DE CALYX
suffixCalyxBin1=strcat('_CALB1',imageFormat);
suffixCalyxBin2=strcat('_CALB2',imageFormat);
suffixCalyxBin3=strcat('_CALB3',imageFormat);
suffixCalyxBin4=strcat('_CALB4',imageFormat);
 
outputResults=fullfile(mainPath,'output');% directory for folders
fileDBDefectsCalyx=fullfile(outputResults,'BDDEFECTOSCALYX.csv'); %both labels: DEFECTS AND CALYX

%% Removing old features files
delete(fileDBDefectsCalyx);

%% Reading training folder with images. Iterates over training images (masks)
imageList=dir(fullfile(pathImagesTraining,imageFilter));
imageNameP='imageNameP';
listSize=size(imageList);
imageCount=listSize(1);

%% Reading training folder with images. Iterates over training images (masks)
for n=1:size(imageList)
    fprintf('Extracting numerical features for training-> %s \n',imageList(n).name);
    originalImage=imageList(n).name;
    
    %% Image processing for calyx in colour and binary images
    % It is assumed that there are images with or without defects for each region.
    % R1..R4.
    imageNameColourCalyx1=fullfile(pathColourCalyx,strcat(originalImage,suffixCalyxColor1));
    imageNameColourCalyx2=fullfile(pathColourCalyx,strcat(originalImage,suffixCalyxColor2));
    imageNameColourCalyx3=fullfile(pathColourCalyx,strcat(originalImage,suffixCalyxColor3));
    imageNameColourCalyx4=fullfile(pathColourCalyx,strcat(originalImage,suffixCalyxColor4));
    
    imageNameBinCalyx1=fullfile(pathBinaryCalyx,strcat(originalImage,suffixCalyxBin1));
    imageNameBinCalyx2=fullfile(pathBinaryCalyx,strcat(originalImage,suffixCalyxBin2));
    imageNameBinCalyx3=fullfile(pathBinaryCalyx,strcat(originalImage,suffixCalyxBin3));
    imageNameBinCalyx4=fullfile(pathBinaryCalyx,strcat(originalImage,suffixCalyxBin4));
    
    %% Calyx features extraction
    label='CALYX';
    defectDetectionExp( 1, imageNameBinCalyx1, imageNameColourCalyx1, fileDBDefectsCalyx, originalImage, label);
    defectDetectionExp( 2, imageNameBinCalyx2, imageNameColourCalyx2, fileDBDefectsCalyx, originalImage, label);
    defectDetectionExp( 3, imageNameBinCalyx3, imageNameColourCalyx3, fileDBDefectsCalyx, originalImage, label);
    defectDetectionExp( 4, imageNameBinCalyx4, imageNameColourCalyx4, fileDBDefectsCalyx, originalImage, label);
    
    %% Image processing for defects in colour and binary images
    % It is assumed that there are images with or without defects for each region.
    % R1..R4.    
    imageNameColourDefects1=fullfile(pathcDefectos,strcat(originalImage,suffixDefects1));
    imageNameColourDefects2=fullfile(pathcDefectos,strcat(originalImage,suffixDefects2));
    imageNameColourDefects3=fullfile(pathcDefectos,strcat(originalImage,suffixDefects3));
    imageNameColourDefects4=fullfile(pathcDefectos,strcat(originalImage,suffixDefects4));   
    
    imageNameBinDefects1=fullfile(pathDefBinary,strcat(originalImage, suffixDefBin1));
    imageNameBinDefects2=fullfile(pathDefBinary,strcat(originalImage, suffixDefBin2));
    imageNameBinDefects3=fullfile(pathDefBinary,strcat(originalImage, suffixDefBin3));
    imageNameBinDefects4=fullfile(pathDefBinary,strcat(originalImage, suffixDefBin4));
    
    
    %% Defects features extraction    
    label='DEFECTOS'; % TODO, change label to DEFECT
    defectDetectionExp( 1, imageNameBinDefects1, imageNameColourDefects1, fileDBDefectsCalyx, originalImage, label);
    defectDetectionExp( 2, imageNameBinDefects2, imageNameColourDefects2, fileDBDefectsCalyx, originalImage, label);
    defectDetectionExp( 3, imageNameBinDefects3, imageNameColourDefects3, fileDBDefectsCalyx, originalImage, label);
    defectDetectionExp( 4, imageNameBinDefects4, imageNameColourDefects4, fileDBDefectsCalyx, originalImage, label);    
    %if n==1
    %     break;
    %end;
end

%% Printing summary report
fprintf('---------\n');
fprintf('Summary report \n');
fprintf('---------\n');
fprintf('Temporal images obtained with this process can be analyzed in %s \n', outputPath);
fprintf('A total of %i images have been analyzed from %s \n', imageCount, pathImagesTraining);
fprintf('The regions marked (masks) by the expert have been converted to numerical values (features). \n');
fprintf('DEFECTS have been saved in file  %s \n', fileDBDefectsCalyx);
fprintf('You must run the process to evaluate images "XXXX.m"! \n');