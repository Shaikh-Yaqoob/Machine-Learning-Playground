# Clasificación automática de naranjas por tamaño y por defectos utilizando técnicas de visión por computadora (ORGANIZANDO REPOSITORIO AÚN FALTA)

![SOFTWARE_PRESENTATION_01](https://github.com/juancarlosmiranda/orange_classification/blob/main/docs/img/orange_classification_diagrams_01_1.0.png?raw=true)

![SOFTWARE_PRESENTATION_02](https://github.com/juancarlosmiranda/orange_classification/blob/main/docs/img/orange_classification_diagrams_02_1.0.png?raw=true)

## Resumen
En este trabajo, se propone una metodología automática y reproducible utilizando técnicas de visión por computadora para clasificación de naranjas por tamaño y por defectos. Los pasos propuestos para clasificación por tamaño fueron: adquisición de imágenes, calibración, procesamiento y segmentación de imágenes, extracción de características y clasificación. Se aplicaron 2 técnicas de procesamiento y segmentación de imágenes para separar la fruta. Para clasificación se evaluaron 2 modos: clasificación según umbral, clasificación con aplicación de aprendizaje automático. El método de segmentación 2, basado en umbrales en el espacio CIELAB, demostró ser el mejor y se vió menos afectado por los cambios de iluminación en una comparativa visual. La mejor combinación de procesos ensamblados para clasificación fue la que incluyó: el método de segmentación 2, medición del eje menor a partir de 4 imágenes y clasificación con el algoritmo SVM. 
Los pasos propuestos para detección de defectos fueron: marcación y creación de banco de imágenes, generación de datos para aprendizaje, evaluación de frutas con el algoritmo KNN. La segmentación de defectos consistió en la implementación de 3 variantes combinadas con operaciones de morfología binaria y suavizado. Las regiones fueron sometidas a un proceso de verificación automática contra lo marcado por un experto. La variante 2 basada en el filtro Prewitt demostró una exactitud de 96\%. Para clasificación de defectos se utilizaron características geométricas y de color en conjunto con el algoritmo KNN.

**Palabras claves:** Visión por computadora, Procesamiento de imágenes, Segmentación, Extracción de características, Clasificación, Aprendizaje automático.

Tesis presentada a la [Facultad Politécnica, Universidad Nacional de Asunción](https://www.pol.una.py/), como requisito para la obtención del Grado de Máster en Ciencias de la Computación.
Beca [CONACYT BECA08-25](https://www.conacyt.gov.py/view-inventario-de-tesis?keys=beca08-25) (https://www.conacyt.gov.py/view-inventario-de-tesis?keys=beca08-25). Apoyo financiero de [CONACYT-Paraguay, bajo el programa 14-POS-008](https://datos.conacyt.gov.py/proyectos/nid/209)
* [https://dx.doi.org/10.13140/RG.2.2.15456.35845](https://dx.doi.org/10.13140/RG.2.2.15456.35845) (escrito en Español)
* [https://repositorio.conacyt.gov.py/handle/20.500.14066/3172](https://repositorio.conacyt.gov.py/handle/20.500.14066/3172) (escrito en Español)


# Automatic grading of oranges by size and by defects using computer vision techniques
## Abstract
In this work, an automatic and reproducible methodology is proposed using computer vision techniques for sorting oranges by size and defects. The proposed steps for size classification were: image acquisition, calibration, image processing and segmentation, feature extraction and classification. Two image processing and segmentation techniques were applied to separate the fruit. For classification, 2 modes were evaluated: classification according to threshold, classification with automatic learning application. Segmentation method 2, based on thresholds in the CIELAB space, proved to be the best and was less affected by lighting changes in a visual comparison. The best combination of processes assembled for classification was the one that included: segmentation method 2, measurement of the minor axis from 4 images and classification with the SVM algorithm. 
The proposed steps for defect detection were: marking and creation of an image bank, generation of data for learning, fruit evaluation with the KNN algorithm. The defect segmentation consisted of the implementation of 3 variants combined with binary morphology and smoothing operations. The regions were subjected to an automatic verification process against the marks of an expert. Variant 2 based on the Prewitt filter showed an accuracy of 96 percent. For defect classification, geometric and color characteristics were used in conjunction with the KNN algorithm.

**Keywords:** Computer vision, Image processing, Segmentation, Classification, Machine learning.

Schollarship [CONACYT BECA08-25](https://www.conacyt.gov.py/view-inventario-de-tesis?keys=beca08-25) (https://www.conacyt.gov.py/view-inventario-de-tesis?keys=beca08-25). Financial support from [CONACYT-Paraguay, under program # 14-POS-008](https://datos.conacyt.gov.py/proyectos/nid/209)
* [https://dx.doi.org/10.13140/RG.2.2.15456.35845](https://dx.doi.org/10.13140/RG.2.2.15456.35845) (written in Spanish)
* [https://repositorio.conacyt.gov.py/handle/20.500.14066/3172](https://repositorio.conacyt.gov.py/handle/20.500.14066/3172) (written in Spanish)



## Contents (TO COMPLETE REVIEW THIS AFTER INSTALL)

1. Pre-requisites.
2. Functionalities.
3. Install and run.
4. Files and folder description.


## 1. Pre-requisites

* MATLAB R2021a.
* Computer Vision System Toolbox
* Statistics and Machine Learning Toolbox (TODO)
* Dataset

## 2. Functionalities

The functionalities of the software are briefly described. Supplementary material can be
found in [USER's Manual](https://github.com/juancarlosmiranda/orange_classification/blob/main/docs/USER_MANUAL_orange_classification_v1.md).

* **[Dataset creation]**  This option creates a hierarchy of metadata. This hierarchy contains sub-folders that will be
  used to store the extracted data.
* **[ xxx]** xxx.


## 3. Install and run

Create your folder environment.

```
xxxx
```

```

|__/DATASET/
       |__/inputToLearn/ -> RGB images
       |__/inputMarked/ -> RGB images with masks

|__/PREPROCESSED_DATASET/
       |__/inputTest -> folder with images for tests
       |__/inputTraining -> folder with images for training.

```

1) Descarga del DATASET con imágenes tomadas en laboratorio y marcaciones manuales realizadas por el experto.
2) /byDefects/PSMet2/SetCreator/MainSetCreator.m, para crear pre-procesar el conjunto de datos.
3) 

## 4.3 Files and folder description

*** TODO: Es necesario colocar la secuencia para el uso de los archivos.
Esto es un montón de scripts sin una secuencia de pasos. ***


Files and modules:

| Files                    | Description              | OS |
|---------------------------|-------------------------|---|
| /byDefects/PSMet2/SetCreator/MainSetCreator.m | Creador de conjuntos de entrenamiento y pruebas. Se encarga de crear un conjunto de entrenamiento y pruebas al azar. Crea un listado inicial de imágenes a partir de un directorio de muestras, las cuales cuentan con su correspondencia de marcación por el experto. | -- |
| /byDefects/PSMet2/CompareROI/CompareSegmentation/MainMet4RSDMet1.m | Genera imagenes de regiones previamente marcadas a MANO. Es un proceso previo a la extraccion automatizada de caracteristicas. Se asume que un experto marcó las frutas a mano con colores. Como salida se producen imágenes. | -- |
| /byDefects/PSMet2/SegMarkExpExtraction/MainSegMarkExpExtraction.m | Genera archivos con características de defectos y calyx, los cuales son utilizados para obtener datos de: color, textura y geometria de defectos y calyx. REQUIRE DE UN PROCESO PREVIO, que genera imagnes de defectos en colores y sus siluetas. Cada imagen en un directorio base, cuenta con sub imágenes de regiones e imágenes de siluetas. Ejemplo: 001.jpg es la imagen principal, existen imágenes de las regiones R1..R4 para lo defectos y a su vez exiten imágenes específicas para sus siluetas de defectos. La función asume que hubo un procesamiento previo, en el cual se generaron imágenes desde las marcas en colores dibujadas por e experto. | -- |
| /byDefects/PSMet2/CompareROI/CompareSegmentation/MainMet4RSDMet1.m, /byDefects/PSMet2/CompareROI/CompareSegmentation/MainMet4RSDMet2.m, /byDefects/PSMet2/CompareROI/CompareSegmentation/MainMet4RSDMet3.m | Genera imagenes de regiones previamente marcadas a MANO. Es un proceso previo a la extraccion automatizada de caracteristicas. Se asume que un experto marco las frutas a mano con colores. Como salida se producen imágenes. | -- |
| . | . | -- |
| /byDefects/PSMet2/FruitEvaluation/ | Se generan datos obtenidos luego de aplicar un método de segmentación y un clasificador de defectos previamente entrenado. Al final se obtiene un listado con las clasificaciones de lo detectado. | -- |
| . | . | -- |
| . | . | -- |
| . | . | -- |
| . | . | -- |

** byDefects/ **
| Folders                    | Description            |
|---------------------------|-------------------------|
| byDefects/SetCreator/ | 1) OK |
| byDefects/SegMarkExp/ | 2). |
| byDefects/SegMarkExpExtraction/ | 3). |
| byDefects/CompareROI/ | . |
| byDefects/FruitEvaluation/ | . |
| byDefects/DefectsSegmentation/ | . |
| . | . |
| . | . |


** bySize/ **
| Folders                    | Description            |
|---------------------------|-------------------------|
| bySize/Calibration4R/ | . |
| bySize/clasSize2ML/ | . |
| bySize/clasSize24R/ | . |
| bySize/clasSizeUM/ | . |
| bySize/conf/ | . |
| bySize/Training24R/ | . |
| . | . |
| . | . |



Folder description:

| Folders                    | Description            |
|---------------------------|-------------------------|
| [orange_classification/](https://github.com/juancarlosmiranda/orange_classification/) | Source code |
| [docs/](https://github.com/juancarlosmiranda/orange_classification/tree/main/docs/) | Documentation |
| . | . |




## Authorship

Please contact author to report bugs [https://www.linkedin.com/in/juan-carlos-miranda-py/](https://www.linkedin.com/in/juan-carlos-miranda-py/)

## Citation

If you find this code useful, please consider citing:

```
@article{miranda2018clasificacion,
  title={Clasificaci{\'o}n autom{\'a}tica de naranjas por tama{\~n}o y por defectos utilizando t{\'e}cnicas de visi{\'o}n por computadora},
  journal={Universidad Nacional de Asunci{\'o}n, San Lorenzo},
  year={2018},    
  doi = {http://dx.doi.org/10.13140/RG.2.2.15456.35845},
  url = {https://www.researchgate.net/publication/326551993_CLASIFICACION_AUTOMATICA_DE_NARANJAS_POR_TAMANO_Y_POR_DEFECTOS_UTILIZANDO_TECNICAS_DE_VISION_POR_COMPUTADORA},
  author={Miranda, Juan Carlos and Legal-Ayala, H},
  keywords = {computer vision, image processing, segmentation, classification, machine learning},
  abstract = {...}
}
```

## Acknowledgements

This work is a result of the [CONACYT BECA08-25](https://www.conacyt.gov.py/view-inventario-de-tesis?keys=beca08-25) granted by [Consejo Nacional de Ciencia y Tecnología (CONACYT)](https://repositorio.conacyt.gov.py/handle/20.500.14066/).
