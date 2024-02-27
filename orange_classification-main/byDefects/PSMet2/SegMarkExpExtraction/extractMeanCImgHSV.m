function [ promedioH, promedioS, promedioV, desviacionH, desviacionS, desviacionV ] = extraerCPromImgHSV( IRecorteRGB, IMascaraC)
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
IRecorteHSV=rgb2hsv(IRecorteRGB); % hsv
IMascara=IMascaraC;

[filasTope, columnasTope, ~]=size(IRecorteRGB);

sumaH=double(0.0);
sumaS=double(0.0);
sumaV=double(0.0);
contadorPixeles=double(0.0);

%variables para el calculo de varianza
sumaVarianzaH=double(0.0);
varianzaH=double(0.0);
sumaVarianzaS=double(0.0);
varianzaS=double(0.0);
sumaVarianzaV=double(0.0);
varianzaV=double(0.0);

%recorrer la imagen mascara
for f=1:1:filasTope
    for c=1:1:columnasTope
        % Leer de la imagen mascara si el valor es diferente a cero
        pixelMascara=IMascara(f,c);
        if pixelMascara == PRIMER_PLANO
            sumaH=double(IRecorteHSV(f,c,1))+sumaH;
            sumaS=double(IRecorteHSV(f,c,2))+sumaS;
            sumaV=double(IRecorteHSV(f,c,3))+sumaV; 
            contadorPixeles=contadorPixeles+1;
        end %if        
    end %for columnas
end %for filas

% --------------------------------------
%valores de los promedios porcanales
%---------------------------------------
promedioH=double(sumaH/contadorPixeles); %promedio canal H
promedioS=double(sumaS/contadorPixeles); %promedio canal S
promedioV=double(sumaV/contadorPixeles); %promedio canal V

%------------------------------------------------------------------------
% Varianza muestral
%------------------------------------------------------------------------
for f=1:1:filasTope
    for c=1:1:columnasTope
        % Leer de la imagen mascara si el valor es diferente a cero
        pixelMascara=IMascara(f,c);
        if pixelMascara == PRIMER_PLANO            
            sumaVarianzaH=sumaVarianzaH+(IRecorteHSV(f,c,1)-promedioH)^2;
            sumaVarianzaS=sumaVarianzaS+(IRecorteHSV(f,c,2)-promedioS)^2;
            sumaVarianzaV=sumaVarianzaV+(IRecorteHSV(f,c,3)-promedioV)^2;            
        end %if        
    end %for columnas
end %for filas
% -----------------------------------------------------------------------
desviacionH=sqrt(sumaVarianzaH/(contadorPixeles));
desviacionS=sqrt(sumaVarianzaS/(contadorPixeles));
desviacionV=sqrt(sumaVarianzaV/(contadorPixeles));

end %fin de la funcion


