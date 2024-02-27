function [ resultado ] = deteccionCuadros(ArrayCuadros, xmin, ymin)
%%Detectar el numero de cuadro en el que se encuentra una coordenada. Se
%%asume previamente configurados cuadros que dividen la pantalla en cuatro,
%%se considera un cuadro 0,0,0,0 como marca de fin de lista. La funcion
%%devuelve el numero de cuadro de 1..4 o N. Esta funcion se utiliza en la
%%deteccion de objetos.


[totalFilas, totalCol]=size(ArrayCuadros);

%% REcorrer tabla con cuadros para detectar el punto inicial
n=1; %indice detector de objetos
for (n=1:totalFilas) 
     columnaInicio=ArrayCuadros(n,1); columnaFin=ArrayCuadros(n,1)+ArrayCuadros(n,3);
     filaInicio=ArrayCuadros(n,2); filaFin=ArrayCuadros(n,2)+ArrayCuadros(n,4);

%     fprintf('probando cuadro %i -> xmin=%i, ymin=%i \n',n,xmin, ymin);
     if((xmin>=columnaInicio) & (xmin<=columnaFin))
%        fprintf('dentro de columnas cuadro numero=%i xmin=%i > %i y xmin=%i < %i \n',n,xmin,columnaInicio,xmin,columnaFin);
        if((ymin>=filaInicio) & (ymin<=filaFin))
%            fprintf('dentro de fila cuadro numero=%i ymin=%i > %i y ymin=%i < %i \n',n,ymin,filaInicio,ymin,filaFin);
                    break;
        else
%            fprintf('FUERA DE FILAS cuadro %i ymin=%i > %i y ymin=%i < %i NOO \n',n,ymin,filaInicio,ymin,filaFin);
        end% filas    
     else
%            fprintf('FUERA DE COLUMNAS cuadro %i xmin=%i > %i y xmin=%i < %i NOO\n',n,xmin,columnaInicio,xmin,columnaFin);
     end
end% for     

%%resultados
if(n==totalFilas)
%    fprintf('xmin=%i ymin=%i NO ENCAJA\n', xmin, ymin);
    resultado='N';
else
%    fprintf('EL CUADRO ES %i\n', n);
    resultado=int2str(n); %devuelve en forma de cadena
end %

end %deteccionCuadros