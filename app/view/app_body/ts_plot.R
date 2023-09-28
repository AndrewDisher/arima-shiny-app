# -------------------------------------------------------------------------
# ---------------------------- Libraries/Packages -------------------------
# -------------------------------------------------------------------------

box::use(
  dplyr[`%>%`],
  shiny[moduleServer, NS, plotOutput, reactive, renderPlot, tagList],
  shinycssloaders[withSpinner]
)

# -------------------------------------------------------------------------
# ---------------------------------- Modules ------------------------------
# -------------------------------------------------------------------------

box::use(
  app/logic[ts_plot_logic]
)

# -------------------------------------------------------------------------
# ------------------------------ UI Function ------------------------------
# -------------------------------------------------------------------------

#' @export
init_ui <- function(id) {
  ns <- NS(id)
  tagList(
    plotOutput(outputId = ns("ts_plot")) %>% 
      withSpinner(type = 4)
  )
}

# -------------------------------------------------------------------------
# ----------------------------- Server Function ---------------------------
# -------------------------------------------------------------------------

#' @export
init_server <- function(id, arima_sim_data, model_fit, parameter_p, 
                        parameter_d, parameter_q) {
  moduleServer(id, function(input, output, session) {
    
    # --------------------------
    # ----- ggplot2 Output -----
    # --------------------------
    output$ts_plot <- renderPlot({
      ts_plot_logic$build_time_series(sim_data = arima_sim_data(),
                                      model_data = model_fit()$fitted_values)
    })
    }
   )
}
