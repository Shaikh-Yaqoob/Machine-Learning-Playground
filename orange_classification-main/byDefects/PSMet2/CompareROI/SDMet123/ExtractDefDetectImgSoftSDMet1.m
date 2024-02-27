function [ ] = ExtractDefDetectImgSoftSDMet3(pathEntrada, pathAplicacion, nombreImagenP, archivoVectorDef, tamanoManchas)
% ########################################################################
% Project AUTOMATIC CLASSIFICATION OF ORANGES BY SIZE AND DEFECTS USING 
% COMPUTER VISION TECHNIQUES 2018
% juancarlosmiranda81@gmail.com
% ########################################################################
% Extrae los defectos de las naranjas, genera como salida un archivo con
% datos separados por comas y genera imagenes intermedias con los defectos
% en, la fruta y los defectos, el contorno de las frutas.
%
% tamanoManchas representa el tamano en pixeles, se utiliza para eliminar
% manchas pequenas y dejar un contorno de la fruta. El objetivo final es
% obtener solaente las manchas.
%
% Se generan imagenes intermedias que corresponden a:
% * imagen generada previamente con fondo removido
% * imagen intermedia con frutas y defectos
% * solamente los defectos aislados
%
% -----------------------------------------------------------------------

%% Datos de configuración archivos
imagenInicial=strcat(pathEntrada,nombreImagenP); %para escritura en archivo de resultados


pathAplicacion3=strcat(pathAplicacion,'removido/'); %imagen generada previamente con fondo removido
pathAplicacion4=strcat(pathAplicacion,'sDefectos/'); %imagen intermedia con frutas y defectos
pathAplicacion5=strcat(pathAplicacion,'defectos/'); %solamente los defectos aislados
pathAplicacion6=strcat(pathAplicacion,'cDefectos/');
pathAplicacion7=strcat(pathAplicacion,'contornos/'); %contornos de frutas
pathAplicacionDeteccion=strcat(pathAplicacion,'deteccion/');

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

    %% salida defectos en COLOR
    nombreImagenDefectosC1=strcat(pathAplicacion6,nombreImagenP,'_','soC1.jpg');
    nombreImagenDefectosC2=strcat(pathAplicacion6,nombreImagenP,'_','soC2.jpg');
    nombreImagenDefectosC3=strcat(pathAplicacion6,nombreImagenP,'_','soC3.jpg');
    nombreImagenDefectosC4=strcat(pathAplicacion6,nombreImagenP,'_','soC4.jpg');

    
    
    %% salida contornos
    nombreImagenContorno1=strcat(pathAplicacion7,nombreImagenP,'_','CM1.jpg');
    nombreImagenContorno2=strcat(pathAplicacion7,nombreImagenP,'_','CM2.jpg');
    nombreImagenContorno3=strcat(pathAplicacion7,nombreImagenP,'_','CM3.jpg');
    nombreImagenContorno4=strcat(pathAplicacion7,nombreImagenP,'_','CM4.jpg');
    

    nombreImagenSalidaDeteccion1=strcat(pathAplicacionDeteccion,nombreImagenP,'_','DET1.jpg');
    nombreImagenSalidaDeteccion2=strcat(pathAplicacionDeteccion,nombreImagenP,'_','DET2.jpg');
    nombreImagenSalidaDeteccion3=strcat(pathAplicacionDeteccion,nombreImagenP,'_','DET3.jpg');
    nombreImagenSalidaDeteccion4=strcat(pathAplicacionDeteccion,nombreImagenP,'_','DET4.jpg');    
    
%% GRANULOMETRIAS
%tamanoManchas=1000; %1000 sacabuenos contornos
   
%% -- BEGIN DEFECTS FEATURES EXTRACTION ----------------------------------
%% Segmentacion de mascara para obtener defectos aislados de ROI
   fprintf('Segmentacion de mascara para obtener REGIONES CANDIDATAS A DEFECTOS ROI --> \n');
   SDMet1(nombreImagenRemovida1, nombreImagenSalida1);
   SDMet1(nombreImagenRemovida2, nombreImagenSalida2);
   SDMet1(nombreImagenRemovida3, nombreImagenSalida3);
   SDMet1(nombreImagenRemovida4, nombreImagenSalida4);   
   
   %% EXTRACCION 
   extractRegionDefSDMet1( nombreImagenSalida1, nombreImagenDefectos1, nombreImagenContorno1, tamanoManchas);
   extractRegionDefSDMet1( nombreImagenSalida2, nombreImagenDefectos2, nombreImagenContorno2, tamanoManchas);
   extractRegionDefSDMet1( nombreImagenSalida3, nombreImagenDefectos3, nombreImagenContorno3, tamanoManchas);    
   extractRegionDefSDMet1( nombreImagenSalida4, nombreImagenDefectos4, nombreImagenContorno4, tamanoManchas);
   
%% Separación de defectos
fprintf('Separación REGIONES CANDIDATAS A DEFECTOS en color --> \n');
backgroundRemoval4(nombreImagenRemovida1, nombreImagenDefectos1, nombreImagenDefectosC1);
backgroundRemoval4(nombreImagenRemovida2, nombreImagenDefectos2, nombreImagenDefectosC2);
backgroundRemoval4(nombreImagenRemovida3, nombreImagenDefectos3, nombreImagenDefectosC3);
backgroundRemoval4(nombreImagenRemovida4, nombreImagenDefectos4, nombreImagenDefectosC4);

%% -- END DEFECTS FEATURES EXTRACTION ----------------------------------

end %end proceso completo

