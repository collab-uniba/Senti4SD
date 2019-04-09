#### [parameterTuning.R](https://github.com/collab-uniba/Senti4SD/blob/master/ClassificationTask/Training/parameterTuning.R):

usage: ```Rscript parameterTuning.R outputFolderName modelsLiblinear extractedFeaturesLABEL.csv```

Does parameter tuning for each liblinear model in "modelsLiblinear" on input "extractedFeaturesLABEL.csv", and generate for each model a txt file (saved in "outputFolderName") containing the Cost parameter that reports the highest accuracy.  
"extractedFeaturesLABEL.csv" is generated via Senti4SD.jar with parameter '-L'. The input dataset for Senti4SD.jar must have 2 colums, one with text and one with label (dataset with no header)

---------------------

### [NgramsExtraction.jar](https://github.com/collab-uniba/Senti4SD/blob/master/ClassificationTask/NgramsExtraction.jar)
Extract from an input dataset lists of n-grams (uni- and bi-). Creates 2 files: UnigramsList and BigramsList.
If input dataset has a label column add a 'true' in the command after your csv dataset.

Example command-line:
```
java -jar NgramsExtraction.jar input.csv [true]
```
---------------------

#### [trainModel.R](https://github.com/collab-uniba/Senti4SD/blob/master/ClassificationTask/Training/trainModel.R):

usage: ```Rscript trainModel.R outputFolderName configFile.txt extractedFeaturesLABEL.csv```

Save the liblinear model (file .Rda) reading data from "configFile.txt" (generated with "parameterTuning.R"). If the input txt is empty, the default values will be used (model=L2-regularized_logistic_regression_(primal) and cost=1)

---------------------
#### [classification.R](https://github.com/collab-uniba/Senti4SD/blob/master/ClassificationTask/classification.R)

usage: ```Rscript classification.R extractedFeatures.csv predictions.csv [modelLiblinear.Rda]```

"extractedFeatures.csv" is generated via Senti4SD.jar, from an input dataset with only a text column.
"modelLiblinear.Rda" is generate with "trainModel.R"
Parameter "modelLiblinear.Rda" is optional. If not present, the default model trained on StackOverflow will be used






