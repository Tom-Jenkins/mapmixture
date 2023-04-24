# app/logic/import_data.R

# Import R packages / functions into module
box::use(
    vroom[vroom],
    tools[file_ext],
    stringr[str_to_lower],
    shinyFeedback[showFeedbackSuccess, showFeedbackWarning, hideFeedback],
)

#' @export
import_user_data <- function(data) {
    file <- data
    ext <- file_ext(file$datapath)

    # Import data via vroom
    data <- vroom(file$datapath)

    # Feedback success if data valid
    # if(data) {
    #   showFeedbackSuccess("admixture_file", color = "#18bc9c", text = NULL)
    # }

    # Convert headers to lowercase
    colnames(data) <- str_to_lower(colnames(data))

    # Return data
    return(data)
}

#' @export
import_sample_data <- function(data) {

    # Import data via vroom
    data <- vroom(data)

    # Convert headers to lowercase
    colnames(data) <- str_to_lower(colnames(data))

    # Return data
    return(data)
}

