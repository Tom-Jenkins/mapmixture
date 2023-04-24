# app/view/map_params_module.R

# Import R packages / functions into module
box::use(  
  shiny[moduleServer, NS, tagList, tags, HTML, icon, reactive],
)


#' @export
ui <- function(id) {
  ns <- NS(id)

  tagList(

    # Plot button
    tags$button(
      id = ns("showmap_bttn"),
      class = "btn btn-success action-button shiny-bound-input fs-5",
      icon("arrows-rotate"),
      HTML("Plot Data")
    )
  )
}


#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    plot_bttn <- reactive({ input$showmap_bttn })

    return(list(plot_bttn = plot_bttn))
  })
}





