#!/bin/bash
SCRIPTDIR=$(dirname "$0")
echo $SCRIPTDIR


if [ -z "$1" ]; then
    echo "Usage: classificationTash1.sh input_directory [output_directory]"
else
if [ ! -d $1 ]; then
    echo "$1 is not a directory!"
else
if [ -z "$2" ]
then
	mkdir -p $SCRIPTDIR/output
	outputdir="$SCRIPTDIR/output"
	#echo "$outputdir"
else
	mkdir -p $SCRIPTDIR/$2
	outputdir="$SCRIPTDIR/$2"
	#echo "$outputdir"
fi


for i in $1/*
do

outputFile=${i##*/}
echo "Processing file: $outputFile"

outputfilepath="$outputdir/out_$outputFile"

#-F A: all features to be considered
#-i file_name: a file containg a document for every line
#-W cbow600.bin: DSM to be loaded
#-oc file_name.csv: output dataset containg the features extracted
#-vd numeric: vectors size (for cbow600.bin the size is 600)
#-L: if present corpus have a label column [optional]
#-ul file_name: unigram's list to use for feature extraction. If not present default Senti4SD unigram's list will be used [optional]
#-bl file_name: bigram's list to use for feature extraction. If not present default Senti4SD bigram's list will be used [optional]

#java -jar $SCRIPTDIR/Senti4SD.jar -F A -i $1 -W $SCRIPTDIR/dsm.bin -oc $SCRIPTDIR/extractedFeatures.csv -vd 600
	java -jar $SCRIPTDIR/Senti4SD-fast.jar -F A -i $i -W $SCRIPTDIR/dsm.bin -oc $SCRIPTDIR/extractedFeatures.csv -vd 600

#classificate using as model "modelLiblinear.Rda", builded with "LiblineaR",
#using model "L2-regularized L2-loss support vector classification (dual)",
#with C=0.05 and as input "CBOW600_Bigram_NoVectDim.csv"
#classification.R will output the result of the classification to $outputFile
	Rscript $SCRIPTDIR/classification.R $SCRIPTDIR/extractedFeatures.csv $outputfilepath
	rm $SCRIPTDIR/extractedFeatures.csv
done
fi
fi

