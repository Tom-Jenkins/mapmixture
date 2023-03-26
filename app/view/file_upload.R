# app/view/file_upload_table.R

# Import R packages / functions into module
box::use(  
  shiny[moduleServer, NS, tagList, h2, h3, tableOutput, renderTable,
        fluidRow, column, wellPanel, fileInput, br, div, p,
        reactive, req, validate, actionButton],
)

# Import custom R functions into module
box::use(
  app/logic/import_data[import_data],
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
          fileInput(ns("admixture_file"), label = "Admixture file", accept = c(".csv", ".tsv")),
          fileInput(ns("coords_file"), label = "Coordinates file", accept = c(".csv", ".tsv")),
          actionButton(ns("load_example_data"), label = "Use Example Data"),
          actionButton(ns("clear_uploads"), label = "Clear Uploaded Data", onclick = "App.clearUploads()"),
        )
      ),
      column(
        width = 5,
        align="center",
        wellPanel(
          class = "file-upload-tables",
          h3("Admixture Data"),
          br(),
          tableOutput(ns("admixture_table")),
        )
      ),
      column(
        width = 4,
        align="center",
        wellPanel(
          class = "file-upload-tables",
          h3("Coordinates Data"),
          br(),
          tableOutput(ns("coords_table")),
        )
      )
    )
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
    
    # Render admixture table
    output$admixture_table <- renderTable({
      req(admixture_data())
      admixture_data()      
    })

    # Import coordinates data
    coords_data <- reactive({
      req(input$coords_file)
      import_data(input$coords_file)
    })

    # Render coordinates table
    output$coords_table <- renderTable({
      req(coords_data())
      coords_data()
    })

  })
}