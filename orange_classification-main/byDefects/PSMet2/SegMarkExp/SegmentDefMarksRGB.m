function [] = SegmentDefMarksRGB(imageToSegment, imageNameDEFROI, imageNameOutput, channel1Min, channel1Max, channel2Min, channel2Max, channel3Min, channel3Max)
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
% Extracts the masks painted by the expert using the value segmentation technique in the RGB space.
%
% Usage:
%
% SegmentDefMarksRGB(
%   maskImage, imageNameDEFROI, imageNameDEFROIBin, 
%   rChannelMin, rChannelMax, gChannelMin, gChannelMax, 
%   bChannelMin, bChannelMax
%);
%
%------------------------------------------------------

RGB=imread(imageToSegment);

% Convert RGB image to chosen colour space
I = RGB;

% Create mask based on chosen histogram thresholds
BW = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
    (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
    (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);

% Initialize output masked image based on input image.
maskedRGBImage = RGB;

% Set background pixels where BW is false to zero.
maskedRGBImage(repmat(~BW,[1 1 3])) = 0;

grayLevel=graythresh(maskedRGBImage(:,:,3)); % threshold placed based on experience
IB2=im2bw(maskedRGBImage(:,:,3),grayLevel);

%% Store cluster images in files
imwrite(maskedRGBImage,imageNameDEFROI,'jpg');
imwrite(IB2,imageNameOutput,'jpg');
end
