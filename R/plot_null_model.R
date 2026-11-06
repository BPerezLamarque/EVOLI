plot_null_model <-
function(res, method, 
                             median=FALSE){
  
  if (!method %in% c("paco", "parafit", "mantel")) {stop("\"method\" must be among 'paco', 'parafit' or 'mantel'.")}
  
  
  if (method=="paco"){
    x_obs <- res$R2_obs
    x_H0 <- res$R2_perm
    name <- expression("PACo R"^2)
    obs <- expression("Obs. R"^2)
  }
  if (method=="parafit"){
    x_obs <- res$ParaFitGlobal
    x_H0 <- res$ParaFitGlobal_perm
    name <- "ParaFit stat."
    obs <- "Obs. stat."
  }
  if (method=="mantel"){
    x_obs <- res$mantel_cor_A
    x_H0 <- res$mantel_cor_A_perm
    name <- "Mantel R"
    obs <- "Obs. R"
  }
  
  df <- rbind(data.frame(value = x_H0, model = "H0"))
  x_all <- c(x_obs, x_H0)
  xlim <- range(x_all) + c(-0.02, 0.02) * diff(range(x_all))
  
  p <- ggplot(df, aes(x = value, y = after_stat(count / sum(count)), fill = model)) +
    geom_vline(xintercept = 0)+
    geom_histogram(bins = 30, alpha = 0.5, position = "identity")
  if (median){
    p <- p + geom_vline(xintercept = median(df$value[df$model=="H0"], na.rm = TRUE), color="#154360",linetype="dashed")
  }
  p <- p + geom_vline(aes(xintercept = x_obs, color = obs, linetype = obs),linewidth = 0.7, alpha=0.5) +
    scale_y_continuous(labels = percent_format(accuracy = 1) ) +# , limits = c(0, 0.15)) +
    theme_bw() + xlab(name) + ylab("Percentage of permutations") +
    scale_fill_manual(values = c("H0" = "#154360"),name = NULL) +
    scale_color_manual(values = setNames("red", obs),name = NULL) +
    scale_linetype_manual(values = setNames("solid", obs),name = NULL) +
    coord_cartesian(xlim = xlim) + labs(x = name) + theme_bw()
  print(p)
  
}
