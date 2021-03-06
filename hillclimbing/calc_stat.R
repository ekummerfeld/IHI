
library(readr)
library(bnlearn)
library(parallel)

setwd("~/work/IHI/hillclimbing/")

source("cgraph.R")
source("bnlearntotetrad.R")


dir <- "../sim_framework/generate/ss100nv25/save/1/data/"
files <- list.files(dir)
print(files)
file.create("hc.log")
times <-mcMap(files, mc.cores = 8, f = function(file) {
  # read in dataset
  suppressMessages(
    data <- read_delim(paste(dir, file, sep = ""), "\t", escape_double = FALSE, trim_ws = TRUE)
  )
  # run  boostrapped hc
  # time <- unname(system.time(
  # bs <- boot.strength(data, R = 100, algorithm = "hc", algorithm.args = list(restart = 5, perturb = 10), debug = TRUE)
  # )[1])
  # agg_hc <- averaged.network(bs[bs$strength > .85 & bs$direction > .5,])
  time <- unname(system.time(
  hc <- hc(data, restart = 5, perturb = 10)
  )[1])
  # export learned bn graph to tetrad compatible format
  output_file <- paste("hc_graphs/", sub("data", "graph", file), sep = "")
  # export_bnlearn_object_to_tetrad(output_file, agg_hc)
  
  cat(sprintf("Hillclimbing on datset %s Complete", file), "hc.log")
  export_bnlearn_object_to_tetrad(output_file, hc)
  return(time)
})
dir <- "../sim_framework/generate/ss100nv25/save/1/graph/"

files <- list.files(dir)
# fancy for loop that can be easily parallized by using mclapply instead
df <- mclapply(files, mc.cores = 8, function(file) {

# load true graph and hc graph from file
true_graph <- import_from_tetrad_file(paste(dir, file, sep = ""))
hc_graph <- import_from_tetrad_file(paste("hc_graphs/", file, sep = ""))
# get the number of the graph and store it in the variable GID
GID <- as.integer(strsplit(file, ".", fixed = T)[[1]][2])

AP <- adjacency_precision(true_graph, hc_graph)
AR <- adjacency_recall(true_graph, hc_graph)
AHP <- arrowhead_precision(true_graph, hc_graph)
AHR <- arrowhead_recall(true_graph, hc_graph)

c(GID, AP, AR, AHP, AHR)
})
# convert output from lapply to a data frame
df <- data.frame(matrix(unlist(df), ncol = 5, byrow =T))
names(df) <- c("GID","AP", "AR", "AHP", "AHR")

# plot distributions

c(colMeans(df[,-1]), mean(unlist(times)))
