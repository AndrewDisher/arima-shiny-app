# -------------------------------------------------------------------------
# ---------------------------- Libraries/Packages -------------------------
# -------------------------------------------------------------------------

box::use(
  dplyr[`%>%`],
  shiny[moduleServer, NS, plotOutput, renderPlot, tagList],
  shiny.semantic[tabset],
  shinycssloaders[withSpinner]
)

# -------------------------------------------------------------------------
# ---------------------------------- Modules ------------------------------
# -------------------------------------------------------------------------

box::use(
  app/logic[ts_diagnostics_logic]
)

# -------------------------------------------------------------------------
# ------------------------------ UI Function ------------------------------
# -------------------------------------------------------------------------

#' @export
init_ui <- function(id) {
  ns <- NS(id)
  tagList(
    tabset(tabs = list(
      list(menu = "Time Series", id = ns("ts_tab"),
           content = plotOutput(outputId = ns("ts_plot")) %>% 
             withSpinner(type = 4)),
      list(menu = "Residual Time Series", id = ns("ts_resid_tab"),
           content = plotOutput(outputId = ns("ts_residual_plot")) %>% 
             withSpinner(type = 4))
      ),
      id = ns("time_series_tabset"))
  )
}

# -------------------------------------------------------------------------
# ----------------------------- Server Function ---------------------------
# -------------------------------------------------------------------------

#' @export
init_server <- function(id, arima_sim_data, model_fit) {
  moduleServer(id, function(input, output, session) {
    # ------------------------------
    # ----- Time Series Output -----
    # ------------------------------
    output$ts_plot <- renderPlot({
      ts_diagnostics_logic$build_time_series(sim_data = arima_sim_data(),
                                             model_data = model_fit()$fitted_values)
    })
    
    # ---------------------------------------
    # ----- Residual Time Series Output -----
    # ---------------------------------------
    output$ts_residual_plot <- renderPlot({
      ts_diagnostics_logic$build_residual_time_series(residuals = model_fit()$residuals)
    })
    
    }
   )
}
