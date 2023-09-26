# -------------------------------------------------------------------------
# ---------------------------- Libraries/Packages -------------------------
# -------------------------------------------------------------------------

box::use(
  ggplot2[aes, ggplot, geom_line, geom_point, labs, theme, theme_minimal],
  ggtext[...]
)

# -----------------------------------------------
# ----- Function to Build Time Series Chart -----
# -----------------------------------------------

#' @export
build_time_series <- function(sim_data, model_data) {
  plot_data <- data.frame(sim_data = sim_data,
                          model_data = model_data,
                          time = 1:length(model_data))
  plot <- ggplot() +
    geom_line(data = plot_data, mapping = aes(x = time, y = sim_data), color = "#166dfc", size = 1) +
    geom_line(data = plot_data, mapping = aes(x = time, y = model_data), color = "#FCA516", size = 1) +
    theme_minimal() +
    labs(x = "<span style = 'font-size:16pt;'>Time</span>",
         y = "<span style = 'font-size:16pt;'>Values</span>",
         title = "<span style = 'font-size:18pt;'><span style = 'color:#166dfc;'>Simulated Data</span>
         vs. <span style = 'color:#FCA516;'>Model Fitted Values</span></span>") +
    theme(plot.title = element_markdown(size = 11, lineheight = 1.2),
          axis.title.x = element_markdown(),
          axis.title.y = element_markdown())
  
  return(plot)
}
