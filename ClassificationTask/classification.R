#Classification over an input dataset using an input liblinear model (or default SO model if not present)

initial.options <- commandArgs(trailingOnly = FALSE)
file.arg.name <- "--file="
script.name <- sub(file.arg.name, "", initial.options[grep(file.arg.name, initial.options)])
script.basename <- dirname(script.name)
path <- paste(getwd(),script.basename,sep="/")

# enable commandline arguments from script launched using Rscript
args<-commandArgs(TRUE)

# test if there is at least one argument: if not, return an error
if (length(args)<2) {
  stop("At least two argument must be supplied.\n", call.=FALSE)
} else if (length(args)==2) {
  cat("No LiblinearModel supplied. Default StackOverflow model will be used.\n")
  # default model file
  args[3] = paste(path,"modelLiblinear.Rda",sep="/")
}

# Params
csv_file <- args[1]
output_file <- args[2]

# library setup, depedencies are handled by R
library(caret) # for param tuning
library(e1071) # for normality adjustment
library(LiblineaR)

# comma delimiter
dataset <- read.csv(csv_file, header = TRUE, sep=",")

# list of predictor vars by name
excluded_predictors <- c("id")
temp <- dataset
dataset <- dataset[ , !(names(dataset) %in% excluded_predictors)]

# if any, exclude rows with Na, NaN and Inf (missing values)
dataset <- na.omit(dataset)

load(file = args[3])

p <- predict(m,dataset)
pred = p$predictions


predictions <- c()
for (i in 0:length(temp[,"id"])){
  predictions <- c(predictions, paste(temp[i,"id"],pred[i], sep=","))
}
# save errors to text file
cat("Row,Predicted\n",file= output_file)
write.table(predictions, file= output_file, quote = FALSE, row.names = FALSE, col.names = FALSE, append=TRUE)

cat(paste(output_file, "was successfully created\n", sep=" "))
