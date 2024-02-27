function [ ] = defectDetectionExp( roiNumber, imageNameFR, imageNameROI, vectorFileDefects, imageNameOriginal, label)
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
%
% Usage:
%
% Creates a file with numerical defects characteristics values from a
% colour image and a binary image as a mask.
% The script receives as input binary images processed with Otzu algorithm.
% OUTPUTS = files with calyx and defects features.
%
% imageNameFR -> binary image with frut shape
% imageNameROI -> image name with region of interest
% vectorFileDefects -> vector file to save defects features.
% imageNameOriginal -> image name of an original image, it is used to
% relater regions.
% label -> Name of the string to be added to the row. Defects marked by the expert are assumed, which is why the results are known.
% 
% 

%% Reading the image with background removed
IFR=imread(imageNameFR);
ImROI=imread(imageNameROI);

%% Shape binarized with background removed
thresholdValue=graythresh(IFR);
IFRB1=im2bw(IFR,thresholdValue); % processed image

%% Labelling conected elements
[objectList Ne]=bwlabel(IFRB1);

%% To calculate objects properties in the image
objectProperties=regionprops(objectList);

%% To search within pixel areas corresponding to objects
objectSelectedList=find([objectProperties.Area]);

%% Gets the coordinates of the area
objectCounter=0; % starts with 0 objects found
% Make a query if there are objects. Exists the posibility of getting an empty
% image.
objectSelectedListSize=size(objectSelectedList,2);

if (objectSelectedListSize==0)
    % if no objects exist, all the features are set to zero
    fprintf('number of objects %i \n', objectCounter);
    meanRGBR=0.0;
    meanRGBG=0.0;
    meanRGBB=0.0;
    stdRGBR=0.0;
    stdRGBG=0.0;
    stdRGBB=0.0;
    meanLABL=0.0;
    meanLABA=0.0;
    meanLABB=0.0;
    stdLABL=0.0;
    stdLABA=0.0;
    stdLABB=0.0;
    meanHSVH=0.0;
    meanHSVS=0.0;
    meanHSVV=0.0;
    stdHSVH=0.0;
    stdHSVS=0.0;
    stdHSVV=0.0;
    sumArea=0;
    perimeter=0.0;
    excentricity=0.0;
    majorAxis=0.0;
    minorAxis=0.0;
    entropy=0.0;
    inertia=0.0;
    energy=0.0;
    label='VACIO';
    x=0; 
    y=0;
    w=0;
    h=0;
    rowValues=sprintf('%s, %10i, %10i, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10i, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10i, %10i, %10i, %10i, %s \n', imageNameOriginal, roiNumber, objectCounter, meanRGBR, meanRGBG, meanRGBB, stdRGBR, stdRGBG, stdRGBB, meanLABL, meanLABA, meanLABB, stdLABL, stdLABA, stdLABB, meanHSVH, meanHSVS, meanHSVV, stdHSVH, stdHSVS, stdHSVV, sumArea, perimeter, excentricity, majorAxis, minorAxis, entropy, inertia, energy, x, y, w, h,label);
    saveAVDefCalyx2( vectorFileDefects, rowValues);
    
else
    for n=1:size(objectSelectedList,2)
        objectCounter=objectCounter+1;
        coordinatesToPaint=round(objectProperties(objectSelectedList(n)).BoundingBox);
        %% cropping the images
        IShapeROI = imcrop(IFRB1,coordinatesToPaint);
        IBackgroundR = imcrop(ImROI,coordinatesToPaint);
        
        %% Extracting features
        % It is a requirement to obtain binary images with Otzu
        [ meanRGBR, meanRGBG, meanRGBB, stdRGBR, stdRGBG, stdRGBB ] = extractMeanCImgRGB( IBackgroundR, IShapeROI);
        %fprintf('%i, %f, %f, %f, %f, %f, %f \n',objectCounter, meanRGBR, meanRGBG, meanRGBB, stdRGBR, stdRGBG, stdRGBB);
        
        [ meanLABL, meanLABA, meanLABB, stdLABL, stdLABA, stdLABB ] = extractMeanCImgLAB( IBackgroundR, IShapeROI);
        %fprintf('%f, %f, %f, %f, %f, %f \n', meanLABL, meanLABA, meanLABB, stdLABL, stdLABA, stdLABB);
        
        [ meanHSVH, meanHSVS, meanHSVV, stdHSVH, stdHSVS, stdHSVV ] = extractMeanCImgHSV( IBackgroundR, IShapeROI);
        %fprintf('%f, %f, %f, %f, %f, %f \n', meanHSVH, meanHSVS, meanHSVV, stdHSVH, stdHSVS, stdHSVV);
        
        [ sumArea, perimeter, excentricity, majorAxis, minorAxis ] = extractDefCarGeoImg(IShapeROI);
        %fprintf('%10i, %10.4f, %10.4f, %10.4f, %10.4f, \n',  sumArea, perimeter, excentricity, majorAxis, minorAxis);
        
        [ entropy, inertia, energy  ] = extractCTextures( IBackgroundR, IShapeROI);
        fprintf('%s, %10i, %10i, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10i, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %s \n', imageNameOriginal, roiNumber, objectCounter, meanRGBR, meanRGBG, meanRGBB, stdRGBR, stdRGBG, stdRGBB, meanLABL, meanLABA, meanLABB, stdLABL, stdLABA, stdLABB, meanHSVH, meanHSVS, meanHSVV, stdHSVH, stdHSVS, stdHSVV, sumArea, perimeter, excentricity, majorAxis, minorAxis, entropy, inertia, energy, label);
        
        %% writing in file
        rowValues=sprintf('%s, %10i, %10i, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10i, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10i, %10i, %10i, %10i, %s \n', imageNameOriginal, roiNumber, objectCounter, meanRGBR, meanRGBG, meanRGBB, stdRGBR, stdRGBG, stdRGBB, meanLABL, meanLABA, meanLABB, stdLABL, stdLABA, stdLABB, meanHSVH, meanHSVS, meanHSVV, stdHSVH, stdHSVS, stdHSVV, sumArea, perimeter, excentricity, majorAxis, minorAxis, entropy, inertia, energy, coordinatesToPaint(1), coordinatesToPaint(2), coordinatesToPaint(3), coordinatesToPaint(4), label);
        saveAVDefCalyx2( vectorFileDefects, rowValues);
    end    
end

end

