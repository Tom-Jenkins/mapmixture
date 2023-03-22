# app/view/file_upload_table.R

box::use(
  # Import R packages into module
  shiny[moduleServer, NS, tagList, h3, tableOutput, renderTable,
        fluidRow, column, wellPanel, fileInput, br, div, p,
        reactive, req, validate],
  vroom,
)


#' @export
ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    fluidRow(
      column(
        width = 3,
        wellPanel(
          h3("Upload File(s)"),
          br(),
          fileInput("admixture", label = "Admixture file"),
          fileInput("temp2", label = "Coordinates file"),  
        )
      ),
      column(
        width = 9,
        p("No file(s) uploaded."),
        tableOutput(ns("table")),
      )
    )
  )
}


#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    # Import admixture data
    # admixture_data <- reactive({
    #   req(input$admixture)
    #   
    #   vroom$vroom(input$file)
    #   
    # })

    # Render admixture table
    # output$table <- renderTable({
    #   admixture_data()
    #   })

    output$table <- renderTable(datasets::iris)
    
    
    
  })
}