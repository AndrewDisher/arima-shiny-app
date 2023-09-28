# -------------------------------------------------------------------------
# ---------------------------- Libraries/Packages -------------------------
# -------------------------------------------------------------------------

box::use(
  ggplot2[aes, ggplot, geom_hline, geom_linerange, geom_point, labs, theme, theme_minimal],
  ggtext[...],
  glue[glue],
  stats[acf, pacf, qnorm]
)

# -------------------------------------------------------------------------
# ---------------------------------- Modules ------------------------------
# -------------------------------------------------------------------------

box::use(
  app/logic[constants]
)

# ------------------------------------------------------
# ----- Function for acquiring ACF and PACF values -----
# ------------------------------------------------------

#' @export
get_auto_cor <- function(model_residuals, max_lag) {
  auto_cor_df <- data.frame(acf = acf(model_residuals, lag.max = max_lag)$acf[2:(max_lag + 1)],
                            pacf = pacf(model_residuals, lag.max = max_lag)$acf,
                            lag = 1:max_lag)
  
  return(auto_cor_df)
}

# ---------------------------------------
# ----- Function to create ACF Plot -----
# ---------------------------------------

#' @export
build_acf <- function(auto_cor_df, n_obs) {
  
  # Colors for labels and plot
  plot_colors <- constants$color_list
  
  # Labels for plot
  plot_labels <- list(x_label = "<span style = 'font-size:16pt;'>Lag</span>", 
                      y_label = "<span style = 'font-size:16pt;'>ACF</span>", 
                      title = glue("<span style = 'font-size:18pt;'><span style = 'color:{plot_colors$primary};'>Autocorrelation Function</span>
                                   and its <span style = 'color:{plot_colors$secondary};'>Confidence Limits</span></span>"))
  
  # Calculate confidence bounds
  limits <- list(upper_limit = qnorm((1 + .95)/2)/sqrt(n_obs),
                 lower_limit = -1 * qnorm((1 + .95)/2)/sqrt(n_obs))
  
  # Build the plot
  acf_plot <- ggplot(data = auto_cor_df, 
                     mapping = aes(x = lag, y = acf)) +
    geom_hline(yintercept = 0, color = "black") +
    geom_hline(yintercept = limits$upper_limit, linetype = "dashed", 
               color = plot_colors$secondary) +
    geom_hline(yintercept = limits$lower_limit, linetype = "dashed",
               color = plot_colors$secondary) +
    geom_linerange(aes(ymin = 0, ymax = acf)) +
    geom_point(color = plot_colors$primary, size = 2) +
    theme_minimal() +
    labs(x = plot_labels$x_label,
         y = plot_labels$y_label,
         title = plot_labels$title) + 
    theme(plot.title = element_markdown(size = 11, lineheight = 1.2),
          axis.title.x = element_markdown(),
          axis.title.y = element_markdown())
  
  return(acf_plot)
}

# ----------------------------------------
# ----- Function to create PACF Plot -----
# ----------------------------------------

#' @export
build_pacf <- function(auto_cor_df, n_obs) {
  # Colors for labels and plot
  plot_colors <- constants$color_list
  
  # Labels for plot
  plot_labels <- list(x_label = "<span style = 'font-size:16pt;'>Lag</span>", 
                      y_label = "<span style = 'font-size:16pt;'>PACF</span>", 
                      title = glue("<span style = 'font-size:18pt;'><span style = 'color:{plot_colors$primary};'>Partial Autocorrelation Function</span>
                                   and its <span style = 'color:{plot_colors$secondary};'>Confidence Limits</span></span>"))
  
  # Calculate confidence bounds
  limits <- list(upper_limit = qnorm((1 + .95)/2)/sqrt(n_obs),
                 lower_limit = -1 * qnorm((1 + .95)/2)/sqrt(n_obs))
  
  # Build the plot
  pacf_plot <- ggplot(data = auto_cor_df, 
                     mapping = aes(x = lag, y = pacf)) +
    geom_hline(yintercept = 0, color = "black") +
    geom_hline(yintercept = limits$upper_limit, linetype = "dashed", 
               color = plot_colors$secondary) +
    geom_hline(yintercept = limits$lower_limit, linetype = "dashed",
               color = plot_colors$secondary) +
    geom_linerange(aes(ymin = 0, ymax = pacf)) +
    geom_point(color = plot_colors$primary, size = 2) +
    theme_minimal() +
    labs(x = plot_labels$x_label,
         y = plot_labels$y_label,
         title = plot_labels$title) + 
    theme(plot.title = element_markdown(size = 11, lineheight = 1.2),
          axis.title.x = element_markdown(),
          axis.title.y = element_markdown())
  
  return(pacf_plot)
}
