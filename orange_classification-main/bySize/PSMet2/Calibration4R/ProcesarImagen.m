function [ ] = ProcesarImagen(pathEntrada, pathAplicacion, nombreImagenP, archivoCalibracion, archivoVector, ArrayCuadros, areaObjetosRemoverBR, canalLMin, canalLMax, canalAMin, canalAMax, canalBMin, canalBMax )
%Proceso completo que se realiza por cada fotografia de entrada
% Se obtienen los datos aplicando operaciones morfológicas y extrayendo
% características geométricas.
% Se guardan resultados intermedios de manera a que se puedan obtener
% imagenes del proceso.
% -----------------------------------------------------------------------

%% Datos de configuración archivos

% Para la calibración se necesita la secuencia de recorte solamente


imagenInicial=strcat(pathEntrada,nombreImagenP);


%% DIRECTORIOS DE GUARDADO
pathAplicacionPR=strcat(pathAplicacion,'pr/'); %pre procesing
pathAplicacionBR=strcat(pathAplicacion,'br/'); %background removal
pathAplicacionROI=strcat(pathAplicacion,'roi/'); %region of interest



%pathAplicacion1=strcat(pathAplicacion,'recortes/');
pathAplicacion2=strcat(pathAplicacion,'sFrutas/');
pathAplicacion3=strcat(pathAplicacion,'removido/');
pathAplicacion4=strcat(pathAplicacion,'sDefectos/');
pathAplicacion5=strcat(pathAplicacion,'defectos/');
%pathAplicacion6=strcat(pathAplicacion,'cDefectos/');

% --- NOMBRE DE IMAGENES INTERMEDIAS ---
% con fondo removido
imagenNombrePR=strcat(pathAplicacionPR,nombreImagenP,'_','PR.jpg'); %imagen RGB con lineas pintadas;
nombreImagenBR=strcat(pathAplicacionBR,nombreImagenP,'_','BR.jpg'); %para indicar silueta del fondo removido
nombreImagenROI=strcat(pathAplicacionROI,nombreImagenP,'_','RO.jpg'); %para indicar el fondo removido y ROI

%prefijo para imagenes de fondo removido y siluetas de fondos removidos en
%deteccion de objetos
nombreImagenSiluetaN=strcat(pathAplicacion2,nombreImagenP,'_','sN');
nombreImagenRemovida=strcat(pathAplicacion3,nombreImagenP,'_','rm');

% Siluetas operaciones morfologicas
nombreImagenSiluetaN1=strcat(pathAplicacion2,nombreImagenP,'_','sN1.jpg');
nombreImagenSiluetaN2=strcat(pathAplicacion2,nombreImagenP,'_','sN2.jpg');
nombreImagenSiluetaN3=strcat(pathAplicacion2,nombreImagenP,'_','sN3.jpg');
nombreImagenSiluetaN4=strcat(pathAplicacion2,nombreImagenP,'_','sN4.jpg');

% nombres de archivos con objetos removidos
nombreImagenRemovida1=strcat(pathAplicacion3,nombreImagenP,'_','rm1.jpg');
nombreImagenRemovida2=strcat(pathAplicacion3,nombreImagenP,'_','rm2.jpg');
nombreImagenRemovida3=strcat(pathAplicacion3,nombreImagenP,'_','rm3.jpg');
nombreImagenRemovida4=strcat(pathAplicacion3,nombreImagenP,'_','rm4.jpg');


    %% salida segmentacion
    nombreImagenSalida1=strcat(pathAplicacion4,nombreImagenP,'_','so1.jpg');
    nombreImagenSalida2=strcat(pathAplicacion4,nombreImagenP,'_','so2.jpg');
    nombreImagenSalida3=strcat(pathAplicacion4,nombreImagenP,'_','so3.jpg');
    nombreImagenSalida4=strcat(pathAplicacion4,nombreImagenP,'_','so4.jpg');

    %% salida defectos
    nombreImagenDefectos1=strcat(pathAplicacion5,nombreImagenP,'_','soM1.jpg');
    nombreImagenDefectos2=strcat(pathAplicacion5,nombreImagenP,'_','soM2.jpg');
    nombreImagenDefectos3=strcat(pathAplicacion5,nombreImagenP,'_','soM3.jpg');
    nombreImagenDefectos4=strcat(pathAplicacion5,nombreImagenP,'_','soM4.jpg');


