%% MainCalibration.m
% Se trabaja con una equivalencia para los 4 recortes o vistas. Anteriormente se
% trabajaba para uno.

% Se debe ejecutar primeramente este script para calibrar las
% configuraciones requeridas para procesar imagenes. Aquí se configuran los
% tamaños de imagenes y de los cuadros y la correspondencia entre pixeles y
% las unidades de medidas de milímetros.

%% --------------------------------------------
%%----- inicio cuerpo de la funcion -----
%% Ajuste de parámetros iniciales
clc; clear all; close all;

 %corrida = datetime('now','Format','yyyyMMdd''T''HHmmss')
 
 
  %% Directory structure definition
 %HOMEUSER='/home/usuario/';
 %MainPath=strcat(HOMEUSER,'OrangeResults/bySize/PSMet2/Training/');
 %pathInputImages=strcat(HOMEUSER,'OrangeResults/inputToLearn/');

 
 %pathConfiguration=strcat(MainPath,'conf/');
 %pathApplication=strcat(MainPath,'tmpToLearn/'); % temporary images
 %pathApplicationSilhouettes=strcat(pathApplication,'sFruits/');
 %pathResults=strcat(MainPath,'output/');% output results
 %mainImageName='mainImageName';
 
 %% Definicion de estructura de directorios 
 %HOMEUSER=strcat(pwd,'/');
 HOMEUSER=fullfile('C:','Users', 'Usuari','development','orange_classification'); 
 pathPrincipal=fullfile(HOMEUSER,'OrangeResults','bySize','PSMet2','Calibration4R');
 
 pathEntradaCalibracion=fullfile(HOMEUSER,'OrangeResults','inputToCalibrate');
 pathEntradaSamples=fullfile(HOMEUSER,'OrangeResults','inputToCalibrate');

 pathConfiguracion=fullfile(pathPrincipal,'conf');
 pathCalibracion=fullfile(pathPrincipal,'calibration'); %se utiliza para situar las imagenes de calibracion
 pathCalibracionSiluetas=fullfile(pathCalibracion,'sFrutas');
 pathResultados=fullfile(pathPrincipal,'output');%se guardan los resultados


%
nombreImagenP='calibracion_001.jpg';
fprintf('\n 1) Copie el archivo de calibración obtenido en el directorio %s \n',pathEntradaCalibracion);   
fprintf('\n 2) Renombre el archivo a  %s \n',nombreImagenP);   
 

 
 % --- NOMBRE DE IMAGENES INTERMEDIAS calibracion ---
nombreImagenRecorte1=fullfile(pathCalibracion,strcat(nombreImagenP,'_','r1.jpg'));
nombreImagenRecorte2=fullfile(pathCalibracion,strcat(nombreImagenP,'_','r2.jpg'));
nombreImagenRecorte3=fullfile(pathCalibracion,strcat(nombreImagenP,'_','r3.jpg'));
nombreImagenRecorte4=fullfile(pathCalibracion,strcat(nombreImagenP,'_','r4.jpg'));
 

% Siluetas operaciones morfologicas calibraion
nombreImagenSiluetaN1=fullfile(pathCalibracion,strcat(nombreImagenP,'_','sN1.jpg'));
nombreImagenSiluetaN2=fullfile(pathCalibracion,strcat(nombreImagenP,'_','sN2.jpg'));
nombreImagenSiluetaN3=fullfile(pathCalibracion,strcat(nombreImagenP,'_','sN3.jpg'));
nombreImagenSiluetaN4=fullfile(pathCalibracion,strcat(nombreImagenP,'_','sN4.jpg'));

 %% Nombres de archivos de configuracion
 % trabajan con métodos para equivalencia con las 4 vistas
 
 %%
 archivoConfiguracion=fullfile(pathConfiguracion,'20170916configuracion.xml'); %Para coordenadas iniciales en tratamiento de imagenes
 %archivoCalibracion=fullfile(pathConfiguracion,'20170916calibracion.xml'); %para indicar al usuario en la parte final la calibracion
 execution_time=string(datetime('now','Format','yyyyMMddHHmmss'));
 calibrationFile= strcat(execution_time,'calibracion.xml');
 archivoCalibracion=fullfile(pathConfiguracion,calibrationFile); %para indicar al usuario en la parte final la calibracion 

 
 
 archivoVector=fullfile(pathResultados,'archivoCalibracion.csv'); %archivo de salida

  
 %% Definicion de los cuadros, según numeración 
Fila1=lecturaConfiguracion('Fila1', archivoConfiguracion);
FilaAbajo=lecturaConfiguracion('FilaAbajo', archivoConfiguracion);

%Cuadro 1 abajo
Cuadro1_lineaGuiaInicialFila=lecturaConfiguracion('Cuadro1_lineaGuiaInicialFila', archivoConfiguracion);
Cuadro1_lineaGuiaInicialColumna=lecturaConfiguracion('Cuadro1_lineaGuiaInicialColumna', archivoConfiguracion);
Cuadro1_espacioFila=lecturaConfiguracion('Cuadro1_espacioFila', archivoConfiguracion);
Cuadro1_espacioColumna=lecturaConfiguracion('Cuadro1_espacioColumna', archivoConfiguracion);

%Cuadro 2 izquierda
Cuadro2_lineaGuiaInicialFila=lecturaConfiguracion('Cuadro2_lineaGuiaInicialFila', archivoConfiguracion);
Cuadro2_lineaGuiaInicialColumna=lecturaConfiguracion('Cuadro2_lineaGuiaInicialColumna', archivoConfiguracion);
Cuadro2_espacioFila=lecturaConfiguracion('Cuadro2_espacioFila', archivoConfiguracion);
Cuadro2_espacioColumna=lecturaConfiguracion('Cuadro2_espacioColumna', archivoConfiguracion);

