#' Application User-Interface
#'
#' @noRd
#' @importFrom shiny addResourcePath fluidPage tags fluidRow span icon strong a sidebarLayout sidebarPanel div tabsetPanel tabPanel mainPanel

app_ui <- function() {

  # Add www/ directory to resource path (deployment)
  addResourcePath(prefix = "www", directoryPath = system.file("www", package = "mapmixture"))

  # Add www/ directory to resource path (developer mode)
  # addResourcePath(prefix = "www", directoryPath = "./inst/www/")

  # App UI
  fluidPage(

    # Link to external CSS
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "www/styles.css")
    ),

    # Enable dependencies
    shinyjs::useShinyjs(),
    waiter::useWaiter(),
    shinyFeedback::useShinyFeedback(),

    # Bootstrap version and bootswatch theme ----
    theme = bslib::bs_theme(version = 5, bootswatch = "flatly"),

    # Navbar with title and links ----
    fluidRow(
      class = "custom-navbar",
      style = "background: #18bc9c; color: white; padding: 10px; margin-bottom: 5px;",
      span(
        span(icon("chart-pie", style = "margin-right: 5px;"), strong("mapmixture"), span(class = "badge bg-light mx-1", "1.1.2")),
        a(
          style = "color: white;",
          href = "https://twitter.com/tom__jenkins",
          target = "_blank",
          span(style = "float: right;", icon("twitter", style = "margin-right: 5px;"), "Twitter"),
        ),
        a(
          style = "color: white;",
          href = "https://github.com/Tom-Jenkins/mapmixture",
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
        span(class = "nav-justified",
          tabsetPanel(
            type = "pills",
            id = "options-pills-container",
            # Map parameters
            tabPanel(
              class = "parameter-options-container primary",
              title = "Map Options",
              mod_map_params_ui("map_params")
              # map_params_module$ui(ns("map_params_module")),
            ),
            # Barplot parameters
            tabPanel(
              class = "parameter-options-container",
              title = "Barplot Options",
              mod_barplot_params_ui("barplot_params")
            ),
          ),
        ),
      ),

      # Main panel for displaying outputs ----
      mainPanel(
        tabsetPanel(
          id = "app-tabset-panel",
          tabPanel(
            title = "Admixture Map",
            icon = icon("earth-europe"),
            mod_main_plot_ui("main_plot")
          ),
          tabPanel(
            title = "Structure Plot",
            icon = icon("chart-simple"),
            mod_barplot_plot_ui("bar_plot")
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
