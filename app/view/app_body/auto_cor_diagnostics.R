# -------------------------------------------------------------------------
# ---------------------------- Libraries/Packages -------------------------
# -------------------------------------------------------------------------

box::use(
  dplyr[`%>%`],
  shiny[moduleServer, NS, plotOutput, reactive, renderPlot, tagList],
  shiny.semantic[tabset],
  shinycssloaders[withSpinner]
)

# -------------------------------------------------------------------------
# ---------------------------------- Modules ------------------------------
# -------------------------------------------------------------------------

box::use(
  app/logic[auto_cor_diagnostics_logic]
)

# -------------------------------------------------------------------------
# ------------------------------ UI Function ------------------------------
# -------------------------------------------------------------------------

#' @export
init_ui <- function(id) {
  ns <- NS(id)
  tagList(
    tabset(tabs = list(
      list(menu = "ACF", id = ns("acf_tab"), 
           content = plotOutput(outputId = ns("acf_plot")) %>% 
             withSpinner(type = 4)),
      list(menu = "PACF", id = ns("pacf_tab"), 
           content = plotOutput(outputId = ns("pacf_plot")) %>% 
             withSpinner(type = 4))
    ),
    id = ns("auto_cor_tabset"))
  )
}

# -------------------------------------------------------------------------
# ----------------------------- Server Function ---------------------------
# -------------------------------------------------------------------------

#' @export
init_server <- function(id, model_fit) {
  moduleServer(id, function(input, output, session) {
    
    # -------------------------------------
    # ----- Reactive Data Preparation -----
    # -------------------------------------
    auto_cor_df <- reactive({ 
      auto_cor_diagnostics_logic$get_auto_cor(model_residuals = model_fit()$residuals,
                                              max_lag = 25)
    })
    
    # ------------------------------
    # ----- Build the ACF Plot -----
    # ------------------------------
    output$acf_plot <- renderPlot({
      auto_cor_diagnostics_logic$build_acf(auto_cor_df = auto_cor_df(),
                                           n_obs = 300)
    })
    
    # -------------------------------
    # ----- Build the PACF Plot -----
    # -------------------------------
    output$pacf_plot <- renderPlot({
      auto_cor_diagnostics_logic$build_pacf(auto_cor_df = auto_cor_df(),
                                            n_obs = 300)
    })
    
    }
   )
}
