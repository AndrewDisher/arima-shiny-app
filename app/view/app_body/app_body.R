# -------------------------------------------------------------------------
# ---------------------------- Libraries/Packages -------------------------
# -------------------------------------------------------------------------

box::use(
  dplyr[`%>%`],
  forecast[is.Arima],
  shiny[a, div, moduleServer, need, NS, reactive, renderPrint, span, tagList, validate, 
        verbatimTextOutput],
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
                                          div(class = "model-input-1",
                                              numeric_input(input_id = ns("AR_input"),
                                                            label = "Auto-Regressive Parameters",
                                                            value = 0,
                                                            min = 0, 
                                                            max = 3)),
                                          div(class = "input-description-1",
                                              "Auto-regressive parameters use previous values of the 
                                              time series to help predict the next value for the series.
                                              The Auto-regressive order of an ARIMA model is closely related
                                              to the Partial Autocorrelation function (PACF). 
                                              Further reading on this concept is available", 
                                              a(target = "_blank", 
                                                href = "https://en.wikipedia.org/wiki/Autoregressive_model", 
                                                span("here."))
                                              ),
                                          div(class = "model-input-2", 
                                              numeric_input(input_id = ns("D_input"),
                                                            label = "Order of Differencing",
                                                            value = 0,
                                                            min = 0, 
                                                            max = 1)),
                                          div(class = "input-description-2",
                                              "Differencing a time series entails subtracting the previous
                                              value in the series from the current value of the series. In practice, 
                                              it is used eliminate some types non-stationarity that can be present in 
                                              the series. Further reading on the differencing (backshift/lag) operator is available", 
                                              a(target = "_blank", 
                                                href = "https://en.wikipedia.org/wiki/Lag_operator", 
                                                span("here.")),
                                              "You can also read about how to determine if your time series requires
                                              differencing in Rob Hyndman's book",
                                              a(target = "_blank", 
                                                href = "https://otexts.com/fpp2/stationarity.html", 
                                                span("Forecasting Principles and Practice."))
                                          ),
                                          div(class = "model-input-3",
                                              numeric_input(input_id = ns("MA_input"),
                                                            label = "Moving Average Parameters",
                                                            value = 0,
                                                            min = 0, 
                                                            max = 3)),
                                          div(class = "input-description-3",
                                              "Moving Average parameters use the shocks, or error terms, of a previous 
                                              value in the series to help predict the next value of the series. The MA order of
                                              an ARIMA model is closely related to the Autocorrelation function (ACF).
                                              Further reading on this concept is available", 
                                              a(target = "_blank", 
                                                href = "https://en.wikipedia.org/wiki/Moving-average_model", 
                                                span("here."))
                                          ))
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
      # Validate that all model parameters have been specified and with valid numbers (0-3)
      validate(
        need(is.numeric(parameter_p()) & is.numeric(parameter_d()) & is.numeric(parameter_q()), 
             "You must specify the order for each model parameter."),
        need(parameter_p() >= 0 & parameter_p() <= 3 &
               parameter_q() >= 0 & parameter_q() <= 3, 
             "AR and MA model parameter values must be between 0 and 3!"),
        need(parameter_d() >= 0 & parameter_d() <= 1,
             "Order of differencing should not exceed 1!")
      )
      
      app_body_logic$train_user_model(arima_sim_data = arima_sim_data(), 
                                      parameter_p = parameter_p(),
                                      parameter_d = parameter_d(),
                                      parameter_q = parameter_q())
    })
    
    output$model_summary <- renderPrint({
      # Validate that the specified model (given numeric model specifications are valid)
      # is stationary. This is a vague validation condition, so we'll check that 
      # other user errors aren't the reason.
      
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
