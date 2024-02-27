function [ ] = detectROICandidates2( pathPrincipal, numROI, nombreImagenRemovida, imagenNombreFR, imagenNombreROI, imagenSalida,archivoVectorDef, nombreImagenOriginal)
% ########################################################################
% Project AUTOMATIC CLASSIFICATION OF ORANGES BY SIZE AND DEFECTS USING 
% COMPUTER VISION TECHNIQUES 2018
% juancarlosmiranda81@gmail.com
% ########################################################################
%A partir de una imagen ROI de los defectos, obtiene un listado en un
%archivo, el cual es relacionado con los defctos detectados y analizados
%por un clasificador.
%clc; clear all; close all;

etiqueta='CANDIDATO';

HOME=strcat(pwd,'/');
pathResultados=strcat(HOME,'OrangeResults/byDefects/PSMet2/FruitEvaluation/','output/'); %
pathTraining=strcat(HOME,'OrangeResults/byDefects/PSMet2/SegMarkExpExtraction/','output/'); %

%% Lectura de la imagen con fondo removido
IFR=imread(imagenNombreFR);
ImROI=imread(imagenNombreROI);


%% Binarización de la silueta fondo removido
umbral=graythresh(IFR);
IFRB1=im2bw(IFR,umbral); %Imagen tratada


%% imagenes
%% figure; imshow(ImROI); %primer codigo que andaba

%% ------ABRIR IMAGEN ------------------
%img = imread(imagenNombreROI);
img = imread(nombreImagenRemovida);
fh = figure;
imshow(img, 'border', 'tight'); %//show your image
hold on;

%% Etiquetar elementos conectados

[ListadoObjetos Ne]=bwlabel(IFRB1);

%% Calcular propiedades de los objetos de la imagen
propiedades= regionprops(ListadoObjetos);

%% Buscar áreas de pixeles correspondientes a objetos
seleccion=find([propiedades.Area]);


%% ------FRAGMENTO DE CLASIFICADOR
%% Carga del dataset de entrenamiento
ETIQUETA_EXPERTO=34;
CARACTERISTICA1=16;
CARACTERISTICA2=26;

% No llevan la misma direccion porque el archivo para test se contruye con
% cada mancha
CARACTERISTICATEST1=14;
CARACTERISTICATEST2=24;


%% primera configuracion
%ETIQUETA_EXPERTO=29;
%CARACTERISTICA1=15;
%CARACTERISTICA2=25;

%CARACTERISTICATEST1=14;
%CARACTERISTICATEST2=24;


numeroVecinos=5;
formatSpec='%s%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%s';

nombreArchivoTraining='BDDEFECTOSCALYX.csv';
fileHandlerTraining=strcat(pathTraining,nombreArchivoTraining); %handle para conjunto de entrenamiento
% se cargan los datos en una tabla
tablaDSTraining = readtable(fileHandlerTraining,'Delimiter',',','Format',formatSpec);
%se cargan las etiquetas de clasificacion
tablaDSTrainingClasificacion=tablaDSTraining(:,ETIQUETA_EXPERTO);
% se cargan las caracteristicas que alimentaran al clasificador, el lugar
tablaDSTrainingCaracteristicas=tablaDSTraining(:,CARACTERISTICA1:CARACTERISTICA2);

%pause
%% Conversion de tablas a array cell
% Con el fin de ingresar al clasificador se realizan las conversiones de
% tipo
arrayTrainingClasificacion=table2cell(tablaDSTrainingClasificacion);

%Conversion de tabla a array y de array a matriz
arrayTrainingCaracteristicas=table2array(tablaDSTrainingCaracteristicas);

fprintf('Entrenando clasificador REGIONES CANDIDATAS --> \n');
Clasificador = fitcknn(arrayTrainingCaracteristicas,arrayTrainingClasificacion,'NumNeighbors',numeroVecinos,'Standardize',1);





