function [ output_args ] = SDMet1(nombreImagenSegmentar, nombreImagenSalida)
% ########################################################################
% Project AUTOMATIC CLASSIFICATION OF ORANGES BY SIZE AND DEFECTS USING 
% COMPUTER VISION TECHNIQUES 2018
% juancarlosmiranda81@gmail.com
% ########################################################################
%% segmentacion con filtros Sobel
IOrig=imread(nombreImagenSegmentar);

IGris=rgb2gray(IOrig);
BW3 = edge(IGris,'canny');
SE = strel('diamond', 1);
BW4 = imclose(BW3,SE);
BW5 = imfill(BW4,'holes');

SE = strel('diamond', 1);
BW6 = imerode(BW5,SE);

BW7=BW6;
%% Almacenar en archivos las imagenes de clusteres
imwrite(BW7,nombreImagenSalida,'jpg');


end

