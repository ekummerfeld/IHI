
run <- function(file, schedule, p) {
  runData("../../../kcd/data/kcd.csv", e = rep(0,10), encode = "new_wmaxsat.pl", test = "BIC", p = p, schedule = schedule, sep = "," ,header = T)
  foo <-parse_solution(encode="new_wmaxsat.pl", sol_file = "../tmp/pipeline.ind.clingo")
  nm <- c("sum_DTC","sum_AUD","sum_MDD","sum_DYS","sum_GAD","sum_SOC","sum_PAN","sum_PTSD")
  write("Graph Nodes:", file=file, append = F)
  cat(nm, file=file, append = T, sep = ",")
  write("\n", file=file, append = T)
  write("Graph Edges:", file=file, append = T)
  e=1
  for(i in 1:8) {
    for(j in 1:8) {
      if (foo$G[i,j]) {
        write(sprintf("%i. %s --> %s", e, nm[j], nm[i]), file=file, append = T)
        e=e+1
      }
    }
  }
  for(i in 1:8) {
    for(j in 1:8) {
      if (foo$Ge[i,j]) {
        foo$Ge[j,i] = 0
        write(sprintf("%i. %s o-o %s", e, nm[j], nm[i]), file=file, append = T)
        e=e+1
      }
    }
  }


}
