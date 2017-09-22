# load the other functions
source("R/utils.R")
source("R/loss.R")

spec <- matrix(c(
  'na_handling_method', 'n', 1, 'character',
  'loss_method', 'l', 1, 'character',
  'prob', 'p', 1, 'double'), byrow = T, ncol = 4)

library("getopt")
args <- getopt(spec)


path <- "./save/1/data/"
tmp <- "R/tmp/"

if(!dir.exists(tmp))
  dir.create(tmp)


FUN <- function(x) {x}

if(!is.null(args$loss_method)) {
  if(args$loss_method == "ul")
    FUN <- ul
  else if(args$loss_method == "atl")
    FUN <- atl
  else {
    print(paste("Unrecognized loss function", args$loss_method))
    quit(status = 1)
  }
} else {
  print("No loss function given; you must pass one in via -l (function)")
  quit(status = 1)
}

if(!is.null(args$prob)) {
prob <- args$prob
} else if (args$loss_method == "ul") {
  print("If you want to use uniform loss, you must pass in the \
  probability by using -prob or -p.")
  quit(status = 1)
}


# do you want to impute, omit, or both?
na_handling_method <- "both"


# if FUN == ul, set p = prob so it can be called correctly in the loop
if(identical(FUN, ul)) {
  formals(FUN) <- alist(df = , p = prob)
}

# loops over all the files in path
for(file_name in list.files(path = path) ) {
  df <- read.csv(paste(path,"/", file_name, sep = ""), sep = "\t")
  # create MVs using FUN
  df_mv <- FUN(df)

  if(na_handling_method == "both") {
    system(paste("rm ", path, file_name, sep= ""))
    write.table(df_mv, file = paste(tmp, "na.", file_name, sep = ""), sep = "\t", quote = F, row.names = F)

  }

  # write file to path
  if(na_handling_method == "impute") {
    imputed_df <- impute(df_mv)
    write.table(imputed_df, file = paste(path, file_name, sep = ""), sep = "\t", quote = F, row.names = F)

  }
  if(na_handling_method == "omit") {
    omit_df <- na.omit(df_mv)
    write.table(omit_df, file = paste(path , file_name, sep = ""), sep = "\t", quote = F, row.names = F)
  }
}
