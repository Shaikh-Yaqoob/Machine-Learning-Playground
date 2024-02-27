function [ precision ] = precisionClase( matriz, numeroClase )
% Recibe un numero de clase y una matriz de resultados

i=numeroClase;
sumatoria=0;

[tamanoFilas, tamanoCol]=size(matriz);

for(i=1:1:tamanoFilas)
    sumatoria=sumatoria+matriz(i,numeroClase);
end % fin for

% Si la clase está vacia
if(matriz(numeroClase,numeroClase)==0)
    precision=0;
else
    precision=matriz(numeroClase,numeroClase)/sumatoria;
end


end % precisionClase



