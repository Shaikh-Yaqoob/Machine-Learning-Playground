function [tableDSTraining, tableDSTest] = splitSetImg( imageList, trainingRatio, mainPath, outputPath)
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
%Given a list of images and a split ratio, this function splits the list into two tables, one for testing and one for training. These lists will be used to organize a pre-training data set.

% INPUT: 
% OUTPUT: tables with file lists

% Use:
% [tableDSTraining, tableDSTest]=SplitImageSet( imageList, trainingRatio, mainPath, outputPath, filenameSet);
% 
% 
tableDSMainSet = imageList;
tableSize=size(tableDSMainSet);  % gets size from main set

totalRows=tableSize(1); % gets the number of rows
testRatio=0;   
totalTrainingRows=0;
totalTestRows=0;

% Limits almost 1 percent for test
if(trainingRatio<=99)
    testRatio=100-trainingRatio; 
    totalTrainingRows=floor((totalRows*trainingRatio)/100);
    totalTestRows=floor((totalRows*testRatio)/100);
    
else
    fprintf('Ratio is not applied, at least 1% must exists for the test file \n');
end % end of validation


%% splits dataset to create test and training dataset
rowCounter=0;
fprintf('Choose %i rows at random for test without replacement \n',totalTestRows);

for(rowCounter=1:1:totalTestRows)

    tableSize=size(tableDSMainSet);
    totalRows=tableSize(1); %tamano filas automatico
    
    selectedRowIndex=int16(rand()*totalRows)+1;
    fprintf('%i row selected \n',selectedRowIndex);
    
    %Elegir fila al azar posicionarse en la fila y borrar del conjunto general
    selectedRow=tableDSMainSet(selectedRowIndex,:);
    if(rowCounter==1)
        tableDSTest=selectedRow;        
    else
        %adds rows
        tableDSTest=[tableDSTest; selectedRow];                
    end
    tableDSMainSet(selectedRowIndex,:)=[]; % clean select row from main dataset
end

% save in traingin table
tableDSTraining=tableDSMainSet;

end % splitSetImg