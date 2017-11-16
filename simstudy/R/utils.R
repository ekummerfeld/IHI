impute <- function(df) {
  complete(mice(df, printFlag = F, m = 1))
}

judge <- function(x,p) {
  rns <- runif(length(x))
  ifelse(rns < p, x, NA)
}

