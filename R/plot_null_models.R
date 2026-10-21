plot_null_models <-
function(res, res_biogeo, method, median=FALSE){
  
  if (method=="paco"){
    x_obs <- res$R2_obs
    x_H0 <- res$R2_perm
    x_H0_biogeo <- res_biogeo$R2_perm
    name <- "PACo R²"
    obs <- "Obs. R²"
  }
  if (method=="parafit"){
    x_obs <- res$ParaFitGlobal
    x_H0 <- res$ParaFitGlobal_perm
    x_H0_biogeo <- res_biogeo$ParaFitGlobal_perm
    name <- "ParaFit stat."
    obs <- "Obs. stat."
  }
  if (method=="mantel"){
    x_obs <- res$mantel_cor_A
    x_H0 <- res$mantel_cor_A_perm
    x_H0_biogeo <- res_biogeo$mantel_cor_A_perm
    name <- "Mantel R"
    obs <- "Obs. R"
  }
  
  df <- rbind(data.frame(value = x_H0, model = "H0"),
              data.frame(value = x_H0_biogeo, model = "H0 biogeo"))
  x_all <- c(x_obs, x_H0, x_H0_biogeo)
  xlim <- range(x_all) + c(-0.02, 0.02) * diff(range(x_all))
  
  p <- ggplot(df, aes(x = value, y = after_stat(count / sum(count)), fill = model)) +
    geom_vline(xintercept = 0)+
    geom_histogram(bins = 30, alpha = 0.5, position = "identity")
  if (median){
    p <- p + geom_vline(xintercept = median(df$value[df$model=="H0"], na.rm = TRUE), color="#154360",linetype="dashed")+
      geom_vline(xintercept = median(df$value[df$model=="H0 biogeo"], na.rm = TRUE), color="#27ae60",linetype="dashed")
  }
  p <- p + geom_vline(aes(xintercept = x_obs, color = obs, linetype = obs),linewidth = 0.7, alpha=0.5) +
    scale_y_continuous(labels = percent_format(accuracy = 1) ) +# , limits = c(0, 0.15)) +
    theme_bw() + xlab(name) + ylab("Percentage of permutations") +
    scale_fill_manual(values = c("H0" = "#154360", "H0 biogeo" = "#27ae60"),name = NULL) +
    scale_color_manual(values = setNames("red", obs),name = NULL) +
    scale_linetype_manual(values = setNames("solid", obs),name = NULL) +
    coord_cartesian(xlim = xlim) + labs(x = name, y = "Density") + theme_bw()
  print(p)
  
  # x_all <- c(x_obs, x_H0, x_H0_biogeo)
  # 
  # hist(x_H0,
  #      col =  adjustcolor("blue", alpha.f = 0.5),
  #      breaks = 20,
  #      freq = FALSE,
  #      xlim = range(x_all) + c(-0.02, 0.02) * diff(range(x_all)),
  #      main = "",
  #      xlab = name)
  # 
  # hist(x_H0_biogeo,
  #      col =  adjustcolor("darkgreen", alpha.f = 0.5),
  #      breaks = 20,
  #      freq = FALSE,
  #      add = TRUE)
  # 
  # abline(v = x_obs, col = adjustcolor("red", alpha.f = 0.5), lwd = 3, lty = 3)
  # 
  # legend("topright",
  #        legend = c("H0", "H0 biogeo", obs),
  #        col = c(adjustcolor("blue", alpha.f = 0.5), adjustcolor("darkgreen", alpha.f = 0.5), adjustcolor("red", alpha.f = 0.5)),
  #        lwd = c(2, 2, 3),
  #        lty = c(1, 1, 3),
  #        bty = "n")
}
