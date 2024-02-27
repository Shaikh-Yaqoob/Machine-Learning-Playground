function [ ] = removerFondo4( imagenNombreColor, imagenNombreMascara, imagenNombreFondo)
% Remueve el fondo obteniendo solamente los pixeles según una máscara
% binaria, mejora la velocidad dado que MAtlab trabaja mejor con 
% operaciones morfologicas

%Lectura de la imagen con fondo
IRecorte=imread(imagenNombreColor);
IMascaraC=imread(imagenNombreMascara);

% Binarizar
umbral=graythresh(IMascaraC);
IMascara=im2bw(IMascaraC,umbral);


%% Se remueve el fondo utilizando una máscara binaria y multiplicando las matrices
IFondo(:, :, 1)=immultiply(IRecorte(:, :, 1),IMascara);
IFondo(:, :, 2)=immultiply(IRecorte(:, :, 2),IMascara);
IFondo(:, :, 3)=immultiply(IRecorte(:, :, 3),IMascara);


imwrite(IFondo,imagenNombreFondo,'jpg');

end %fin de la funcion

