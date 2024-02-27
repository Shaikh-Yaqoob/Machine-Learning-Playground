function [] = BRPreProc(mainImageRGB, imageNamePR, xmin, ymin, width, height)
%
% Project: AUTOMATIC CLASSIFICATION OF ORANGES BY SIZE AND DEFECTS USING
% COMPUTER VISION TECHNIQUES
%
% Author: Juan Carlos Miranda. https://github.com/juancarlosmiranda/
% Date: 2018
% Update:  December 2023
%
% Description:
% This function paints regions in the original image to isolate noise that 
% does not belong in the image.
%
% Usage:
%
%

IRGB=imread(mainImageRGB);

%% apply a balck rectangle to remove noises
coordinatesToPaint=[xmin, ymin, width, height]; % definition of a region using a balck rectangle
% to separate fruits from rectangle 1, this solves the overlap of rectangle 1 and rectangle 3
IRGB((coordinatesToPaint(2)-2):(coordinatesToPaint(2)+2),coordinatesToPaint(1):(coordinatesToPaint(1)+(coordinatesToPaint(3)-1)),1)=0;
IRGB((coordinatesToPaint(2)-2):(coordinatesToPaint(2)+2),coordinatesToPaint(1):(coordinatesToPaint(1)+(coordinatesToPaint(3)-1)),2)=0;
IRGB((coordinatesToPaint(2)-2):(coordinatesToPaint(2)+2),coordinatesToPaint(1):(coordinatesToPaint(1)+(coordinatesToPaint(3)-1)),3)=0;

% This eliminates noise beyond the lower region
[totalRows,totalColumns]=size(IRGB)
topOfRows=coordinatesToPaint(2)+(coordinatesToPaint(4)-1)
IRGB(topOfRows:totalRows,1:totalColumns)=0;


%% save original images with image processing to remove noises
imwrite(IRGB,imageNamePR,'jpg');

end
