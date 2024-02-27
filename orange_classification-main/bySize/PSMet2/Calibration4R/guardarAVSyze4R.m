function [ output_args ] = guardarAVSyze4R( nombreArchivo, filaAgregar )

fileIDTest = fopen(nombreArchivo,'r'); %el hander para saber si existe
fileID = fopen(nombreArchivo,'a'); %abre el archivo para agregar datos
  

if (fileIDTest==-1)
    %% Es primera vez
    %Si se agregan mas campos, se debe agregar su cabecera    
    filaCabecera=sprintf('nombre_imagen, equivPxmmR1, equivPxmmR2, equivPxmmR3, equivPxmmR4, sumaAreaPxR1, sumaAreaPxR2, sumaAreaPxR3, sumaAreaPxR4, diametroPxR1, diametroPxR2, diametroPxR3, diametroPxR4, ejeMayorPxR1, ejeMayorPxR2, ejeMayorPxR3, ejeMayorPxR4, ejeMenorPxR1, ejeMenorPxR2, ejeMenorPxR3, ejeMenorPxR4, diametrommR1, diametrommR2, diametrommR3, diametrommR4, ejeMayormmR1, ejeMayormmR2, ejeMayormmR3, ejeMayormmR4, ejeMenormmR1, ejeMenormmR2, ejeMenormmR3, ejeMenormmR4, clasificacionSize');

    fprintf('\n CREANDO ARCHIVO CON CARACTERÍSTICAS \n');
    fprintf(fileID,'%6s \n',filaCabecera);% agrega la cabecera
    fprintf(fileID,'%6s',filaAgregar);

else
    fprintf('AGREGANDO DATOS AL ARCHIVO EXISTENTE \n');
    fclose(fileIDTest);% cierra el handler de lectura, dado que el archivo existe
    fprintf(fileID,'%6s',filaAgregar);
    
end %fin verificacion si el archivo existe
    
    fclose(fileID);    %cierre del archivo para escritura

end %guardarArchivoVector

