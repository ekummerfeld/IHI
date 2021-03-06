
# super alpha version of a data structure that can be used to hold a general graph. 
# TBD if I want to extend this class instead of having a 'type' field
# also, names is probably unnecessary
cgraph <- function(type = character(), names = c(character()), skeleton = matrix(), edges = list(c())) {
  return(
  structure(list(type = type , names = names, skeleton = skeleton, edges = edges), class = "cgraph")
  )
}

bn_learn_to_cgraph <- function(bn_graph) {
  # converts a learned graph of bn-class to a grpah of cgraph-class
  if (!(class(bn_graph) == "bn")) stop("Input is not of class bn!")
  
  names <- names(bn_graph$nodes)
  # get the skeleton
  skeleton <- lapply(nm, function(x) {
    bn_graph$nodes[[x]]$nbr
    }
  )
  names(skeleton) <- names
  # get the edges
  edges <- cbind(unname(bn_graph$arcs), "-->")
  return(cgraph("G", names, skeleton, edges))
}


import_from_tetrad_file <- function(file) {
  # this function imports a tetrad graph 
  # parse the tetrad file as a list of character vectors
  tmp_file <- read_lines(file)
  # get the names of the nodes from 
  nodes <- strsplit(tmp_file[2], ",")[[1]]
  # strip out first 4 lines and last line
  tmp_file <- tmp_file[5:( length(tmp_file) - 1)]
  # remove the number of the edge 
  tmp_file <- sub("[0-9]+.", "", tmp_file)
  # prep the lines so the edge matrix can be filled in easily
  tmp_file <- strsplit(trimws(tmp_file), " ")
  # get the number of edges
  n_edges <- length(tmp_file)
  # instantiant edge matrix
  edges <- matrix(nrow = n_edges, ncol = 3) 
  # fill it in!
  for (i in 1:n_edges) {
    edges[i, 1] <- tmp_file[[i]][1]
    edges[i, 2] <- tmp_file[[i]][3]
    edges[i, 3] <- tmp_file[[i]][2]
  }
  # get the skeleton from the edge representation
  # loop over the nodes
  skeleton <- lapply(nodes, function(node) {
    neighborhood <- c()
    # loop over the edges
    for (i in 1:n_edges) {
      # if a node is in an edge, find its partner (neighbor)
      if( node %in% edges[i, 1:2]) {
        neighbor <- edges[i, c(node != edges[i,1:2], F)]
          if (!(neighbor %in% neighborhood))
            neighborhood <- c(neighborhood, neighbor)
      }
    }
    return(neighborhood)
  }
  )
  names(skeleton) <- nodes
  return(cgraph("G", nodes, skeleton, edges))
}

adjacency_precision <- function(true_graph, est_graph) {
  # if (class(true_graph) != "cgraph" || class(est_graph) != "cgraph")
  #   stop("at least of the graphs are not the correct type!")
  # if (!setequal(true_graph$names,est_graph$names))
  #   stop ("the nodes do not match!")
  # get the number of predicted adjacencies
  n_pred_adjs <- sum(lengths(est_graph$skeleton)) 
  n_correct <- 0
  # for each node, calculate the intersection true graph neighborhood and the estimated graph neighborhood
  # the cardinality is the number correctly predicted for that node
  for (node in names(true_graph$skeleton)) {
    n_correct <- n_correct + length(intersect(true_graph$skeleton[[node]], est_graph$skeleton[[node]]))
  } 
  return(n_correct/n_pred_adjs)
}

adjacency_recall <- function(true_graph, est_graph) {
  # if (class(true_graph) != "cgraph" || class(est_graph) != "cgraph")
  #   stop("at least of the graphs are not the correct type!")
  # if (!setequal(true_graph$names,est_graph$names))
  #   stop ("the nodes do not match!")
  n_true_adjs <- sum(lengths(true_graph$skeleton)) 
  n_correct <- 0
  # for each node, calculate the intersection true graph neighborhood and the estimated graph neighborhood
  # the cardinality is the number correctly predicted for that node
  for (node in names(true_graph$skeleton)) {
    n_correct <- n_correct + length(intersect(true_graph$skeleton[[node]], est_graph$skeleton[[node]]))
  }
  return(n_correct/n_true_adjs)
}

# helper function to determine wether or not a row is in a matrix
is_row_in_matrix <- function(matrix, row) {
  any(
    apply(matrix, 1, function(x) isTRUE(all.equal(x, row))
    )
  )
}

arrowhead_precision <- function(true_graph, est_graph) {
  # if (class(true_graph) != "cgraph" || class(est_graph) != "cgraph")
  #   stop("at least of the graphs are not the correct type!")
  # if (!setequal(true_graph$names,est_graph$names))
  #   stop ("names of the nodes do not match!")
  n_pred_arrows <- length(est_graph$edges[,1])
  # TODO(arix) comment this later
  n_correct <- sum(apply(true_graph$edges, 1, function(edge_in_tg) {
    ifelse(is_row_in_matrix(est_graph$edges, edge_in_tg), 1, 0)
  }))
  n_correct/n_pred_arrows
}

arrowhead_recall <- function(true_graph, est_graph) {
  # if (class(true_graph) != "cgraph" || class(est_graph) != "cgraph")
  #   stop("at least of the graphs are not the correct type!")
  # if (!setequal(true_graph$names,est_graph$names))
  #   stop ("names of the nodes do not match!")
  n_true_arrows <- length(true_graph$edges[,1])
  # TODO(arix) comment this later
  n_correct <- sum(apply(true_graph$edges, 1, function(edge_in_tg) {
    ifelse(is_row_in_matrix(est_graph$edges, edge_in_tg), 1, 0)
  }))
  n_correct/n_true_arrows
}

 
