compare_null_models <-
function(results, results_biogeo, method, median=FALSE){
  
  if (method=="paco"){
    mu_null <- mean(results$R2_perm)
    mu_null_biogeo <- mean(results_biogeo$R2_perm)
    sd_null <- sd(results$R2_perm)
    sd_null_biogeo <- sd(results_biogeo$R2_perm)
    obs <- results$R2_obs
    if (median){
      median_null <- median(results$R2_perm)
      median_null_biogeo <- median(results_biogeo$R2_perm)
    }
  }
  
  if (method=="parafit"){
    mu_null <- mean(results$ParaFitGlobal_perm)
    mu_null_biogeo <- mean(results_biogeo$ParaFitGlobal_perm)
    sd_null <- sd(results$ParaFitGlobal_perm)
    sd_null_biogeo <- sd(results_biogeo$ParaFitGlobal_perm)
    obs <- results$ParaFitGlobal
    if (median){
      median_null <- median(results$ParaFitGlobal_perm)
      median_null_biogeo <- median(results_biogeo$ParaFitGlobal_perm)
    }
  }
  
  if (method=="mantel"){
    mu_null <- mean(results$mantel_cor_A_perm)
    mu_null_biogeo <- mean(results_biogeo$mantel_cor_A_perm)
    sd_null <- sd(results$mantel_cor_A_perm)
    sd_null_biogeo <- sd(results_biogeo$mantel_cor_A_perm)
    obs <- results$mantel_cor_A
    if (median){
      median_null <- median(results$mantel_cor_A_perm)
      median_null_biogeo <- median(results_biogeo$mantel_cor_A_perm)
    }
  }
  
  # Statistics with Standardized Effect Size (SES) which indicates how strong the departure from each null expectation is.
  SES_null <- (obs-mu_null)/sd_null
  SES_null_biogeo <- (obs-mu_null_biogeo)/sd_null_biogeo
  
  # fraction of the original deviation explained by geographic structure.
  fraction_explained <- (mu_null_biogeo - mu_null) / (obs - mu_null)
  if (median){
    fraction_explained <- (median_null_biogeo - median_null) / (obs - median_null)
  }
  
  res <- rbind(c("Random permutations (H0)", round(mu_null,4),  round(sd_null,4),  round(SES_null,4), ""),
               c("Biogeographic-based permutations (H0 biogeo)",  round(mu_null_biogeo,4),  round(sd_null_biogeo,4),  round(SES_null_biogeo,4),  round(fraction_explained,4)))
  
  colnames(res) <- c("Random permutations", "mean", "sd", "SES", "f fraction")
  
  return(res)
  
}
