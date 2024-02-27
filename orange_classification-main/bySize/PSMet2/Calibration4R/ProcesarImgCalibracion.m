function [ ] = ProcesarImgCalibracion(pathEntrada, pathAplicacion, nombreImagenP, ArrayCuadros, areaObjetosRemoverBR, canalLMin, canalLMax, canalAMin, canalAMax, canalBMin, canalBMax)
%               ProcesarImagen       (pathEntrada, pathAplicacion, nombreImagenP, archivoCalibracion, archivoVector, ArrayCuadros, areaObjetosRemoverBR, canalLMin, canalLMax, canalAMin, canalAMax, canalBMin, canalBMax )
%function [ ] = ProcesarImgCalibracion(pathEntrada, pathAplicacion, nombreImagenP, ArrayCuadros, areaObjetosRemoverBR, canalLMin, canalLMax, canalAMin, canalAMax, canalBMin, canalBMax)
% Separa el fondo y genera imagenes con las regiones de interese separadas
% Se procesa una imagen pero no se sacan caracteristicas geometricas ni de
% colores, es a los efectos de generar las imagenes siluetas.
% los resultados son imagenes que sirven como entrada para un proceso de
% medición, de las imagenes se obtienen las equivalencias
%% Datos de configuración archivos


imagenInicial=fullfile(pathEntrada,nombreImagenP);


%% DIRECTORIOS DE GUARDADO
pathAplicacionPR=fullfile(pathAplicacion,'pr'); %pre procesing
pathAplicacionBR=fullfile(pathAplicacion,'br'); %background removal
pathAplicacionROI=fullfile(pathAplicacion,'roi'); %region of interest



%pathAplicacion1=strcat(pathAplicacion,'recortes/');
pathAplicacion2=fullfile(pathAplicacion,'sFrutas');
pathAplicacion3=fullfile(pathAplicacion,'removido');
%pathAplicacion4=strcat(pathAplicacion,'sDefectos/');
%pathAplicacion5=strcat(pathAplicacion,'defectos/');
%pathAplicacion6=strcat(pathAplicacion,'cDefectos/');

% --- NOMBRE DE IMAGENES INTERMEDIAS ---
% con fondo removido
imagenNombrePR=fullfile(pathAplicacionPR,strcat(nombreImagenP,'_','PR.jpg')); %imagen RGB con lineas pintadas;
nombreImagenBR=fullfile(pathAplicacionBR,strcat(nombreImagenP,'_','BR.jpg')); %para indicar silueta del fondo removido
nombreImagenROI=fullfile(pathAplicacionROI,strcat(nombreImagenP,'_','RO.jpg')); %para indicar el fondo removido y ROI

%prefijo para imagenes de fondo removido y siluetas de fondos removidos en
%deteccion de objetos
nombreImagenSiluetaN=fullfile(pathAplicacion2,strcat(nombreImagenP,'_','sN'));
nombreImagenRemovida=fullfile(pathAplicacion3,strcat(nombreImagenP,'_','rm'));


% nombres de archivos con objetos fondo removidos
%nombreImagenRemovida1=strcat(pathAplicacion3,nombreImagenP,'_','rm1.jpg');
%nombreImagenRemovida2=strcat(pathAplicacion3,nombreImagenP,'_','rm2.jpg');
%nombreImagenRemovida3=strcat(pathAplicacion3,nombreImagenP,'_','rm3.jpg');
%nombreImagenRemovida4=strcat(pathAplicacion3,nombreImagenP,'_','rm4.jpg');


    %% salida segmentacion
%    nombreImagenSalida1=strcat(pathAplicacion4,nombreImagenP,'_','so1.jpg');
%    nombreImagenSalida2=strcat(pathAplicacion4,nombreImagenP,'_','so2.jpg');
%    nombreImagenSalida3=strcat(pathAplicacion4,nombreImagenP,'_','so3.jpg');
%    nombreImagenSalida4=strcat(pathAplicacion4,nombreImagenP,'_','so4.jpg');

    %% salida defectos
%    nombreImagenDefectos1=strcat(pathAplicacion5,nombreImagenP,'_','soM1.jpg');
%    nombreImagenDefectos2=strcat(pathAplicacion5,nombreImagenP,'_','soM2.jpg');
%    nombreImagenDefectos3=strcat(pathAplicacion5,nombreImagenP,'_','soM3.jpg');
%    nombreImagenDefectos4=strcat(pathAplicacion5,nombreImagenP,'_','soM4.jpg');


%% GRANULOMETRIAS
%areaObjetosRemoverBR=5000; % para siluetas y detección de objetos. Tamaño para realizar granulometria
%% configuracion de umbrales
%canalLMin = 0.0; canalLMax = 96.653; canalAMin = -23.548; canalAMax = 16.303; canalBMin = -28.235; canalBMax = -1.169;

% ----- FIN Definicion de las variables de configuracion -----




%% -- BEGIN IMAGE PROCESSING ----------------------------------
%% Separacion de fondo
%fprintf('BR -> Pre tratamiento de fondo --> \n');
% Sigue la sintaxis de los rectangulos xmin,ymin,width,height
Cuadro1_lineaGuiaInicialColumna=ArrayCuadros(1,1);
Cuadro1_lineaGuiaInicialFila=ArrayCuadros(1,2);
Cuadro1_espacioColumna=ArrayCuadros(1,3);
Cuadro1_espacioFila=ArrayCuadros(1,4);
%BRPreProc(imagenInicial, imagenNombrePR, Cuadro1_lineaGuiaInicialColumna, Cuadro1_lineaGuiaInicialFila-2, Cuadro1_espacioColumna, Cuadro1_espacioFila);
%BRPreProc(imagenInicial, imagenNombrePR, Cuadro1_lineaGuiaInicialColumna, Cuadro1_lineaGuiaInicialFila-2, Cuadro1_espacioColumna, Cuadro1_espacioFila);

fprintf('BR -> Segmentación de fondo --> \n'); %salida una imagen con 4 siluetas
%BRemovalLAB(imagenInicial, nombreImagenBR, areaObjetosRemoverBR, canalLMin, canalLMax, canalAMin, canalAMax, canalBMin, canalBMax);
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
fprintf('Segmentacion de mascara para obtener defectos aislados de ROI --> \n');
% Esta es la funcion que da buenos resultados
%%Imagen 1 
%   SegmentacionSobel1(nombreImagenRemovida1, nombreImagenSalida1);
%   SegmentacionSobel1(nombreImagenRemovida2, nombreImagenSalida2);
%   SegmentacionSobel1(nombreImagenRemovida3, nombreImagenSalida3);
%   SegmentacionSobel1(nombreImagenRemovida4, nombreImagenSalida4);   
   
%% Separación de defectos
fprintf('Separación de defectos en color --> \n');
%removerFondo4(nombreImagenRemovida1, nombreImagenSalida1, nombreImagenDefectos1);
%removerFondo4(nombreImagenRemovida2, nombreImagenSalida2, nombreImagenDefectos2);
%removerFondo4(nombreImagenRemovida3, nombreImagenSalida3, nombreImagenDefectos3);
%removerFondo4(nombreImagenRemovida4, nombreImagenSalida4, nombreImagenDefectos4);

%% -- END DEFECTS FEATURES EXTRACTION ----------------------------------
    

% -----------------------------------------------------------------------
end %end proceso completo

