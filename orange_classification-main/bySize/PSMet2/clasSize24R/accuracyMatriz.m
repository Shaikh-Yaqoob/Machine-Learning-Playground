function [ accuracyResult ] = accuracyMatriz( matriz)
% Recibe una matriz de resultados y calcula la exactitud

sumatoriaDiagonal=0;
sumatoria=0;

[tamanoFilas, tamanoCol]=size(matriz);

for(i=1:1:tamanoFilas)
    for(j=1:1:tamanoCol)
        sumatoria=sumatoria+matriz(i,j);
        if(i==j)
            %%diagonal principal
            sumatoriaDiagonal=sumatoriaDiagonal+matriz(i,j);
        end
    end
end % fin for


accuracyResult=sumatoriaDiagonal/sumatoria;

end % precisionClase



