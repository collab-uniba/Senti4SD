# Senti4SD

### What is Senti4SD for? ###

* Quick summary
* Version
* [Learn Markdown](https://bitbucket.org/tutorials/markdowndemo)


### How do I get set up? ###

To run the script you need:

* Java 8
* R

The script will also install, if not already present, two R packages:

* Caret [https://cran.r-project.org/package=caret]
* LiblineaR [https://cran.r-project.org/package=LiblineaR] 

To classify your data using Senti4SD

```
#!sh
sh classificationTask.sh inputCorpus.csv outputPredictions.csv

```
where inputCorpus.csv is a file containing the data you want to classify, considering a document for each line, and outputPredictions.csv is where the predictions will be saved. This last parameter is optional, if not present the output of the classification will be saved in a file called "predictions.csv"

To see how the tool work run as example 
```
#!sh
sh classificationTask.sh Sample.csv

```

It will create as output a csv file called "predictions.csv"

### Who do I talk to? ###

* Nicole Novielli, nicole.novielli@uniba.it
* Fabio Calefato, fabio.calefato@uniba.it
