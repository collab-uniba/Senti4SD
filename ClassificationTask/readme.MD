### [Senti4SD.jar](https://github.com/collab-uniba/Senti4SD/blob/master/ClassificationTask/Senti4SD.jar)
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
### [NgramsExtraction.jar](https://github.com/collab-uniba/Senti4SD/blob/master/ClassificationTask/NgramsExtraction.jar)
Extract from an input dataset lists of n-grams (uni- and bi-). Creates 2 files: UnigramsList and BigramsList.
If input dataset has a label column add a 'true' in the command after your csv dataset.

Example command-line:
```
java -jar NgramsExtraction.jar input.csv [true]
```
