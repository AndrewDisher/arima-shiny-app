# -------------------------------------------------------------------------
# ---------------------------- Libraries/Packages -------------------------
# -------------------------------------------------------------------------

box::use(
  dplyr[`%>%`],
  forecast[is.Arima],
  shiny[a, div, moduleServer, NS, reactive, renderPrint, span, tagList, verbatimTextOutput],
  shiny.semantic[action_button, icon, numeric_input, tabset],
  shinycssloaders[withSpinner]
)

# -------------------------------------------------------------------------
# ---------------------------------- Modules ------------------------------
# -------------------------------------------------------------------------

box::use(
  app/view[ts_diagnostics, auto_cor_diagnostics, misc_diagnostics],
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
                # ----------------------------------------------
                # ----- Tabset for Model Params and Output -----
                # ----------------------------------------------
                card(class = c("plot-card", "inputs"),
                     # --- User Model Parameter Inputs ---
                     tabset(tabs = list(
                       list(menu = "Model Parameters", id = ns("params"),
                            content = tagList(
                              custom_grid(class = "model-input-grid",
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
                                                        max = 3))
                              )),
                       # --- Model Summary Output ---
                       list(menu = "Model Output", id = ns("mod_output"),
                            content = verbatimTextOutput(outputId = ns("model_summary")) %>% 
                              withSpinner(type = 4)
                            )
                       ))
                     ),
                # -----------------------------
                # ----- Plot Output Cards -----
                # -----------------------------
                # Time Series Plot
                card(class = c("plot-card", "time-series"), 
                     ts_diagnostics$init_ui(id = ns("ts_diagnostics"))),
                # Plots for ACF and PACF
                card(class = c("plot-card", "acf-pcf"),
                     auto_cor_diagnostics$init_ui(id = ns("auto_cor_diagnostics"))),
                # Plot for Inverse Unit Root Circle
                card(class = c("plot-card", "unit-circle"),
                     misc_diagnostics$init_ui(id = ns("misc_diagnostics"))))
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
    
    output$model_summary <- renderPrint({
      model_fit()$model %>% 
        summary()
    })
    
    # ----------------------------------------------
    # ----- Initialize Module Server Functions -----
    # ----------------------------------------------
    ts_diagnostics$init_server(id = "ts_diagnostics",
                               arima_sim_data = arima_sim_data,
                               model_fit = model_fit)
    
    auto_cor_diagnostics$init_server(id = "auto_cor_diagnostics",
                                     model_fit = model_fit,
                                     param_p = parameter_p,
                                     param_d = parameter_d,
                                     param_q = parameter_q)
    
    misc_diagnostics$init_server(id = "misc_diagnostics",
                                 model_fit = model_fit)
      
    }
   )
}
