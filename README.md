# Senti4SD

Senti4SD is an emotion polarity classifier specifically trained to support sentiment analysis in developers' communication channels. 
Senti4SD is trained and evaluated on a gold standard of over 4K posts extracted from Stack Overflow. 

**NOTE**: You will need to install [Git LFS](https://git-lfs.github.com) extension to check out this project. Once installed and initialized, simply run:

```bash
$ git lfs clone https://github.com/collab-uniba/Senti4SD.git
```

### How do I get set up? ###
To set up the tool, simply run the following script from the command line:
```bash
$ ./requirements.sh
```
To run the script you need:

* Java 8
* R

The script will also install, if not already present, three R packages:

* [Caret](https://cran.r-project.org/package=caret)
* [LiblineaR](https://cran.r-project.org/package=LiblineaR)
* [e1071](https://cran.r-project.org/package=e1071)

To classify your data using Senti4SD

```bash
$ ./classificationTask.sh inputCorpus.csv outputPredictions.csv

```
where inputCorpus.csv is a file containing the data you want to classify, considering a document for each line, and outputPredictions.csv is where the predictions will be saved. This last parameter is optional, if not present the output of the classification will be saved in a file called "predictions.csv"

To see how the tool work run as example 
```
$ ./classificationTask.sh Sample.csv

```

It will create as output a csv file called "predictions.csv"

### Who do I talk to? ###

* Nicole Novielli, nicole.novielli@uniba.it
* Fabio Calefato, fabio.calefato@uniba.it
