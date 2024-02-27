function [ output_args ] = backgroundRemoval4( ColorImageName, MaskImageName, BackgroundImageName)
% ########################################################################
% Project AUTOMATIC CLASSIFICATION OF ORANGES BY SIZE AND DEFECTS USING 
% COMPUTER VISION TECHNIQUES 2018
% juancarlosmiranda81@gmail.com
% ########################################################################
% It removes the background by only obtaining the pixels according to a binary mask, it improves the speed since Matlab works better with morphological operations

%Reading the image with background
IClipping=imread(ColorImageName);
IMaskC=imread(MaskImageName);

% Threshold and binarize
threshold=graythresh(IMaskC);
IMask=im2bw(IMaskC,threshold);


%% The background is removed using a binary mask and multiplying the matrices
IBackground(:, :, 1)=immultiply(IClipping(:, :, 1),IMask);
IBackground(:, :, 2)=immultiply(IClipping(:, :, 2),IMask);
IBackground(:, :, 3)=immultiply(IClipping(:, :, 3),IMask);


imwrite(IBackground,BackgroundImageName,'jpg');

end %End function

