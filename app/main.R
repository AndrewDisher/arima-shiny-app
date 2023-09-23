box::use(
  shiny[moduleServer, NS],
  shiny.semantic[semanticPage]
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  semanticPage(
    
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
  })
}
