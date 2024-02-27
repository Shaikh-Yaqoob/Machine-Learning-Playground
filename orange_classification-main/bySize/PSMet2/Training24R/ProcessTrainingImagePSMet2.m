function [ ] = ProcessTrainingImagePSMet2(pathInput, pathApplication, mainImageName, fileCalibration, fileVector, ArrayRectangles, areaObjectsRemoveBR, channelLMin, channelLMax, channelAMin, channelAMax, channelBMin, channelBMax )
%
% -----------------------------------------------------------------------
% Complete process that is performed for each entry photograph
% Data are obtained by applying morphological operations and extracting geometric characteristics.
% Intermediate results are stored so that they can be obtained images of the process.
% -----------------------------------------------------------------------

%% Configuration files
% For the calibration the clipping sequence is needed only
initialImage=fullfile(pathInput,mainImageName);


%% Temporary directories
pathApplicationPR=fullfile(pathApplication,'pr'); %pre procesing
pathApplicationBR=fullfile(pathApplication,'br'); %background removal
pathApplicationROI=fullfile(pathApplication,'roi'); %region of interest


pathApplication2=fullfile(pathApplication,'sFruits');
pathApplication3=fullfile(pathApplication,'removed');

% --- NOMBRE DE IMAGENES INTERMEDIAS ---
% con fondo removido
imagenNombrePR=fullfile(pathApplicationPR,strcat(mainImageName,'_','PR.jpg')); %imagen RGB con lineas pintadas;
ImageNameBR=fullfile(pathApplicationBR,strcat(mainImageName,'_','BR.jpg')); %para indicar silueta del fondo removido
ImageNameROI=fullfile(pathApplicationROI,strcat(mainImageName,'_','RO.jpg')); %para indicar el fondo removido y ROI

%prefijo para imagenes de fondo removido y siluetas de fondos removidos en
%deteccion de objetos
imageNameSilhouetteN=fullfile(pathApplication2,strcat(mainImageName,'_','sN'));
imageNameRemoved=fullfile(pathApplication3,strcat(mainImageName,'_','rm'));

% Siluetas operaciones morfologicas
imageNameSilhouetteN1=fullfile(pathApplication2,strcat(mainImageName,'_','sN1.jpg'));
imageNameSilhouetteN2=fullfile(pathApplication2,strcat(mainImageName,'_','sN2.jpg'));
imageNameSilhouetteN3=fullfile(pathApplication2,strcat(mainImageName,'_','sN3.jpg'));
imageNameSilhouetteN4=fullfile(pathApplication2,strcat(mainImageName,'_','sN4.jpg'));

% nombres de archivos con objetos removidos
imageNameRemoved1=fullfile(pathApplication3,strcat(mainImageName,'_','rm1.jpg'));
imageNameRemoved2=fullfile(pathApplication3,strcat(mainImageName,'_','rm2.jpg'));
imageNameRemoved3=fullfile(pathApplication3,strcat(mainImageName,'_','rm3.jpg'));
imageNameRemoved4=fullfile(pathApplication3,strcat(mainImageName,'_','rm4.jpg'));

%% GRANULOMETRIAS
objectSize=2000; %size of objects for features extraction

%% -- BEGIN IMAGE PROCESSING ----------------------------------
%% Separacion de fondo
% Follow the syntax of the rectangles xmin,ymin,width,height
Rectangle_lineGuideInitialColum=ArrayRectangles(1,1);
Rectangle_lineGuideInitialRow=ArrayRectangles(1,2);
Rectangle_columnSpace=ArrayRectangles(1,3);
Rectangle_rowSpace=ArrayRectangles(1,4);

fprintf('BR -> Background Segmentation --> \n'); % check out an image with 4 silhouettes
BRemovalLAB(initialImage, ImageNameBR, areaObjectsRemoveBR, channelLMin, channelLMax, channelAMin, channelAMax, channelBMin, channelBMax,Rectangle_lineGuideInitialColum, Rectangle_lineGuideInitialRow-2, Rectangle_columnSpace, Rectangle_rowSpace);

%% Background removal
fprintf('BR -> Background removal, separation of ROI--> \n'); % check out an image with 4 objects
backgroundRemoval4(initialImage, ImageNameBR, ImageNameROI);

%% Clipping of ROI
fprintf('BR -> Detection of objects in rectangles. Cutting ROI and ROI silhouettes --> \n'); %output 4 images of an object each
objectDetection2( ImageNameBR, ImageNameROI, imageNameSilhouetteN, imageNameRemoved, ArrayRectangles )

%% -- END IMAGE PROCESSING ----------------------------------

    

%% By Size --> Extraccion de caracteristicas
pixelmmR1=readConfiguration('pixelLinealR1', fileCalibration);
pixelmmR2=readConfiguration('pixelLinealR2', fileCalibration);
pixelmmR3=readConfiguration('pixelLinealR3', fileCalibration);
pixelmmR4=readConfiguration('pixelLinealR4', fileCalibration);

