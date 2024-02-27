function [ specificity ] = specificityClase( matriz, numeroClase )
% Recibe un numero de clase y una matriz de resultados

i=numeroClase;
tn=0;
fp=0;

[tamanoFilas, tamanoCol]=size(matriz);


% calculo de TN
for(i=1:1:tamanoFilas)
    for(j=1:1:tamanoCol)
            if(i~=numeroClase)
                if(j~=numeroClase)
%                    fprintf('%i',matriz(i,j));
                    tn=tn+matriz(i,j);
                end
            end

    end %
end % fin for

% calculo de fp
for(i=1:1:tamanoFilas)
        if(i~=numeroClase)
            fp=fp+matriz(i,numeroClase);
        end %
end % fin for

%Para proteger la division por cero
if(tn+fp==0)
    specificity=0;    
else
    specificity=tn/(tn+fp);
end


end % precisionClase



