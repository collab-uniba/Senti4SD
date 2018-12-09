# Senti4SD

Senti4SD is an emotion polarity classifier specifically trained to support sentiment analysis in developers' communication channels. 
Senti4SD is trained and evaluated on a gold standard of over 4K posts extracted from Stack Overflow. It is part of the Collab Emotion Mining Toolkit, ([EMTk](https://github.com/collab-uniba/EMTk)).

## Fair Use Policy
Please, cite the following paper if you intend to use our tool for your own research:
> Calefato, F., Lanubile, F., Maiorano, F., Novielli N. (2018) "Sentiment Polarity Detection for Software Development," _Empirical Software Engineering_, 23(3), pp:1352-1382, doi: https://doi.org/10.1007/s10664-017-9546-9. [(BibTeX)](https://scholar.googleusercontent.com/scholar.bib?q=info:2Vtb0Wmx7hEJ:scholar.google.com/&output=citation&scisig=AAGBfm0AAAAAW9gCvJzwrHV1MKhoxzqLaJZA8lPDFxgx&scisf=4&ct=citation&cd=-1&hl=en)

**NOTE**: You will need to install [Git LFS](https://git-lfs.github.com) extension to check out this project. Once installed and initialized, simply run:

```bash
$ git lfs clone https://github.com/collab-uniba/Senti4SD.git
```

### How do I get set up? ###
To set up the tool, simply run the following script from the command line:
```bash
$ sh requirements.sh
```
To run the script you need:

* Java 8
* R

The script will also install, if not already present, three R packages:

* [Caret](https://cran.r-project.org/package=caret)
* [LiblineaR](https://cran.r-project.org/package=LiblineaR)
* [e1071](https://cran.r-project.org/package=e1071)

### Running ###
To classify your data using Senti4SD, execute the following instruction from the command line:

```bash
$ cd ClassificationTask
$ sh classificationTask.sh inputCorpus.csv outputPredictions.csv

```
where `inputCorpus.csv` is a file containing the data you want to classify, considering a document for each line, and `outputPredictions.csv` is where the predictions will be saved. This last parameter is optional, if not present the output of the classification will be saved in a file called `predictions.csv`.

To see how the tool works, you can execute the following example:
```
$ cd ClassificationTask
$ sh classificationTask.sh Sample.csv
```

This will produce as output a csv file called `predictions.csv`.

### Who do I talk to? ###

* <a href="mailto:nicole.novielli@uniba.it">Nicole Novielli</a>
* [Fabio Calefato](https://github.com/bateman)
