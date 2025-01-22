#' Information Modals Module: UI
#'
#' @noRd
mod_info_modals_ui <- function(id){
  ns <- shiny::NS(id)
  shiny::tagList(

  )
}

#' Information Modals Module: Server
#'
#' @noRd
mod_info_modals_server <- function(id, admixture_info_bttn, coords_info_bttn){
  shiny::moduleServer( id, function(input, output, session){
    ns <- session$ns

    # Admixture table example (mod_info_modals_utils_sample_table_html.R)
    table_admixture <- admixture_sample_table()

    # Coordinates table example (mod_info_modals_utils_sample_table_html.R)
    table_coords <- coords_sample_table()

    # Function to build modal
    build_modal <- function(custom_title, html_content) {
      shiny::modalDialog(
        title = shiny::strong(custom_title, style = "font-size: larger;"),
        html_content,
        shiny::br(),
        shiny::div(
          class = "text-center",
          htmltools::HTML('<button type="button" class="btn btn-success modal-close-bttn" data-dismiss="modal" data-bs-dismiss="modal">Close</button>')
        ),
        footer = NULL,
        easyClose = TRUE,
        size = "l"
      )
    }

    # Show modal on click of admixture info button
    shiny::observeEvent(admixture_info_bttn(), {
      shiny::showModal(build_modal("Admixture File Format", table_admixture))
    })

    # Show modal on click of coordinates info button
    shiny::observeEvent(coords_info_bttn(), {
      shiny::showModal(build_modal("Coordinates File Format", table_coords))
    })

  })
}
