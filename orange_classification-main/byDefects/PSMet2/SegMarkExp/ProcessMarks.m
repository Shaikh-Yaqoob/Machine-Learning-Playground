function [ ] = ProcessMarks(pathImages, pathMasks, outputPath, imageNameP, rectangleList, objectAreaBR, lChannelMin, lChannelMax, aChannelMin, aChannelMax, bChannelMax, bChannelMin )
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
% For each image, the background is separated, segmenting the four regions
% according to frames defined in the image acquisition.
% Background is removed from the acquired images using thresholds for
% channels in LAB space. And the following intermediate results (images)
% are generated:
% * Binary regions of interest of the fruit and its reflections in the
%   mirror.
% * Color images without background.
% * Background silhouettes removed.
% * Extraction of geometric features from binary images.
% * Crops of fruit images from each region of the mirror (1..4).
%
%
% Usage:
%
% ProcessMarks(pathImages, pathImagesTraining, outputPath, imageNameP, rectangleList, objectAreaBR, LchannelMin, LChannelMax, AChannelMin, AChannelMax, BChannelMin, BChannelMax )
%

%% Datos de configuración archivos
colourImage=fullfile(pathImages,imageNameP); % original image to extract colour values
maskImage=fullfile(pathMasks,imageNameP); % image with manually made marks (masks for calyx and defects)

%% Ouput folders
outputPathBR=fullfile(outputPath,'IBR'); % main image with binary fruit shapes (4 regions) and background removed.
outputPathROI=fullfile(outputPath,'IROI'); % main color image with 4 regions of interest (ROI) and background removed.
outputPathROIMasks=fullfile(outputPath,'MROI'); % main color image with 4 regions of interest (ROI), defects and colour masks, background removed.

outputPathIS=fullfile(outputPath,'ISFrutas'); % fruit shapes 1..4 cut out from the main image
outputPathIRM=fullfile(outputPath,'IRM'); % fruits with background removed 1..4 cut out from the main image
outputPathRemMask=fullfile(outputPath,'MRM'); % fruits with background removed and colour mask for calyx and defects, regions 1..4


%% Settings for defects/calyx classes, colour and mask images
outputPathCALROI=fullfile(outputPath,'ROICalyxC'); % main colour image with masks for calyx, background removed
outputPathCALROIBin=fullfile(outputPath,'ROICalyxBin'); % main binary image with masks for calyx
outputPathDEFROI=fullfile(outputPath,'ROIDefC'); % main colour image with masked defects
outputPathDEFROIBin=fullfile(outputPath,'ROIDefBin'); % % 1 imagen con 4 marcas en binario

% calyx masks
pathCalyxColor=fullfile(outputPath,'MCalyxColor'); % calyx masks with background removed in regions 1..4
pathCalyxBinary=fullfile(outputPath,'MCalyxBin'); % binary calyx masks with background removed in regions 1..4
% defects masks
pathDefColor=fullfile(outputPath,'MDefColor'); % defects masks with background removed in regions 1..4
pathDefBinary=fullfile(outputPath,'MDefBin'); % binary defects masks with background removed in regions 1..4

% --- Results with intermediate images ---
% background removed
imageNameBR=fullfile(outputPathBR,strcat(imageNameP,'_','BR.jpg')); % shapes with background removed
imageNameROI=fullfile(outputPathROI,strcat(imageNameP,'_','RO.jpg')); % colour shapes and background removed
imageNameROIMarca=fullfile(outputPathROIMasks,strcat(imageNameP,'_','MRO.jpg')); % para indicar el fondo removido y ROI
imageNameF=fullfile(outputPathROI,strcat(imageNameP,'_','I.jpg')); % prior to reverse image

% Definition of prefixes for colour and binary images with background
% removed, which are used in object detection
imageNameShapeN=fullfile(outputPathIS,strcat(imageNameP,'_','sN'));
imageNameRemoved=fullfile(outputPathIRM,strcat(imageNameP,'_','rm'));
imageNameRemovedMask=fullfile(outputPathRemMask,strcat(imageNameP,'_','Mrm'));

% Defining file names for color and binary defect regions.
imageNameCALROI=fullfile(outputPathCALROI,strcat(imageNameP,'_','DR.jpg')); % Calyx marked in magenta colour
imageNameCALROIBin=fullfile(outputPathCALROIBin,strcat(imageNameP,'_','DRB.jpg')); % Calyx masks in white colour

