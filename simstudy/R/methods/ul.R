ul <- function(df, p) {
  as.data.frame(apply(df, c( 1, 2), judge, p = p))
}