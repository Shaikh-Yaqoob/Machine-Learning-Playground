function [ ] = extraerRegionManchasPrewitt( nombreImagenManchas, nombreImagenDefectos, nombreImagenContorno, tamanoMaximoManchas )
% REcibe imagenes segmentadas, las cuenta y genera una imagen de solo
% manchas.
% Produce una imagen final con las manchas y sin contorno.


%% Lectura de la imagen
IManchas=imread(nombreImagenManchas);

%% Binarización
umbral=graythresh(IManchas);
IManchasB1=im2bw(IManchas,umbral); %Imagen tratada
IManchasContorno=im2bw(IManchas,umbral); %Se utiliza para obtener el complemento, se borran las particulas



%% Etiquetar elementos conectados

[ListadoObjetos Ne]=bwlabel(IManchasContorno);

%% Calcular propiedades de los objetos de la imagen

propiedades= regionprops(ListadoObjetos);

%propiedades.Area
%% Buscar áreas menores a tamanoMaximoManchas
%fprintf('tamanoMaximoManchas %i \n', tamanoMaximoManchas);
seleccion=find([propiedades.Area]<tamanoMaximoManchas);

%fprintf('seleccion Menores\n');
%seleccion
%% Eliminar áreas 

for n=1:size(seleccion,2)

    coordenadasAPintar=round(propiedades(seleccion(n)).BoundingBox);
    % pintado de manchas en colr negro
    IManchasContorno(coordenadasAPintar(2):coordenadasAPintar(2)+coordenadasAPintar(4)-1,coordenadasAPintar(1):coordenadasAPintar(1)+coordenadasAPintar(3)-1)=0;

end

%% --- sacar el contorno y dejar solamente defectos
IManchasB2=bitxor(IManchasB1,IManchasContorno);

%% ----------------------------------
%% exagerar los defectos para que puedan ser bien pintados
% Aplicacion de cerradura para agrandar y cerrar agujeros, esto permite
% tener una mejor siluetas de los defectos. Utiliza un elemento
% estructurante mayor.
SE = strel('disk', 2); %1 FUNCIONA MUY BIEN 2 es bueno
IManchasB3 = imdilate(IManchasB2,SE);% exagerando la máscara me permite tomar mas region del defecto

SE = strel('disk', 1); %
IManchasB4 = imopen(IManchasB3,SE);%


SE = strel('disk',2); %
IManchasB5 = imclose(IManchasB4,SE);%


%% cierra las manchas con agujeros
IManchasFinal = imfill(IManchasB5,'holes');


%% ----------------------------------
%% guardado de imagenes y contornos
imwrite(IManchasContorno,nombreImagenContorno,'jpg')
imwrite(IManchasFinal,nombreImagenDefectos,'jpg')
end

