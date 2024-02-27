function [ etiqueta ] = clasificadorUmbral( medicionAComparar )
    clase1='pequeña';
    clase2='mediana';
    clase3='grande';
    
    
    umbralClase1Fin=64.0;
    umbralClase2Inicio=umbralClase1Fin;
    umbralClase2Fin=68.60;
    umbralClase3Inicio=umbralClase2Fin;
    if ( medicionAComparar < umbralClase1Fin)
        etiqueta=clase1;
        %fprintf('clase 1');
    else
        if ((medicionAComparar >= umbralClase2Inicio)   & (medicionAComparar <umbralClase2Fin))
            %fprintf('clase 2');
            etiqueta=clase2;            
        else
            if (medicionAComparar >= umbralClase3Inicio)            
                %fprintf('clase 3');                
                etiqueta=clase3;                
            end %clase 3    
        end %clase 2
        
    end %clase 1

end

