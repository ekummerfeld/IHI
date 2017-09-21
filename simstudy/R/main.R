# load the other functions
source("R/utils.R")
source("R/loss.R")

# these varaibles all need to be delcared before the code runs
# where the datasets from tetrad are
path <- "./save/1/data/"

# needs to be set to ul or atl
FUN <- ul
#  only needs for ul
prob <- .97
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
  # write file to path
  if(na_handling_method == "both" || na_handling_method == "impute") {
    imputed_df <- impute(df_mv)
    write.table(imputed_df, file = paste(path, file_name, sep = ""), sep = "\t", quote = F, row.names = F)
  }
  if(na_handling_method == "both" || na_handling_method == "omit") {
    omit_df <- na.omit(df_mv)
    write.table(omit_df, file = paste(path , file_name, sep = ""), sep = "\t", quote = F, row.names = F)
  }
}
