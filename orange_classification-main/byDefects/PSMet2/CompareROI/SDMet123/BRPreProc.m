function [] = BRPreProc(imagenInicialRGB, imagenNombrePR, xmin,ymin,width,height)
% ########################################################################
% Project AUTOMATIC CLASSIFICATION OF ORANGES BY SIZE AND DEFECTS USING 
% COMPUTER VISION TECHNIQUES 2018
% juancarlosmiranda81@gmail.com
% ########################################################################
% Se encarga de pintar las partes de la imagen original para aislar ruidos
% que n corresponden a la imagen.
IRGB=imread(imagenInicialRGB);



%% colocar linea pixelada en negro para elimnar ruidos 
coordenadasAPintar=[xmin, ymin, width, height]; %definicion de la zona linea pixelada en negro
% separar a las naranjas del cuadro 1, soluciona la superposicion del
% cuadro 1 y del cuadro 3
IRGB((coordenadasAPintar(2)-2):(coordenadasAPintar(2)+2),coordenadasAPintar(1):(coordenadasAPintar(1)+(coordenadasAPintar(3)-1)),1)=0;
IRGB((coordenadasAPintar(2)-2):(coordenadasAPintar(2)+2),coordenadasAPintar(1):(coordenadasAPintar(1)+(coordenadasAPintar(3)-1)),2)=0;
IRGB((coordenadasAPintar(2)-2):(coordenadasAPintar(2)+2),coordenadasAPintar(1):(coordenadasAPintar(1)+(coordenadasAPintar(3)-1)),3)=0;

% elimina ruidos que se encuentran mas abajo del rectangulo inferior
[filasTotal,columnasTotal]=size(IRGB)
topeFilas=coordenadasAPintar(2)+(coordenadasAPintar(4)-1)
%IRGB(topeFilas:filasTotal-1,1:columnasTotal-4)=0;
IRGB(topeFilas:filasTotal,1:columnasTotal)=0;
%IRGB(topeFilas:filasTotal-1,1:columnasTotal-4,1)=0;
%IRGB(topeFilas:filasTotal-1,1:columnasTotal-4,2)=0;
%IRGB(topeFilas:filasTotal-1,1:columnasTotal-4,3)=0;

%% guardar imagen original pero tratada para eliminar ruidos
imwrite(IRGB,imagenNombrePR,'jpg');

end
