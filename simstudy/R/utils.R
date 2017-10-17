impute <- function(df) {
  library(mice)
  complete(mice(df, printFlag = F, m = 1))
}

judge <- function(x,p) {
  rns <- runif(length(x))
  ifelse(rns < p, x, NA)
}
