function [ sensitivity ] = sensitivityClase( matriz, numeroClase )
% Recibe un numero de clase y una matriz de resultados

i=numeroClase;
sumatoria=0;

[tamanoFilas, tamanoCol]=size(matriz);

for(i=1:1:tamanoCol)
    sumatoria=sumatoria+matriz(numeroClase,i);
end % fin for

% Si la clase está vacia
if(matriz(numeroClase,numeroClase)==0)
    sensitivity=0;
else
    sensitivity=matriz(numeroClase,numeroClase)/sumatoria;
end




end % precisionClase



