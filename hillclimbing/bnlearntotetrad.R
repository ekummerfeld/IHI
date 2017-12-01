export_bnlearn_object_to_tetrad <- function(file, model) {
  # This function exports an object of bn-class in a TETRAD compatible form
  write("Graph Nodes:", file = file, append = F)
  cat(names(model$nodes), file = file, append = T, sep = ",")
  write('\n', file = file, append = T)
  write("Graph Edges:", file = file, append = T)

  n <- 1
  for (i in 1:length(model$nodes)) {
    node <- names(model$nodes)[i]
    for (child in model$nodes[[i]]$children) {
      write(sprintf("%i. %s --> %s", n, node, child), file = file, append = T)
      n <- n + 1
    }
  }
  cat('\n', file = file, append = T)
}