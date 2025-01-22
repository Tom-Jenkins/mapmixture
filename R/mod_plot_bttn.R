#' Plot Button Module: UI
#'
#' @noRd
mod_plot_bttn_ui <- function(id){
  ns <- shiny::NS(id)
  shiny::tagList(

    # Plot Map button ----
    shiny::tags$button(
      id = ns("plot_map_bttn"),
      class = "btn me-1 btn-success plot-bttn action-button btn-sm shiny-bound-input fs-5 disabled",
      shiny::icon("chart-pie"),
      htmltools::HTML("Plot Map")
    ),

    # Plot Bar button ----
    shiny::tags$button(
      id = ns("plot_bar_bttn"),
      class = "btn btn-success plot-bttn action-button btn-sm shiny-bound-input fs-5 disabled",
      shiny::icon("chart-simple"),
      htmltools::HTML("Plot Bar")
    )
  )
}

#' Plot Button Module: Server
#'
#' @noRd
mod_plot_bttn_server <- function(id){
  shiny::moduleServer( id, function(input, output, session){
    ns <- session$ns

    plot_map_bttn <- shiny::reactive(input$plot_map_bttn)
    plot_bar_bttn <- shiny::reactive(input$plot_bar_bttn)

    return(list(plot_map_bttn = plot_map_bttn, plot_bar_bttn = plot_bar_bttn))

  })
}
