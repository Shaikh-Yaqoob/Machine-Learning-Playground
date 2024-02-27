function [ ] = ExtractDefDetectImgSoft(pathEntrada, pathAplicacion, nombreImagenP, archivoVectorDef, tamanoManchas)
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

pathAplicacion3=fullfile(pathAplicacion,'removido'); %imagen generada previamente con fondo removido
pathAplicacion4=fullfile(pathAplicacion,'sDefectos'); %imagen intermedia con frutas y defectos
pathAplicacion5=fullfile(pathAplicacion,'defectos'); %solamente los defectos aislados
pathAplicacion6=fullfile(pathAplicacion,'cDefectos');
pathAplicacion7=fullfile(pathAplicacion,'contornos'); %contornos de frutas

pathAplicacionDeteccion=fullfile(pathAplicacion,'deteccion');

% nombres de archivos con objetos removidos
nombreImagenRemovida1=fullfile(pathAplicacion3,strcat(nombreImagenP,'_','rm1.jpg'));
nombreImagenRemovida2=fullfile(pathAplicacion3,strcat(nombreImagenP,'_','rm2.jpg'));
nombreImagenRemovida3=fullfile(pathAplicacion3,strcat(nombreImagenP,'_','rm3.jpg'));
nombreImagenRemovida4=fullfile(pathAplicacion3,strcat(nombreImagenP,'_','rm4.jpg'));


%% salida segmentacion
nombreImagenSalida1=fullfile(pathAplicacion4,strcat(nombreImagenP,'_','so1.jpg'));
nombreImagenSalida2=fullfile(pathAplicacion4,strcat(nombreImagenP,'_','so2.jpg'));
nombreImagenSalida3=fullfile(pathAplicacion4,strcat(nombreImagenP,'_','so3.jpg'));
nombreImagenSalida4=fullfile(pathAplicacion4,strcat(nombreImagenP,'_','so4.jpg'));

%% salida defectos
nombreImagenDefectos1=fullfile(pathAplicacion5,strcat(nombreImagenP,'_','soM1.jpg'));
nombreImagenDefectos2=fullfile(pathAplicacion5,strcat(nombreImagenP,'_','soM2.jpg'));
nombreImagenDefectos3=fullfile(pathAplicacion5,strcat(nombreImagenP,'_','soM3.jpg'));
nombreImagenDefectos4=fullfile(pathAplicacion5,strcat(nombreImagenP,'_','soM4.jpg'));

%% salida defectos en COLOR
nombreImagenDefectosC1=fullfile(pathAplicacion6,strcat(nombreImagenP,'_','soC1.jpg'));
nombreImagenDefectosC2=fullfile(pathAplicacion6,strcat(nombreImagenP,'_','soC2.jpg'));
nombreImagenDefectosC3=fullfile(pathAplicacion6,strcat(nombreImagenP,'_','soC3.jpg'));
nombreImagenDefectosC4=fullfile(pathAplicacion6,strcat(nombreImagenP,'_','soC4.jpg'));
   
    
%% salida contornos
nombreImagenContorno1=fullfile(pathAplicacion7,strcat(nombreImagenP,'_','CM1.jpg'));
nombreImagenContorno2=fullfile(pathAplicacion7,strcat(nombreImagenP,'_','CM2.jpg'));
nombreImagenContorno3=fullfile(pathAplicacion7,strcat(nombreImagenP,'_','CM3.jpg'));
nombreImagenContorno4=fullfile(pathAplicacion7,strcat(nombreImagenP,'_','CM4.jpg'));

nombreImagenSalidaDeteccion1=fullfile(pathAplicacionDeteccion,strcat(nombreImagenP,'_','DET1.jpg'));
nombreImagenSalidaDeteccion2=fullfile(pathAplicacionDeteccion,strcat(nombreImagenP,'_','DET2.jpg'));
nombreImagenSalidaDeteccion3=fullfile(pathAplicacionDeteccion,strcat(nombreImagenP,'_','DET3.jpg'));
nombreImagenSalidaDeteccion4=fullfile(pathAplicacionDeteccion,strcat(nombreImagenP,'_','DET4.jpg'));
    
