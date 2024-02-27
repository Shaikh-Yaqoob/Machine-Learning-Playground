function [ output_args ] = guardarArchivoMetricas( nombreArchivo, filaAgregar )

fileIDTest = fopen(nombreArchivo,'r'); %el hander para saber si existe
fileID = fopen(nombreArchivo,'a'); %abre el archivo para agregar datos
  

if (fileIDTest==-1)
    %% Es primera vez
    %Si se agregan mas campos, se debe agregar su cabecera
    filaCabecera=sprintf('PRECISION, SENSIBILIDAD, ESPECIFICIDAD');
    fprintf('CREANDO ARCHIVO METRICAS \n');
    fprintf(fileID,'%6s \n',filaCabecera);% agrega la cabecera
    fprintf(fileID,'%6s',filaAgregar);

else
    %fprintf('AGREGANDO DATOS AL ARCHIVO EXISTENTE \n');
    fclose(fileIDTest);% cierra el handler de lectura, dado que el archivo existe
    fprintf(fileID,'%6s',filaAgregar);
    
end %fin verificacion si el archivo existe
    
    fclose(fileID);    %cierre del archivo para escritura

end %guardarArchivoMetricas

