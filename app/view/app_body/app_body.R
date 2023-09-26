# -------------------------------------------------------------------------
# ---------------------------- Libraries/Packages -------------------------
# -------------------------------------------------------------------------

box::use(
  shiny[div, moduleServer, NS, tagList, reactive],
  shiny.semantic[numeric_input]
)

# -------------------------------------------------------------------------
# ---------------------------------- Modules ------------------------------
# -------------------------------------------------------------------------

box::use(
  app/view[ts_plot],
  app/logic[app_body_logic]
)

# -------------------------------------------------------------------------
# ----------------------------- Helper Functions --------------------------
# -------------------------------------------------------------------------

card <- function(class, ...) {div(class = class, ...)}

custom_grid <- function(class, ...) {div(class = class, ...)}

# -------------------------------------------------------------------------
# ------------------------------ UI Function ------------------------------
# -------------------------------------------------------------------------

#' @export
init_ui <- function(id) {
  ns <- NS(id)
  tagList(
    custom_grid(class = "body-layout", 
                # Time Series Plot
                card(class = c("plot-card", "time-series"), 
                     ts_plot$init_ui(id = ns("ts_plot"))),
                # User Model Parameter Inputs
                card(class = c("plot-card", "inputs"),
                     numeric_input(input_id = ns("AR_input"),
                                   label = "Auto-Regressive Parameters",
                                   value = 0,
                                   min = 0, 
                                   max = 3),
                     numeric_input(input_id = ns("D_input"),
                                   label = "Order of Differencing",
                                   value = 0,
                                   min = 0, 
                                   max = 1),
                     numeric_input(input_id = ns("MA_input"),
                                   label = "Moving Average Parameters",
                                   value = 0,
                                   min = 0, 
                                   max = 3)),
                # Plots for ACF and PACF
                card(class = c("plot-card", "acf-pcf")),
                # Plot for Inverse Unit Root Circle
                card(class = c("plot-card", "unit-circle")))
  )
}

# -------------------------------------------------------------------------
# ----------------------------- Server Function ---------------------------
# -------------------------------------------------------------------------

#' @export
init_server <- function(id, arima_sim_data) {
  moduleServer(id, function(input, output, session) {
    
    # ---------------------------
    # ----- Reactive Inputs -----
    # ---------------------------
    parameter_p <- reactive({ input$AR_input })
    parameter_d <- reactive({ input$D_input })
    parameter_q <- reactive({ input$MA_input })
    
    # ----------------------------------
    # ----- Reactive Data Modeling -----
    # ----------------------------------
    model_fit <- reactive({
      app_body_logic$train_user_model(arima_sim_data = arima_sim_data(), 
                                     parameter_p = parameter_p(),
                                     parameter_d = parameter_d(),
                                     parameter_q = parameter_q())
    })
    
    # ----------------------------------------------
    # ----- Initialize Module Server Functions -----
    # ----------------------------------------------
    ts_plot$init_server(id = "ts_plot", 
                        arima_sim_data = arima_sim_data,
                        model_fit = model_fit)
      
    }
   )
}
