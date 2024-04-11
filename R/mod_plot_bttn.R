#' Plot Button Module: UI
#'
#' @noRd
#' @importFrom shiny NS tagList tags icon
mod_plot_bttn_ui <- function(id){
ns <- NS(id)
tagList(

  # Plot Map button ----
  tags$button(
    id = ns("plot_map_bttn"),
    class = "btn me-1 btn-success plot-bttn action-button btn-sm shiny-bound-input fs-5 disabled",
    icon("chart-pie"),
    htmltools::HTML("Plot Map")
  ),

  # Plot Bar button ----
  tags$button(
    id = ns("plot_bar_bttn"),
    class = "btn btn-success plot-bttn action-button btn-sm shiny-bound-input fs-5 disabled",
    icon("chart-simple"),
    htmltools::HTML("Plot Bar")
  )
)
}

#' Plot Button Module: Server
#'
#' @noRd
mod_plot_bttn_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    plot_map_bttn <- reactive(input$plot_map_bttn)
    plot_bar_bttn <- reactive(input$plot_bar_bttn)

    return(list(plot_map_bttn = plot_map_bttn, plot_bar_bttn = plot_bar_bttn))

  })
}
