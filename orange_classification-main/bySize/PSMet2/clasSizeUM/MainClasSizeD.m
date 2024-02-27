%% Clasificacion utilizando umbrales fijos, definidos en la funcion clasificador

%% Ajuste de parámetros iniciales
clc; clear all; close all;

HOMEUSER=strcat(pwd,'/');
pathPrincipal=strcat(HOMEUSER,'OrangeResults/bySize/PSMet2/Classification/');

pathResultados=strcat(pathPrincipal,'output/clasSizeUM/');

  
 %% Parametros de entrada en fomato .csv
 nombreArchivoMC1='resultadomDc1.csv';
 nombreArchivoMC2='resultadomDc2.csv';
 nombreArchivoMC3='resultadomDc3.csv';
 
 %Leer las 
nombreArchivoTest='aTSCSize2UM.csv';
nombreArchivoScreen='screenSize2UM.txt'; 
 %% valores experimentos
totalPruebas=1;
 
%% posiciones en el archivo para etieutas y campos
ETIQUETA_EXPERTO=34;
EJE_MAYOR_EXPERTO=35;
EJE_MENOR_EXPERTO=36;

DIAMETRO_SOFTWARE=22;

%% especificacion del formato
formatSpec='%s%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%s%f%f';

fileHandlerMC1=strcat(pathResultados,nombreArchivoMC1);%handle resultados clase1
fileHandlerMC2=strcat(pathResultados,nombreArchivoMC2);%handle resultados clase2
fileHandlerMC3=strcat(pathResultados,nombreArchivoMC3);%handle resultados clase2


fileHandlerTest=strcat(pathResultados,nombreArchivoTest); %handle para conjunto de prueba
fileHandlerDiary=strcat(pathResultados,nombreArchivoScreen);


%% Remover archivos antiguos de resultados
%fprintf('Borrando archivos de pruebas anteriores \n'); 
%removerArchivos(fileHandlerTraining); 
%removerArchivos(fileHandlerTest); 
%removerArchivos(fileHandlerDiary);
%removerArchivos(fileHandlerMC1);
%removerArchivos(fileHandlerMC2);
%removerArchivos(fileHandlerMC3);


%% Apertura del diario de pantallas
diary(fileHandlerDiary)


%% Definición a cero de las variables promedio
% Precision, sensibilidad, especificidad, accuracy
matrizAcumulados=zeros(3,4);

    
%% Pruebas
% bucle para repetir pruebas
for(prueba=1:1:totalPruebas)

    
    
%% 
fprintf('-----------------------------------\n');
fprintf('PRUEBA # %i \n',prueba);
fprintf('-----------------------------------\n');




%% --- INICIO PRINCIPAL DEL CLASIFICADOR ---
% Se levanta en una tabla el conjunto de datos a clasificar
tablaDSTest = readtable(fileHandlerTest,'Delimiter',',','Format',formatSpec);

% Se obtiene la caracteristica para comparar.
tablaDSTestComparar=tablaDSTest(:,DIAMETRO_SOFTWARE);
arrayTest=table2array(tablaDSTestComparar);


contadorVP=0;
contadorP=0;
contadorM=0;
contadorG=0;
contadorNI=0;

matrizResultados=zeros(3,3);
%% Recorrer archivo
indiceTest=1;
[totalArrayTest, campos]=size(arrayTest);
for indiceTest=1:totalArrayTest


    %% seleccion del objeto a comparar
    objetoComparar = arrayTest(indiceTest,1); %objeto a comparar

    
    nombreDelaImagenComparar=char(table2array(tablaDSTest(indiceTest,1)));
    etiquetaExperto=char(table2array(tablaDSTest(indiceTest,ETIQUETA_EXPERTO)));
    ejeMayorExperto=table2array(tablaDSTest(indiceTest,EJE_MAYOR_EXPERTO));
    ejeMenorExperto=table2array(tablaDSTest(indiceTest,EJE_MENOR_EXPERTO));

    %% Ejecucion de prediccion
    clasificacionObjetoEtiqueta=clasificadorUmbral(objetoComparar(1));
        
    %% Presentacion de Resultados


        
        % ---------------------------------------------------------------
        filaMatriz=1;
        columnaMatriz=1;
        
        switch char(clasificacionObjetoEtiqueta)
            case 'pequena'
                columnaMatriz=1;
            case 'mediana'
                columnaMatriz=2;                
            case 'grande'
                columnaMatriz=3;                
        end

        switch etiquetaExperto
            case 'pequena'
                filaMatriz=1;
            case 'mediana'
                filaMatriz=2;                
            case 'grande'
                filaMatriz=3;                
        end
        % --------------------------------------------------------------

    matrizResultados(filaMatriz,columnaMatriz)=matrizResultados(filaMatriz,columnaMatriz)+1;        
    if(strcmp(etiquetaExperto,clasificacionObjetoEtiqueta))

    else
        fprintf('%s, ejeMenorSoft_mm = %f, ',nombreDelaImagenComparar, double(objetoComparar(1,1)));        
        fprintf('cs=> %s',clasificacionObjetoEtiqueta);
        fprintf(', ce= %s, ejeMayor_mm=%f, ejeMenor_mm=%f \n', etiquetaExperto, ejeMayorExperto, ejeMenorExperto);        
        %        fprintf(' NO IGUALES \n');
    end%comparacion
    
