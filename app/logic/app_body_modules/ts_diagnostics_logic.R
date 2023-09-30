# -------------------------------------------------------------------------
# ---------------------------- Libraries/Packages -------------------------
# -------------------------------------------------------------------------

box::use(
  dplyr[`%>%`],
  ggplot2[aes, ggplot, geom_hline, geom_line, geom_point, labs, theme, theme_minimal],
  ggtext[...],
  glue[glue]
)

# -------------------------------------------------------------------------
# ---------------------------------- Modules ------------------------------
# -------------------------------------------------------------------------

box::use(
  app/logic[constants]
)

# -----------------------------------------------
# ----- Function to Build Time Series Chart -----
# -----------------------------------------------

#' @export
build_time_series <- function(sim_data, model_data) {
  # Data frame for plotting
  plot_data <- data.frame(sim_data = sim_data,
                          model_data = model_data,
                          time = 1:length(model_data))
  
  # Colors for labels and plot
  plot_colors <- constants$color_list
  
  # Labels for plot
  plot_labels <- list(x_label = "<span style = 'font-size:16pt;'>Time</span>",
                      y_label = "<span style = 'font-size:16pt;'>Values</span>",
                      title = glue("<span style = 'font-size:18pt;'><span style = 'color:{plot_colors$primary};'>Simulated Data</span>
                                   vs. <span style = 'color:{plot_colors$secondary};'>Model Fitted Values</span></span>"))
  
  # Construct Plot
  plot <- ggplot() +
    geom_line(data = plot_data, mapping = aes(x = time, y = sim_data), 
              color = constants$color_list$primary, size = 1) +
    geom_line(data = plot_data, mapping = aes(x = time, y = model_data), 
              color = constants$color_list$secondary, size = 1) +
    theme_minimal() +
    labs(x = plot_labels$x_label,
         y = plot_labels$y_label,
         title = plot_labels$title) +
    theme(plot.title = element_markdown(size = 11, lineheight = 1.2),
          axis.title.x = element_markdown(),
          axis.title.y = element_markdown())
  
  return(plot)
}

# --------------------------------------------------
# ----- Function to Build Residual Time Series -----
# --------------------------------------------------

#' @export
build_residual_time_series <- function(residuals) {
  # Data frame for plotting
  plot_data <- data.frame(residual_data = residuals %>% 
                            as.numeric(),
                          time = 1:length(residuals))
  
  # Colors for labels and plot
  plot_colors <- constants$color_list
  
  # Labels for plot
  plot_labels <- list(x_label = "<span style = 'font-size:16pt;'>Time</span>",
                      y_label = "<span style = 'font-size:16pt;'>Residuals</span>",
                      title = glue("<span style = 'font-size:18pt;'><span style = 'color:{plot_colors$primary};'>Ordered Model Residuals</span></span>"))
  
  # Construct the Residual Plot
  plot <- ggplot(data = plot_data, mapping = aes(x = time, y = residual_data)) +
    geom_hline(yintercept = 0, linetype = "dashed") +
    geom_line(color = plot_colors$primary, size = 1) +
    theme_minimal() +
    labs(x = plot_labels$x_label,
         y = plot_labels$y_label,
         title = plot_labels$title) +
    theme(plot.title = element_markdown(size = 11, lineheight = 1.2),
          axis.title.x = element_markdown(),
          axis.title.y = element_markdown())
  
  return(plot)
}
