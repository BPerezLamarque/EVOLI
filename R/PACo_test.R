PACo_test <-
function (dist_A, dist_B, network, nperm = 1000, seed = NA, symmetric = TRUE, nullmodel = 2, table_biogeo = NULL) {
  
  D <- prepare_paco_data_test(dist_A, dist_B, network)
  
  if (!nullmodel %in% c(1,2,3,"r0","shuffle","biogeo")) {
    stop("Pick a null model among \"1\" (\"r0\") or \"2\" (\"shuffle\") or \"3\" (\"biogeo\").")
  }
  if (!("H_PCo" %in% names(D))) {
    D <- add_pcoord_test(D)
  }
  
  suppressWarnings(
    proc <- vegan::procrustes(X = D$H_PCo, Y = D$P_PCo, symmetric = symmetric)
  )
  m2ss <- proc$ss   
  if (!is.na(seed)) set.seed(seed)
  
  
  if (nullmodel %in% c(3,"biogeo")) { 
    if (!all(rownames(D$HP) %in% table_biogeo$species)){
      stop("Provide a table_biogeo with all the species from tree_A.")
    }
    table_biogeo <- table_biogeo[match(rownames(D$HP), table_biogeo$species), ]
  }
  
  ss_perm <- numeric(nperm)
  if (nullmodel %in% c(1,"r0")) {
    null_model <- vegan::nullmodel(D$HP, "r0")
    randomised_matrices <- stats::simulate(null_model, nsim = nperm)
  }
  
  for (n in 1:nperm) {
    
    if (nullmodel %in% c(1,"r0")) {
      permuted_HP <- randomised_matrices[, , n]
      permuted_HP <- permuted_HP[rownames(D$HP), colnames(D$HP)]
    }
    
    if (nullmodel %in% c(2,"shuffle")) { # null model 2 : random permutations of rows
      permuted_HP <- D$HP[sample(1:nrow(D$HP)), ]
      rownames(permuted_HP) <- rownames(D$HP)
    }
    
    if (nullmodel %in% c(3,"biogeo")) { # null model 3 : permutations constraining the biogeography
      permuted_HP <- D$HP
      for (zone in unique(table_biogeo$biogeo)) {
        w <- which(table_biogeo$biogeo==zone)
        s <- as.numeric(sample(as.character(w))) 
        permuted_HP[w,] <- as.matrix(permuted_HP[s,])
      }
      rownames(permuted_HP) <- rownames(D$HP)
    }
    
    perm_D <- list(H = D$H, P = D$P, HP = permuted_HP)
    perm_paco <- add_pcoord_test(perm_D)
    
    suppressWarnings(
      perm_proc <- vegan::procrustes(X = perm_paco$H_PCo, Y = perm_paco$P_PCo, symmetric = symmetric)
    )
    
    ss_perm[n] <- perm_proc$ss
  }
  ss_perm <- ss_perm[!is.na(ss_perm)]
  
  R2_obs <- 1 - m2ss
  R2_perm <- 1 - ss_perm
  
  pvalue <- mean(R2_perm >= R2_obs)
  
  out <- c()
  out$proc <- proc
  out$R2_obs <- R2_obs
  out$p <- pvalue
  out$R2_perm <- R2_perm
  out$ss <- m2ss
  out$nperm <- nperm
  out$nullmodel <- nullmodel
  return(out)
}
