% ########################################################################
% Project AUTOMATIC CLASSIFICATION OF ORANGES BY SIZE AND DEFECTS USING 
% COMPUTER VISION TECHNIQUES 2018
% juancarlosmiranda81@gmail.com
% ########################################################################
%% Ajuste de parámetros iniciales
clc; clear all; close all;

%imagenInicial='siluetaN1.jpg';
%imagenInicial='siluetaN2.jpg';
imagenInicial='siluetaN3.jpg';

tamanoAreaBorrar=1000; %tamano en pixeles de las areas a borrar
%% Lectura de la imagen
IOrig=imread(imagenInicial);

%% Convertir a escala de grises
%IGray=rgb2gray(IOrig);

%% Umbralización y Binarización
umbral=graythresh(IOrig);
IB1=im2bw(IOrig,umbral);

%% Mostrar imagen original
imshow(IOrig)

%% Etiquetado de áreas conectadas, se necesita una imagen binaria
[L Ne]=bwlabel(IB1); %en L los objetos y en Ne= números de áreas etiquetadas

%% Cálculo de propiedades de los objetos de la imagen
% se toman los datos geométricos necesarios para luego poder caracterizarlos.
propiedades= regionprops(L,'Area','Perimeter');
hold on


%% Mostrar características geométricas
% Se recorre de principio a fin las propiedades obtenidas
sumaArea=0;
%fprintf('       N#;      Area;  Perimetro;  Redondez;Excentricidad; Centroide X; Centroide Y; \n');
fprintf('       N#;      Area;  Perimetro; \n');
for n=1:size(propiedades,1)
    redondez=(4*propiedades(n).Area*pi)/(propiedades(n).Perimeter^2); %fórmula de redondez de objetos
    fprintf('%10.2i; %10.2i; %10.2f; %10.4f; \n', n,propiedades(n).Area, propiedades(n).Perimeter, redondez);
    sumaArea=sumaArea+propiedades(n).Area;
end

fprintf('Suma de Areas= %10.2i \n', sumaArea);
