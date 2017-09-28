impute <- function(df) {
  library(mice)
  complete(mice(df, printFlag = F))
}

judge <- function(x,p) {
  rns <- runif(length(x))
  ifelse(rns < p, x, NA)
}