%% GRANULOMETRIAS
%areaObjetosRemoverBR=5000; % para siluetas y detección de objetos. Tamaño para realizar granulometria
tamanoObjetosCar=2000; %granulometria para extraccion de objetos segun car geometricas

%% ----- INICIO Definicion de topes
% Para definicion de rectangulos
% Se calcula el tamaño de la imagen para luego aplicar las lineas de
% cortes.
% obtener el tamaño


%% -- BEGIN IMAGE PROCESSING ----------------------------------
%% Separacion de fondo
%fprintf('BR -> Pre tratamiento de fondo --> \n');
% Sigue la sintaxis de los rectangulos xmin,ymin,width,height
Cuadro1_lineaGuiaInicialColumna=ArrayCuadros(1,1);
Cuadro1_lineaGuiaInicialFila=ArrayCuadros(1,2);
Cuadro1_espacioColumna=ArrayCuadros(1,3);
Cuadro1_espacioFila=ArrayCuadros(1,4);
%imagenInicial
%imagenNombrePR
%BRPreProc(imagenInicial, imagenNombrePR, Cuadro1_lineaGuiaInicialColumna, Cuadro1_lineaGuiaInicialFila-2, Cuadro1_espacioColumna, Cuadro1_espacioFila);

fprintf('BR -> Segmentación de fondo --> \n'); %salida una imagen con 4 siluetas
BRemovalLAB(imagenInicial, nombreImagenBR, areaObjetosRemoverBR, canalLMin, canalLMax, canalAMin, canalAMax, canalBMin, canalBMax,Cuadro1_lineaGuiaInicialColumna, Cuadro1_lineaGuiaInicialFila-2, Cuadro1_espacioColumna, Cuadro1_espacioFila);

%% Removiendo fondo
fprintf('BR -> Removiendo fondo, separacion ROI--> \n'); %salida una imagen con 4 objetos
removerFondo4(imagenInicial, nombreImagenBR, nombreImagenROI);

%% Recortes de ROI
fprintf('BR -> Detección de objetos en cuadros. Recortando ROI y siluetas ROI --> \n'); %salida 4 imagenes de un objeto cada una
deteccionObjetos2( nombreImagenBR, nombreImagenROI, nombreImagenSiluetaN, nombreImagenRemovida, ArrayCuadros )

%% -- END IMAGE PROCESSING ----------------------------------


    
%% -- BEGIN DEFECTS FEATURES EXTRACTION ----------------------------------
%% Segmentacion de mascara para obtener defectos aislados de ROI
%fprintf('Segmentacion de mascara para obtener defectos aislados de ROI --> \n');
% Esta es la funcion que da buenos resultados
%%Imagen 1 
%   SegmentacionSobel1(nombreImagenRemovida1, nombreImagenSalida1);
%   SegmentacionSobel1(nombreImagenRemovida2, nombreImagenSalida2);
%   SegmentacionSobel1(nombreImagenRemovida3, nombreImagenSalida3);
%   SegmentacionSobel1(nombreImagenRemovida4, nombreImagenSalida4);   

%   SegmentacionPrewitt(nombreImagenRemovida1, nombreImagenSalida1);
%   SegmentacionPrewitt(nombreImagenRemovida2, nombreImagenSalida2);
%   SegmentacionPrewitt(nombreImagenRemovida3, nombreImagenSalida3);
%   SegmentacionPrewitt(nombreImagenRemovida4, nombreImagenSalida4);   

