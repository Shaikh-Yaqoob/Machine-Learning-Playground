function [ result ] = rectangleDetection(ArrayRectangles, xmin, ymin)
% ########################################################################
% Project AUTOMATIC CLASSIFICATION OF ORANGES BY SIZE AND DEFECTS USING 
% COMPUTER VISION TECHNIQUES 2018
% juancarlosmiranda81@gmail.com
% ########################################################################
%
% Detect the frame number in which a coordinate is found.
% It assumes previously configured frames that divide the screen into four,
% is considered a box 0,0,0,0 as end of list mark. The function
% returns the frame number of 1..4 or N. This function is used in the
% object detection.


[totalRows, totalCol]=size(ArrayRectangles);

%% REcorrer tabla con cuadros para detectar el punto inicial
n=1; %indice detector de objetos
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
%    fprintf('xmin=%i ymin=%i NO ENCAJA\n', xmin, ymin);
    result='N';
else
%    fprintf('EL CUADRO ES %i\n', n);
    result=int2str(n); %devuelve en forma de cadena
end %

end %deteccionCuadros
