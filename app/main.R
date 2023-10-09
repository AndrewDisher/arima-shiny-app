# -------------------------------------------------------------------------
# ---------------------------- Libraries/Packages -------------------------
# -------------------------------------------------------------------------

box::use(
  shiny[moduleServer, NS, reactive, tags],
  shiny.semantic[semanticPage]
)

# -------------------------------------------------------------------------
# ---------------------------------- Modules ------------------------------
# -------------------------------------------------------------------------

box::use(
  app/logic[arima_simulation],
  app/view[main_info_modal, app_body]
)

# -------------------------------------------------------------------------
# -------------------------------- UI Function ----------------------------
# -------------------------------------------------------------------------

#' @export
ui <- function(id) {
  ns <- NS(id)
  semanticPage(
    # ------------------------------
    # ----- Application header -----
    # ------------------------------
    tags$div(class = "app-header",
             tags$a(class = "header-logo",
                    href = "https://www.umassd.edu/",
                    target = "_blank",
                    tags$img(class = "logo-image",
                             src = "https://d92mrp7hetgfk.cloudfront.net/images/sites/misc/u_of_massachusetts-dartmouth-1/standard.png?1548463840")),
             tags$div(class = "header-separator"),
             tags$div(class = "header-title", "Practice with ARIMA Time Series Modeling"),
             tags$div(class = "header-info", main_info_modal$init_ui(id = ns("main_info_modal")))
             ),
    
    # ----------------------------
    # ----- Application Body -----
    # ----------------------------
    app_body$init_ui(id = ns("app_body")),
    
    # Adding some white space
    tags$div(class = "white-space"),
    
    # ------------------------------
    # ----- Application footer -----
    # ------------------------------
    tags$footer(class = "app-footer",
                tags$div(class = "message", "Built by Andrew Disher"),
                tags$a(class = "github-link",
                       href = "https://github.com/AndrewDisher",
                       target = "_blank",
                       tags$img(class = "author-img",
                                src = "https://logos-download.com/wp-content/uploads/2016/09/GitHub_logo.png")),
                tags$a(class = "linkedIn-link",
                       href = "https://www.linkedin.com/in/andrew-disher-8b091b212/",
                       target = "_blank",
                       tags$img(class = "author-img",
                                src = "https://pngimg.com/uploads/linkedIn/linkedIn_PNG16.png")),
                tags$a(class = "website-link",
                       href = "https://andrew-disher.netlify.app/",
                       target = "_blank",
                       tags$img(class = "author-img",
                                src = "https://cdn.onlinewebfonts.com/svg/img_1489.png")))
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
    main_info_modal$init_server(id = "main_info_modal")
    app_body$init_server(id = "app_body", arima_sim_data = arima_sim)
    
    # -----------------------------------------
    # ----- Modal for Check Answer Button -----
    # -----------------------------------------
    
  })
}
