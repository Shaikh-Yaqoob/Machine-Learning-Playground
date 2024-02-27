function [ result ] = readConfiguration( labelSearch, fileConfig)
%
% Project: AUTOMATIC CLASSIFICATION OF ORANGES BY SIZE AND DEFECTS USING 
% COMPUTER VISION TECHNIQUES
%
% Author: Juan Carlos Miranda. https://github.com/juancarlosmiranda/
% Date: 2018
% Update:  December 2023
%
% Description:
% This function reads configuration files saved as XML format.
%
% Reading from XML file
% Values to search inside the XML

xDoc = xmlread(fullfile(fileConfig)); % Reading in file

% get all item list
ItemList = xDoc.getElementsByTagName('listitem');

% Go through the elements
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
end % end for



if ~isempty(valueLabel)
    msg = sprintf('Item "%s" has a value of "%s"',labelSearch, valueLabel);
    
else
    msg = sprintf('Did not find the "%.2i" item.', labelSearch);
end
%disp(msg);

result=str2num(valueLabel);

end
