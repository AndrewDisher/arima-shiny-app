# -------------------------------------------------------------------------
# ---------------------------- Libraries/Packages -------------------------
# -------------------------------------------------------------------------

box::use(
  ggplot2[aes, annotate, coord_fixed, facet_wrap, geom_hline, geom_point, geom_vline, ggplot, labs, theme, 
          theme_minimal, vars],
  ggtext[...],
  glue[glue],
  forecast[autoplot, is.Arima]
)

# -------------------------------------------------------------------------
# ---------------------------------- Modules ------------------------------
# -------------------------------------------------------------------------

box::use(
  app/logic[constants]
)

# ------------------------------------------
# ----- Function to Acquire Unit Roots -----
# ------------------------------------------

#' @export
get_unit_roots <- function(model) {
  # Use forecast's autoplot to acquire data frame (containing needed root data)
  data <- autoplot(model)$data
}

# --------------------------------------------------------------------
# ----- Function to Produce Unit Root Plot Labels for Facet Wrap -----
# --------------------------------------------------------------------

facet_labeller <- function(labels) {lapply(labels, 
                                          function(x) paste("Inverse", as.character(x),
                                                            "Roots"))
}

# ------------------------------------------------------
# ----- Function to Plot Inverse Unit Root Circles -----
# ------------------------------------------------------

#' @export
build_unit_circle <- function(unit_root_data) {
  
  # ----- Case 1: No Model Parameters Selected ----- #
  if (nrow(unit_root_data) == 0) {
    # Generate placeholder data
    plot_data <- data.frame(roots = c(NA, NA),
                            type = c("AR", "MA"), 
                            Real = c(NA, NA),
                            Imaginary = c(NA, NA),
                            UnitCircle = c("Within", "Within"))
    
    # Determine title of plot
    plot_title <- glue("<span style = 'font-size:18pt;'>No AR or MA Roots</span>")
    
    # ----- Case 2: One Model Parameter Selected ----- #
  } else if(length(unique(unit_root_data$type)) == 1) {
    if (unique(unit_root_data$type) == "AR") {
      plot_data <- rbind(unit_root_data, 
                         data.frame(roots = c(NA),
                                    type = c("MA"), 
                                    Real = c(NA),
                                    Imaginary = c(NA),
                                    UnitCircle = c("Within")))
    } else if (unique(unit_root_data$type) == "MA") {
      plot_data <- rbind(data.frame(roots = c(NA),
                                    type = c("AR"), 
                                    Real = c(NA),
                                    Imaginary = c(NA),
                                    UnitCircle = c("Within")),
                         unit_root_data)
    }
    
    # Title of Plot
    plot_title <- glue("<span style = 'font-size:18pt;'>Inverse Model Parameter Roots</span>")
    
    # ----- Case 3: Two or More Model Parameters Selected ----- #
  } else {
    plot_data <- unit_root_data
    
    # Title of Plot
    plot_title <- glue("<span style = 'font-size:18pt;'>Inverse Model Parameter Roots</span>")
  }
  
  # Define labels for plot title, axes
  plot_labels <- list(x_label = "<span style = 'font-size:16pt;'>Real</span>",
                      y_label = "<span style = 'font-size:16pt;'>Imaginary</span>",
                      title = plot_title)
  
  # Build the plot
  plot <- ggplot(data = plot_data,
                 mapping = aes(x = Real, y = Imaginary)) +
    #coord_fixed(ratio = 1) +
    annotate("path", 
             x = cos(seq(0, 2 * pi, length.out = 100)),
             y = sin(seq(0, 2 * pi, length.out = 100))) +
    geom_vline(xintercept = 0) +
    geom_hline(yintercept = 0) +
    labs(x = plot_labels$x_label,
         y = plot_labels$y_label,
         title = plot_title) +
    # geom_point(size = 3) +
    facet_wrap(~type, labeller = facet_labeller) +
    theme_minimal() +
    theme(plot.title = element_markdown(size = 11, lineheight = 1.2),
          axis.title.x = element_markdown(),
          axis.title.y = element_markdown())
  
  # If there are any roots (parameters selected) then add geom_point element
  if (nrow(unit_root_data) != 0) {
    plot <- plot + geom_point(size = 3, color = constants$color_list$primary)
  }
  
  return(plot)
}
