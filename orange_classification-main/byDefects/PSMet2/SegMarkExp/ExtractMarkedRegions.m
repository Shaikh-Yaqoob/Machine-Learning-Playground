function [ ] = ExtractMarkedRegions(inputPath, mainPath, imageNameP)
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
% Usage:
%
%
% Extracts the defects of the oranges, generates as output a file with data 
% separated by commas and generates intermediate images with the defects in, 
% the fruit and the defects, the outline of the fruits.

% [spotSize] represents the size in pixels, it is used to remove small spots 
% and leave an outline of the fruit. The ultimate goal is to get only 
% the stains.

% Intermediate images are generated that correspond to:
%  * previously generated image with background removed
%  * intermediate image with fruits and defects
%  * only isolated defects
%
%
% -----------------------------------------------------------------------

%% Initial parameter setting
initialImage=fullfile(inputPath,imageNameP); % to write results
outputPathIRM=fullfile(mainPath,'IRM'); % fruits with background removed 1..4 cut out from the main image
outputPathcDefects=fullfile(mainPath,'cDefectos');

%% Settings for masks and colour images
pathColourCalyx=fullfile(mainPath,'cCalyx'); % to keep the calyx in colour
pathBinaryCalyx=fullfile(mainPath,'MCalyxBin'); % to keep the calyx in binary image
pathDefColor=fullfile(mainPath,'cDefColor'); % to keep the defects in colour
pathDefBinary=fullfile(mainPath,'MDefBin'); % to keep the defects in binary image

% filenames with removed objects
imageNameRemoved1=fullfile(outputPathIRM,strcat(imageNameP,'_','rm1.jpg'));
imageNameRemoved2=fullfile(outputPathIRM,strcat(imageNameP,'_','rm2.jpg'));
imageNameRemoved3=fullfile(outputPathIRM,strcat(imageNameP,'_','rm3.jpg'));
imageNameRemoved4=fullfile(outputPathIRM,strcat(imageNameP,'_','rm4.jpg'));

%% output with color defects
imageNameDefectsC1=fullfile(outputPathcDefects,strcat(imageNameP,'_','soC1.jpg'));
imageNameDefectsC2=fullfile(outputPathcDefects,strcat(imageNameP,'_','soC2.jpg'));
imageNameDefectsC3=fullfile(outputPathcDefects,strcat(imageNameP,'_','soC3.jpg'));
imageNameDefectsC4=fullfile(outputPathcDefects,strcat(imageNameP,'_','soC4.jpg'));

% Definition of image names for calyx segmented in color and binary
imageNameCalyxColour1=fullfile(pathColourCalyx,strcat(imageNameP,'_','CALC1.jpg')); % calyx colour image
imageNameCalyxColour2=fullfile(pathColourCalyx,strcat(imageNameP,'_','CALC2.jpg'));
imageNameCalyxColour3=fullfile(pathColourCalyx,strcat(imageNameP,'_','CALC3.jpg'));
imageNameCalyxColour4=fullfile(pathColourCalyx,strcat(imageNameP,'_','CALC4.jpg'));    

imageNameCalyxBin1=fullfile(pathBinaryCalyx,strcat(imageNameP,'_','CALB1.jpg')); % calyx binary mask
imageNameCalyxBin2=fullfile(pathBinaryCalyx,strcat(imageNameP,'_','CALB2.jpg'));
imageNameCalyxBin3=fullfile(pathBinaryCalyx,strcat(imageNameP,'_','CALB3.jpg'));
imageNameCalyxBin4=fullfile(pathBinaryCalyx,strcat(imageNameP,'_','CALB4.jpg'));    

imageNameDefBin1=fullfile(pathDefBinary,strcat(imageNameP,'_','DEFB1.jpg')); % defects binary mask
imageNameDefBin2=fullfile(pathDefBinary,strcat(imageNameP,'_','DEFB2.jpg'));
imageNameDefBin3=fullfile(pathDefBinary,strcat(imageNameP,'_','DEFB3.jpg'));
imageNameDefBin4=fullfile(pathDefBinary,strcat(imageNameP,'_','DEFB4.jpg'));    
    
%% Granulometry
% spotSize=1000; % 1000 pixels obtains good contour
   
%% -- BEGIN DEFECTS FEATURES EXTRACTION ----------------------------------
%% Mask segmentation to obtain isolated defects from the region of interest

%% Separation of painted calyx
fprintf('Separation of painted in CALYX--> \n');
backgroundRemoval4(imageNameRemoved1, imageNameCalyxBin1, imageNameCalyxColour1);
backgroundRemoval4(imageNameRemoved2, imageNameCalyxBin2, imageNameCalyxColour2);
backgroundRemoval4(imageNameRemoved3, imageNameCalyxBin3, imageNameCalyxColour3);
backgroundRemoval4(imageNameRemoved4, imageNameCalyxBin4, imageNameCalyxColour4);

   
%% Separation of painted defects
fprintf('Separation of painted defects in colour images --> \n');
% here, defects are separated using masks marked by an expert
backgroundRemoval4(imageNameRemoved1, imageNameDefBin1, imageNameDefectsC1);
backgroundRemoval4(imageNameRemoved2, imageNameDefBin2, imageNameDefectsC2);
backgroundRemoval4(imageNameRemoved3, imageNameDefBin3, imageNameDefectsC3);
backgroundRemoval4(imageNameRemoved4, imageNameDefBin4, imageNameDefectsC4);

%% -- END DEFECTS FEATURES EXTRACTION ----------------------------------
    
% -----------------------------------------------------------------------
end

