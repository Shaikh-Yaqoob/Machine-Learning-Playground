function [ result ] = rectangleDetection(ArrayRectangles, xmin, ymin)
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
% Detect the frame number in which a coordinate is found.
% It assumes previously configured frames that divide the screen into four,
% is considered a box 0,0,0,0 as end of list mark. The function
% returns the frame number of 1..4 or N. This function is used in the
% object detection.
% Usage:
%
%

[totalRows, totalCol]=size(ArrayRectangles);

%% Iterate over a table wth rectangles to detect the first coodinate
n=1; % object detection index
for (n=1:totalRows) 
     columnBegin=ArrayRectangles(n,1); columnEnd=ArrayRectangles(n,1)+ArrayRectangles(n,3);
     rowBegin=ArrayRectangles(n,2); rowEnd=ArrayRectangles(n,2)+ArrayRectangles(n,4);

     %fprintf('testing rectangle %i -> xmin=%i, ymin=%i \n',n,xmin, ymin);
     if((xmin>=columnBegin) & (xmin<=columnEnd))
        %fprintf('Inside columns rectangle number=%i xmin=%i > %i y xmin=%i < %i \n',n,xmin,columnBegin,xmin,columnEnd);
        if((ymin>=rowBegin) & (ymin<=rowEnd))
            %fprintf('Inside rows rectangle number=%i ymin=%i > %i y ymin=%i < %i \n',n,ymin,rowBegin,ymin,rowEnd);
                    break;
        else
            %fprintf('OUTSIDE ROWS rectangle number %i ymin=%i > %i y ymin=%i < %i NOO \n',n,ymin,rowBegin,ymin,rowEnd);
        end% filas    
     else
            %fprintf('OUTSIDE COLUMNS rectangle number %i xmin=%i > %i y xmin=%i < %i NOO\n',n,xmin,columnBegin,xmin,columnEnd);
     end
end% for     

%%results
if(n==totalRows)
%    fprintf('xmin=%i ymin=%i does not fit \n', xmin, ymin); ONLY FOR DEBUG
%    PURPOSES
    result='N';
else
%    fprintf('The rectangle is %i\n', n); ONLY FOR DEBUG
%    PURPOSES
    result=int2str(n); % it returns a results as string format
end %

end % end of rectangle detection
