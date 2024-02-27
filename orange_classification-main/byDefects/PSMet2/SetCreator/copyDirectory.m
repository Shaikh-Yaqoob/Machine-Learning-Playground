function [ ] = copyDirectory( tablaDSTArchivos, pathEntradaImagenesFuente, pathEntradaImagenesDestino)
%
% Project: AUTOMATIC CLASSIFICATION OF ORANGES BY SIZE AND DEFECTS USING 
% COMPUTER VISION TECHNIQUES
%
% Author: Juan Carlos Miranda. https://github.com/juancarlosmiranda/
% Date: 2018
% Update:  December 2023
%
% Description:
%
% Giveng a table with filenames, iterate over this table and copy files from source to destination path

% INPUT: tables with filenames, source and destination paths
% OUTPUT: images copied

% Use:
% 
% copyDirectory( tableDSTraining, pathImagesMasks, pathImagesTraining);
% 
tableSize=size(tablaDSTArchivos);
totalRows=tableSize(1);

for(rowCounter=1:1:totalRows)
    %% copying from source to destination
    sourceFilenamePath=fullfile(pathEntradaImagenesFuente,tablaDSTArchivos(rowCounter).name);
    destinationFilenamePath=fullfile(pathEntradaImagenesDestino,tablaDSTArchivos(rowCounter).name);
    
    fprintf("COPYING FILES %s %s \n",sourceFilenamePath, destinationFilenamePath);
    [status,msg] = copyfile(sourceFilenamePath,destinationFilenamePath);   
end

end

