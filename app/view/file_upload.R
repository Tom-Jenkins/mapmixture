# app/view/file_upload.R

# Import R packages / functions into module
box::use(  
  shiny[moduleServer, NS, tagList, tags, fileInput, span, splitLayout, actionButton, strong, icon, reactive, req, observeEvent, eventReactive, reactiveVal, reactiveValues, observe, HTML, div, isolate],
  shinyjs[useShinyjs, runjs],
  vroom[vroom],
  tools[file_ext],
  stringr[str_to_lower],
  purrr[map_lgl],
)


#' @export
ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    useShinyjs(),

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
      fileInput(ns("admixture_file"), label = NULL, accept = c(".csv", ".tsv", ".txt"), placeholder = ".csv | .tsv | .txt"),
      div(
        icon("circle-check", class = "fa-solid fa-xl hidden", id = "admixture-success", style="color: #18bc9c; padding-top: 18px; padding-left: 10px;"),
        icon("circle-exclamation", class = "fa-solid fa-xl hidden", id = "admixture-warning", style="color: #f39c12; padding-top: 18px; padding-left: 10px;")
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
        icon("circle-check", class = "fa-solid fa-xl hidden", id = "coords-success", style="color: #18bc9c; padding-top: 18px; padding-left: 10px;"),
        icon("circle-exclamation", class = "fa-solid fa-xl hidden", id = "coords-warning", style="color: #f39c12; padding-top: 18px; padding-left: 10px;")
      ),
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

      # Activate hidden class for all admixture icons
      runjs("document.getElementById('admixture-success').classList.add('hidden')")
      runjs("document.getElementById('admixture-warning').classList.add('hidden')")

      # Remove all previous error messages from UI
      runjs("if(document.getElementById('admixture-error-message')) document.getElementById('admixture-error-message').remove()")
      
      # Import user data
      ext <- file_ext(input$admixture_file$datapath)
      dataset_admix <- vroom(input$admixture_file$datapath)

      # Rename first and second column names
      colnames(dataset_admix)[1] <- "Site"
      colnames(dataset_admix)[2] <- "Ind"

      # Convert first two column to character type
      dataset_admix[[1]] <- as.character(dataset_admix[[1]])
      dataset_admix[[2]] <- as.character(dataset_admix[[2]])

      # Validation ----
      na_admix <- which(colSums(is.na(dataset_admix)) > 0)
      cluster_cols <- dataset_admix[, 3:ncol(dataset_admix)]
      colN_type <- map_lgl(cluster_cols, is.double)

      # 1. Check for NAs by column ----
      if (length(na_admix != 0)) {
        # NA in column 1
        if (1 %in% na_admix) {
          runjs("App.renderFeedbackWarning('admixture', 'Empty cell or NA in column 1. Ensure all cells have a site label.')")
        # NA in column 2
        } else if (2 %in% na_admix) {
          runjs("App.renderFeedbackWarning('admixture', 'Empty cell or NA in column 2. Ensure all cells have an individual label.')")
        # NA in columns 3:n
        } else {
          # runjs("App.renderFeedbackWarning('admixture', 'Empty cell or NA in cluster column(s). Ensure all cells have a number and put zero for no admixture.')")
          runjs(
            paste0(
              "App.renderFeedbackWarning('admixture', 'Empty cell or NA in column ", toString(na_admix), ". Ensure all cells in cluster column have an integer or decimal from 0–1.')"
            )
          )
        }

      # 2. Check cluster columns 3:n are all of type numeric (double) ----
      } else if (FALSE %in% colN_type) {
        # runjs("App.renderFeedbackWarning('admixture', 'Incorrect data type in cluster column(s). Ensure all cells have an integer or decimal from 0–1.')")
        runjs(
          paste0(
            "App.renderFeedbackWarning('admixture', 'Incorrect data type in column ", toString(which(!colN_type)+2), ". Ensure all cells in cluster column have an integer or decimal from 0–1.')"
          )
        )

      # 3. Check all cluster rows add up to exactly 1 ----
      } else if (all(round(rowSums(cluster_cols), digits = 5) == 1) == FALSE) { # Fixed bug "Fix cluster sum bug" 8a4144a
        runjs(
          paste0(
            "App.renderFeedbackWarning('admixture', 'One or more cluster rows do not add up to 1. Check admixture proportions in row ", toString(which(rowSums(cluster_cols) != 1)), ".')"
          )
        )
        
      # If data valid then print success message to UI, convert colnames to lower case and return data
      } else {
        runjs("App.renderFeedbackSuccess('admixture')")
        colnames(dataset_admix) <- str_to_lower(colnames(dataset_admix))
        return(dataset_admix)
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
      
      # Import user data
      ext <- file_ext(input$coords_file$datapath)
      dataset_coords <- vroom(input$coords_file$datapath)

      # Rename first, second and third column names
      colnames(dataset_coords)[1] <- "Site"
      colnames(dataset_coords)[2] <- "Lat"
      colnames(dataset_coords)[3] <- "Lon"

      # Convert first column to character type
      dataset_coords[[1]] <- as.character(dataset_coords[[1]])

      # Validation ----
      na_coords <- which(colSums(is.na(dataset_coords)) > 0)
      coords_siteIDs <- sort(dataset_coords[[1]]) # coordinates file unique site IDs
      admix_siteIDs <- sort(unique(admixture_data()[[1]])) # admixture file unique site IDs


      # 1. Check for NAs by column ----
      if (length(na_coords != 0)) {
        # NA in column 1
        if (1 %in% na_coords) {
          runjs("App.renderFeedbackWarning('coords', 'Empty cell or NA in column 1. Ensure all cells have a site label.')")
        # NA in column 2
        } else if (2 %in% na_coords) {
          runjs("App.renderFeedbackWarning('coords', 'Empty cell or NA in column 2. Ensure all cells have a latitude decimal.')")
        # NA in column 3
        } else if (3 %in% na_coords) {
          runjs("App.renderFeedbackWarning('coords', 'Empty cell or NA in column 3. Ensure all cells have a longitude decimal.')")
        }
      
      # 2. Check for Lat and Lon types ----
      } else if (is.double(dataset_coords[[2]]) == FALSE) {
        runjs("App.renderFeedbackWarning('coords', 'Incorrect data type in column 2. Ensure all cells have a latitude decimal.')")
      } else if (is.double(dataset_coords[[3]]) == FALSE) {
        runjs("App.renderFeedbackWarning('coords', 'Incorrect data type in column 3. Ensure all cells have a longitude decimal.')")

      # 3. Check coordinate site IDs exactly match admixture site IDs
      } else if (all(coords_siteIDs == admix_siteIDs) == FALSE) {
        runjs("App.renderFeedbackWarning('coords', 'Site IDs do not match. Ensure site IDs are present and match in both admixture and coordinates files.')")

      # If data valid then print success message to UI, convert colnames to lower case and return data
      } else {
        runjs("App.renderFeedbackSuccess('coords')")
        colnames(dataset_coords) <- str_to_lower(colnames(dataset_coords))
        return(dataset_coords)
      }
    })


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