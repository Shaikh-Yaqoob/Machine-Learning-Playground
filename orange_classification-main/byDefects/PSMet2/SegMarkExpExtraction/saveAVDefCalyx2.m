function [ ] = saveAVDefCalyx2( filename, rowToAdd)
%
% Project: AUTOMATIC CLASSIFICATION OF ORANGES BY SIZE AND DEFECTS USING
% COMPUTER VISION TECHNIQUES
%
% Author: Juan Carlos Miranda. https://github.com/juancarlosmiranda/
% Date: 2018
% Update:  December 2023
%
% Description:
% Save data from features in a comma separated file
% Usage:
%
fileIDTest = fopen(filename,'r'); % open a file and check the handler result
fileID = fopen(filename,'a'); % open a file to add data
  

if (fileIDTest==-1)
    %% It is a first time
    % If more fields are added, their header must be added
    rowHeader=sprintf('imagen, numeroROI, contadorObjetos, promedioRGB_R, promedioRGB_G, promedioRGB_B, desviacionRGB_R, desviacionRGB_G, desviacionRGB_B, promedioLAB_L, promedioLAB_A, promedioLAB_B, desviacionLAB_L, desviacionLAB_A, desviacionLAB_B, promedioHSV_H, promedioHSV_S, promedioHSV_V, desviacionHSV_H, desviacionHSV_S, desviacionHSV_V, sumaArea, perimetro, excentricidad, ejeMayor, ejeMenor, entropia, inercia, energia, x, y, w, h, clasificacion');
    fprintf('Creating defects and caly file \n');
    fprintf(fileID,'%6s \n',rowHeader);% add a header in file
    fprintf(fileID,'%6s',rowToAdd);

else
    fprintf('Adding data to the defects and calyx file \n');
    fclose(fileIDTest); % closing reading handler, because the file already exists
    fprintf(fileID,'%6s',rowToAdd);
    
end
    
    fclose(fileID);    % closing the opened file

end

