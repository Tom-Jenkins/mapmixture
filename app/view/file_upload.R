# app/view/file_upload_table.R

# Import R packages / functions into module
box::use(  
  shiny[moduleServer, NS, tagList, h2, h3, tableOutput, renderTable,
        fluidRow, column, wellPanel, fileInput, br, div, p,
        reactive, req, validate, actionButton, span, strong, splitLayout, icon],
)

# Import custom R functions into module
box::use(
  app/logic/import_data[import_data],
)

# Function to create info modal
# Launch modal when user clicks information icon



#' @export
ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    span(strong("Upload Admixture File"), icon("circle-info", class = "m-1")),
    splitLayout(
      style = "padding-top: 10px;", 
      cellWidths = c("70%", "30%"),
      fileInput(ns("admixture_file"), label = NULL, accept = c(".csv", ".tsv")),
      actionButton(ns("sample_data_admixture_bttn"), "Sample Data", style = "font-size: 13px; height: 37px;"),
    ),
    span(strong("Upload Coordinates File"), icon("circle-info", class = "m-1")),
    splitLayout(
      style = "padding-top: 10px;", 
      cellWidths = c("70%", "30%"),
      fileInput(ns("coords_file"), label = NULL, accept = c(".csv", ".tsv")),
      actionButton(ns("sample_data_coords_bttn"), "Sample Data", style = "font-size: 13px; height: 37px;"),
    ),
    br(),
  )
}


#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    # Import admixture data
    admixture_data <- reactive({
      req(input$admixture_file)
      import_data(input$admixture_file)
    })

    # Import coordinates data
    coords_data <- reactive({
      req(input$coords_file)
      import_data(input$coords_file)
    })

    # Return data as a named list
    return(list(admixture_data = admixture_data, coords_data = coords_data))
  })
}