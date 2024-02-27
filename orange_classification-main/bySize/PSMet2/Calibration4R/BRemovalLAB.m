function [] = BRemovalLAB(imagenInicialRGB, imagenNombreFR, tamanoObjeto, canalLMin, canalLMax, canalAMin, canalAMax, canalBMin, canalBMax, xmin,ymin,width,height)
% Valores empíricos para el conjunto de imágenes
% NO BORRAR --> canalLMin = 0.0; canalLMax = 96.653; canalAMin = -23.548; canalAMax = 16.303; canalBMin = -28.235; canalBMax = -1.169;



% Recibe las medidas del cuadro 1 para realizar recortes y eliminar objetos
% que no pertenecen a las naranjas. Se reciben elos parámetros
% xmin,ymin,width,height.

% Crea una máscara a partir de una imagen RGB utilizando umbralizacion y el
% espacio LAB con un máximo y un mínimo en cada canal.
% como resultado se genera una imagen intermedia, con siluetas de las
% frutas, la misma es utilizada por otros procesos. 
% Codigo generado con colorThresholder app on 02-Sep-2017

% abrir imagen original
IRGB=imread(imagenInicialRGB);

% Convertir imagen RGB al espacio CIELAB
IRGB = im2double(IRGB);
cform = makecform('srgb2lab', 'AdaptedWhitePoint', whitepoint('D65'));
I = applycform(IRGB,cform);

% Definir umbrales para canal 1 basados en histograma
%canalLMin = 0.0;
%canalLMax = 96.653;

% Definir umbrales para canal 2 basados en histograma
%canalAMin = -23.548;
%canalAMax = 16.303;

% Definir umbrales para canal 3 basados en histograma
%canalBMin = -28.235;
%canalBMax = -1.169;

% Crear mascara según los umbrales del historgrama
BW = (I(:,:,1) >= canalLMin ) & (I(:,:,1) <= canalLMax) & ...
    (I(:,:,2) >= canalAMin ) & (I(:,:,2) <= canalAMax) & ...
    (I(:,:,3) >= canalBMin ) & (I(:,:,3) <= canalBMax);

% Inicializar la mascara obtenida con la imagen RGB
mascaraRGBImagen = IRGB;

% colocar en cero los pixeles considerados como fondo
mascaraRGBImagen(repmat(~BW,[1 1 3])) = 0;

%figure('Name','Original');imshow(IRGB);
%figure('Name','Mascara Binaria');imshow(BW);
%figure('Name','Segmentada');imshow(mascaraRGBImagen);

%Se vuelve a invertir para dejar con unos la silueta
mascaraInversa=1-BW;
%figure('Name','inversa');imshow(mascaraInversa);

% Aplicacion de operacion erosion
SE = strel('disk', 4);
IB1 = imerode(mascaraInversa,SE);

%% Llenado de agujeros
IB2 = imfill(IB1,'holes');

%% --------------------------------------
%% colocar linea pixelada en negro para elimnar ruidos 
coordenadasAPintar=[xmin, ymin, width, height]; %definicion de la zona linea pixelada en negro
% separar a las naranjas del cuadro 1, soluciona la superposicion del
% cuadro 1 y del cuadro 3
IB2((coordenadasAPintar(2)-2):(coordenadasAPintar(2)+2),coordenadasAPintar(1):(coordenadasAPintar(1)+(coordenadasAPintar(3)-1)))=0;

% elimina ruidos que se encuentran mas abajo del rectangulo inferior
[filasTotal,columnasTotal]=size(IB2);
topeFilas=coordenadasAPintar(2)+(coordenadasAPintar(4)-1);
%IRGB(topeFilas:filasTotal-1,1:columnasTotal-4)=0;
IB2(topeFilas:filasTotal,1:columnasTotal)=0;

%% --------------------------------------

%% Elimina los elementos cuya area es igual al parametro, deja los elementos grandes
IB3=bwareaopen(IB2,tamanoObjeto);


%%----------------------------------







%% guardar imagen final con los contorno de la fruta
imwrite(IB3,imagenNombreFR,'jpg');

end
