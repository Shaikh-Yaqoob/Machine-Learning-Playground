# TODO LIST

## TODO - documentación
### Presentación del repositorio
~Colocar el enlace a la tesis en la página del CONACYT.~
~Subir el update a la página de Researchgate~
Hacer un readme para ejecutar.
Subir las imágenes en un zenodo
Subir fotografías y un video del funcionamiento.
Crear la secuencia de pasos que vaya enlazada con la tesis para replicar.

### TODO - organización de código
Separar el DATASET ORIGINAL de los elementos pre-procesados.
Separar dataset de salidas
Corregir los paths, pasar a la instrucción fullfile y addpath. Trabajar con addpath y fullfile

Quitar las cadenas hardcoded
Crear un script instalador que cree la secuencia de directorios automaticamente.
Translate to matlab script to clean folders
Traducir campos de Training\conf\20170916configuracion.xml
Traducir nombres de variables
Traducir nombres de funciones.
Traducir nombres de archivos
Traducir nombres de campos en archivos.
Traducir comentarios del texto.
Traducir los datos del .csv.
Traducir los comentarios
Limpiar el código de comentarios antiguos.
Actualizar las cabeceras de los archivos de código.
Por último, colocar en librerías comunes las funciones que se han repetido como ser: removeFiles.m
Colocar un README por cada carpeta
Faltaría un menu unificador para todos los procesos.
Cambiar los separadores a punto y coma.
hACER UN GRÁFICO GENERAL DE USO
En "detectROICandidates2", solucionar los problemas del path
Llegado el momento, separar el entrenamiento del pipeline de detección. Agregr una función que lea el modelo entrenado desde un archivo.
Colocar las etiquetas DEFECTOS Y CALYX en variables, porque están hardcoded



## Folders to check
Carpeta con los respectivos módulos.

Verificar la carpeta bySize/ y byDefects/


byDefects/
---------
CompareROI/
DefectsSegmentation/

~SetCreator [OK]~
~SegMarkExp [OK]~
~SegMarkExpExtraction [OK]~
~FruitEvaluation [OK]~


Hacer un mapa de las coordenadas XY.
Hacer un listado de los conceptos aplicados para generar una receta con 
tareas habituales MATLAB
