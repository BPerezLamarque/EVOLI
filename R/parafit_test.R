parafit_test <-
function (dist_A, dist_B, network, nperm = 1000,
                          seed = NULL, correction = "none",
                          nullmodel="shuffle", table_biogeo=NULL) {
  epsilon <- sqrt(.Machine$double.eps)
  
  if (is.null(seed)) {
    runif(1)
    seed <- .Random.seed[trunc(runif(1, 1, 626))]
  }
  
  if (!nullmodel %in% c(1,2,3,"r0","shuffle","biogeo")) {
    stop("Pick a null model among \"1\" (\"r0\") or \"2\" (\"shuffle\") or \"3\" (\"biogeo\").")
  }
  
  HP <- t(as.matrix(network))
  host.D <- dist_A
  para.D <- dist_B
  # now tree_A on rows and tree_B on columns
  
  if (nullmodel %in% c(3,"biogeo")) { 
    if (!all(rownames(host.D) %in% table_biogeo$species)){
      stop("Provide a table_biogeo with all the species from tree_A.")
    }
    table_biogeo <- table_biogeo[match(rownames(host.D), table_biogeo$species), ]
  }
  
  
  
  host.D <- as.matrix(host.D)
  host.pc <- pcoa_test(host.D, correction = correction)
  if (host.pc$correction[2] == 1) {
    if (min(host.pc$values[, 2]) < -epsilon) 
      stop("Tree A matrix has negative eigenvalues. Rerun with correction=\"lingoes\" or correction=\"cailliez\"")
    sum.host.values.sq <- sum(host.pc$values[, 1]^2)
    host.vectors <- host.pc$vectors
  } else {
    sum.host.values.sq <- sum(host.pc$values[, 2]^2)
    host.vectors <- host.pc$vectors.cor
  }
  if (!nullmodel %in% c(1,2,3,"r0","shuffle","biogeo")) {
    stop("Pick a null model among \"1\" (\"r0\") or \"2\" (\"shuffle\") or \"3\" (\"biogeo\").")
  }
  n.host <- nrow(host.D)
  para.D <- as.matrix(para.D)
  para.pc <- pcoa_test(para.D, correction = correction)
  if (para.pc$correction[2] == 1) {
    if (min(para.pc$values[, 2]) < -epsilon) 
      stop("Tree B matrix has negative eigenvalues. Rerun with correction=\"lingoes\" or correction=\"cailliez\"")
    sum.para.values.sq <- sum(para.pc$values[, 1]^2)
    para.vectors <- para.pc$vectors
  }else {
    sum.para.values.sq <- sum(para.pc$values[, 2]^2)
    para.vectors <- para.pc$vectors.cor
  }
  n.para <- nrow(para.D)

  tracemax <- max(sum.host.values.sq, sum.para.values.sq)
  if (n.host == n.para) {
      cat("The function cannot check if matrix network has been entered in the right way.", 
          "\n")
      cat("It will assume that the rows of network correspond to the clade B.", 
          "\n")
  }else {
    temp <- dim(HP)
    if (temp[1] == n.host) {
      if (temp[2] != n.para) 
        stop("Matrices dist_A, dist_B and network not comformable")
    }else if (temp[2] == n.host) {
      if (temp[1] != n.para) 
        stop("Matrices dist_A, dist_B and network not comformable")
      !
          cat("Matrix network has been transposed for comformity with dist_A and dist_B.", 
              "\n")
    }else {
      stop("Matrices dist_A, dist_B and network not comformable")
    }
  }
  p.per.h <- apply(HP, 1, sum)
  h.per.p <- apply(HP, 2, sum)
  mat.4 <- t(host.vectors) %*% HP %*% para.vectors
  global <- sum(mat.4^2)
  if (nperm > 0) {
    set.seed(seed)
    nGT <- 1
    global.perm <- NA
    for (i in 1:nperm) {
      
      if (nullmodel %in% c(1,"r0")) {
        HP.perm <- apply(HP, 2, sample)
      }
      if (nullmodel %in% c(2,"shuffle")) {
        HP.perm <- HP[sample(1:nrow(HP)),]
      }
      if (nullmodel %in% c(3,"biogeo")){ # Takes into account biogeography
        HP.perm <- HP
        for (zone in unique(table_biogeo$biogeo)){
          w <- which(table_biogeo$biogeo==zone)
          s <- as.numeric(sample(as.character(w))) 
          HP.perm[w,] <- as.matrix(HP.perm[s,])
        }
        rownames(HP.perm) = rownames(HP)
      }
      
      mat.4.perm <- t(host.vectors) %*% HP.perm %*% para.vectors
      global.perm <- c(global.perm, sum(mat.4.perm^2))
      if (global.perm[i + 1] >= global) 
        nGT <- nGT + 1
    }
    global.perm <- global.perm[-1] # under H0 
    p.global <- nGT/(nperm) # nGT/(nperm + 1)
  }else {
    p.global <- NA
  }
  
  out <- list(ParaFitGlobal = global, 
              p = p.global, 
              ParaFitGlobal_perm=global.perm,
              nperm = nperm,
              nullmodel = nullmodel)
  return(out)
}
