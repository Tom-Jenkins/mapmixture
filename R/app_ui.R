#' Application User-Interface
#'
#' @noRd
#' @import shiny
#' @importFrom bslib bs_theme
#' @importFrom htmltools HTML htmlDependency
#' @importFrom shinyjs useShinyjs
#' @importFrom waiter useWaiter
#' @importFrom shinyFeedback useShinyFeedback

app_ui <- function() {

  # Add www/ directory to resource path
  addResourcePath(prefix = "www", directoryPath = system.file("www", package = "mapmixture"))

  # App UI
  fluidPage(

    # Link to external CSS
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "www/styles.css")
    ),

    # Enable dependencies
    useShinyjs(),
    useWaiter(),
    useShinyFeedback(),

    # Bootstrap version and bootswatch theme ----
    theme = bs_theme(version = 5, bootswatch = "flatly"),

    # Navbar with title and links ----
    fluidRow(
      class = "custom-navbar",
      style = "background: #18bc9c; color: white; padding: 10px; margin-bottom: 5px;",
      span(
        span(icon("chart-pie", style = "margin-right: 5px;"), strong("Mapmixture"), span(class = "badge bg-light mx-1", "1.1.0")),
        a(
          style = "color: white;",
          href = "https://twitter.com/tom__jenkins",
          target = "_blank",
          span(style = "float: right;", icon("twitter", style = "margin-right: 5px;"), "Twitter"),
        ),
        a(
          style = "color: white;",
          href = "https://github.com/Tom-Jenkins/Mapmixture",
          target = "_blank",
          span(style = "float: right; margin-right: 20px;", icon("github", style = "margin-right: 5px;"), "GitHub")),
      ),
    ),

    # Sidebar layout with inputs (left) and outputs (right) ----
    sidebarLayout(

      # Sidebar panel for inputs ----
      sidebarPanel(
        class = "sidebar-container",

        div(
          class = "sidebar-nonparam-container",

          # File upload UI module ----
          mod_file_upload_ui("file_upload"),

          # Plot button UI module ----
          mod_plot_bttn_ui("plot_bttn")
        ),

        # Tab panel for map and bar chart input parameters ----
        div(class = "nav-justified",
            tabsetPanel(
              type = "pills",
              id = "options-pills-container",
              tabPanel(
                class = "parameter-options-container",
                title = "Map Options",
                mod_map_params_ui("map_params")
                # map_params_module$ui(ns("map_params_module")),
              )
            )
        ),
      ),

      # Main panel for displaying outputs ----
      mainPanel(
        tabsetPanel(
          tabPanel(
            title = "Admixture Map",
            icon = icon("earth-europe"),
            mod_main_plot_ui("main_plot")
          ),
          tabPanel(
            title = "File Format",
            icon = icon("file"),
            file_format_content(),
            br(),
          ),
          tabPanel(
            title = "Gallery",
            icon = icon("image"),
            gallery_content(),
            br(),
          ),
          tabPanel(
            title = "About",
            icon = icon("circle-question"),
            about_content(),
          ),
        )
      )

    ),

    # Link to external JavaScript
    tags$script(src = "www/script.js")
  )
}
