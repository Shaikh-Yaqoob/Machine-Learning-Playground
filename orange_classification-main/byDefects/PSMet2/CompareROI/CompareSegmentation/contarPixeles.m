function [sumaArea] = contarPixeles( imagenNombreSilueta)
% ########################################################################
% Project AUTOMATIC CLASSIFICATION OF ORANGES BY SIZE AND DEFECTS USING 
% COMPUTER VISION TECHNIQUES 2018
% juancarlosmiranda81@gmail.com
% ########################################################################
%% Lectura de la imagen
IOrig=imread(imagenNombreSilueta);

%% Umbralización y Binarización
umbral=graythresh(IOrig);
IB1=im2bw(IOrig,umbral);

%% Etiquetado de áreas conectadas, se necesita una imagen binaria
[L Ne]=bwlabel(IB1); %en L los objetos y en Ne= números de áreas etiquetadas

%% Cálculo de propiedades de los objetos de la imagen
% se toman los datos geométricos necesarios para luego poder caracterizarlos.
propiedades= regionprops(L,'Area');

%% Mostrar características geométricas
% Se recorre de principio a fin las propiedades obtenidas
sumaArea=0;
for n=1:size(propiedades,1)
        sumaArea=sumaArea+propiedades(n).Area;
end

end %fin funcion