%% obtenr coordenadas de areas
contadorObjetos=0; %encontrados
%numeroCuadro='';
%size(seleccion,2)
% consulta si existen objetos, puede venir una imagen vacía
if (size(seleccion,2)==0)
    %si no existen objetos coloca en cero todos los valores de
    %caracteristicas.
    fprintf('cantidad de objetos %i \n', contadorObjetos);
    promedioRGBR=0.0;
    promedioRGBG=0.0;
    promedioRGBB=0.0;
    desviacionRGBR=0.0;
    desviacionRGBG=0.0;
    desviacionRGBB=0.0;
    promedioLABL=0.0;
    promedioLABA=0.0;
    promedioLABB=0.0;
    desviacionLABL=0.0;
    desviacionLABA=0.0;
    desviacionLABB=0.0;
    promedioHSVH=0.0;
    promedioHSVS=0.0;
    promedioHSVV=0.0;
    desviacionHSVH=0.0;
    desviacionHSVS=0.0;
    desviacionHSVV=0.0;
    sumaArea=0;
    perimetro=0.0;
    excentricidad=0.0;
    ejeMayor=0.0;
    ejeMenor=0.0;
    entropia=0.0;
    inercia=0.0;
    energia=0.0;
    etiqueta='VACIO';
    x=0; 
    y=0;
    w=0;
    h=0;
    fila=sprintf('%s, %10i, %10i, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10i, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10i, %10i, %10i, %10i, %s \n', nombreImagenOriginal, numROI, contadorObjetos, promedioRGBR, promedioRGBG, promedioRGBB, desviacionRGBR, desviacionRGBG, desviacionRGBB, promedioLABL, promedioLABA, promedioLABB, desviacionLABL, desviacionLABA, desviacionLABB, promedioHSVH, promedioHSVS, promedioHSVV, desviacionHSVH, desviacionHSVS, desviacionHSVV, sumaArea, perimetro, excentricidad, ejeMayor, ejeMenor, entropia, inercia, energia, x, y, w, h,etiqueta);
    guardarAVDefCalyx2( archivoVectorDef, fila);       
else
%% ------------------------
for n=1:size(seleccion,2)
    contadorObjetos=contadorObjetos+1;
    coordenadasAPintar=round(propiedades(seleccion(n)).BoundingBox); %coordenadas de pintado
    %% recorta las imagenes

    ISiluetaROI = imcrop(IFRB1,coordenadasAPintar);
    IFondoR = imcrop(ImROI,coordenadasAPintar);
    
    %% INICIO extraer caracteristicas
    % las siluetas ya denen venir binarizadas con Otzu.
    [ promedioRGBR, promedioRGBG, promedioRGBB, desviacionRGBR, desviacionRGBG, desviacionRGBB ] = extractMeanCImgRGB( IFondoR, ISiluetaROI);
%    fprintf('%i, %f, %f, %f, %f, %f, %f \n',contadorObjetos, promedioR, promedioG, promedioB, desviacionR, desviacionG, desviacionB);

    [ promedioLABL, promedioLABA, promedioLABB, desviacionLABL, desviacionLABA, desviacionLABB ] = extractMeanCImgLAB( IFondoR, ISiluetaROI);
%    fprintf('%f, %f, %f, %f, %f, %f \n', promedioL, promedioA, promedioB, desviacionL, desviacionA, desviacionB);

    [ promedioHSVH, promedioHSVS, promedioHSVV, desviacionHSVH, desviacionHSVS, desviacionHSVV ] = extractMeanCImgHSV( IFondoR, ISiluetaROI);
%    fprintf('%f, %f, %f, %f, %f, %f \n', promedioH, promedioS, promedioV, desviacionH, desviacionS, desviacionV);

%    fprintf('contador objetos %i \n', contadorObjetos);    
    [ sumaArea, perimetro, excentricidad, ejeMayor, ejeMenor ] = extractDefCarGeoImg(ISiluetaROI);
