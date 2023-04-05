# app/main.R

# Import R packages / functions into module
box::use(
  shiny[moduleServer, NS, tags, fluidPage, fluidRow, span, h1, h2, h3, h4, strong, icon, p, a, sidebarLayout, sidebarPanel, mainPanel, fileInput, tabsetPanel, tabPanel, div, actionButton, splitLayout, br, renderTable, tableOutput, req, callModule, reactive, column, plotOutput, uiOutput],
  bslib[bs_theme],
  sf[st_read],
)

# Import modules
box::use(
  app/view/file_upload,
  app/view/barchart_module,
  app/view/map_module,
  app/view/map_params_module,
)

# Load static data
world_data <- st_read("./app/static/data/world.gpkg")


# UI COMPONENTS
#' @export
ui <- function(id) {
  ns <- NS(id)
  
  fluidPage(

    # Bootstrap version and bootswatch theme ----
    theme = bs_theme(version = 5, bootswatch = "flatly"),

    # Navbar with title and links ----
    fluidRow(
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
    # Sidebar layout with inputs (left) and outputs (right) ----
    sidebarLayout(

      # Sidebar panel for inputs ----
      sidebarPanel(

        # File upload UI module ----
        file_upload$ui(ns("file_upload")),

        # Tab panel for map and bar chart input options ----
        div(class = "nav-justified",
          tabsetPanel(
            type = "pills",
            tabPanel(
              title = "Map Options",
              map_params_module$ui(ns("map_params_module")),
            ),
            tabPanel(
              class = "nav-fill",
              title = "Bar Chart Options",
            ),
          ),
        ),
      ),

      # Main panel for displaying outputs ----
      mainPanel(
        tabsetPanel(
          tabPanel(
            title = "Admixture Map",
            icon = icon("earth-europe"),
            fluidRow(
              column(6, tableOutput(ns("admixture_table"))),
              column(6, tableOutput(ns("coords_table"))),
            ),            
            # uiOutput(ns("download_bttn")),
            # plotOutput(ns("example_map"), height = "800px", width = "100%"),
          ),
          tabPanel(
            title = "Bar Chart",
            icon = icon("chart-simple"),
            #TBC
          ),
          tabPanel(
            title = "FAQs",
            icon = icon("circle-question"),
            #TBC
          ),
        )
      )
    )
    # map_module$ui(ns("map_module")),
  )
}


# SERVER COMPONENTS
#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    # Import data from file upload module
    admixture_data <- file_upload$server("file_upload")[["admixture_data"]]
    coords_data <- file_upload$server("file_upload")[["coords_data"]]
    
    # Render admixture table
    output$admixture_table <- renderTable({
      req(admixture_data())
      admixture_data()
    })

    # Render coords table
    output$coords_table <- renderTable({
      req(coords_data())
      coords_data()
    })

    # file_upload$server("file_upload")

    # Bar chart module
    # barchart_module$server("barchart_module")

    # Map parameters module
    map_params_module$server("map_params_module", dataframe = admixture_data)
  })
}
