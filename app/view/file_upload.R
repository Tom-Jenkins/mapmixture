# app/view/file_upload_table.R

# Import R packages / functions into module
box::use(  
  shiny[moduleServer, NS, tagList, tags, fileInput, span, splitLayout, actionButton, strong, icon, reactive, req, observeEvent, modalDialog, modalButton, showModal],
)

# Import custom R functions into module
box::use(
  app/logic/import_data[import_data],
)


#' @export
ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    # useSweetAlert(),

    # Do not display the progress bar on file input ----
    tags$style(".shiny-file-input-progress {display: none}"),

    # Admixture file upload ----
    span(
      strong("Upload Admixture File"),
      tags$button(id = ns("admixture_info_bttn"), class = "btn action-button info-modal-bttn", icon("circle-info")),
    ),
    splitLayout(
      style = "padding-top: 10px;", 
      cellWidths = c("70%", "30%"),
      fileInput(ns("admixture_file"), label = NULL, accept = c(".csv", ".tsv")),
      actionButton(ns("sample_data_admixture_bttn"), "Sample Data", style = "font-size: 13px; height: 37px;"),
    ),

    # Coordinates file upload ----
    span(
      strong("Upload Coordinates File"),
      tags$button(id = ns("coords_info_bttn"), class = "btn action-button info-modal-bttn", icon("circle-info")),
    ),
    splitLayout(
      style = "padding-top: 10px;", 
      cellWidths = c("70%", "30%"),
      fileInput(ns("coords_file"), label = NULL, accept = c(".csv", ".tsv")),
      actionButton(ns("sample_data_coords_bttn"), "Sample Data", style = "font-size: 13px; height: 37px;"),
    ),
  )
}


#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    # Import admixture data ----
    admixture_data <- reactive({
      req(input$admixture_file)
      import_data(input$admixture_file)
    })

    # Import coordinates data ----
    coords_data <- reactive({
      req(input$coords_file)
      import_data(input$coords_file)
    })

    # Admixture info button event
    admixture_info_bttn <- reactive(input$admixture_info_bttn)

    # Coordinates info button event
    coords_info_bttn <- reactive(input$coords_info_bttn)

    # Return data as a named list ----
    return(list(admixture_data = admixture_data, coords_data = coords_data, admixture_info_bttn = admixture_info_bttn, coords_info_bttn = coords_info_bttn))    
    
  })
}