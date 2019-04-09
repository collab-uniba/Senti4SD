library(data.table)
library(LiblineaR)

#' Read Features
#'
#' Read feature file.
#'
#' @param filename CSV file containing features.
#' @return A data.table object with id column parsed as an integer.
ReadFeatures <- function(filename) {
  features <- fread(filename)
  features[, id := as.integer(sub("^t", "", id)) + 1]
  features
}

#' Features
#'
#' Call Senti4SD-fast.jar to compute features.
#'
#' @param input Input text file with a single column and no header.
#' @param output Output file containing computed features.
#' @param path Directory where the Senti4SD jar file and dsm.bin files
#'   are stored.
#' @param read.file If TRUE, read with data.table the content of
#'   output file.
#' @param use.temp.file If TRUE, output will be removed after feature
#'   computation. This also enforces read.file as TRUE.
#' @return The result of feature extraction if read.file is TRUE,
#'   stdout and stderr of the Java process as invisible object
#'   otherwise.
Features <- function(input, output, path=".", read.file=TRUE, use.temp.file=FALSE) {
  senti.jar <- file.path(path, "Senti4SD-fast.jar")
  dsm.bin <- file.path(path, "dsm.bin")
  args <- c("-jar", senti.jar, "-F", "A", "-i", input, "-W", dsm.bin,
            "-oc", output, "-vd", "600")
  res <- invisible(system2("java", args, stdout=TRUE, stderr=TRUE))
  if (read.file || use.temp.file) {
    res <- ReadFeatures(output)
    if (use.temp.file) {
      file.remove(output)
    }
  }
  res
}

#' Load Model
#'
#' Load LiblineaR model.
#'
#' @param model.filename Rda file where the model is stored.
#' @return the LiblineaR model.
LoadModel <- function(model.filename) {
  load(model.filename)
  m
}

#' Predict
#'
#' Predict polarity from a set of features.
#'
#' @param model The LiblineaR model object.
#' @param features The feature data.table object.
#' @return A factor with levels positive, negative and neutral.
Predict <- function(model, features) {
  features <- features[, names(features) != "id", with=FALSE]
  predict(model, features)$predictions
}

#' Senti4SD
#'
#' Runs Senti4SD on given pieces of text.
#'
#' @param text A character vector on which to run Senti4SD.
#' @param model The LiblineaR model to use for prediction.
#' @param senti4sd.path Path where Senti4SD jar file is located.
#' @return A data.table object with text, id and (predicted) polarity
#'   columns.
Senti4SD <- function(text, model, senti4sd.path) {
  text <- gsub("\n", " ", text)
  text.file <- tempfile()
  fwrite(data.table(text), text.file, row.names=FALSE, col.names=FALSE)
  features <- Features(text.file, tempfile(), senti4sd.path, TRUE, TRUE)
  features <- na.omit(features)
  prediction <- Predict(model, features)
  result <- cbind(features[, list(id)], polarity=prediction)
  result <- result[order(id)]
  result[, text := text[id]]
  file.remove(text.file)
  result
}

#' Senti4SD Chunked
#'
#' Runs Senti4SD on given pieces of text by splitting the input in
#' different chunks and running Senti4SD on each chunk.
#'
#' @param text A character vector on which to run Senti4SD.
#' @param model The LiblineaR model to use for prediction.
#' @param senti4sd.path Path where Senti4SD jar file is located.
#' @param chunk.size Maximum number of text element to consider for
#'   one single run of Senti4SD.
#' @param memory.limit Maximum amount of memory (in GB) to use for one
#'   run of Senti4SD. Overrides \code{chunk.size} by setting it to
#'   \code{500 * memory.limit}.
#' @return A data.table object with text, id and (predicted) polarity
#'   columns.
Senti4SDChunked <- function(text, model, senti4sd.path,
                            chunk.size=1000, memory.limit=0) {
  if (memory.limit > 0) {
    chunk.size <- 500 * memory.limit
  }
  chunks <- split(text, (1:length(text) - 1) %/% chunk.size)
  rbindlist(lapply(1:length(chunks), function(i) {
    chunk <- chunks[[i]]
    logging::loginfo("Running Senti4SD on chunk %d of size %d",
                     i, length(chunk))
    t <- system.time(res <- Senti4SD(chunk, model, senti4sd.path))
    logging::loginfo("Senti4SD run on chunk %d in %.2f seconds",
                     i, t["elapsed"])
    res
  }))
}
