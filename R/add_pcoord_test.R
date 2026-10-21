add_pcoord_test <-
function (D) {
  HP_bin <- which(D$HP > 0, arr.ind = TRUE)
  H_PCo <- coordpcoa_test(D$H, correction = "cailliez")$vectors
  P_PCo <- coordpcoa_test(D$P, correction = "cailliez")$vectors
  D$H_PCo <- H_PCo[HP_bin[, 1,drop=F], ,drop=F]
  D$P_PCo <- P_PCo[HP_bin[, 2,drop=F], ,drop=F]
  return(D)
}
