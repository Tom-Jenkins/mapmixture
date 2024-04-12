#' File Upload Module: UI
#'
#' @noRd
#' @importFrom shiny NS tagList tags span strong icon splitLayout div fileInput
mod_file_upload_ui <- function(id){
  ns <- NS(id)
  tagList(

    # Admixture file upload ----
    span(
      strong("Upload Admixture File"),
      tags$button(id = ns("admixture_info_bttn"), class = "btn action-button info-modal-bttn", icon("circle-info")),
    ),
    splitLayout(
      style = "padding-top: 10px;",
      cellWidths = c("70%", "30%"),
      cellArgs = list(style = "overflow: hidden;"),
      fileInput(ns("admixture_file"), label = NULL, accept = c(".csv", ".tsv", ".txt"), placeholder = ".csv | .tsv | .txt"),
      div(
        icon("circle-check", class = "fa-solid fa-xl hidden", id = "admixture-success", style="color: #18bc9c; padding-top: 18px; padding-left: 10px; padding-bottom: 20px;"),
        icon("circle-exclamation", class = "fa-solid fa-xl hidden", id = "admixture-warning", style="color: #f39c12; padding-top: 18px; padding-left: 10px; padding-bottom: 20px;")
      ),
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
      fileInput(ns("coords_file"), label = NULL, accept = c(".csv", ".tsv", ".txt"), placeholder = ".csv | .tsv | .txt"),
      div(
        icon("circle-check", class = "fa-solid fa-xl hidden", id = "coords-success", style="color: #18bc9c; padding-top: 18px; padding-left: 10px; padding-bottom: 20px;"),
        icon("circle-exclamation", class = "fa-solid fa-xl hidden", id = "coords-warning", style="color: #f39c12; padding-top: 18px; padding-left: 10px; padding-bottom: 20px;")
      ),
    ),
  )
}

