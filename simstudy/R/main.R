# load the other functions
setwd("R")
source("load.R")

# these varaibles all need to be delcared before the code runs
# where the datasets from tetrad are
input_path <- "../save/1/data/"
# the partial directory you want them to save; look at the write.table calls
output_path <- "../ul/"
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
# loops over all the files in input_path
for(file_name in list.files(path = input_path) ) {
  df <- read.csv(paste(input_path,"/", file_name, sep = ""), sep = "\t")
  # create MVs using FUN
  df_mv <- FUN(df)
  # write file to output_path + "impute/save/1/data" + file_name (or omit/save ...)
  if(na_handling_method == "both" || na_handling_method == "impute") {
    imputed_df <- impute(df_mv)
    write.table(imputed_df, file = paste(output_path, "impute/save/1/data/", file_name, sep = ""), sep = "\t", quote = F, row.names = F)
  }
  if(na_handling_method == "both" || na_handling_method == "omit") {
    omit_df <- na.omit(df_mv)
    write.table(omit_df, file = paste(output_path, "omit/save/1/data/" , file_name, sep = ""), sep = "\t", quote = F, row.names = F)
  }
}
