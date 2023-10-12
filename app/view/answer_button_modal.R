# -------------------------------------------------------------------------
# ---------------------------- Libraries/Packages -------------------------
# -------------------------------------------------------------------------

box::use(
  shiny[moduleServer, NS, observeEvent, renderUI, tagList, uiOutput],
  shiny.semantic[action_button, show_modal]
)

# -------------------------------------------------------------------------
# ---------------------------------- Modules ------------------------------
# -------------------------------------------------------------------------

box::use(
  app/logic[answer_button_modal_logic]
)

# -------------------------------------------------------------------------
# ------------------------------ UI Function ------------------------------
# -------------------------------------------------------------------------

#' @export
init_ui <- function(id) {
  ns <- NS(id)
  tagList(
    # ----- Application Info Modal -----
    uiOutput(ns("modal")),
    
    # ----- Application Info Modal Button -----
    action_button(input_id = ns("show"), 
                  label = "Show Answer", 
                  class = "ui positive button")
  )
}

# -------------------------------------------------------------------------
# ----------------------------- Server Function ---------------------------
# -------------------------------------------------------------------------

#' @export
init_server <- function(id, params) {
  moduleServer(id, function(input, output, session) {
    # ------------------------------------
    # ----- Show Answer Button Modal -----
    # ------------------------------------
    observeEvent(input$show, {
      show_modal(id = "modal_UI")
    })
    
    output$modal <- renderUI({
      answer_button_modal_logic$build_modal(modal_id = session$ns("modal_UI"),
                                            params = params())
    })
    }
   )
}
