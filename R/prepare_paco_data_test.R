prepare_paco_data_test <-
function (dist_A, dist_B, network) {
  
  HP <- t(as.matrix(network))
  H <- dist_A
  P <- dist_B
  # now tree_A on rows and tree_B on columns
  
  if (NROW(H) != NCOL(H)) 
    stop("dist_A should be a square matrix")
  if (NROW(P) != NCOL(P)) 
    stop("dist_B should be a square matrix")
  if (NROW(H) != NROW(HP)) {
    warning("The network matrix should have clade_A in columns. It has been translated.")
    HP <- t(HP)
  }
  if (!(NROW(H) %in% dim(HP))) 
    stop("The number of species in dist_A and network don't match")
  if (!(NROW(P) %in% dim(HP))) 
    stop("The number of species in dist_B and network don't match")
  if (!all(rownames(HP) %in% rownames(H))) 
    stop("The species names dist_A and network don't match")
  if (!all(colnames(HP) %in% rownames(P))) 
    stop("The species names dist_B and network don't match")
  H <- H[rownames(HP), rownames(HP)]
  P <- P[colnames(HP), colnames(HP)]
  HP[HP > 0] <- 1
  D <- list(H = H, P = P, HP = HP)
  class(D) <- "paco"
  return(D)
}
