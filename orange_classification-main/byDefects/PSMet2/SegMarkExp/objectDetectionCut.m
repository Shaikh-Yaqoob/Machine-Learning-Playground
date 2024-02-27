function [ ] = objectDetectionCut( imageNameFR, imageNameROI, imageNameRemoved, rectangleArray)
%
% Project: AUTOMATIC CLASSIFICATION OF ORANGES BY SIZE AND DEFECTS USING
% COMPUTER VISION TECHNIQUES
%
% Author: Juan Carlos Miranda. https://github.com/juancarlosmiranda/
% Date: 2018
% Update:  December 2023
%
% Description:

% It receives a segmented black and white image, this is used as a mask to 
% detect objects. The procedure consists of detecting pixel regions and 
% cropping the objects to separate them into smaller images.
%
% Usage:
% 
%

%% Reading the image with background removed
IFR=imread(imageNameFR);
ImROI=imread(imageNameROI);


%% Binarization of the silhouette background removed
umbral=graythresh(IFR);
IFRB1=im2bw(IFR,umbral); 

%% Label connected elements
[objectList Ne]=bwlabel(IFRB1);

%% Calculate properties of image objects
regionProperties= regionprops(objectList);

%% Find pixel areas corresponding to objects
objectsSelected=find([regionProperties.Area]);

%% get area coordinates
objectCounter=0; % elements found
rectangleNumber='';
for n=1:size(objectsSelected,2)
    objectCounter=objectCounter+1;
    coodinatesToPaint=round(regionProperties(objectsSelected(n)).BoundingBox);
    %% cropping images
    IBackgroundR = imcrop(ImROI,coodinatesToPaint);
    %% rectangle number detection
    rectangleNumber=rectangleDetection(rectangleArray, coodinatesToPaint(1), coodinatesToPaint(2)); %asigma el numero de cuadro que corresponde a la imagen

    if(rectangleNumber=='N')
        outputBR=strcat(imageNameRemoved, rectangleNumber, int2str(objectCounter),'.jpg');
    else
        outputBR=strcat(imageNameRemoved, rectangleNumber,'.jpg');        
    end

    %% saves the cropped images, both the ROI and the silhouette of each object
    imwrite(IBackgroundR,outputBR,'jpg');    
end

end