%Cuadro 3 centro
Cuadro3_lineaGuiaInicialFila=lecturaConfiguracion('Cuadro3_lineaGuiaInicialFila', archivoConfiguracion);
Cuadro3_lineaGuiaInicialColumna=lecturaConfiguracion('Cuadro3_lineaGuiaInicialColumna', archivoConfiguracion);
Cuadro3_espacioFila=lecturaConfiguracion('Cuadro3_espacioFila', archivoConfiguracion);
Cuadro3_espacioColumna=lecturaConfiguracion('Cuadro3_espacioColumna', archivoConfiguracion);

%Cuadro 4 derecha
Cuadro4_lineaGuiaInicialFila=lecturaConfiguracion('Cuadro4_lineaGuiaInicialFila', archivoConfiguracion);
Cuadro4_lineaGuiaInicialColumna=lecturaConfiguracion('Cuadro4_lineaGuiaInicialColumna', archivoConfiguracion);
Cuadro4_espacioFila=lecturaConfiguracion('Cuadro4_espacioFila', archivoConfiguracion);
Cuadro4_espacioColumna=lecturaConfiguracion('Cuadro4_espacioColumna', archivoConfiguracion);

%%carga en memoria para que sea mas rapido
ArrayCuadros=[Cuadro1_lineaGuiaInicialColumna, Cuadro1_lineaGuiaInicialFila, Cuadro1_espacioColumna, Cuadro1_espacioFila;
Cuadro2_lineaGuiaInicialColumna, Cuadro2_lineaGuiaInicialFila, Cuadro2_espacioColumna, Cuadro2_espacioFila;
Cuadro3_lineaGuiaInicialColumna, Cuadro3_lineaGuiaInicialFila, Cuadro3_espacioColumna, Cuadro3_espacioFila;
Cuadro4_lineaGuiaInicialColumna, Cuadro4_lineaGuiaInicialFila, Cuadro4_espacioColumna, Cuadro4_espacioFila;
0,0,0,0
];

%% GRANULOMETRIAS
areaObjetosRemoverBR=5000; % para siluetas y detección de objetos. Tamaño para realizar granulometria
%% configuracion de umbrales
canalLMin = 0.0; canalLMax = 96.653; canalAMin = -23.548; canalAMax = 16.303; canalBMin = -28.235; canalBMax = -1.169; %parametros de umbralizacion de fondo

 
%% Ingreso de valores 
 banderaCalibracion=input('Ingrese 0=falta calibrar, 1=ya esta calibrado >'); %0 falta calabrar 1=calibrado
 NOCALIBRADO=0;
 
 %% Remover archivos antiguos, borrar archivos antiguos
 removerArchivos(archivoVector);

%% Inicio del proceso
 if(banderaCalibracion==NOCALIBRADO)
    fprintf('\n--- PROCESO DE CALIBRACIÓN EN MARCHA --- \n');    
    ProcesarImgCalibracion(pathEntradaCalibracion, pathCalibracion, nombreImagenP, ArrayCuadros, areaObjetosRemoverBR, canalLMin, canalLMax, canalAMin, canalAMax, canalBMin, canalBMax);
    calibracionDef24R(pathCalibracionSiluetas, nombreImagenP,archivoCalibracion);
    

    fprintf('\n--- ATENCIÓN! --- \n');        
    fprintf('1) Repita el proceso de tantas veces sea posible, ajuste los \n valores manualmente para hacer coincidir \n los cuadros en el archivo Para calibrar sobre escriba MANUALMENTE con los valores obtenidos como resultados en el archivo %s \n', archivoConfiguracion);        
    fprintf('2) Para calibrar la correspondencia entre pixeles y milímetros \n sobreescriba MANUALMENTE con los valores \n obtenidos como resultados en el archivo %s \n', archivoCalibracion);
 else
    fprintf('\n--- CALCULANDO VALORES DE PRUEBA --- \n');     
    %% --------------------------------------------------------------------
    %carga del listado de nombres
    listado=dir(strcat(pathEntradaSamples,'*.jpg'));


    %% Remover archivos antiguos, borrar archivos antiguos
    removerArchivos(archivoVector);
    
    
    %% lectura en forma de bach del directorio de la cámara
    for n=1:size(listado)
        fprintf('Extrayendo características para entrenamiento-> %s \n',listado(n).name);    
        nombreImagenP=listado(n).name;    
        ProcesarImagen(pathEntradaSamples, pathCalibracion, nombreImagenP , archivoCalibracion, archivoVector, ArrayCuadros, areaObjetosRemoverBR, canalLMin, canalLMax, canalAMin, canalAMax, canalBMin, canalBMax);
        %break
    end %for del listado

    total=size(listado);

    fprintf('\n -------------------------------- \n');
    fprintf('Se procesaron un total de %i archivos \n',total(1));
    fprintf('El experto deberá ETIQUETAR %i filas \n',total(1));
    fprintf('En el archivo %s antes de correr el clasificador \n', archivoVector);
    fprintf('\n -------------------------------- \n');     
    fprintf('\n Verifique el vector de resultados en el archivo %s \n', archivoVector);
     
    %% --------------------------------------------------------------------     
 end %fin if(banderaCalibracion==NOCALIBRADO)
