# app/view/map_params_module.R

# Import R packages / functions into module
box::use(  
  shiny[moduleServer, NS, tagList, br, icon, reactive],
  shinyWidgets[actionBttn],
)


#' @export
ui <- function(id) {
  ns <- NS(id)

  tagList(
    br(),

    # Plot button
    actionBttn(
      inputId = ns("showmap_bttn"),
      label = "Plot Data", 
      style = "simple",
      color = "success",
      icon = icon("arrows-rotate"),
      size = "md"
    ),
    br(),
    br(),
  )
}


#' @export
server <- function(id, admixture_df) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    plot_bttn <- reactive(input$showmap_bttn)

    return(list(plot_bttn = plot_bttn))
  })
}





