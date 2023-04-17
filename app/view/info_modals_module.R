# app/view/map_params_module.R

# Import R packages / functions into module
box::use(  
  shiny[moduleServer, NS, modalDialog, observeEvent, showModal, modalButton, HTML, strong, br, tagList, div, span, h3],
)

# Import custom R functions into module
box::use(
  app/logic/html_content[html_admixture_sample_table, html_coords_sample_table],
)


#' @export
ui <- function(id) {
  ns <- NS(id)
}


#' @export
server <- function(id, info_bttn_admixture, info_bttn_coords) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    # Admixture table example
    table_admixture <- html_admixture_sample_table()

    # Coordinates table example
    coords_admixture <- html_coords_sample_table()

    # Function to build modal
    build_modal <- function(custom_title, html_content) {
      modalDialog(
        title = strong(custom_title, style = "font-size: larger;"),
        # br(),
        html_content,
        br(),
        div(
          class = "text-center",
          HTML('<button type="button" class="btn btn-success modal-close-bttn" data-dismiss="modal" data-bs-dismiss="modal">Close</button>')
        ),
        footer = NULL, 
        easyClose = TRUE,
        size = "l"
      )
    }

    # Show modal on click of admixture info button
    observeEvent(info_bttn_admixture(), {
        showModal(build_modal("Admixture File Format", table_admixture))
    })

    # Show modal on click of coordinates info button
    observeEvent(info_bttn_coords(), {
        showModal(build_modal("Coordinates File Format", coords_admixture))
    })
    
  })
}



