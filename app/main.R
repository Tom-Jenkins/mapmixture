# app/main.R

# Import R packages / functions into module
box::use(
  shiny[moduleServer, NS, tags, fluidPage, fluidRow, span, h1, h2, h3, h4, strong, icon, p, a],
  bslib[bs_theme],
)

# Call modules
box::use(
  app/view/file_upload,
  app/view/barchart_module,
  app/view/map_module,
)


# UI COMPONENTS
#' @export
ui <- function(id) {
  ns <- NS(id)
  
  fluidPage(
    theme = bs_theme(version = 5, bootswatch = "flatly"),
    # MAPMIXTURE TITLE ROW
    fluidRow(
      # class = "mapmixture-title",
      style = "background: #18bc9c; color: white; padding: 10px; margin-bottom: 5px;",
      span(
        span(icon("chart-pie", style = "margin-right: 5px;"), strong("Mapmixture v0.1")),
        a(
          style = "color: white;",
          href = "https://twitter.com/tom__jenkins",
          target = "_blank",
          span(style = "float: right;", icon("twitter", style = "margin-right: 5px;"), "Twitter"),
        ),        
        a(
          style = "color: white;",
          href = "https://github.com/Tom-Jenkins",
          target = "_blank",
          span(style = "float: right; margin-right: 20px;", icon("github", style = "margin-right: 5px;"), "GitHub")),
      ),
    ),
    map_module$ui(ns("map_module")),
  )
}


# SERVER COMPONENTS
#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    # File upload module
    file_upload$server("file_upload")

    # Bar chart module
    barchart_module$server("barchart_module")

    # Map pie chart module
    map_module$server("map_module")
  })
}
