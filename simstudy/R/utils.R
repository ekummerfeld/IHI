impute <- function(df) {
  library(mice)
  complete(mice(df, printFlag = F))
}

judge <- function(x,p) {
  ifelse(runif(1) < p, x, NA)
}