# load the other functions
source("R/utils.R")
source("R/loss.R")

# library to handle command line arguments
library("getopt")
# faster I/O
library("data.table")
# libraries for parallel computing
library("foreach")
library("doMC")

# set up the args one can pass through via `Rscript`
spec <- matrix(c(
  "dir", "d", 1, "character",
  "na_handling_method", "n", 1, "character",
  "loss_method", "l", 1, "character",
  "prob", "p", 1, "double"), byrow = T, ncol = 4)
# get the args
args <- getopt(spec)


dir <- paste("generate/", args$dir, sep = "")

if (!(dir %in% list.dirs("generate", recursive = F))) {
  write(dir, stderr())
  write(" directory not found",
        stderr()
  )
  quit(status = 1)
}

# parse input to make sure its legit
na_methods <- c("omit", "impute", "both")
na_method <- match.arg(args$na_handling_method, na_methods)

loss_methods <- c("ul", "atl", "lv")
loss_method <- match.arg(args$loss_method, loss_methods)

prob <- args$prob

if (is.null( prob) && (loss_method == "lv")) {
  write("If you wish to use large value loss, you must specifiy the probability",
    stderr()
  )
  quit(status = 1)
}

# set loss_func to the function as given by loss_method
loss_func <- function(df, loss_method, p)  {
  switch(loss_method, lv = lv(df, p), ul = ul(df, p), atl = atl(df))
}

# path to tetrad saves
save <- "save/1/data/"

path <- paste(dir, "/", save, sep = "")
# create the relevant directories to store the files, depending on the value of na_handle

OMIT <- paste("./omit/", args$dir, "/", save, sep = "")
IMPUTE <- paste("./impute/", args$dir, "/", save, sep = "")



registerDoMC(4)
invisible(
  foreach(file_name = list.files(path = path), .packages = "mice") %dopar% {
  # Read in files (in parallel)
    df <- fread(paste(path, file_name, sep = ""), sep = "\t")

    write(paste("Core", Sys.getpid(), "is making a mess of", file_name), stdout())
    # generate missing data
   if (loss_method == "ul") {
     prob <- 1 - 1 / length(df)
   }
#   prob <- args$prob
    # create missing values using the loss method set by bash
    df_mv <- loss_func(df, loss_method, prob)

    if (na_method == "impute" || na_method == "both") {
      write(paste("Core", Sys.getpid(), "is imputing", file_name), stdout())
      fwrite(impute(df_mv), file = paste(IMPUTE, file_name, sep = ""),
      sep = "\t", quote = F, row.names = F, na = NA)
    }
    if (na_method == "omit" || na_method == "both") {
            write(paste("Core", Sys.getpid(), "is dropping NAs in", file_name), stdout())
      fwrite(na.omit(df_mv), file = paste(OMIT, file_name, sep = ""),
             sep = "\t", quote = F, row.names = F
      )
    }
})
