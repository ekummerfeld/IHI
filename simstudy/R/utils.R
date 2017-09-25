impute <- function(df) {
  library(mice)
  complete(mice(df, printFlag = T))
}

judge <- function(x,p) {
  ifelse(runif(1) < p, x, NA)
}