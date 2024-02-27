% ########################################################################
%
% Project AUTOMATIC CLASSIFICATION OF ORANGES BY SIZE AND DEFECTS USING 
% COMPUTER VISION TECHNIQUES
% 2018
% juancarlosmiranda81@gmail.com
% ########################################################################
%
%
% This function scrolls through a directory loaded with images and generates 
% a training set for the algorithm, it is saved in a separate text file by
% commas.csv and serves as input for the process classifier.
% Assuming SYSTEM CALIBRATION is assumed, this script scrolls through all 
% the files of an input directory.
%
% Subsequently, an EXPERT MUST CLASSIFY THE RESULTS by placing
% the labels of the fruits in the column of the generated file. The
% labels must be copied manually from the data file of the expert.
% The functionality of this script is to use all the samples, obtain
% characteristics. There is another module that generates randomized 
% populations based on the proportion of the user.

%% Adjustment of initial parameters
clc; clear all; close all;
 
 %% Directory structure definition
 HOMEUSER=fullfile('C:','Users', 'Usuari','development','orange_classification');  % POINT TO "..user root" folder
 %HOMEUSER=strcat(pwd,'/');
 MainPath=fullfile(HOMEUSER,'OrangeResults','bySize','PSMet2','Training');
 pathInputImages=fullfile(HOMEUSER,'OrangeResults','inputToLearn');
 
 pathConfiguration=fullfile(MainPath,'conf');
 pathApplication=fullfile(MainPath,'tmpToLearn'); % temporary images
 pathApplicationSilhouettes=fullfile(pathApplication,'sFruits');
 pathResults=fullfile(MainPath,'output');% output results
 mainImageName='mainImageName';

 %% Configuration file names
 % Calibration settings generated from 4 views of the mirrors are used.
 
 %%
 fileConfiguration=fullfile(pathConfiguration,'20170916configuration.xml'); % For initial coordinates in image processing
 %fileCalibration=fullfile(pathConfiguration,'20170916calibration.xml'); % to indicate to the user in the final part the calibration
 
 
 fileCalibration=fullfile(pathConfiguration,'20230218223112calibracion.xml');
 fileVector=fullfile(pathResults,'acm2SIZEC4R.csv'); %output file

  
 %% Definition of rectangles, according to numbering
Row1=readConfiguration('Fila1', fileConfiguration);
RowDown=readConfiguration('FilaAbajo', fileConfiguration);

%Rectangle 1 down
Rectangle1_lineGuideInitialRow=readConfiguration('Cuadro1_lineaGuiaInicialFila', fileConfiguration);
Rectangle1_lineGuideInitialColumn=readConfiguration('Cuadro1_lineaGuiaInicialColumna', fileConfiguration);
Rectangle1_rowSpace=readConfiguration('Cuadro1_espacioFila', fileConfiguration);
Rectangle1_colSpace=readConfiguration('Cuadro1_espacioColumna', fileConfiguration);

%Rectangle 2 left
Rectangle2_lineGuideInitialRow=readConfiguration('Cuadro2_lineaGuiaInicialFila', fileConfiguration);
Rectangle2_lineGuideInitialColumn=readConfiguration('Cuadro2_lineaGuiaInicialColumna', fileConfiguration);
Rectangle2_rowSpace=readConfiguration('Cuadro2_espacioFila', fileConfiguration);
Rectangle2_colSpace=readConfiguration('Cuadro2_espacioColumna', fileConfiguration);

%Rectangle 3 center
Rectangle3_lineGuideInitialRow=readConfiguration('Cuadro3_lineaGuiaInicialFila', fileConfiguration);
Rectangle3_lineGuideInitialColumn=readConfiguration('Cuadro3_lineaGuiaInicialColumna', fileConfiguration);
Rectangle3_rowSpace=readConfiguration('Cuadro3_espacioFila', fileConfiguration);
Rectangle3_colSpace=readConfiguration('Cuadro3_espacioColumna', fileConfiguration);

%Rectangle 4 right
Rectangle4_lineGuideInitialRow=readConfiguration('Cuadro4_lineaGuiaInicialFila', fileConfiguration);
Rectangle4_lineGuideInitialColumn=readConfiguration('Cuadro4_lineaGuiaInicialColumna', fileConfiguration);
Rectangle4_rowSpace=readConfiguration('Cuadro4_espacioFila', fileConfiguration);
Rectangle4_colSpace=readConfiguration('Cuadro4_espacioColumna', fileConfiguration);

%% Load the coordinates in memory to make it faster
ArrayRectangles=[Rectangle1_lineGuideInitialColumn, Rectangle1_lineGuideInitialRow, Rectangle1_colSpace, Rectangle1_rowSpace;
Rectangle2_lineGuideInitialColumn, Rectangle2_lineGuideInitialRow, Rectangle2_colSpace, Rectangle2_rowSpace;
Rectangle3_lineGuideInitialColumn, Rectangle3_lineGuideInitialRow, Rectangle3_colSpace, Rectangle3_rowSpace;
Rectangle4_lineGuideInitialColumn, Rectangle4_lineGuideInitialRow, Rectangle4_colSpace, Rectangle4_rowSpace;
0,0,0,0
];

%% GRANULOMETRY
areaObjectsRemoveBR=5000; % for silhouettes and objects detection. Size for granulometry
%% Color threshold settings
channellLMin = 0.0; channelLMax = 96.653; channelAMin = -23.548; channelAMax = 16.303; channelBMin = -28.235; channelBMax = -1.169; %background thresholding parameters by channles LAB


%% Remove old files, delete old files
removeFiles(fileVector);

%% --------------------------------------------------------------------
% loading the list of image names
list=dir(fullfile(pathInputImages,'*.jpg'));

%% bach reading of the entry directory
for n=1:size(list)
    fprintf('Features extraction for training-> %s \n',list(n).name);    
    mainImageName=list(n).name;    
    ProcessTrainingImagePSMet2(pathInputImages, pathApplication, mainImageName , fileCalibration, fileVector, ArrayRectangles, areaObjectsRemoveBR, channellLMin, channelLMax, channelAMin, channelAMax, channelBMin, channelBMax);
%break;
end %

total=size(list);

fprintf('\n -------------------------------- \n');
fprintf('A total of %i files were processed \n',total(1));
fprintf('The expert should LABEL  %i rows \n',total(1));
fprintf('Make a copy of the %s file  \n', fileVector);
fprintf('and place the LABELS classified by the expert before running the classifier \n');
fprintf('\n -------------------------------- \n');
