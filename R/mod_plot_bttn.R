#' Plot Button Module: UI
#'
#' @noRd
#' @importFrom shiny NS tagList tags icon
#' @importFrom htmltools HTML
mod_plot_bttn_ui <- function(id){
ns <- NS(id)
tagList(

  # Plot Map button  ----
  tags$button(
    id = ns("plot_bttn"),
    class = "btn btn-success action-button shiny-bound-input fs-5 disabled",
    icon("arrows-rotate"),
    HTML("Plot Map")
  )
)
}

#' Plot Button Module: Server
#'
#' @noRd
mod_plot_bttn_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    plot_bttn <- reactive({ input$plot_bttn })

    return(list(plot_bttn = plot_bttn))

  })
}
