function [] = BRemovalLAB(rgbColourImage, imageNameBR, imageNameF, objectSize, lChannelMin, lChannelMax, aChannelMin, aChannelMax, bChannelMin, bChannelMax, xmin,ymin,width,height)
%
% Project: AUTOMATIC CLASSIFICATION OF ORANGES BY SIZE AND DEFECTS USING
% COMPUTER VISION TECHNIQUES
%
% Author: Juan Carlos Miranda. https://github.com/juancarlosmiranda/
% Date: 2018
% Update:  December 2023
%
% Description:
% Receive measurements from rectangle number 1 (main figure from acquisition)
% to make cuts and remove objects that do not belong to oranges. The parameters 
% xmin,ymin,width,height are received. Creates a mask from an RGB image using 
% thresholding and the LAB space with a maximum and minimum on each channel. 
% As a result, an intermediate image is generated, with figures of the fruits, 
% it is used by other processes. This code was generated with colorThresholder 
% application on 02-Sep-2017
%
%
% Usage:
% BRemovalLAB(colourImage, imageNameBR, imageNameF, objectAreaBR, lChannelMin, lChannelMax, aChannelMin, aChannelMax, bChannelMax, bChannelMin,rectangle1_X, rectangle1_Y-2, rectangle1_W, rectangle1_H);
%

% Empirical values for the image dataset, mantain this for reference. The
% values were selected based on colour histogram.
% lChannelMin = 0.0; 
% lChannelMax = 96.653; 
% aChannelMin = -23.548; 
% aChannelMax = 16.303; 
% bChannelMin = -28.235; 
% bChannelMax = -1.169;
%
% abrir imagen original
IRGB=imread(rgbColourImage);

% RGB colour space conversion to CIELAB
IRGB = im2double(IRGB);
cform = makecform('srgb2lab', 'AdaptedWhitePoint', whitepoint('D65'));
I = applycform(IRGB,cform);

% Create mask a binary mask according to the histogram thresholds
BW = (I(:,:,1) >= lChannelMin ) & (I(:,:,1) <= lChannelMax) & ...
    (I(:,:,2) >= aChannelMin ) & (I(:,:,2) <= aChannelMax) & ...
    (I(:,:,3) >= bChannelMin ) & (I(:,:,3) <= bChannelMax);

% It is reversed again to leave the figure
reverseMask=1-BW;

% Erosion morphological operation application
SE = strel('disk', 4);
IB1 = imerode(reverseMask,SE);

% Filling holes in the figure
IB2 = imfill(IB1,'holes');

% Adds a black line to eliminate noise
coordinatesToPaint=[xmin, ymin, width, height];
% definition of the black pixelated line area, separate the oranges from 
% rectangle 1, solve the overlap of the rectangle 1 and rectangle 3

IB2((coordinatesToPaint(2)-2):(coordinatesToPaint(2)+2),coordinatesToPaint(1):(coordinatesToPaint(1)+(coordinatesToPaint(3)-1)))=0;

% noise removal at the bottom of the image
[totalRows,totalColumns]=size(IB2);
limitRow=coordinatesToPaint(2)+(coordinatesToPaint(4)-1);
IB2(limitRow:totalRows,1:totalColumns)=0;

% Eliminate elements whose area is equal to the parameter, leave large elements.
IB3=bwareaopen(IB2,objectSize);


% Save final image with fruit shape/ contour
imwrite(IB3,imageNameBR,'jpg');

end
