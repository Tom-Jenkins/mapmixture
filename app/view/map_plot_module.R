# app/view/map_module.R

# Import R packages / functions into module
box::use(  
  shiny[moduleServer, NS, tagList, fluidRow, column, h2, h3, h4],
)

# Import modules
box::use(
  app/view/file_upload,
)

# Import custom R functions into module
box::use(
  app/logic/data_transformation[transform_data, prepare_pie_data, merge_coords_data],
)


# CRS options
# epsg <- crs_data$code
# projection <- crs_data$note
epsg <- c(3035,3857,4326,27700)
projection <- c("ETRS89-extended / LAEA Europe","WGS 84 / Pseudo-Mercator","WGS 84","OSGB36 / British National Grid")

# Set waiter spinner theme (https://shiny.john-coene.com/waiter/)
waiter_set_theme(html = spin_loaders(15, color = "grey", style = "font-size: 50px;"), color = "#f5f5f5")


#' @export
ui <- function(id) {
  ns <- NS(id)

  tagList(
    br(),
    # Coordinate Reference System (CRS) input ----
    pickerInput(
      inputId = ns("crs_input"),
      label = strong("Coordinate Reference System (EPSG)"),
      width = "100%",
      selected = "3857",
      choicesOpt = list(
        subtext = paste0("EPSG: ", projection)
      ),
      options = list("live-search" = TRUE, maxOptions = 20),
      choices = epsg
    ),
    # Boundary limits input ----
    div(strong("Boundary Limits")),
    div(style = "display: inline-block;", textInput(ns("xmin_input"), label = "xmin", width = "80px", placeholder = "e.g. -15", value = -15)),
    div(style = "display: inline-block;", textInput(ns("xmax_input"), label = "xmax", width = "80px", placeholder = "e.g. 15", value = 15)),
    div(style = "display: inline-block;", textInput(ns("ymin_input"), label = "ymin", width = "80px", placeholder = "e.g. 40", value = 40)),
    div(style = "display: inline-block;", textInput(ns("ymax_input"), label = "ymax", width = "80px", placeholder = "e.g. 64", value = 64)),
    # Expand axes on map switch ----
    switchInput(
      inputId = ns("expand_switch"),
      label = "Expand Axes",
      value = TRUE,
      onStatus = "primary",
      size = "normal",
      inline = TRUE,
      labelWidth = "85px"
    ),
    # Choose cluster colours input ----
    div(strong("Cluster Colours")),
    uiOutput(ns("colours_input")),
    # Pie Chart Size
    numericInputIcon(
      inputId = ns("piesize_input"),
      label = strong("Pie Chart Size"),
      value = 2,
      min = 0,
      max = 20,
      step = 0.5,
      icon = icon("chart-pie"),
      help_text = "Please pick a number between 0 and 20",
      width = "200px"
    ),
    # Theme Options
    div(strong("Theme Options")),
    div(style = "display: inline-block;", colourInput(ns("sea_input"), label = "Sea colour", value = "#deebf7")),
    div(style = "display: inline-block;", colourInput(ns("land_input"), label = "Land colour", value = "#d9d9d9")),
    div(style = "display: inline-block;", numericInput(ns("text_size"), label = "Axis text size", width = "100px", value = 6)),
    div(style = "display: inline-block;", numericInput(ns("title_size"), label = "Axis title size", width = "100px", value = 7)),
    # Show Map Button
    br(),
    actionBttn(
      inputId = ns("showmap_bttn"),
      label = "Plot Map", 
      style = "simple",
      color = "success",
      # icon = icon("map"),
      size = "md"
    ),
  )
}


