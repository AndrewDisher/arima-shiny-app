# -------------------------------------------------------------------------
# ---------------------------- Libraries/Packages -------------------------
# -------------------------------------------------------------------------

box::use(
  shiny[tags],
  shiny.semantic[action_button, modal]
)

# -------------------------------------------------------------------------
# ---------------------------------- Modules ------------------------------
# -------------------------------------------------------------------------

# box::use(
#   
# )

#' @export
build_modal <- function(modal_id) {
  modal(
    id = modal_id,
    header = list(tags$h4("Fatal Force App")),
    footer = action_button(input_id = "dismiss_modal",
                           label = "Dismiss",
                           class = "ui button positive"),
    settings = list(c("transition", "fly down"))
  )
}
