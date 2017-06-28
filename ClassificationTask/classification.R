# enable commandline arguments from script launched using Rscript
args<-commandArgs(TRUE)

# Params
csv_file <- args[1]
output_file <- args[2]

# library setup, depedencies are handled by R
library(caret) # for param tuning
library(e1071) # for normality adjustment
library(LiblineaR)

# comma delimiter
SO <- read.csv(csv_file, header = TRUE, sep=",")

# list of predictor vars by name
excluded_predictors <- c("id")
temp <- SO
SO <- SO[ , !(names(SO) %in% excluded_predictors)]

# if any, exclude rows with Na, NaN and Inf (missing values)
SO <- na.omit(SO)

load(file = "./modelLiblinear.Rda")

p <- predict(m,SO)
pred = p$predictions


predictions <- c()
  for (i in 0:length(temp[,"id"])){
    predictions <- c(predictions, paste(temp[i,"id"],pred[i], sep=","))
  }
  # save errors to text file
  cat("Row,Predicted\n",file= output_file)
  write.table(predictions, file= output_file, quote = FALSE, row.names = FALSE, col.names = FALSE, append=TRUE)

cat(paste(output_file, "was successfully created\n", sep=" "))
