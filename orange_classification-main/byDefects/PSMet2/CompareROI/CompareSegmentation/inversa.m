function [ ] = inversa(nombreMascara, nombreMascaraFinal)
% ########################################################################
% Project AUTOMATIC CLASSIFICATION OF ORANGES BY SIZE AND DEFECTS USING 
% COMPUTER VISION TECHNIQUES 2018
% juancarlosmiranda81@gmail.com
% ########################################################################

IExp=imread(nombreMascara);
%% 
nivel=graythresh(IExp);
IBExp=im2bw(IExp,nivel);
final=1-IBExp; %inversa
imwrite(final,nombreMascaraFinal,'jpg');

end %funcion