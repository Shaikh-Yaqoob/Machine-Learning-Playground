function [ ] = extractSDMet1( nombreImagenManchas, nombreImagenDefectos, nombreImagenContorno, tamanoMaximoManchas )
% ########################################################################
% Project AUTOMATIC CLASSIFICATION OF ORANGES BY SIZE AND DEFECTS USING 
% COMPUTER VISION TECHNIQUES 2018
% juancarlosmiranda81@gmail.com
% ########################################################################
% REcibe imagenes segmentadas, las cuenta y genera una imagen de solo
% manchas.
% Produce una imagen final con las manchas y sin contorno.


%% Lectura de la imagen
IManchas=imread(nombreImagenManchas);

%% cierra las manchas con agujeros
IManchasFinal = IManchas;

%% ----------------------------------
%% guardado de imagenes y contornos
imwrite(IManchasFinal,nombreImagenDefectos,'jpg')
end

