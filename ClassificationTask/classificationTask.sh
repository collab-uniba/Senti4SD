#!/bin/bash
SCRIPTDIR=$(dirname "$0")
echo $SCRIPTDIR

if [ -z "$1" ]; then
    echo "Usage: classificationTash.sh input.csv [predictions.csv]"
else
if [ ! -f $1 ]; then
    echo "File $1 not found!"
else
outputFile="$SCRIPTDIR/$2"
if [ -z "$2" ]
then
	outputFile="$SCRIPTDIR/predictions.csv"
fi

#-F A: all features to be considered
#-i file_name: a file containg a document for every line
#-W cbow600.bin: DSM to be loaded
#-oc file_name.csv: output dataset containg the features extracted
#-vd numeric: vectors size (for cbow600.bin the size is 600)
#-L: if present corpus have a label column [optional]
#-ul file_name: unigram's list to use for feature extraction. If not present default Senti4SD unigram's list will be used [optional]
#-bl file_name: bigram's list to use for feature extraction. If not present default Senti4SD bigram's list will be used [optional]

#java -jar $SCRIPTDIR/Senti4SD.jar -F A -i $1 -W $SCRIPTDIR/dsm.bin -oc $SCRIPTDIR/extractedFeatures.csv -vd 600
java -jar $SCRIPTDIR/Senti4SD-fast.jar -F A -i $1 -W $SCRIPTDIR/dsm.bin -oc $SCRIPTDIR/extractedFeatures.csv -vd 600

#classificate using as model "modelLiblinear.Rda", builded with "LiblineaR",
#using model "L2-regularized L2-loss support vector classification (dual)",
#with C=0.05 and as input "CBOW600_Bigram_NoVectDim.csv"
#classification.R will output the result of the classification to $outputFile
Rscript $SCRIPTDIR/classification.R $SCRIPTDIR/extractedFeatures.csv $outputFile
rm $SCRIPTDIR/extractedFeatures.csv
fi
fi
