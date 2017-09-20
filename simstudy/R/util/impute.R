impute <- function(df) {
  library(mice)
  complete(mice(df, printFlag = F))
}