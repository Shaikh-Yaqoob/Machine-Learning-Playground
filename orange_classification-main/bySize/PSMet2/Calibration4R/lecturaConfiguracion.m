function [ resultado ] = lecturaConfiguracion( etiquetaBuscar, archivoConfig)
% --------------------------------------------
%% Lectura de XML
%Valores a buscar en el XML

xDoc = xmlread(fullfile(archivoConfig)); %Lectura del archivo

% obtener todos los elementos items
listadoItems = xDoc.getElementsByTagName('listitem');

%Recorrer los elementos items
for k = 0:listadoItems.getLength-1
   itemActual = listadoItems.item(k); %listItem actual
   
   % Get the label element. In this file, each
   % listitem contains only one label.
   listadoEtiquetas = itemActual.getElementsByTagName('label');
   elementoSeleccionado = listadoEtiquetas.item(0);
      
   % Check whether this is the label you want.
   % The text is in the first child node.
   %    disp('ANTES DEL clIF');
   %disp(elementoSeleccionado.getFirstChild.getData);
       
   if strcmp(elementoSeleccionado.getFirstChild.getData, etiquetaBuscar)
   %    disp('DENTRO DEL IF');
       listadoEtiquetas = itemActual.getElementsByTagName('value');
       elementoSeleccionado = listadoEtiquetas.item(0);      
       etiquetaValor = char(elementoSeleccionado.getFirstChild.getData);
       break;
   end %if strcmp  
end %fin del for



if ~isempty(etiquetaValor)
    msg = sprintf('Item "%s" tiene un valor de "%s"',etiquetaBuscar, etiquetaValor);
    
else
    msg = sprintf('Did not find the "%.2i" item.', etiquetaBuscar);
end
%disp(msg);

resultado=str2num(etiquetaValor);

% -------------------------------------------
end %fin de funcion