%% Declaracion de variables con valores de pixeles
%% Recorte 1
sumAreaPxR1=0; 
diameterPxR1=0; 
mayorAxisPxR1=0; 
minorAxisPxR1=0;

sumAreammR1=0.0;
diametermmR1=0.0;
minorAxismmR1=0.0;
minorAxismmR1=0.0;

%% Recorte 2
sumAreaPxR2=0; 
diameterPxR2=0; 
mayorAxisPxR2=0; 
minorAxisPxR2=0;

sumAreammR2=0.0;
diametermmR2=0.0;
minorAxismmR2=0.0;
minorAxismmR2=0.0;

%% Recorte 3
sumAreaPxR3=0; 
diameterPxR3=0; 
mayorAxisPxR3=0; 
minorAxisPxR3=0;

sumAreammR3=0.0;
diametermmR3=0.0;
minorAxismmR3=0.0;
minorAxismmR3=0.0;

%% Recorte 4
sumAreaPxR4=0; 
diameterPxR4=0; 
mayorAxisPxR4=0; 
minorAxisPxR4=0;

sumAreammR4=0.0;
diametermmR4=0.0;
minorAxismmR4=0.0;
minorAxismmR4=0.0;

%% Features extraction
fprintf('Geometric features extraction--> \n');
fprintf('Geometric features extraction from rectangle 1 --> \n');
[ sumAreaPxR1, diameterPxR1, mayorAxisPxR1, minorAxisPxR1]=extractFeatGeom4R( imageNameSilhouetteN1,objectSize);
fprintf('Geometric features extraction from rectangle 2 --> \n');
[ sumAreaPxR2, diameterPxR2, mayorAxisPxR2, minorAxisPxR2]=extractFeatGeom4R( imageNameSilhouetteN2,objectSize);
fprintf('Geometric features extraction from rectangle 3 --> \n');
[ sumAreaPxR3, diameterPxR3, mayorAxisPxR3, minorAxisPxR3]=extractFeatGeom4R( imageNameSilhouetteN3,objectSize);
fprintf('Geometric features extraction from rectangle 4 --> \n');
[ sumAreaPxR4, diameterPxR4, mayorAxisPxR4, minorAxisPxR4]=extractFeatGeom4R( imageNameSilhouetteN4,objectSize);


%% Cálculo para unidades de medida
diametermmR1=diameterPxR1*pixelmmR1;
minorAxismmR1=mayorAxisPxR1*pixelmmR1;
minorAxismmR1=minorAxisPxR1*pixelmmR1;

diametermmR2=diameterPxR2*pixelmmR2;
minorAxismmR2=mayorAxisPxR2*pixelmmR2;
minorAxismmR2=minorAxisPxR2*pixelmmR2;

diametermmR3=diameterPxR3*pixelmmR3;
minorAxismmR3=mayorAxisPxR3*pixelmmR3;
minorAxismmR3=minorAxisPxR3*pixelmmR3;

diametermmR4=diameterPxR4*pixelmmR4;
minorAxismmR4=mayorAxisPxR4*pixelmmR4;
minorAxismmR4=minorAxisPxR4*pixelmmR4;


%% Guardado en archivo
clase='SIN_CLASIFICAR';
fprintf('Features obtained --> \n');
fprintf('%s, %10.4f, %10.4f, %10.4f, %10.4f,%10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %s \n', initialImage, pixelmmR1, pixelmmR2, pixelmmR3, pixelmmR4, sumAreaPxR1, sumAreaPxR2, sumAreaPxR3, sumAreaPxR4, diameterPxR1, diameterPxR2, diameterPxR3, diameterPxR4, mayorAxisPxR1, mayorAxisPxR2, mayorAxisPxR3, mayorAxisPxR4, minorAxisPxR1, minorAxisPxR2, minorAxisPxR3, minorAxisPxR4, diametermmR1, diametermmR2, diametermmR3, diametermmR4, minorAxismmR1, minorAxismmR2, minorAxismmR3, minorAxismmR4, minorAxismmR1, minorAxismmR2, minorAxismmR3, minorAxismmR4, clase);

% First everything related to pixels is saved, then the conversions to millimeters
fila=sprintf('%s, %10.4f, %10.4f, %10.4f, %10.4f,%10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %10.4f, %s \n', initialImage, pixelmmR1, pixelmmR2, pixelmmR3, pixelmmR4, sumAreaPxR1, sumAreaPxR2, sumAreaPxR3, sumAreaPxR4, diameterPxR1, diameterPxR2, diameterPxR3, diameterPxR4, mayorAxisPxR1, mayorAxisPxR2, mayorAxisPxR3, mayorAxisPxR4, minorAxisPxR1, minorAxisPxR2, minorAxisPxR3, minorAxisPxR4, diametermmR1, diametermmR2, diametermmR3, diametermmR4, minorAxismmR1, minorAxismmR2, minorAxismmR3, minorAxismmR4, minorAxismmR1, minorAxismmR2, minorAxismmR3, minorAxismmR4, clase);
saveAVSyze4R( fileVector, fila)

% -----------------------------------------------------------------------

% -----------------------------------------------------------------------
end %end proceso completo