%    fprintf('%10i, %10.4f, %10.4f, %10.4f, %10.4f, \n',  sumaArea, perimetro, excentricidad, ejeMayor, ejeMenor);    
    
    [ entropia, inercia, energia  ] = extractCTextures( IFondoR, ISiluetaROI);
    

    %% FIN extraer caracteristicas  
    fprintf('En el archivo %s antes de correr el clasificador de DEFECTOS\n', archivoVectorDef);
    
    %% ---------------  CLASIFICACION DEL DEFECTO -------------------------
    cellRegistro = {nombreImagenOriginal, promedioRGBR, promedioRGBG, promedioRGBB, desviacionRGBR, desviacionRGBG, desviacionRGBB, promedioLABL, promedioLABA, promedioLABB, desviacionLABL, desviacionLABA, desviacionLABB, promedioHSVH, promedioHSVS, promedioHSVV, desviacionHSVH, desviacionHSVS, desviacionHSVV, sumaArea, perimetro, excentricidad, ejeMayor, ejeMenor, entropia, inercia, energia, etiqueta};
    tablaDSTest = cell2table(cellRegistro(1:end,:));
    tablaDSTestComparar=tablaDSTest(:,CARACTERISTICATEST1:CARACTERISTICATEST2); %tabla con solo caracteristicas
    arrayTest=table2array(tablaDSTestComparar); %convierte a array para extraer lo necesario

    %
    objetoComparar = arrayTest(1,1:11) %objeto a comparar

    %% Ejecucion de prediccion
    fprintf('Clasificando REGIONES CANDIDATAS --> \n');
    clasificacionObjeto = predict(Clasificador,objetoComparar);
    fprintf('indiceTest=%i ,cs=>%s|\n', contadorObjetos, char(clasificacionObjeto(1)));

    %% guardar el archivo
    %fila=sprintf('%s, %10i, %10i, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10i, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10i, %10i, %10i, %10i, %10i, %10i, %10i, %10i, %s \n', nombreImagenOriginal, numROI, contadorObjetos, promedioRGBR, promedioRGBG, promedioRGBB, desviacionRGBR, desviacionRGBG, desviacionRGBB, promedioLABL, promedioLABA, promedioLABB, desviacionLABL, desviacionLABA, desviacionLABB, promedioHSVH, promedioHSVS, promedioHSVV, desviacionHSVH, desviacionHSVS, desviacionHSVV, sumaArea, perimetro, excentricidad, ejeMayor, ejeMenor, entropia, inercia, energia, coordenadasAPintar(1),  coordenadasAPintar(2), coordenadasAPintar(3), coordenadasAPintar(4), char(clasificacionObjeto(1)));
    fila=sprintf('%s, %10i, %10i, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10i, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10i, %10i, %10i, %10i, %s \n', nombreImagenOriginal, numROI, contadorObjetos, promedioRGBR, promedioRGBG, promedioRGBB, desviacionRGBR, desviacionRGBG, desviacionRGBB, promedioLABL, promedioLABA, promedioLABB, desviacionLABL, desviacionLABA, desviacionLABB, promedioHSVH, promedioHSVS, promedioHSVV, desviacionHSVH, desviacionHSVS, desviacionHSVV, sumaArea, perimetro, excentricidad, ejeMayor, ejeMenor, entropia, inercia, energia, coordenadasAPintar(1), coordenadasAPintar(2), coordenadasAPintar(3), coordenadasAPintar(4), char(clasificacionObjeto(1)));
    saveAVDefCalyx2( archivoVectorDef, fila);

    %% selector para marcar en un windows
    switch char(clasificacionObjeto(1))
        case 'DEFECTOS'
        rectangle('Position',propiedades(n).BoundingBox,'EdgeColor','g','LineWidth',2)
        text(propiedades(n).Centroid(:,1), propiedades(n).Centroid(:,2),int2str(n),'Color','b');
        hold on %se van a gregando a la figura principal
        case 'CALYX'
        rectangle('Position',propiedades(n).BoundingBox,'EdgeColor','r','LineWidth',2)
        text(propiedades(n).Centroid(:,1), propiedades(n).Centroid(:,2),int2str(n),'Color','b');
        hold on %se van a gregando a la figura principal
    end

    %% ------------- PINTAR MANCHAS ---------------
    % Si clasificacion de objeto igual a CALYX O A DEFECTOS PINTAR
    
end % fin de ciclo


end% fin if

%% Mostrar imagen resultante

%% ------CERRAR IMAGEN ------------------
frm = getframe( fh ); %// get the image+rectangle
imwrite( frm.cdata, imagenSalida ); %// save to file
close( fh );


end %fin funcion

