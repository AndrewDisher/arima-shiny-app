# -------------------------------------------------------------------------
# ---------------------------- Libraries/Packages -------------------------
# -------------------------------------------------------------------------

box::use(
  ggplot2[aes, ggplot, geom_line, geom_point],
  shiny[moduleServer, NS, plotOutput, reactive, renderPlot],
  shiny.semantic[semanticPage]
)

# -------------------------------------------------------------------------
# ---------------------------------- Modules ------------------------------
# -------------------------------------------------------------------------

box::use(
  app/logic[arima_simulation]
)

# -------------------------------------------------------------------------
# -------------------------------- UI Function ----------------------------
# -------------------------------------------------------------------------

#' @export
ui <- function(id) {
  ns <- NS(id)
  semanticPage(
    plotOutput(outputId = ns("arima_plot"))
  )
}

# -------------------------------------------------------------------------
# ------------------------------ Server Function --------------------------
# -------------------------------------------------------------------------

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    # ---------------------------
    # ----- Reactive Inputs -----
    # ---------------------------
    
    # Information for simulated arima model params
    arima_params <- reactive({ arima_simulation$simulate_params() })
    model_specs <- reactive({ arima_params()$model_specs })
    simulation_order <- reactive({ arima_params()$order })
    
    # Simulated time series using params
    arima_sim <- reactive({ arima_simulation$simulate_arima(param_list = model_specs()) })
    
    # ----------------------------------------------
    # ----- Initialize Module Server Functions -----
    # ----------------------------------------------
    
    output$arima_plot <- renderPlot({
      ggplot(data = data.frame(time_series = arima_sim(),
                               time = 1:length(arima_sim())),
             aes(x = time, y = time_series)) +
        geom_line() +
        geom_point()
    })
    
  })
}