end %fin de archivo

%% --- FIN PRINCIPAL DEL CLASIFICADOR    ---

fprintf('Resultados \n');
fprintf('-----------\n');

%% Mostrar resultados de la matriz
[totalFilas, totalColumnas]=size(matrizResultados);
    fprintf(' clas.software                  |\n');
    fprintf(' pequeno  | mediana  | grande   | clas.experto|\n');
for(filas=1:1:totalFilas)
    for(columnas=1:1:totalColumnas)
        fprintf('%10i|',matrizResultados(filas,columnas));
    end%for

    switch filas
        case 1
            fprintf(' pequeno     |');
        case 2
            fprintf(' mediana     |');
        case 3
            fprintf(' grande      |');
    end    
    fprintf('\n');           
end %end for


    TP=matrizResultados(1,1)+matrizResultados(2,2)+matrizResultados(3,3);
    FP=matrizResultados(2,1)+matrizResultados(3,1)+matrizResultados(3,2);
    FN=matrizResultados(1,2)+matrizResultados(1,3)+matrizResultados(2,3);

    % Presentacion de resultados
    for(i=1:1:totalFilas)
        precision=precisionClase(matrizResultados,i);
        sensibilidad=sensitivityClase(matrizResultados,i);
        especificidad=specificityClase(matrizResultados,i);
        accuracy=accuracyMatriz(matrizResultados);        
        
        fprintf('Clase=%i, precision=%f, sensibilidad=%f especificidad=%f exactitud=%f\n', i, precision, sensibilidad, especificidad, accuracy);
        filaResultadosMetricas=sprintf('%f, %f, %f, %f, \n',precision, sensibilidad, especificidad,accuracy);

        %%Almacenado de resultados por clases
        matrizAcumulados(i,1)=matrizAcumulados(i,1)+precision;
        matrizAcumulados(i,2)=matrizAcumulados(i,2)+sensibilidad;
        matrizAcumulados(i,3)=matrizAcumulados(i,3)+especificidad;
        matrizAcumulados(i,4)=matrizAcumulados(i,4)+accuracy;
        
        switch i
            case 1
                %acumulados por clases                
                guardarArchivoMetricas(fileHandlerMC1,filaResultadosMetricas);
            case 2
                %acumulados por clases
                guardarArchivoMetricas(fileHandlerMC2,filaResultadosMetricas);
            case 3
                %acumulados por clases
                guardarArchivoMetricas(fileHandlerMC3,filaResultadosMetricas);
        end    %switch
        
        

    end %

end% final de las pruebas


%% sacando el promedio

fprintf('-----------------------------------\n');
fprintf('RESULTADOS \n');
%fprintf('Vecinos: %i\n', numeroVecinos);
fprintf('Total de pruebas: %i\n', totalPruebas);
fprintf('-----------------------------------\n');


matrizAcumulados
matrizPromedios=matrizAcumulados/totalPruebas;

[totalFilas, totalColumnas]=size(matrizPromedios);
    fprintf(' clas.software                  |\n');
    fprintf(' precisión  | sensibilidad | especificidad  | Exactitud  | CLASE |\n');
for(filas=1:1:totalFilas)
    for(columnas=1:1:totalColumnas)
        fprintf('%10.4f |', matrizPromedios(filas,columnas));
    end
    fprintf(' %i |\n', filas);
end


%% calculo genral del algoritmo
precisionAlgoritmo=0.0;
sensibilidadAlgoritmo=0.0;
especificidadAlgoritmo=0.0;
accuracyAlgoritmo=0.0;

fprintf('\n ------------------------------- \n');
fprintf('\n RESULTADO GENERAL DEL ALGORITMO \n');
for(filas=1:1:totalFilas)
    precisionAlgoritmo=precisionAlgoritmo+matrizPromedios(filas,1);
    sensibilidadAlgoritmo=sensibilidadAlgoritmo+matrizPromedios(filas,2);
    especificidadAlgoritmo=especificidadAlgoritmo+matrizPromedios(filas,3);
    accuracyAlgoritmo=accuracyAlgoritmo+matrizPromedios(filas,4);        
end

precisionAlgoritmo=precisionAlgoritmo/3;
sensibilidadAlgoritmo=sensibilidadAlgoritmo/3;
especificidadAlgoritmo=especificidadAlgoritmo/3;
accuracyAlgoritmo=accuracyAlgoritmo/3;

fprintf('precision= %10.4f | exactitud= %10.4f | sensibilidad= %10.4f | especificidad= %10.4f \n', precisionAlgoritmo, accuracyAlgoritmo, sensibilidadAlgoritmo, especificidadAlgoritmo);
