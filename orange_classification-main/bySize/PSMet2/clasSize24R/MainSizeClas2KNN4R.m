%% Pruebas del clasificador de machine learning
% Es el archivo que realizará los test y la eficacia del clasificador
% A partir de un archivo con el conjunto completo clasificado, se procede a 
% realizar los test de eficacia. Estos test pueden ayudar a saber si el
% clasificador realiza correctamente su trabajo.
% Al final muestra una matriz de resultados segú la clasificación del
% experto y del software.
%
% 4R= 4 recortes, ML= machine learning
%% Ajuste de parámetros iniciales
clc; clear all; close all;


 %% Directory structure definition
HOMEUSER='/home/usuario/';
pathPrincipal=strcat(HOMEUSER,'OrangeResults/bySize/PSMet2/Classification/');
pathResultados=strcat(pathPrincipal,'output/clasSize24R/'); 
  
% * Leer el archivo principal.
% * Leer los valores de proporcion de los conjuntos.
% * Leer tabla del archivo conjunto principal.
% * Tomando el set principal, crear en forma aleatoria las filas del test, seleccionando 
% los valores.
% * Tomando el set principal, crear el set de training.
% Con ambos conjuntos, realizar un ciclo que clasifique y luego anote las
% buenas clasificaciones y las malas clasificaicones, con el fin de conocer
% la eficacia

 %% Parametros de entrada en fomato .csv
 nombreArchivoMC1='resultadomc1.csv';
 nombreArchivoMC2='resultadomc2.csv';
 nombreArchivoMC3='resultadomc3.csv';
 
 nombreArchivoSetCompleto='aTSCSize2KNN4RML.csv';
 
 
 %Leer las 
 nombreArchivoTraining='aTSSizeKNN24RML.csv';
 nombreArchivoTest='aTSize2KNN4RML.csv';
 nombreArchivoScreen='screenSize2KNN4RML.txt'; 
 %% valores experimentos
totalPruebas=100;
numeroVecinos=1; 
 


%% especificacion del formato
formatSpec='%s%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%s';

fileHandlerMC1=strcat(pathResultados,nombreArchivoMC1);%handle resultados clase1
fileHandlerMC2=strcat(pathResultados,nombreArchivoMC2);%handle resultados clase2
fileHandlerMC3=strcat(pathResultados,nombreArchivoMC3);%handle resultados clase2


fileHandlerTraining=strcat(pathResultados,nombreArchivoTraining); %handle para conjunto de entrenamiento
fileHandlerTest=strcat(pathResultados,nombreArchivoTest); %handle para conjunto de prueba
fileHandlerDiary=strcat(pathResultados,nombreArchivoScreen);


%% Remover archivos antiguos de resultados, borrar archivos
%fprintf('Borrando archivos de pruebas anteriores \n'); 
removerArchivos(fileHandlerTraining); 
removerArchivos(fileHandlerTest); 
removerArchivos(fileHandlerDiary);
removerArchivos(fileHandlerMC1);
removerArchivos(fileHandlerMC2);
removerArchivos(fileHandlerMC3);


%% Apertura del diario de pantallas
diary(fileHandlerDiary)


%% Ingresar parametros
proporcionTraining=input('INGRESE EL PORCENTAGE PARA TRAINING:');


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


dividirConjuntos24R( proporcionTraining, pathPrincipal, pathResultados, nombreArchivoSetCompleto, nombreArchivoTraining, nombreArchivoTest);


%% Carga del dataset de entrenamiento
% se cargan los datos en una tabla
tablaDSTraining = readtable(fileHandlerTraining,'Delimiter',',','Format',formatSpec);

%se cargan las etiquetas de clasificacion, el lugar 34 corresponde a la
%etiqueta de clasificacion
tablaDSTrainingClasificacion=tablaDSTraining(:,34);

% se cargan las caracteristicas que alimentaran al clasificador,
% corresponde a la etiqueta de eje menor 30 al 33
tablaDSTrainingCaracteristicas=tablaDSTraining(:,30:33);

%% Conversion de tablas a array cell
% Con el fin de ingresar al clasificador se realizan las conversiones de
% tipo
arrayTrainingClasificacion=table2cell(tablaDSTrainingClasificacion);


%Conversion de tabla a array y de array a matriz
arrayTrainingCaracteristicas=table2array(tablaDSTrainingCaracteristicas);


