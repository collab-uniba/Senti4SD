## Classification over an input dataset using an input liblinear model
## (or default SO model if not present)

logging::basicConfig()

ScriptPath <- function() {
  initial.options <- commandArgs(trailingOnly=FALSE)
  file.arg.name <- "--file="
  script.name <- sub(file.arg.name, "", initial.options[grep(file.arg.name,
                                                             initial.options)])
  if (length(script.name)) {
    dirname(script.name)
  } else {
    "."
  }
}

ParseArgs <- function(script.path) {
  ## enable commandline arguments from script launched using Rscript
  args <- as.list(commandArgs(TRUE))
  if (length(args) < 1) {
    stop("At least one argument must be supplied.", call.=FALSE)
  }
  if (length(args) < 5) {
    args[[5]] <- FALSE
  }

  if (is.null(args[[2]])) {
    args[[2]] <- "predictions.csv"
  }
  if (is.null(args[[3]])) {
    args[[3]] <- tempfile()
    args[[5]] <- TRUE
    message(sprintf("No feature file provided, using temporary file %s.",
                    args[[3]]))
  } else {
    args[[5]] <- as.logical(args[[5]])
    if (length(args[[5]]) == 0 | is.na(args[[5]])) {
      stop("Supplied boolean for temporary file is incorrectly formatted")
    }
  }
  if (is.null(args[[4]])) {
    message("No LiblinearModel supplied. Default StackOverflow model will be used.")
    args[[4]] <- file.path(script.path, "modelLiblinear.Rda")
  }

  list(input.file=args[[1]],
       output.file=args[[2]],
       feature.file=args[[3]],
       use.temp.file=args[[5]],
       model.file=args[[4]])
}

script.path <- ScriptPath()
args <- ParseArgs(script.path)
attach(args)

source(file.path(script.path, "classification_functions.R"))

model <- LoadModel(model.file)

features <- Features(input.file, feature.file, script.path, TRUE, use.temp.file)
## if any, exclude rows with Na, NaN and Inf (missing values)
features <- na.omit(features)

prediction <- Predict(model, features)

result <- cbind(features[, list(id)], polarity=prediction)
result <- result[order(id)]

text <- read.csv2(input.file, header=FALSE, col.names="text")$text
result[, text := text[id]]

fwrite(result, output.file)
message(sprintf("%s was successfully created.", output.file))
