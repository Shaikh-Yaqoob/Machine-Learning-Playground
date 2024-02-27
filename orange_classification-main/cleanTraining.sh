#!/bin/sh

##################################################
# 
# 2018
# juancarlosmiranda81@gmail.com
#
##################################################

dUser=$HOME"/";
dApplication="OrangeResults/bySize/PSMet2/";
dMethod="Training/";

fullPath=$dUser$dApplication$dMethod;

# ----------------------------------------
# Output Directories
# ----------------------------------------
dOutput=$fullPath"output/"; #output files for training
dTmpToLearn=$fullPath"tmpToLearn/"; # intermediate images

dTmpBr=$dTmpToLearn"br/"; #image with background removed all in one image
dTmpRemoved=$dTmpToLearn"removed/"; #image whith background removed, cut
dTmpRoiSilhouettes=$dTmpToLearn"roi/"; #only regions of interest
dTmpFruitsSilhouettes=$dTmpToLearn"sFruits/"; #fruit segmented
files="*";

echo "------------------- \n";
echo "Attention this script will erase previous results, do you want to continue? \n";
echo "------------------- \n";


echo "------------------- \n";
echo "CLEANING IMAGE DIRECTORIES \n";
echo "------------------- \n";
# --------------------------------
echo "FILES->"$files;
echo "BR->"$dTmpBr$files;
echo "BACKGROUND REMOVED->"$dTmpRemoved$files;
echo "ROI->"$dTmpRoiSilhouettes$files;
echo "FRUITS SILHOUETTER->"$dTmpFruitsSilhouettes$files;

rm -Rf $dTmpBr$files;
rm -Rf $dTmpRemoved$files;
rm -Rf $dTmpRoiSilhouettes$files;
rm -Rf $dTmpFruitsSilhouettes$files;