%%   extraerRegionManchasPrewitt( nombreImagenSalida1, nombreImagenDefectos1, tamanoManchas);
%   extraerRegionManchasPrewitt( nombreImagenSalida2, nombreImagenDefectos2, tamanoManchas);
%   extraerRegionManchasPrewitt( nombreImagenSalida3, nombreImagenDefectos3, tamanoManchas);    
%   extraerRegionManchasPrewitt( nombreImagenSalida4, nombreImagenDefectos4, tamanoManchas);
%% Esto no da tan buenos resultados, luego de experimentar, el procedimiento 1 es el mejor
%   SegmentacionSobel2(nombreImagenRemovida1, nombreImagenSalida1);
%   SegmentacionSobel2(nombreImagenRemovida2, nombreImagenSalida2);
%   SegmentacionSobel2(nombreImagenRemovida3, nombreImagenSalida3);
%   SegmentacionSobel2(nombreImagenRemovida4, nombreImagenSalida4);   
   
%% Separación de defectos
%fprintf('Separación de defectos en color --> \n');
%removerFondo4(nombreImagenRemovida1, nombreImagenSalida1, nombreImagenDefectos1);
%removerFondo4(nombreImagenRemovida2, nombreImagenSalida2, nombreImagenDefectos2);
%removerFondo4(nombreImagenRemovida3, nombreImagenSalida3, nombreImagenDefectos3);
%removerFondo4(nombreImagenRemovida4, nombreImagenSalida4, nombreImagenDefectos4);

%% -- END DEFECTS FEATURES EXTRACTION ----------------------------------
    


%% By Size --> Extraccion de caracteristicas
pixelmmR1=lecturaConfiguracion('pixelLinealR1', archivoCalibracion);
pixelmmR2=lecturaConfiguracion('pixelLinealR2', archivoCalibracion);
pixelmmR3=lecturaConfiguracion('pixelLinealR3', archivoCalibracion);
pixelmmR4=lecturaConfiguracion('pixelLinealR4', archivoCalibracion);





%% Declaracion de variables con valores de pixeles
%% Recorte 1
sumaAreaPxR1=0; 
diametroPxR1=0; 
ejeMayorPxR1=0; 
ejeMenorPxR1=0;

sumaAreammR1=0.0;
diametrommR1=0.0;
ejeMayormmR1=0.0;
ejeMenormmR1=0.0;

%% Recorte 2
sumaAreaPxR2=0; 
diametroPxR2=0; 
ejeMayorPxR2=0; 
ejeMenorPxR2=0;

sumaAreammR2=0.0;
diametrommR2=0.0;
ejeMayormmR2=0.0;
ejeMenormmR2=0.0;

%% Recorte 3
sumaAreaPxR3=0; 
diametroPxR3=0; 
ejeMayorPxR3=0; 
ejeMenorPxR3=0;

sumaAreammR3=0.0;
diametrommR3=0.0;
ejeMayormmR3=0.0;
ejeMenormmR3=0.0;

%% Recorte 4
sumaAreaPxR4=0; 
diametroPxR4=0; 
ejeMayorPxR4=0; 
ejeMenorPxR4=0;

sumaAreammR4=0.0;
diametrommR4=0.0;
ejeMayormmR4=0.0;
ejeMenormmR4=0.0;

%% Extracción de características
fprintf('Extraccion de características geometricas--> \n');
fprintf('Extraccion de características geometricas Recorte 1 --> \n');
[ sumaAreaPxR1, diametroPxR1, ejeMayorPxR1, ejeMenorPxR1]=extraerCarGeom4R( nombreImagenSiluetaN1,tamanoObjetosCar);
fprintf('Extraccion de características geometricas Recorte 2 --> \n');
[ sumaAreaPxR2, diametroPxR2, ejeMayorPxR2, ejeMenorPxR2]=extraerCarGeom4R( nombreImagenSiluetaN2,tamanoObjetosCar);
fprintf('Extraccion de características geometricas Recorte 3 --> \n');
[ sumaAreaPxR3, diametroPxR3, ejeMayorPxR3, ejeMenorPxR3]=extraerCarGeom4R( nombreImagenSiluetaN3,tamanoObjetosCar);
fprintf('Extraccion de características geometricas Recorte 4 --> \n');
[ sumaAreaPxR4, diametroPxR4, ejeMayorPxR4, ejeMenorPxR4]=extraerCarGeom4R( nombreImagenSiluetaN4,tamanoObjetosCar);