imageNameDEFROI=fullfile(outputPathDEFROI,strcat(imageNameP,'_','DR.jpg')); % Defects marked in blue colour
imageNameDEFROIBin=fullfile(outputPathDEFROIBin,strcat(imageNameP,'_','DRB.jpg')); % Defects marked in white colour

imageNameCalColor=fullfile(pathCalyxColor,strcat(imageNameP,'_','DC.jpg')); % Calyx, numbered image for ROI 1..4 in colour
imageNameCalBin=fullfile(pathCalyxBinary,strcat(imageNameP,'_','CALB')); % Calyx, numbered image for ROI 1..4 binary masks

imageNameDefColor=fullfile(pathDefColor,strcat(imageNameP,'_','DC.jpg')); % Defects, numbered image for ROI 1..4 in colour
imageNameDefBin=fullfile(pathDefBinary,strcat(imageNameP,'_','DEFB')); % Defects, , numbered image for ROI 1..4 binary masks


%% -- BEGIN IMAGE PROCESSING ----------------------------------
%% ----- Definition of limits for rectangles
% Settings for definition of previously configured rectangles during the
% calibration process. It is used to detect the region from a main image
% with mirrors (see 3.2 Adquisición de imágenes int the Thesis Book).

rectangle1_X=rectangleList(1,1);
rectangle1_Y=rectangleList(1,2);
rectangle1_W=rectangleList(1,3);
rectangle1_H=rectangleList(1,4);

fprintf('BR -> Main image, background segmentation applying the LAB colour space --> \n'); % output an image with 4 shapes
BRemovalLAB(colourImage, imageNameBR, imageNameF, objectAreaBR, lChannelMin, lChannelMax, aChannelMin, aChannelMax, bChannelMax, bChannelMin,rectangle1_X, rectangle1_Y-2, rectangle1_W, rectangle1_H);

%% Background removal
fprintf('BR -> Main image, background removal, separation of regions of interest (ROI) --> \n'); % output an image with 4 shapes
backgroundRemoval4(colourImage, imageNameBR, imageNameROI);
backgroundRemoval4(maskImage, imageNameBR, imageNameROIMarca);


%% Parameters for CALYX segmentation under the RGB colour space
fprintf('DR -> Segmenting CALYX marked by expert in the 4 ROIs, ROI separation --> \n'); % output an image with 4 shapes
% RGB channels min and max values
rChannelMin = 216.000;
rChannelMax = 255.000;
gChannelMin = 0.000;
gChannelMax = 132.000;
bChannelMin = 201.000;
bChannelMax = 255.000;

SegmentDefMarksRGB(maskImage, imageNameCALROI, imageNameCALROIBin, rChannelMin, rChannelMax, gChannelMin, gChannelMax, bChannelMin, bChannelMax);


%% Parameters for DEFECTS segmentation under the RGB colour space
fprintf('DR -> Segmenting DEFECTS marked by expert in the 4 ROIs, ROI separation --> \n'); % output an image with 4 shapes
% RGB channels min and max values
rChannelMin = 0.000;
rChannelMax = 15.000;
gChannelMin = 0.000;
gChannelMax = 11.000;
bChannelMin = 231.000;
bChannelMax = 255.000;

SegmentDefMarksRGB(maskImage, imageNameDEFROI, imageNameDEFROIBin, rChannelMin, rChannelMax, gChannelMin, gChannelMax, bChannelMin, bChannelMax);

%% Region of interest cuts
fprintf('BR -> Object detection inside rectangles. Cropping ROI and ROI shapes --> \n'); % output 4 images of an object each
% assigns numbers of objects according to their membership in the box
objectDetection2( imageNameBR, imageNameROI, imageNameShapeN, imageNameRemoved, rectangleList ); 
objectDetection2( imageNameBR, imageNameROIMarca, imageNameShapeN, imageNameRemovedMask, rectangleList ); 


% cut based on calyx shapes
objectDetectionCut( imageNameBR, imageNameCALROI, imageNameCalColor, rectangleList );
objectDetectionCut( imageNameBR, imageNameCALROIBin, imageNameCalBin, rectangleList );

% cut based on defects shapes
objectDetectionCut( imageNameBR, imageNameDEFROI, imageNameDefColor, rectangleList );
objectDetectionCut( imageNameBR, imageNameDEFROIBin, imageNameDefBin, rectangleList );

%% -- END IMAGE PROCESSING ----------------------------------

end

