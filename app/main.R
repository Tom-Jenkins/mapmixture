# app/main.R

# Import functions from packages
box::use(
  shiny[moduleServer, NS, tags, bootstrapPage, navbarPage, tabPanel,
        tabsetPanel, br, div, p],
)

# Call modules
box::use(
  app/view/file_upload_table,
)

# UI COMPONENTS
#' @export
ui <- function(id) {
  ns <- NS(id)
  
  bootstrapPage(
    navbarPage(
      title = "Mapmixture v0.1",
      
      # Tab 1
      tabPanel(
        title = "Plot Admixture",
        tabsetPanel(
          tabPanel(
            title = "Upload",
            br(),
            file_upload_table$ui(ns("table")),
          ),
          tabPanel(
            title = "Bar Chart"
          ),
          tabPanel(
            title = "Pie Chart Map"
          )
        )
      ),
      
      # Tab 2
      tabPanel(
        title = "Data Format",
        # table$ui(ns("table")),
      ),
      
      # Tab 3
      tabPanel(
        title = "FAQs",
        # table$ui(ns("table")),
      )
    )
  )
}

# SERVER COMPONENTS
#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    # code
    file_upload_table$server("table")
  })
}
