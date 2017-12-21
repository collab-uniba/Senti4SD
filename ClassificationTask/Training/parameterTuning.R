#Parameter tuning LibLinear

# enable commandline arguments from script launched using Rscript
args<-commandArgs(TRUE)

# creates current output directory for current execution
output_dir <- args[1]
if(!dir.exists(output_dir))
  dir.create(output_dir, showWarnings = FALSE, recursive = TRUE, mode = "0777")

# Params
models_file <- args[2]
csv_file <- args[3]
# logs errors to file
error_file <- paste(args[1], "log", sep = ".")
log.error <- function() {
  cat(geterrmessage(), file=paste(output_dir, error_file, sep = "/"), append=TRUE)
}
options(show.error.locations=TRUE)
options(error=log.error)

# library setup, depedencies are handled by R
library(caret) # for param tuning
library(e1071) # for normality adjustment
library(LiblineaR)

# comma delimiter
dataset <- read.csv(csv_file, header = TRUE, sep=",")

# name of outcome var to be predicted
outcomeName <- "label"
# list of predictor vars by name
excluded_predictors <- c("id")
temp <- dataset
dataset <- dataset[ , !(names(dataset) %in% excluded_predictors)]
predictorsNames <- names(dataset[,!(names(dataset)  %in% c(outcomeName))]) # removes the var to be predicted from the test set

# if any, exclude rows with Na, NaN and Inf (missing values)
dataset <- na.omit(dataset)

x=dataset[,predictorsNames]
y=factor(dataset[,outcomeName])

set.seed(846)
# create stratified training and test sets from SO dataset
splitIndex <- createDataPartition(dataset[,outcomeName], p = .70, list = FALSE)
xTrain=x[splitIndex,]
xTest=x[-splitIndex,]
yTrain=y[splitIndex]
yTest=y[-splitIndex]

testing <- dataset[-splitIndex, ]

# load all the classifiers to tune
classifiers <- readLines(models_file)

for(i in 1:length(classifiers)){
  nline <- strsplit(classifiers[i], ":")[[1]]
  classifier <- nline[1]
  number <- as.integer(nline[2])
  cat(paste("Building model for classifier", classifier,"\n",sep=" "))
  #cat(paste(number,"\n"))  
  tryCosts=c(0.01,0.05,0.10,0.20,0.25,0.50,1,2,4,8)
  bestCost=NA
  bestAcc=0
  
  # output file for the classifier at nad
  output_file <- paste(output_dir, paste(classifier, "txt", sep="."), sep = "/")
  
  cat("Input file:",csv_file,"\n",sep="",file=output_file)
  cat("Classifier:",classifier,"\n",sep="",file=output_file,append=TRUE)
  cat("Id Classifier:",number,"\n",sep="",file=output_file,append=TRUE)
  
  for(co in tryCosts){
    
    start.time <- Sys.time() 
    
    acc=LiblineaR(data=xTrain,target=yTrain,type=number,cost=co,bias=TRUE,cross=10,verbose=FALSE)
    
    end.time <- Sys.time()
    time.taken <- end.time-start.time
    
    cat("Results for C=",co," : ",acc," accuracy.\n",sep="")
    cat("Time taken for k-fold: ",capture.output(time.taken),"\n",sep="")
    if(acc>bestAcc){
      bestCost=co
      bestAcc=acc
    } }

  
  cat("Cost:",bestCost,"\n",file=output_file,sep="",append=TRUE)
  cat("Best cost is: ",bestCost,sep="\n")
  cat("Accuracy:",bestAcc,"\n",file=output_file,sep="",append=TRUE)
  cat("Best accuracy is: ",bestAcc,sep="\n")
  
  start.time <- Sys.time()
  # Re-train best model with best cost value.
  m=LiblineaR(data=xTrain,target=yTrain,type=number,cost=bestCost,bias=TRUE,verbose=FALSE)
  
  end.time <- Sys.time()
  time.taken <- end.time - start.time
}
