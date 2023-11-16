#' Information Modals Module: UI
#'
#' @noRd
#' @importFrom shiny NS tagList
mod_info_modals_ui <- function(id){
  ns <- NS(id)
  tagList(

  )
}

#' Information Modals Module: Server
#'
#' @noRd
#' @importFrom shiny NS tagList modalDialog strong br div observeEvent showModal
mod_info_modals_server <- function(id, admixture_info_bttn, coords_info_bttn){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    # Admixture table example (mod_info_modals_utils_sample_table_html.R)
    table_admixture <- admixture_sample_table()

    # Coordinates table example (mod_info_modals_utils_sample_table_html.R)
    table_coords <- coords_sample_table()

    # Function to build modal
    build_modal <- function(custom_title, html_content) {
      modalDialog(
        title = strong(custom_title, style = "font-size: larger;"),
        html_content,
        br(),
        div(
          class = "text-center",
          htmltools::HTML('<button type="button" class="btn btn-success modal-close-bttn" data-dismiss="modal" data-bs-dismiss="modal">Close</button>')
        ),
        footer = NULL,
        easyClose = TRUE,
        size = "l"
      )
    }

    # Show modal on click of admixture info button
    observeEvent(admixture_info_bttn(), {
      showModal(build_modal("Admixture File Format", table_admixture))
    })

    # Show modal on click of coordinates info button
    observeEvent(coords_info_bttn(), {
      showModal(build_modal("Coordinates File Format", table_coords))
    })

  })
}
