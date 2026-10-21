phylosignal_network <-
function(network, tree_A, tree_B=NULL, method = "Jaccard_weighted", nperm = 10000, correlation = "Pearson", only_A = FALSE, 
                                permutation = "shuffle", table_biogeo=NULL){
  
  
  if (is.null(tree_B)) {only_A <- TRUE} 
  
  if (!inherits(tree_A, "phylo")) {stop("object \"tree_A\" is not of class \"phylo\".")}
  if (!is.null(tree_B)) {if (!inherits(tree_B, "phylo")) {stop("object \"tree_B\" is not of class \"phylo\".")}}
  
  if (is.null(method)) {stop("Please provide a \"method\" to compute phylogenetic signals among 'Jaccard_weighted', 'Jaccard_binary', 'Bray-Curtis', 'GUniFrac', 'UniFrac_unweighted', and 'degree'.")}
  if (method %in% c("GUniFrac", "UniFrac_unweighted")) {if (is.null(tree_B)) stop("Please provide a phylogenetic tree \"tree_B\" for guild B.")}
  if (!method %in% c("Jaccard_weighted","Jaccard_binary", "Bray-Curtis", "GUniFrac", "UniFrac_unweighted", "degree")) {stop("Please provide a \"method\" to compute phylogenetic signals among 'Jaccard_weighted', 'Jaccard_binary', 'Bray-Curtis', 'GUniFrac', 'UniFrac_unweighted', and 'degree'.")}
  
  
  if (!permutation %in% c("shuffle","nbpartners", "biogeo")) {stop("Please provide a type of \"permutation\" among 'shuffle' and 'nbpartners'.")}
  if (permutation!="shuffle") {if (method %in% c("degree")) stop("The argument \"permutation\" is not used for this method.")}
  
  
  if (permutation == "biogeo") { 
    if (!all(table_biogeo$species %in% colnames(network))){
      stop("Provide a table_biogeo with all the species from tree_A.")
    }
    table_biogeo <- table_biogeo[match(colnames(network), table_biogeo$species), ]
  }
  
  
  if (!correlation %in% c("Pearson", "Spearman", "Kendall")) {stop("Please pick a \"correlation\" among Pearson, Spearman, and Kendall.")}
  
  if (nrow(network)<2){stop("Please provide a \"network\" with at least 2 species in clade B.")}
  if (ncol(network)<2){stop("Please provide a \"network\" with at least 2 species in clade A.")}
  
  
  # Only keep species with at least 1 interaction
  network <- network[rowSums(network)>0,]
  network <- network[,colSums(network)>0]
  
  # A in columns and B in rows
  nb_A <- ncol(network)
  nb_B <- nrow(network)
  names(nb_A) <- "nb_A"
  names(nb_B) <- "nb_B"
  
  # Check names
  if (all(is.null(colnames(network)))|all(is.null(rownames(network)))) {stop("Please provide a \"network\" with row names and columns names matching the species names.")}
  
  if (!all(colnames(network) %in% tree_A$tip.label)){stop("Please provide a \"tree_A\" for all the species in clade A (the columns of the interaction network).")}
  if (only_A==FALSE) { if (!all(rownames(network) %in% tree_B$tip.label)){stop("Please provide a \"tree_B\" for all the species in clade B (the rows of the interaction network).")}}
  
  tree_A <- ape::drop.tip(tree_A,tip=tree_A$tip.label[which(!tree_A$tip.label %in% colnames(network))])
  if (only_A==FALSE) { tree_B <- ape::drop.tip(tree_B,tip=tree_B$tip.label[which(!tree_B$tip.label %in% rownames(network))])}
  
  
  if (!is.rooted(tree_A)){tree_A <- phytools::midpoint.root(tree_A) }
  if (only_A==FALSE) { if (!is.rooted(tree_B)){tree_B <- phytools::midpoint.root(tree_B) }}
  
  if (only_A==TRUE) { 
    network <- network[1:nrow(network),tree_A$tip.label]
  } else {
    network <- network[tree_B$tip.label,tree_A$tip.label]
  }
  
  # Mantel tests
  
  if (permutation=="shuffle"){
    mantel_A <- mantel_test(network=network, tree_A=tree_A, tree_B=tree_B, method=method, nperm=nperm, correlation=correlation, permutation=permutation)
    if (only_A==FALSE) {mantel_B <- mantel_test(network=t(network), tree_A=tree_B, tree_B=tree_A, method, nperm, correlation, permutation=permutation)
    }else{mantel_B <- list(R=NA, p_value_upper=NA, p_value_lower=NA)}
  }
  
  if (permutation=="nbpartners"){
    mantel_A <- mantel_test(network=network, tree_A=tree_A, tree_B=tree_B, method=method, nperm=nperm, correlation=correlation, permutation=permutation)
    if (only_A==FALSE) {mantel_B <- mantel_test(network=t(network), tree_A=tree_B, tree_B=tree_A, method=method, nperm=nperm, correlation=correlation, permutation=permutation)
    }else{mantel_B <- list(R=NA, p_value_upper=NA, p_value_lower=NA)}
  }
  
  if (permutation=="biogeo"){
    mantel_A <- mantel_test(network=network, tree_A=tree_A, tree_B=tree_B, method=method, nperm = nperm, correlation= correlation, permutation=permutation, table_biogeo=table_biogeo)
    mantel_B <- list(R=NA, p_value_upper=NA, p_value_lower=NA)
  }
  
  out <- list(nb_A=as.integer(nb_A), nb_B=as.integer(nb_B), 
              mantel_cor_A=mantel_A$R, p_upper_A=mantel_A$p_value_upper, p_lower_A=mantel_A$p_value_lower,mantel_cor_A_perm=mantel_A$random_correlation, 
              mantel_cor_B=mantel_B$R, p_upper_B=mantel_B$p_value_upper, p_lower_B=mantel_B$p_value_lower,mantel_cor_B_perm=mantel_B$random_correlation)
  
  return(out)
}
