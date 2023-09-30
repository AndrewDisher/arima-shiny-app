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
  app/logic[misc_diagnostics_logic]
)

# -------------------------------------------------------------------------
# ------------------------------ UI Function ------------------------------
# -------------------------------------------------------------------------

#' @export
init_ui <- function(id) {
  ns <- NS(id)
  tagList(
    tabset(tabs = list(
      list(menu = "Inverse Unit Root Circle", id = ns("unit_circle_tab"),
           content = plotOutput(outputId = ns("unit_circle")) %>% 
             withSpinner(type = 4)),
      list(menu = "Normality Plot", id = ns("normality_tab"),
           content = plotOutput(outputId = ns("normality_plot")) %>% 
             withSpinner(type = 4))
    ),
    id = ns("misc_tabset"))
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
    
    unit_root_data <- reactive({
      misc_diagnostics_logic$get_unit_roots(model = model_fit()$model)
    })
    
    # ------------------------------
    # ----- Unit Circle Output -----
    # ------------------------------
    output$unit_circle <- renderPlot({
      misc_diagnostics_logic$build_unit_circle(unit_root_data = unit_root_data())
    })
    
    # ---------------------------------
    # ----- Normal QQ Plot Output -----
    # ---------------------------------
    output$normality_plot <- renderPlot({
      misc_diagnostics_logic$build_normality_plot(residuals = model_fit()$residuals)
    })
    }
   )
}
