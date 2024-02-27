function [ promedioL, promedioA, promedioB, desviacionL, desviacionA, desviacionB ] = extractMeanCImgLAB( IRecorteRGB, IMascaraC)
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
IRecorteLAB=rgb2lab(IRecorteRGB); % hsv

IMascara=IMascaraC;

[filasTope, columnasTope, ~]=size(IRecorteRGB);

sumaL=double(0.0);
sumaA=double(0.0);
sumaB=double(0.0);
contadorPixeles=double(0.0);

%variables para el calculo de varianza
sumaVarianzaL=double(0.0);
varianzaL=double(0.0);
sumaVarianzaA=double(0.0);
varianzaA=double(0.0);
sumaVarianzaB=double(0.0);
varianzaB=double(0.0);

%recorrer la imagen mascara
for f=1:1:filasTope
    for c=1:1:columnasTope
%        % Leer de la imagen mascara si el valor es diferente a cero
        pixelMascara=IMascara(f,c);

        if pixelMascara == PRIMER_PLANO
            sumaL=double(IRecorteLAB(f,c,1))+sumaL;
            sumaA=double(IRecorteLAB(f,c,2))+sumaA;
            sumaB=double(IRecorteLAB(f,c,3))+sumaB; 
            contadorPixeles=contadorPixeles+1;
        end %if        
    end %for columnas
end %for filas


% --------------------------------------
%valores de los promedios porcanales
%---------------------------------------
promedioL=double(sumaL/contadorPixeles); %promedio canal L
promedioA=double(sumaA/contadorPixeles); %promedio canal A
promedioB=double(sumaB/contadorPixeles); %promedio canal B

%------------------------------------------------------------------------
% Varianza muestral
%------------------------------------------------------------------------
for f=1:1:filasTope
    for c=1:1:columnasTope
%        % Leer de la imagen mascara si el valor es diferente a cero
        pixelMascara=IMascara(f,c);
        if pixelMascara == PRIMER_PLANO            
            sumaVarianzaL=sumaVarianzaL+(IRecorteLAB(f,c,1)-promedioL)^2;
            sumaVarianzaA=sumaVarianzaA+(IRecorteLAB(f,c,2)-promedioA)^2;
            sumaVarianzaB=sumaVarianzaB+(IRecorteLAB(f,c,3)-promedioB)^2;            
        end %if        
    end %for columnas
end %for filas
% -----------------------------------------------------------------------
%cálculo de la varianza por canal H
%sumaBarianzaS
desviacionL=sqrt(sumaVarianzaL/(contadorPixeles));
desviacionA=sqrt(sumaVarianzaA/(contadorPixeles));
desviacionB=sqrt(sumaVarianzaB/(contadorPixeles));

%% resultados finales

end %fin de la funcion


