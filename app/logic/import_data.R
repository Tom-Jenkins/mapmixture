# app/logic/import_data.R

# Import R packages / functions into module
box::use(
    vroom[vroom],
    tools[file_ext],
)

#' @export
import_data <- function(data) {
    file <- data
    ext <- file_ext(file$datapath)
    vroom(file$datapath)
}



