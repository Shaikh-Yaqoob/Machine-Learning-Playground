function [ promedioR, promedioG, promedioB, desviacionR, desviacionG, desviacionB ] = extractMeanCImgRGB( IRecorteRGB, IMascaraC)
% ########################################################################
% Project AUTOMATIC CLASSIFICATION OF ORANGES BY SIZE AND DEFECTS USING 
% COMPUTER VISION TECHNIQUES 2018
% juancarlosmiranda81@gmail.com
% ########################################################################
% Extraer color promedio de una imagen, utilizando una silueta para
% cuantificar el color y los valores que se extraen. 
% El resultado se trabaja en el espacio de color HSV.

PRIMER_PLANO=1;

%Lectura de la imagen con fondo
IMascara=IMascaraC;


[filasTope, columnasTope, ~]=size(IRecorteRGB);

sumaR=double(0.0);
sumaG=double(0.0);
sumaB=double(0.0);
contadorPixeles=double(0.0);

%variables para el calculo de varianza
sumaVarianzaR=double(0.0);
varianzaG=double(0.0);
sumaVarianzaG=double(0.0);
varianzaG=double(0.0);
sumaVarianzaB=double(0.0);
varianzaB=double(0.0);

%recorrer la imagen mascara
for f=1:1:filasTope
    for c=1:1:columnasTope
%        % Leer de la imagen mascara si el valor es diferente a cero
        pixelMascara=IMascara(f,c);

        if pixelMascara == PRIMER_PLANO
            sumaR=double(IRecorteRGB(f,c,1))+sumaR;
            sumaG=double(IRecorteRGB(f,c,2))+sumaG;
            sumaB=double(IRecorteRGB(f,c,3))+sumaB; 
            contadorPixeles=contadorPixeles+1;
        end %if        
    end %for columnas
end %for filas

% --------------------------------------
%valores de los promedios porcanales
%---------------------------------------
promedioR=double(sumaR/contadorPixeles); %promedio canal R
promedioG=double(sumaG/contadorPixeles); %promedio canal G
promedioB=double(sumaB/contadorPixeles); %promedio canal B

%------------------------------------------------------------------------
% Varianza muestral
%------------------------------------------------------------------------
for f=1:1:filasTope
    for c=1:1:columnasTope
%        % Leer de la imagen mascara si el valor es diferente a cero
        pixelMascara=IMascara(f,c);
        if pixelMascara == PRIMER_PLANO            
            sumaVarianzaR=sumaVarianzaR+(IRecorteRGB(f,c,1)-promedioR)^2;
            sumaVarianzaG=sumaVarianzaG+(IRecorteRGB(f,c,2)-promedioG)^2;
            sumaVarianzaB=sumaVarianzaB+(IRecorteRGB(f,c,3)-promedioB)^2;            
        end %if        
    end %for columnas
end %for filas
% -----------------------------------------------------------------------

desviacionR=sqrt(double(sumaVarianzaR/(contadorPixeles)));
desviacionG=sqrt(double(sumaVarianzaG/(contadorPixeles)));
desviacionB=sqrt(double(sumaVarianzaB/(contadorPixeles)));

%% resultados finales

end %fin de la funcion


