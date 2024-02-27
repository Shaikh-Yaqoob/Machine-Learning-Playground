function [ sumaArea, perimetro, excentricidad, ejeMayor, ejeMenor ] = extraerDefCarGeoImg(IOrig)
% ########################################################################
% Project AUTOMATIC CLASSIFICATION OF ORANGES BY SIZE AND DEFECTS USING 
% COMPUTER VISION TECHNIQUES 2018
% juancarlosmiranda81@gmail.com
% ########################################################################
%% Lectura de la imagen

IB1=IOrig;

%% Etiquetado de áreas conectadas, se necesita una imagen binaria
[L Ne]=bwlabel(IB1); %en L los objetos y en Ne= números de áreas etiquetadas

%% Cálculo de propiedades de los objetos de la imagen
% se toman los datos geométricos necesarios para luego poder caracterizarlos.
propiedades= regionprops(L,'Area','Perimeter','Eccentricity','MajorAxisLength','MinorAxisLength');


%% Mostrar características geométricas
% Se recorre de principio a fin las propiedades obtenidas
sumaArea=0;
redondez=0;
diametro=0;

ejeMayor=0;
ejeMenor=0;

%fprintf('       N#;      Area;  Perimetro; \n');
tamano=1;

for n=1:size(propiedades,1)
         sumaArea=propiedades(n).Area;
         perimetro=propiedades(n).Perimeter;
         excentricidad=propiedades(n).Eccentricity;
         ejeMayor=propiedades(n).MajorAxisLength;
         ejeMenor=propiedades(n).MinorAxisLength; 
end


end