%% Cálculo para unidades de medida
diametrommR1=diametroPxR1*pixelmmR1;
%sumaAreammR1=sumaAreaPxR1*pixelCuadradoR1;
ejeMayormmR1=ejeMayorPxR1*pixelmmR1;
ejeMenormmR1=ejeMenorPxR1*pixelmmR1;

diametrommR2=diametroPxR2*pixelmmR2;
%sumaAreammR2=sumaAreaPxR2*pixelCuadradoR2;
ejeMayormmR2=ejeMayorPxR2*pixelmmR2;
ejeMenormmR2=ejeMenorPxR2*pixelmmR2;

diametrommR3=diametroPxR3*pixelmmR3;
%sumaAreammR3=sumaAreaPxR3*pixelCuadradoR3;
ejeMayormmR3=ejeMayorPxR3*pixelmmR3;
ejeMenormmR3=ejeMenorPxR3*pixelmmR3;

diametrommR4=diametroPxR4*pixelmmR4;
%sumaAreammR4=sumaAreaPxR4*pixelCuadradoR4;
ejeMayormmR4=ejeMayorPxR4*pixelmmR4;
ejeMenormmR4=ejeMenorPxR4*pixelmmR4;


%% Guardado en archivo
clase='SIN_CLASIFICAR';
fprintf('Características obtenidas --> \n');
fprintf('%s, %10.4f, %10.4f, %10.4f, %10.4f,%10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %s \n', imagenInicial, pixelmmR1, pixelmmR2, pixelmmR3, pixelmmR4, sumaAreaPxR1, sumaAreaPxR2, sumaAreaPxR3, sumaAreaPxR4, diametroPxR1, diametroPxR2, diametroPxR3, diametroPxR4, ejeMayorPxR1, ejeMayorPxR2, ejeMayorPxR3, ejeMayorPxR4, ejeMenorPxR1, ejeMenorPxR2, ejeMenorPxR3, ejeMenorPxR4, diametrommR1, diametrommR2, diametrommR3, diametrommR4, ejeMayormmR1, ejeMayormmR2, ejeMayormmR3, ejeMayormmR4, ejeMenormmR1, ejeMenormmR2, ejeMenormmR3, ejeMenormmR4, clase);

% Se guardan primero todo lo relacionado a pixeles, luego las conversiones
% a milimetros
fila=sprintf('%s, %10.4f, %10.4f, %10.4f, %10.4f,%10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %s \n', imagenInicial, pixelmmR1, pixelmmR2, pixelmmR3, pixelmmR4, sumaAreaPxR1, sumaAreaPxR2, sumaAreaPxR3, sumaAreaPxR4, diametroPxR1, diametroPxR2, diametroPxR3, diametroPxR4, ejeMayorPxR1, ejeMayorPxR2, ejeMayorPxR3, ejeMayorPxR4, ejeMenorPxR1, ejeMenorPxR2, ejeMenorPxR3, ejeMenorPxR4, diametrommR1, diametrommR2, diametrommR3, diametrommR4, ejeMayormmR1, ejeMayormmR2, ejeMayormmR3, ejeMayormmR4, ejeMenormmR1, ejeMenormmR2, ejeMenormmR3, ejeMenormmR4, clase);
guardarAVSyze4R( archivoVector, fila)

% -----------------------------------------------------------------------


fprintf('Extraccion de características Defectos--> \n');
%[ sumaArea, redondez, diametro, ejeMayor, ejeMenor, totalPixelesManchas, totalManchas ] = extraerCarPrewitt( nombreImagenRemovida1, nombreImagenDefectos1, nombreImagenDefectos2, nombreImagenDefectos3, nombreImagenDefectos4);



% -----------------------------------------------------------------------
end %end proceso completo

