function [] = dividirConjuntosUmbral2( proporcionTraining, pathPrincipal, pathResultados, nombreArchivoSetCompleto, nombreArchivoTraining, nombreArchivoTest)
% Divide un conjunto y genera dos archivos, uno de test y otro de training.
% Ambos mutuamente excluyentes.
%clc; clear all; close all;


%% Varios valores

% pathPrincipal='/home/usuario/ml/'; 
% pathResultados=strcat(pathPrincipal,'output/clasSizeML/');
 %% Parametros de entrada en fomato .csv
% nombreArchivoSetCompleto='archivoTrainingSetCompleto.csv';
% nombreArchivoTraining='archivoSetTraining.csv';
% nombreArchivoTest='archivoSetTest.csv';

formatSpec='%s%f%f%f%f%f%f%f%f%f%f%s'; %formato del archivo a leer

fileHandlerSetCompleto=strcat(pathResultados,nombreArchivoSetCompleto); 
fileHandlerTraining=strcat(pathResultados,nombreArchivoTraining); %handle para conjunto de entrenamiento
fileHandlerTest=strcat(pathResultados,nombreArchivoTest); %handle para conjunto de prueba

%% Carga del dataset de entrenamiento
% se cargan los datos en una tabla
tablaDSTSetCompleto = readtable(fileHandlerSetCompleto,'Delimiter',',','Format',formatSpec);
tamanoTabla=size(tablaDSTSetCompleto);

%% Declaracion de variables
TotalFilas=tamanoTabla(1); %tamano filas automatico
%proporcionTraining=80;
proporcionTest=0;   
TotalFilasTraining=0;
TotalFilasTest=0;


%Al menos 1porciento debe quedar para test
if(proporcionTraining<=99)
    proporcionTest=100-proporcionTraining; 
    TotalFilasTraining=int16((TotalFilas*proporcionTraining)/100);
    TotalFilasTest=int16((TotalFilas*proporcionTest)/100);
        
    fprintf('Proporcion Training=%3.2f \n',proporcionTraining);
    fprintf('Proporcion Test=%3.2f \n',proporcionTest);    
    fprintf('Total Filas=%i \n',TotalFilas);
    fprintf('Total Filas Training=%i \n',TotalFilasTraining);    
    fprintf('Total Filas Test=%i \n',TotalFilasTest);        
    
else
    fprintf('No se aplica la PROPORCION, debe existir al menos 1% para el archivo Test \n');
end % fin validacion


%% Dividir conjunto
contadorRandom=0;
fprintf('Elegir %i filas al azar para Test sin reemplazo \n',TotalFilasTest);


%% Ciclo para creacion de los conjuntos de entrenamiento y de test
for(contadorRandom=1:1:TotalFilasTest)
    filaIndexEleccion=int16(rand()*TotalFilasTest)+1;
%    fprintf('%i) %i fila seleccionada \n',contadorRandom,filaIndexEleccion);
    
    %Elegir fila al azar
    %posicionarse en la fila y borrar del conjunto general
    filaElegida=tablaDSTSetCompleto(filaIndexEleccion,:);
    if(contadorRandom==1)
        %crea la primera fila
        tablaDSTest=filaElegida;        
    else
        %Agrega filas
        tablaDSTest=[tablaDSTest; filaElegida];                
    end %(contadorRandom==1)
    tablaDSTSetCompleto(filaIndexEleccion,:)=[]; %borrar la fila seleccionada del conjunto principal
end %end for

%Guardar los restantes en training
tablaDSTraining=tablaDSTSetCompleto;

%% Guarda los conjuntos en archivos para test
writetable(tablaDSTraining,fileHandlerTraining,'WriteRowNames',true)
writetable(tablaDSTest,fileHandlerTest,'WriteRowNames',true)



end %fin dividirConjunto

