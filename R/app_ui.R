#' Application User-Interface
#'
#' @noRd
app_ui <- function() {

  # Add www/ directory to resource path (deployment)
  shiny::addResourcePath(prefix = "www", directoryPath = system.file("www", package = "mapmixture"))

  # Add www/ directory to resource path (developer mode)
  # shiny::addResourcePath(prefix = "www", directoryPath = "./inst/www/")

  # App UI
  shiny::fluidPage(

    # Link to external CSS
    shiny::tags$head(
      shiny::tags$link(rel = "stylesheet", type = "text/css", href = "www/styles.css")
    ),

    # Enable dependencies
    shinyjs::useShinyjs(),
    waiter::useWaiter(),
    shinyFeedback::useShinyFeedback(),

    # Bootstrap version and bootswatch theme ----
    theme = bslib::bs_theme(version = 5, bootswatch = "flatly"),

    # Navbar with title and links ----
    shiny::fluidRow(
      class = "custom-navbar",
      style = "background: #18bc9c; color: white; padding: 10px; margin-bottom: 5px;",
      shiny::span(
        shiny::span(shiny::icon("chart-pie", style = "margin-right: 5px;"), shiny::strong("mapmixture"), shiny::span(class = "badge bg-light mx-1", "1.1.2")),
        shiny::a(
          style = "color: white;",
          href = "https://twitter.com/tom__jenkins",
          target = "_blank",
          shiny::span(style = "float: right;", shiny::icon("twitter", style = "margin-right: 5px;"), "Twitter"),
        ),
        shiny::a(
          style = "color: white;",
          href = "https://github.com/Tom-Jenkins/mapmixture",
          target = "_blank",
          shiny::span(style = "float: right; margin-right: 20px;", shiny::icon("github", style = "margin-right: 5px;"), "GitHub")),
      ),
    ),

    # Sidebar layout with inputs (left) and outputs (right) ----
    shiny::sidebarLayout(

      # Sidebar panel for inputs ----
      shiny::sidebarPanel(
        class = "sidebar-container",

        shiny::div(
          class = "sidebar-nonparam-container",

          # File upload UI module ----
          mod_file_upload_ui("file_upload"),

          # Plot button UI module ----
          mod_plot_bttn_ui("plot_bttn")
        ),

        # Tab panel for map and bar chart input parameters ----
        shiny::span(class = "nav-justified",
                    shiny::tabsetPanel(
            type = "pills",
            id = "options-pills-container",
            # Map parameters
            shiny::tabPanel(
              class = "parameter-options-container primary",
              title = "Map Options",
              mod_map_params_ui("map_params")
              # map_params_module$ui(ns("map_params_module")),
            ),
            # Barplot parameters
            shiny::tabPanel(
              class = "parameter-options-container",
              title = "Barplot Options",
              mod_barplot_params_ui("barplot_params")
            ),
          ),
        ),
      ),

      # Main panel for displaying outputs ----
      shiny::mainPanel(
        shiny::tabsetPanel(
          id = "app-tabset-panel",
          shiny::tabPanel(
            title = "Admixture Map",
            icon = shiny::icon("earth-europe"),
            mod_main_plot_ui("main_plot")
          ),
          shiny::tabPanel(
            title = "Structure Plot",
            icon = shiny::icon("chart-simple"),
            mod_barplot_plot_ui("bar_plot")
          ),
          shiny::tabPanel(
            title = "File Format",
            icon = shiny::icon("file"),
            file_format_content(),
            shiny::br(),
          ),
          shiny::tabPanel(
            title = "Gallery",
            icon = shiny::icon("image"),
            gallery_content(),
            shiny::br(),
          ),
          shiny::tabPanel(
            title = "About",
            icon = shiny::icon("circle-question"),
            about_content(),
          ),
        )
      )

    ),

    # Link to external JavaScript
    shiny::tags$script(src = "www/script.js")
  )
}
