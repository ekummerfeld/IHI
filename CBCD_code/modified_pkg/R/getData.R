getData = function(filename, e, sep, header){
  
  
  D = list()
  d = as.matrix(read.table(filename, sep = sep, header = header))
  D$n = ncol(d)
  cn = c()
  for(i in 1:D$n){
    cn = c(cn, paste("X",i, sep = ""))
  }  
  colnames(d) = cn
  D$data = d 
  D$Cx<-cov(D$data)
  D$e = e
  D$N = nrow(D$data)
  
  D
}