#' @export
server <- function(id, example_data, example_coords) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    # DATA
    #----------------------------------------------------------------

    # Import data from file upload module
    # example_data <- file_upload$server("file_upload")[["admixture_data"]]
    # coords <- file_upload$server("file_upload")[["coords_data"]]
    # example_data <- vroom("./app/static/data/admixture_example.csv")
    # coords <- vroom("./app/static/data/coordinates_example.csv")

    tempdata <- reactive({
      req(example_data())

      # Convert headers to lowercase
      colnames(example_data()) <- str_to_lower(colnames(example_data()))

      # Convert data.frame to long format for plotting with ggplot
      data <- transform_data(example_data())
      return(data)
    })


    # PARAMETERS
    #----------------------------------------------------------------

    # Import theme options chosen by user
    map_theme <- eventReactive({
      input$sea_input
      input$text_size
      input$title_size}, {
        theme(
          axis.text = element_text(colour = "black", size = input$text_size),
          axis.title = element_text(colour = "black", size = input$title_size),
          panel.grid = element_line(colour = "white", size = 0.1),
          panel.background = element_rect(fill = input$sea_input),
          panel.border = element_rect(fill = NA, colour = "black", size = 0.3),
          plot.title = element_text(size = 10, face = "bold"),
          legend.title = element_blank()
        )
    })

    # Import pie chart size chosen by user
    pie_size <- eventReactive(input$piesize_input, {
      as.double(input$piesize_input)
    })  

    # Import map boundary chosen by user (default should be the boundary of the points)
    bbox1 <- eventReactive(c(input$xmin_input, input$xmax_input, input$ymin_input, input$ymax_input), {
        st_bbox(c(xmin = as.double(input$xmin_input),
                  xmax = as.double(input$xmax_input),
                  ymin = as.double(input$ymin_input),
                  ymax = as.double(input$ymax_input)),
                  crs = st_crs(4326))
    })

    # Delays a reactive expression by X milliseconds
    bbox <- bbox1 %>% debounce(millis = 1000)

    # Import Coordinate Reference System chosen by user (default: LAEA Europe)
    CRS <- eventReactive(input$crs_input, {
      # Convert EPSG 4326 to EPSG 3857
      str_replace(input$crs_input, "4326", "3857") %>%
        # Convert string to integer
        as.integer
    })    


    # COMPUTATION
    #----------------------------------------------------------------

    # Transform data into format required for scatterpie (returns a tibble)
    piedata <- reactive({ 
      req(tempdata())
      prepare_pie_data(tempdata())
    })
    
    # Merge coordinates data with piedata (returns a tibble)
    piecoords <- reactive({
      req(example_coords(), piedata(), CRS())
      merge_coords_data(example_coords(), piedata(), CRS())
    })

    # Store the input IDs of the cluster colours outputUI (e.g. cluster_input1, cluster_input2, cluster_inputN)
    cluster_input_names <- reactive({
      clusters <- paste0("cluster_input", 1:ncol(piecoords()[, 4:ncol(piecoords())]))
      print(clusters)
      return(clusters)
    })

    # Render the correct number of colour options to the UI
    output$colours_input <- renderUI({
      req(cluster_input_names(), piecoords())
      labels <- paste0("Cluster ", 1:ncol(piecoords()[, 4:ncol(piecoords())]))
      print(labels)
      
      map2(cluster_input_names(), labels, ~ div(style = "display: inline-block; width: 100px; margin-top: 5px;", colourInput(ns(.x), label = .y, value = "white")))
    })

    # Collect colours chosen by users
    user_cols <- reactive({
      colours <- map_chr(cluster_input_names(), ~ input[[.x]] %||% "")
      print(colours)
      return(colours)
    })

    # Transform bounding box to CRS chosen by user
    boundary <- reactive({
      bbox() %>%
        st_as_sfc() %>%
        st_transform(crs = CRS()) %>%
        st_bbox()
    })

    # Transform world to CRS chosen by user
    world <- reactive({
      st_transform(world_data, crs = CRS())
    })

    # Render map on click of button
    observeEvent(input$showmap_bttn, {
      req(input$xmin_input, input$xmax_input, input$ymin_input, input$ymax_input, input$crs_input, input$piesize_input, piecoords(), cluster_input_names())

      # Render map
      output$example_map <- renderPlot({
        ggplot()+
          geom_sf(data = world(), colour = "black", fill = input$land_input, size = 0.1)+
          coord_sf(xlim = c(boundary()[["xmin"]], boundary()[["xmax"]]),
                  ylim = c(boundary()[["ymin"]], boundary()[["ymax"]]),
                  expand = input$expand_switch)+
          geom_scatterpie(aes(x=lon, y=lat, group=site), pie_scale = pie_size(), data=piecoords(), cols = colnames(piecoords())[4:ncol(piecoords())])+
          xlab("Longitude")+
          ylab("Latitude")+
          # scale_fill_manual(values = c("blue","green"))+
          scale_fill_manual(values = user_cols())+
          ggtitle("Study area")+
          map_theme()
      })

      # Render download button
      output$download_bttn <- renderUI({
        div(style = "position: fixed;",
          dropdown(
            style = "simple", icon = icon("download"), status = "success", size = "sm", right = TRUE, width = "300px",
            actionBttn("gege", label = "My button"),
          )
        )
      })  
    })


    # Download render plot in image format chosen by user
    # CODE TO GO IN SEPARATE MODULE!

  })
}