#' File Upload Module: Server
#'
#' @noRd
#' @importFrom shiny moduleServer reactive req observe
#' @importFrom shinyjs runjs
mod_file_upload_server <- function(id){
  moduleServer(id, function(input, output, session){
    ns <- session$ns

    # Import user admixture data ----
    admixture_data <- reactive({
      req(input$admixture_file)

      # Activate hidden class for all admixture icons
      runjs("document.getElementById('admixture-success').classList.add('hidden')")
      runjs("document.getElementById('admixture-warning').classList.add('hidden')")

      # Disable button if not already disabled
      runjs("document.getElementById('plot_bttn-plot_bar_bttn').classList.add('disabled')")
      runjs("document.getElementById('options-pills-container').style.pointerEvents = 'none';")

      # Remove all previous error messages from UI
      runjs("if(document.getElementById('admixture-error-message')) document.getElementById('admixture-error-message').remove()")

      # Read in user data
      admix_df <- read_input_data(input$admixture_file$datapath)


      # Validation ----

      # Check data has been read properly as a data.frame with three or more columns
      if (!ncol(admix_df) >= 3) {
        runjs("renderFeedbackWarning('admixture', 'Invalid file. Please upload a valid comma-separated values or tab-separated values file.')")
      } else{

        # Extract data to test
        na_admix <- which(colSums(is.na(admix_df) | admix_df == "") > 0) # NAs or blank space in data
        cluster_cols <- admix_df[, 3:ncol(admix_df)] # subset cluster columns
        colN_type <- purrr::map_lgl(cluster_cols, is.numeric) # cluster column type

        # 1. Check for NAs by column ----
        if (length(na_admix != 0)) {
          # NA in column 1
          if (1 %in% na_admix) {
            runjs("renderFeedbackWarning('admixture', 'Empty cell or NA in column 1. Ensure all cells have a site label.')")
            # NA in column 2
          } else if (2 %in% na_admix) {
            runjs("renderFeedbackWarning('admixture', 'Empty cell or NA in column 2. Ensure all cells have an individual label.')")
            # NA in columns 3:n
          } else {
            runjs(
              paste0(
                "renderFeedbackWarning('admixture', 'Empty cell or NA in column ", toString(na_admix), ". Ensure all cells in cluster column have an integer or decimal from 0-1.')"
              )
            )
          }

          # 2. Check cluster columns 3:n are all of type numeric ----
        } else if (FALSE %in% colN_type) {
          runjs(
            paste0(
              "renderFeedbackWarning('admixture', 'Incorrect data type in column ", toString(which(!colN_type)+2), ". Ensure all cells in cluster column have an integer or decimal from 0-1.')"
            )
          )

        #   # 3. Check all cluster rows add up to exactly 1 ----
        # } else if (all(round(rowSums(cluster_cols), digits = 5) == 1) == FALSE) { # Fixed bug "Fix cluster sum bug" 8a4144a
        #   runjs(
        #     paste0(
        #       "renderFeedbackWarning('admixture', 'One or more cluster rows do not add up to 1. Check admixture proportions in row ", toString(which(rowSums(cluster_cols) != 1)), ".')"
        #     )
        #   )

          # If data valid then print success message to UI, convert colnames to lower case and return data
        } else {
          runjs("renderFeedbackSuccess('admixture')")

          # Remove disabled class from Plot Bar button when valid status is TRUE
          runjs("document.getElementById('plot_bttn-plot_bar_bttn').classList.remove('disabled');")

          # Enable pointer event on parameter pills
          runjs("document.getElementById('options-pills-container').style.pointerEvents = 'auto';")

          return(admix_df)
        }
      }
    })


    # Import user coordinates data ----
    coords_data <- reactive({
      req(input$coords_file)

      # Activate hidden class for all coords icons
      runjs("document.getElementById('coords-success').classList.add('hidden')")
      runjs("document.getElementById('coords-warning').classList.add('hidden')")

      # Remove all previous error messages from UI
      runjs("if(document.getElementById('coords-error-message')) document.getElementById('coords-error-message').remove()")

      # Process user data
      coords_df <- read_input_data(input$coords_file$datapath)


      # Validation ----

      # Check data has been read properly as a data.frame with three columns
      if (ncol(coords_df) != 3) {
        runjs("renderFeedbackWarning('coords', 'Invalid file. Please upload a valid comma-separated values or tab-separated values file.')")
      } else {

        # Extract data to test
        na_coords <- which(colSums(is.na(coords_df) | coords_df == "") > 0)
        coords_siteIDs <- sort(coords_df[[1]]) # coordinates file unique site IDs
        admix_siteIDs <- sort(unique(admixture_data()[[1]])) # admixture file unique site IDs

        # 1. Check for NAs by column ----
        if (length(na_coords != 0)) {
          # NA in column 1
          if (1 %in% na_coords) {
            runjs("renderFeedbackWarning('coords', 'Empty cell or NA in column 1. Ensure all cells have a site label.')")
            # NA in column 2
          } else if (2 %in% na_coords) {
            runjs("renderFeedbackWarning('coords', 'Empty cell or NA in column 2. Ensure all cells have a latitude decimal.')")
            # NA in column 3
          } else if (3 %in% na_coords) {
            runjs("renderFeedbackWarning('coords', 'Empty cell or NA in column 3. Ensure all cells have a longitude decimal.')")
          }

          # 2. Check for Lat and Lon types ----
        } else if (is.double(coords_df[[2]]) == FALSE) {
          runjs("renderFeedbackWarning('coords', 'Incorrect data type in column 2. Ensure all cells have a latitude decimal.')")
        } else if (is.double(coords_df[[3]]) == FALSE) {
          runjs("renderFeedbackWarning('coords', 'Incorrect data type in column 3. Ensure all cells have a longitude decimal.')")

          # 3. Check coordinate site IDs exactly match admixture site IDs
        } else if (all(coords_siteIDs == admix_siteIDs) == FALSE) {
          runjs("renderFeedbackWarning('coords', 'Site IDs do not match. Ensure site IDs are present and match in both admixture and coordinates files.')")

          # If data valid then print success message to UI, convert colnames to lower case and return data
        } else {
          runjs("renderFeedbackSuccess('coords')")
          return(coords_df)
        }
      }
    })


    # Check validation status of admixture and coordinates user input ----
    input_valid <- reactive({
      # Check if both admixture_data() and coords_data() are not NULL (indicating successful validation)
      if (!is.null(admixture_data()) && !is.null(coords_data())) {
        return(TRUE)  # Validation successful
      } else {
        return(FALSE) # Validation not successful
      }
    })

    # Remove disabled class from Plot Map button when valid status is TRUE
    observe({
      # If TRUE
      if (input_valid()) {
        runjs("document.getElementById('plot_bttn-plot_map_bttn').classList.remove('disabled')")
      }
      # If FALSE
      if (!input_valid()) {
        runjs("document.getElementById('plot_bttn-plot_map_bttn').classList.add('disabled')")
      }
    })


    # Capture admixture info button click event ----
    admixture_info_bttn <- reactive(input$admixture_info_bttn)

    # Capture coordinates info button click event ----
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
