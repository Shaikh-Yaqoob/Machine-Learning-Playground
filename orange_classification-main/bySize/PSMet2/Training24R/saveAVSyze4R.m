function [ output_args ] = saveAVSyze4R( fileName, rowToAdd )
%
fileIDTest = fopen(fileName,'r'); %open handler for test
fileID = fopen(fileName,'a'); %open handler for adding data
  

if (fileIDTest==-1)
    %% Is the firts time?
    %If more fields are added, your header should be added
    rowHeader=sprintf('nombre_imagen, equivPxmmR1, equivPxmmR2, equivPxmmR3, equivPxmmR4, sumaAreaPxR1, sumaAreaPxR2, sumaAreaPxR3, sumaAreaPxR4, diametroPxR1, diametroPxR2, diametroPxR3, diametroPxR4, ejeMayorPxR1, ejeMayorPxR2, ejeMayorPxR3, ejeMayorPxR4, ejeMenorPxR1, ejeMenorPxR2, ejeMenorPxR3, ejeMenorPxR4, diametrommR1, diametrommR2, diametrommR3, diametrommR4, ejeMayormmR1, ejeMayormmR2, ejeMayormmR3, ejeMayormmR4, ejeMenormmR1, ejeMenormmR2, ejeMenormmR3, ejeMenormmR4, clasificacionSize');

    fprintf('\n CREATING FILE WITH FEATURES \n');
    fprintf(fileID,'%6s \n',rowHeader);% agrega la cabecera
    fprintf(fileID,'%6s',rowToAdd);

else
    fprintf('ADDING DATA TO THE EXISTING FILE \n');
    fclose(fileIDTest);% close reading handler, the file is created
    fprintf(fileID,'%6s',rowToAdd);
    
end %end file testing
    
    fclose(fileID);    %close file

end %