%% Entrenamiento del clasificador
% Se alimenta al clasficador con caracteristicas y las etiquetas para las
% mismas
fprintf('Entrenando clasificador \n');
Clasificador = fitcknn(arrayTrainingCaracteristicas,arrayTrainingClasificacion,'NumNeighbors',numeroVecinos,'Standardize',1);


%% Dividir archivos



%% --- INICIO PRINCIPAL DEL CLASIFICADOR ---
% Se levanta en una tabla el conjunto de datos a clasificar
tablaDSTest = readtable(fileHandlerTest,'Delimiter',',','Format',formatSpec);

% Se obtiene la caracteristica para comparar. 30 al 33 eje menor de los
% recortes
tablaDSTestComparar=tablaDSTest(:,30:33);
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
    objetoComparar = arrayTest(indiceTest,1:4); %objeto a comparar
    nombreDelaImagenComparar=char(table2array(tablaDSTest(indiceTest,1)));
    etiquetaComparar=char(table2array(tablaDSTest(indiceTest,34)));
    %
    ejeMenorCompararR1=char(table2array(tablaDSTest(indiceTest,30)));            
    ejeMenorCompararR2=char(table2array(tablaDSTest(indiceTest,31)));            
    ejeMenorCompararR3=char(table2array(tablaDSTest(indiceTest,32)));            
    ejeMenorCompararR4=char(table2array(tablaDSTest(indiceTest,33)));            

    
    
    %% Ejecucion de prediccion
    clasificacionObjeto = predict(Clasificador,objetoComparar);
    
    %% Presentacion de Resultados


        
        % ---------------------------------------------------------------
        filaMatriz=1;
        columnaMatriz=1;
        
        switch char(clasificacionObjeto(1))
            case 'pequena'
                columnaMatriz=1;
            case 'mediana'
                columnaMatriz=2;                
            case 'grande'
                columnaMatriz=3;                
        end

        switch etiquetaComparar
            case 'pequena'
                filaMatriz=1;
            case 'mediana'
                filaMatriz=2;                
            case 'grande'
                filaMatriz=3;                
        end
        % --------------------------------------------------------------

    matrizResultados(filaMatriz,columnaMatriz)=matrizResultados(filaMatriz,columnaMatriz)+1;        
    if(strcmp(etiquetaComparar,clasificacionObjeto(1)))

    else
%        fprintf('%s, Eje mayor = %f, , Eje menor = %f, ce= %s ',nombreDelaImagenComparar, double(objetoComparar(1,1)), double(objetoComparar(1,2)),etiquetaComparar);        
%        fprintf('cs=> %s \n',char(clasificacionObjeto(1)));

        fprintf('%s, ejeMenorSoft_mmR1 = %f, ejeMenorSoft_mmR2 = %f, ejeMenorSoft_mmR3 = %f, ejeMenorSoft_mmR4 = %f',nombreDelaImagenComparar, double(objetoComparar(1,1)), double(objetoComparar(1,2)), double(objetoComparar(1,3)), double(objetoComparar(1,4)));        
        %fprintf('%s,  ejeMenorSoft_mmR2 = %f, ejeMenorSoft_mmR3 = %f, ejeMenorSoft_mmR4 = %f',nombreDelaImagenComparar, double(objetoComparar(1,1)), double(objetoComparar(1,2)), double(objetoComparar(1,3)));        
        fprintf('cs=> %s', char(clasificacionObjeto(1)));
        fprintf(', ce= %s \n', etiquetaComparar);
        %        fprintf(', ce= %s, ejeMayor_mm=%f, ejeMenor_mm=%f \n', etiquetaComparar, ejeMayorComparar, ejeMenorComparar);
        
        
        
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
            fprintf(' pequena     |');
        case 2
            fprintf(' mediana     |');
        case 3
            fprintf(' grande      |');
    end    
    fprintf('\n');           
end %end for


    %TP=matrizResultados(1,1)+matrizResultados(2,2)+matrizResultados(3,3);
    %FP=matrizResultados(2,1)+matrizResultados(3,1)+matrizResultados(3,2);
    %FN=matrizResultados(1,2)+matrizResultados(1,3)+matrizResultados(2,3);

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
fprintf('Vecinos: %i\n', numeroVecinos);
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
    %fprintf(' %i |\n', filas);

        switch filas
        case 1
            fprintf(' pequeno     |\n');
        case 2
            fprintf(' mediana     |\n');
        case 3
            fprintf(' grande      |\n');
    end    

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


