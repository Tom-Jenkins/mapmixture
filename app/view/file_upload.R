# app/view/file_upload.R

# Import R packages / functions into module
box::use(  
  shiny[moduleServer, NS, tagList, tags, fileInput, span, splitLayout, actionButton, strong, icon, reactive, req, observeEvent, eventReactive, reactiveVal, reactiveValues, observe, HTML, div, isolate],
  shinyjs[useShinyjs, onclick, onevent, runjs],
  shinyFeedback[useShinyFeedback, showFeedbackWarning, showFeedbackSuccess, hideFeedback],
  vroom[vroom]
)

# Import custom R functions into module
box::use(
  app/logic/import_data[import_user_data, import_sample_data],
)


#' @export
ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    useShinyjs(),
    useShinyFeedback(),

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
      cellArgs = list(style = "overflow: hidden;"),
      fileInput(ns("admixture_file"), label = NULL, accept = c(".csv", ".tsv")),
      # tags$button(id = ns("load_sample_data_admixture_bttn"), class = "btn btn-default action-button shiny-bound-input sample-data-bttn", HTML("Load Sample Data")),
    ),

    # Coordinates file upload ----
    span(
      strong("Upload Coordinates File"),
      tags$button(id = ns("coords_info_bttn"), class = "btn action-button info-modal-bttn", icon("circle-info")),
    ),
    splitLayout(
      style = "padding-top: 10px;", 
      cellWidths = c("70%", "30%"),
      cellArgs = list(style = "overflow: hidden;"),
      fileInput(ns("coords_file"), label = NULL, accept = c(".csv", ".tsv")),
      # tags$button(id = ns("load_sample_data_coords_bttn"), class = "btn btn-default action-button shiny-bound-input sample-data-bttn", HTML("Load Sample Data")),
    ),
  )
}


#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    # Import user admixture data ----
    admixture_data <- reactive({
      req(input$admixture_file)
      import_user_data(input$admixture_file)
    })

    # Import user coordinates data ----
    coords_data <- reactive({
      req(input$coords_file)
      import_user_data(input$coords_file)
    })

    # # Import sample admixture data ----
    # admixture_sample <- import_sample_data("./app/static/data/admixture_example.csv")
    # observeEvent(input$load_sample_data_admixture_bttn, {
    #   runjs("App.renderSampleData('admixture')")
    #   # print(admixture_sample)
    # })

    # # Import sample coordinates data ----
    # coords_sample <- import_sample_data("./app/static/data/coordinates_example.csv")
    # observeEvent(input$load_sample_data_coords_bttn, {
    #   runjs("App.renderSampleData('coordinates')")
    #   # print(coords_sample)
    # })

    # Admixture info button event
    admixture_info_bttn <- reactive(input$admixture_info_bttn)

    # Coordinates info button event
    coords_info_bttn <- reactive(input$coords_info_bttn)

    # Return data as a named list ----
    return(list(
      admixture_data = admixture_data,
      coords_data = coords_data,
      admixture_info_bttn = admixture_info_bttn,
      coords_info_bttn = coords_info_bttn
    ))    
    
  })
}