# -------------------------------------------------------------------------
# ---------------------------- Libraries/Packages -------------------------
# -------------------------------------------------------------------------

box::use(
  shiny[a, br, div, h4, p, span],
  shiny.semantic[action_button, modal]
)

# -------------------------------------------------------------------------
# ---------------------------------- Modules ------------------------------
# -------------------------------------------------------------------------

# box::use(
#   
# )

# --------------------------------------------
# ----- Function to Build the Info Modal -----
# --------------------------------------------

#' @export
build_modal <- function(modal_id) {
  modal(
    id = modal_id,
    header = list(h4(class = "modal-title",
                          "Practice with ARIMA Time Series Modeling")),
    footer = action_button(input_id = "dismiss_modal",
                           label = "Dismiss",
                           class = "ui positive button"),
    settings = list(c("transition", "fly down")),
    content = list(
      # ---------------------------------
      # ----- About the Application -----
      # ---------------------------------
      h4(class = "modal-description-header", "About the Project"),
      
      p(class = "modal-paragraph", "This is some text"),
      br(),
      
      # ------------------------------------------
      # ----- Tech Stack Used in Application -----
      # ------------------------------------------
      h4(class = "modal-description-header", "Technologies Used"),
      div(class = "technology-grid",
          div(class = "left-description", span(style = "font-weight: bold;", "Technology Stack:")),
          div(class = "right-tech-used",
              a(href = "https://www.r-project.org/",
                target = "_blank",
                span(class = "tech-span", "R")), 
              a(href = "https://www.rstudio.com/products/shiny/",
                target = "_blank",
                span(class = "tech-span", "R/Shiny")),
              a(href = "https://developer.mozilla.org/en-US/docs/Web/HTML", 
                target = "_blank",
                span(class = "tech-span", "HTML")),
              a(href = "https://developer.mozilla.org/en-US/docs/Web/CSS", 
                target = "_blank",
                span(class = "tech-span", "CSS")),
              a(href = "https://aws.amazon.com/ec2/", 
                target = "_blank",
                span(class = "tech-span", "AWS EC2")),
              a(href = "https://www.docker.com/", 
                target = "_blank",
                span(class = "tech-span", "Docker"))
          )
      ),
      br(),
      
      # ------------------------------
      # ----- Notable R Packages -----
      # ------------------------------
      div(class = "technology-grid",
          div(class = "left-description",
              span(style = "font-weight: bold;", "Notable R Packages:")),
          div(class = "right-tech-used",
              a(href = "https://ggplot2.tidyverse.org/index.html",
                target = "_blank",
                span(class = "tech-span", "ggplot2")),
              a(href = "https://rstudio.github.io/renv/articles/renv.html",
                target = "_blank", 
                span(class = "tech-span", "renv")),
              a(href = "https://klmr.me/box/",
                target = "_blank",
                span(class = "tech-span", "box")),
              a(href = "https://dplyr.tidyverse.org/",
                target = "_blank", 
                span(class = "tech-span", "dplyr")),
              a(href = "https://appsilon.github.io/rhino/",
                target = "_blank", 
                span(class = "tech-span", "rhino")),
              a(href = "https://appsilon.github.io/shiny.semantic/",
                target = "_blank", 
                span(class = "tech-span", "shiny.semantic")),
              a(href = "https://pkg.robjhyndman.com/forecast/",
                target = "_blank", 
                span(class = "tech-span", "forecast"))
          )
      ),
      br(),
      
      # ----------------------------
      # ----- About the Author -----
      # ----------------------------
      h4(class = "modal-description-header", "About the Author"),
      div(class = "author-description",
          "My name is Andrew Disher and I am a Data Science Master's student at the
          University of Massachusetts Dartmouth. Among other things, I delight in building 
          R Shiny applications that showcase the collective power of R, Shiny, HTML, CSS, and
          a suite of other readily available web technologies, all to better communicate data. You can reach me
          via LinkedIn, and browse some of my other work available on GitHub and my website. Cheers!")
    )
  )
}
