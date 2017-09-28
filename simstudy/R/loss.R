library("parallel")
ul <- function(df, p) {
  print(p)
  as.data.frame(
    mclapply(df, judge, p = p)
    )
}

atl <- function(df) {
  
  loss_fn <- function(x) {
    ifelse(x < -3, .90,
           ifelse(x < -2, .05*(x+2) +.95, 
                  ifelse(x < 2, .95,
                         ifelse(x <3, -.15*(x-2) +.95, 
                                ifelse(x >=3, .8, 1
                                )
                         )
                  )
           )
    )
  }
  
  mu <- apply(df, 2, mean)
  sd <- apply(df, 2, sd)
  
  ndf <- as.data.frame(t(apply(df, 1, function(x) { (x - mu)/sd})))
  
  mv_ndf <- apply(ndf, c(1, 2), function(x) {
    judge(x, p = loss_fn(x)) })
  
  as.data.frame(t(apply(mv_ndf, 1, function(x) { (x*sd + mu)} )))
}