%% GRANULOMETRIAS
%tamanoManchas=1000; %1000 sacabuenos contornos
   
%% -- BEGIN DEFECTS FEATURES EXTRACTION ----------------------------------
%% Segmentacion de mascara para obtener defectos aislados de ROI
fprintf('Segmentacion de mascara para obtener REGIONES CANDIDATAS A DEFECTOS ROI --> \n');
SDMet2(nombreImagenRemovida1, nombreImagenSalida1);
SDMet2(nombreImagenRemovida2, nombreImagenSalida2);
SDMet2(nombreImagenRemovida3, nombreImagenSalida3);
SDMet2(nombreImagenRemovida4, nombreImagenSalida4);   

   
%% EXTRACCION pREWITT DE LOS BORDES DE LA NARANJA, VA CON segmentacion Prewitt
extractRegionDefPrewitt( nombreImagenSalida1, nombreImagenDefectos1, nombreImagenContorno1, tamanoManchas);
extractRegionDefPrewitt( nombreImagenSalida2, nombreImagenDefectos2, nombreImagenContorno2, tamanoManchas);
extractRegionDefPrewitt( nombreImagenSalida3, nombreImagenDefectos3, nombreImagenContorno3, tamanoManchas);    
extractRegionDefPrewitt( nombreImagenSalida4, nombreImagenDefectos4, nombreImagenContorno4, tamanoManchas);
   
%% Separación de defectos
fprintf('Separación REGIONES CANDIDATAS A DEFECTOS en color --> \n');
backgroundRemoval4(nombreImagenRemovida1, nombreImagenDefectos1, nombreImagenDefectosC1);
backgroundRemoval4(nombreImagenRemovida2, nombreImagenDefectos2, nombreImagenDefectosC2);
backgroundRemoval4(nombreImagenRemovida3, nombreImagenDefectos3, nombreImagenDefectosC3);
backgroundRemoval4(nombreImagenRemovida4, nombreImagenDefectos4, nombreImagenDefectosC4);

%% -- END DEFECTS FEATURES EXTRACTION ----------------------------------

%% CLSIFICAR DEFECTOS CANDIDATOS
% Por cada imagen de R1..R4 se toman los defectos y se cuentan. Estos
% defectos se llevan a un clasificador que cuenta por regiones los posibles
% defectos encontrados
%archivoVectorDef='';
fprintf('Detección de REGIONES CANDIDATAS A DEFECTOS en color --> \n');
detectROICandidates2( pathAplicacion, 1, nombreImagenRemovida1 ,nombreImagenDefectos1, nombreImagenDefectosC1, nombreImagenSalidaDeteccion1,archivoVectorDef, nombreImagenP);
detectROICandidates2( pathAplicacion, 2, nombreImagenRemovida2 ,nombreImagenDefectos2, nombreImagenDefectosC2, nombreImagenSalidaDeteccion2,archivoVectorDef, nombreImagenP);
detectROICandidates2( pathAplicacion, 3, nombreImagenRemovida3 ,nombreImagenDefectos3, nombreImagenDefectosC3, nombreImagenSalidaDeteccion3,archivoVectorDef, nombreImagenP);
detectROICandidates2( pathAplicacion, 4, nombreImagenRemovida4 ,nombreImagenDefectos4, nombreImagenDefectosC4, nombreImagenSalidaDeteccion4,archivoVectorDef, nombreImagenP);
% -----------------------------------------------------------------------
end %end proceso completo

%C:\Users\Usuari\development\orange_classification\OrangeResults\byDefects\PSMet2\SegMarkExpExtraction\output
%C:\Users\Usuari\development\orange_classification\byDefects\PSMet2\FruitEvaluation\OrangeResults\byDefects\PSMet2\SegMarkExpExtraction\output\BDDEFECTOSCALYX.csv