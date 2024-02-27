function [ ] = deteccionObjetos2( imagenNombreFR, imagenNombreROI, nombreImagenSiluetaN, nombreImagenRemovida, ArrayCuadros)
% SALIDAS= nombreImagenSiluetaN, nombreImagenRemovida

% Recibe una imagen segmentada en blanco y negro, esta se utiliza como
% mascara para detectar los objetos. El procedimiendo consiste en detectar
% las regiones de pixeles y recortar los objetos para separarlos en
% imagenes más pequenas.


%% Lectura de la imagen con fondo removido
IFR=imread(imagenNombreFR);
ImROI=imread(imagenNombreROI);


%% Binarización de la silueta fondo removido
umbral=graythresh(IFR);
IFRB1=im2bw(IFR,umbral); %Imagen tratada

%% Etiquetar elementos conectados

[ListadoObjetos Ne]=bwlabel(IFRB1);

%% Calcular propiedades de los objetos de la imagen
propiedades= regionprops(ListadoObjetos);

%% Buscar áreas de pixeles correspondientes a objetos
seleccion=find([propiedades.Area]);

%% obtenr coordenadas de areas
contadorObjetos=0; %encontrados
numeroCuadro='';
for n=1:size(seleccion,2)
    contadorObjetos=contadorObjetos+1;
    coordenadasAPintar=round(propiedades(seleccion(n)).BoundingBox);
    %% recorta las imagenes
    ISiluetaROI = imcrop(IFRB1,coordenadasAPintar);
    IFondoR = imcrop(ImROI,coordenadasAPintar);
    %% deteccion del numero de cuadro
%    fprintf('---INICIO DETECCION DE CUADROS ---\n');
    numeroCuadro=deteccionCuadros(ArrayCuadros, coordenadasAPintar(1), coordenadasAPintar(2)); %asigma el numero de cuadro que corresponde a la imagen
%    fprintf('---FIN DETECCION DE CUADROS ---\n');
    if(numeroCuadro=='N')
%        fprintf('IGUAL A N... \n');        
        salidaSiluetaN=strcat(nombreImagenSiluetaN, numeroCuadro, int2str(contadorObjetos),'.jpg');
        salidaRemovida=strcat(nombreImagenRemovida, numeroCuadro, int2str(contadorObjetos),'.jpg');
    else
%        fprintf('No es igual a N \n');
        salidaSiluetaN=strcat(nombreImagenSiluetaN, numeroCuadro,'.jpg');
        salidaRemovida=strcat(nombreImagenRemovida, numeroCuadro,'.jpg');        
    end %if(numeroCuadro=='N')

    %% guarda las imagenes recortadas, tanto la ROI como la silueta de cada objeto
    imwrite(ISiluetaROI,salidaSiluetaN,'jpg');
    imwrite(IFondoR,salidaRemovida,'jpg');    
end % fin de ciclo

end

