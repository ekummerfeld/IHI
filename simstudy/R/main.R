# load the other functions
source("R/utils.R")
source("R/loss.R")
# R library that does imputation
library("profvis")
library("data.table")
# library to handle command line arguments
library("getopt")


# set up the args one can pass through via `Rscript`
spec <- matrix(c(
  "dir", "d", 1, "character",
  "na_handling_method", "n", 1, "character",
  "loss_method", "l", 1, "character",
  "prob", "p", 1, "double"), byrow = T, ncol = 4)
# get the args
args <- getopt(spec)


dir <- paste("generate/", args$dir, sep = "")

if(!(dir %in% list.dirs("generate", recursive = F))) {
  write(dir, stderr())
  write(" directory not found",
        stderr()
  )
  quit(status = 1)
}

# parse input to make sure its legit
na_methods <- c("omit", "impute")
na_method <- match.arg(args$na_handling_method, na_methods)

loss_methods <- c("ul", "atl", "lv")
loss_method <- match.arg(args$loss_method, loss_methods)

prob <- args$prob

if (is.null( prob) && ( loss_method == "ul" || loss_method == "lv")) {
  write("If you wish to use uniform loss, you must specifiy the probability",
    stderr()
  )
  quit(status = 1)
}

# set loss_func to the function as given by loss_method
loss_func <- function(df, loss_method, p = prob)  {
  switch(loss_method, lv = lv(df, p), ul = ul(df, p), atl = atl(df))
}

# path to tetrad saves
save <- "save/1/data/"

path <- paste(dir, "/", save, sep = "")
# create the relevant directories to store the files, depending on the value of na_handle

ROUT <- paste("./rout/", args$dir,"/", save, sep = "")
prof <- profvis({
# loops over all the files in path
for (file_name in list.files(path = path) ) {
  df <- fread(paste(path, file_name, sep = ""), sep = "\t")
  
  # generate missing data
  df_mv <- loss_func(df, loss_method)
  # write the imputed/omited datafiles to impute/ or omit/

# write file to path
  if (na_method == "impute") {
    fwrite(impute(df_mv), file = paste(ROUT, file_name, sep = ""),
      sep = "\t", quote = F, row.names = F
    )
  }

  if (na_method == "omit") {
    omit_df <- na.omit(df_mv)
    fwrite(omit_df, file = paste(ROUT, file_name, sep = ""),
      sep = "\t", quote = F, row.names = F
    )
  }
}
})
save(prof, file = paste("./rout/", args$dir, "/", "prof", sep = ""))
