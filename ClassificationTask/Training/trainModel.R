#Train liblinear model 

# enable commandline arguments from script launched using Rscript
args<-commandArgs(TRUE)

# creates current output directory for current execution
output_dir <- args[1]
if(!dir.exists(output_dir))
  dir.create(output_dir, showWarnings = FALSE, recursive = TRUE, mode = "0777")

# Params
config_file <- args[2]
csv_file <- args[3]
# logs errors to file
error_file <- paste(output_dir, "log", sep = ".")
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
temp <- dataset
# name of outcome var to be predicted
outcomeName <- "label"
# list of predictor vars by name
excluded_predictors <- c("id")
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
testingTemp <- temp[-splitIndex, ]

# load the configuration file to tune
configuration <- readLines(config_file)

if(length(configuration)>0){
  
classifier <- strsplit(configuration[3],":")[[1]][2]
classifierName <- strsplit(configuration[2],":")[[1]][2]
number <- as.integer(classifier)
C <- strsplit(configuration[4],":")[[1]][2]
C <- as.double(gsub(" ", "", C))

}else{
cat(paste("WARNING! Configuration file is empty. Default values will be used.\n"))
  
classifierName <- "L2-regularized_logistic_regression_(primal)"
number <- 0
C <- 1
}
cat(paste("Classifier",classifierName,"with cost",C,"\n",sep=" "))

# Train model with cost value.
cat(paste("Training...\n"))
m=LiblineaR(data=xTrain,target=yTrain,type=number,cost=C,bias=TRUE,verbose=FALSE)

output_model_name <- paste(paste("modelLiblinear",classifierName,sep="_"), "Rda", sep=".")
output_model <- paste(output_dir, output_model_name, sep="/")
save(m, file=output_model)
cat(paste("Successfully saved LibLinear model to", output_model,"\n", sep=" "))

