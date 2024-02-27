function [ output_args ] = SegmentacionDefectos(nombreImagenSegmentar, nombreImagenSalida)

%% segmentacion con filtros Sobel
IOrig=imread(nombreImagenSegmentar);

IGris=rgb2gray(IOrig);

BW3 = edge(IGris,'canny');
%BW3 = edge(IGris,'Prewitt');


%SE = strel('line', 2,0);
%BW41 = imdilate(BW3,SE);
%BW42 = imfill(BW41,'holes');


% Aplicacion de operacion 
%SE = strel('disk', 1);
%SE = strel('line', 2,0);
SE = strel('diamond', 1);
BW4 = imclose(BW3,SE);
BW5 = imfill(BW4,'holes');


%SE = strel('disk', 1);
%SE = strel('line', 1,0);
SE = strel('diamond', 1);
BW6 = imerode(BW5,SE);

%SE = strel('line', 2,90);
%BW7 = imerode(BW6,SE);



BW7=BW6;
%% Almacenar en archivos las imagenes de clusteres
imwrite(BW7,nombreImagenSalida,'jpg');


end

