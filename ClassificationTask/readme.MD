### [Senti4SD-fast.jar](https://github.com/collab-uniba/Senti4SD/blob/master/ClassificationTask/Senti4SD-fast.jar)
Extracts feature from an input dataset (1 or 2 columns (depends if the dataset have a label column) comma separated. Each line an text item to analyze). Creates an output csv with the features extracted.

Command-line parameters:
 
 * ```-F features```, feature to evaluate {A, S, L, K} A for All, S for Semantic, L for Lexicon, K for Keyword
 * ```-i filename```, the dataset to use (.csv)
 * ```-W filename```, the word space to use (.bin)
 * ```-oc filename```, output csv 
 * ```-vd numeric```, vectors size
 * ```-L``` if present corpus have a label column [optional]
 * ```-ul filename```, unigram's list [optional]
 * ```-bl filename```, bigram's list [optional]
 
 Example command-line:
```
java -jar Senti4SD-fast.jar -F A -i input.csv -W wordSpace.bin -oc output.csv -vd 600 [-L] [-ul unigramList -bl bigramList] 
```

---------------------
#### [classification.R](https://github.com/collab-uniba/Senti4SD/blob/master/ClassificationTask/classification.R)

usage: ```Rscript classification.R extractedFeatures.csv predictions.csv [modelLiblinear.Rda]```

"extractedFeatures.csv" is generated via Senti4SD-fast.jar
"modelLiblinear.Rda" is generate with "trainModel.R"
Parameter "modelLiblinear.Rda" is optional. If not present, the default model trained on StackOverflow will be used

