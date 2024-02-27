function [ result ] = readConfiguration( labelSearch, fileConfig)
% ########################################################################
% Project AUTOMATIC CLASSIFICATION OF ORANGES BY SIZE AND DEFECTS USING 
% COMPUTER VISION TECHNIQUES 2018
% juancarlosmiranda81@gmail.com
% ########################################################################
% --------------------------------------------
%% Lectura de XML
%Valores a buscar en el XML

xDoc = xmlread(fullfile(fileConfig)); %Lectura del archivo

% get all item list
ItemList = xDoc.getElementsByTagName('listitem');

%Go through the elements
for k = 0:ItemList.getLength-1
   currentItem = ItemList.item(k); %listItem actual
   
   % Get the label element. In this file, each
   % listitem contains only one label.
   labelList = currentItem.getElementsByTagName('label');
   selectedItem = labelList.item(0);
      
       
   if strcmp(selectedItem.getFirstChild.getData, labelSearch)
       labelList = currentItem.getElementsByTagName('value');
       selectedItem = labelList.item(0);      
       valueLabel = char(selectedItem.getFirstChild.getData);
       break;
   end %if strcmp  
end %fin del for



if ~isempty(valueLabel)
    msg = sprintf('Item "%s" has a value of "%s"',labelSearch, valueLabel);
    
else
    msg = sprintf('Did not find the "%.2i" item.', labelSearch);
end
%disp(msg);

result=str2num(valueLabel);

% -------------------------------------------
end %fin de funcion

