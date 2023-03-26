# app/view/barchart_module.R

# Import R packages / functions into module
box::use(  
  shiny[moduleServer, NS, tagList, fluidRow, column, h3, tableOutput, renderTable, plotOutput, renderPlot, sidebarLayout, sidebarPanel, mainPanel],
  vroom[vroom],
  grDevices[colorRampPalette],
  ggplot2[ggplot, aes, geom_bar, scale_y_continuous, facet_wrap, scale_fill_manual, ylab, theme, element_blank, element_text],
  dplyr[n_distinct]
)

# Import custom R functions into module
box::use(
  app/logic/data_transformation[transform_data],
)


#' @export
ui <- function(id) {
    ns <- NS(id)

    tagList(
      sidebarLayout(
        sidebarPanel(
          h3("Parameters"),
        ),
        mainPanel(
          plotOutput(ns("example_barchart"), height = "800px", width = "100%"),
        )
      )
    )

}


#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {

    # Import data
    example_data <- vroom("./app/static/data/admixture_example.csv")

    # Convert data.frame to long format for plotting with ggplot
    data <- transform_data(example_data)

    # Import colours chosen by user
    pal <- colorRampPalette(c("green","blue"))
    cols <- pal(n_distinct(data$Cluster))

    # Import theme options chosen by user
    custom_theme <- theme(
      axis.text.x = element_blank(),
      axis.ticks.x = element_blank(),
      axis.title.x = element_blank(),
      strip.text = element_text(colour="black", size=12),
      panel.grid = element_blank(),
      panel.background = element_blank(),
      legend.position = "top",
      legend.title = element_blank(),
      legend.text = element_text(size = 12)
    )

    # Render bar chart
    output$example_barchart <- renderPlot({
      ggplot(data = data, aes(x = Individual, y = Admixture, fill = Cluster))+
        geom_bar(stat = "identity")+
        scale_y_continuous(expand = c(0,0))+
        facet_wrap(~Site, scales = "free", ncol = 2)+
        scale_fill_manual(values = cols)+
        ylab("Admixture proportion")+
        # xlab("Individual")+
        custom_theme
        
    })

  })
}



