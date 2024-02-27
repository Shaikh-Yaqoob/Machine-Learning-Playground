function [ ] = SDMet3(nombreImagenSegmentar, nombreImagenSalida)
% ########################################################################
% Project AUTOMATIC CLASSIFICATION OF ORANGES BY SIZE AND DEFECTS USING 
% COMPUTER VISION TECHNIQUES 2018
% juancarlosmiranda81@gmail.com
% ########################################################################
%% segmentacion con filtros Sobel, Prewit
IOrig=imread(nombreImagenSegmentar);

IGris=rgb2gray(IOrig);

media1=IGris;
%% obtener gradientes, los gradientes indican donde cambian los colores
[Gmag, ~] = imgradient(media1,'Prewitt');
I = mat2gray(Gmag);

nivel=0.10; %umbral colocado en base a la experiencia
IB2=im2bw(I,nivel);

% apertura para eliminar los detalles pequeños
SE = strel('disk', 1);
IB3 = imopen(IB2,SE);

%% Almacenar en archivos las imagenes de clusteres
imwrite(IB3,nombreImagenSalida,'jpg');
end

