# app/logic/import_data.R

# Import R packages / functions into module
box::use(
    vroom[vroom],
    tools[file_ext],
    stringr[str_to_lower],
)

#' @export
import_data <- function(data) {
    file <- data
    ext <- file_ext(file$datapath)
    data <- vroom(file$datapath)

    # Convert headers to lowercase
    colnames(data) <- str_to_lower(colnames(data))

    # Return data
    return(data)
}



