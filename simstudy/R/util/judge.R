judge <- function(x,p) {
  ifelse(runif(1) < p, x, NA)
}