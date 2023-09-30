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
  app/logic[misc_diagnostics_logic]
)

# -------------------------------------------------------------------------
# ------------------------------ UI Function ------------------------------
# -------------------------------------------------------------------------

#' @export
init_ui <- function(id) {
  ns <- NS(id)
  tagList(
    plotOutput(outputId = ns("unit_circle")) %>% 
      withSpinner(type = 4)
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
    
    # --------------------------
    # ----- ggplot2 Output -----
    # --------------------------
    output$unit_circle <- renderPlot({
      misc_diagnostics_logic$build_unit_circle(unit_root_data = unit_root_data())
    })
      
    }
   )
}
