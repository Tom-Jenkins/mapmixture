# app/view/map_params_module.R

# Import R packages / functions into module
box::use(  
  shiny[moduleServer, NS, tagList, fluidRow, column, h2, h3, h4, tableOutput, renderTable, plotOutput, renderPlot, sidebarLayout, sidebarPanel, mainPanel, selectInput, reactive, observeEvent, eventReactive, observe, br, icon, req, textInput, div, strong, bindEvent, freezeReactiveValue, debounce, textAreaInput, numericInput, uiOutput, renderUI, reactiveValues, wellPanel, tabsetPanel, tabPanel, sliderInput, fileInput, span],
  shinyWidgets[pickerInput, searchInput, actionBttn, numericInputIcon, switchInput, materialSwitch, dropdown, dropdownButton, tooltipOptions],
  colourpicker[colourInput],
  dplyr[group_by, summarise, n_distinct, arrange, select],
  tidyr[contains],
  magrittr[`%>%`],
  purrr[map, map2, map_chr],
  stringr[str_to_lower, str_replace, str_replace_all],
  sf[st_bbox, st_crs, st_as_sf, st_as_sfc, st_transform, st_read, st_set_crs],
  rlang[`%||%`],
  ggplot2[theme, element_text, element_line, element_rect, element_blank, margin],
  shinyFeedback[useShinyFeedback, showFeedbackWarning, hideFeedback],
)


# CRS options
# epsg <- crs_data$code
# projection <- crs_data$note
epsg <- c(3035,3857,4326,27700)
projection <- c("ETRS89-extended / LAEA Europe","WGS 84 / Pseudo-Mercator","WGS 84","OSGB36 / British National Grid")


#' @export
ui <- function(id) {
  ns <- NS(id)

  tagList(

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
    div(style = "display: inline-block;", textInput(ns("xmin_input"), label = "xmin", width = "80px", placeholder = "-15")),
    div(style = "display: inline-block;", textInput(ns("xmax_input"), label = "xmax", width = "80px", placeholder = "15")),
    div(style = "display: inline-block;", textInput(ns("ymin_input"), label = "ymin", width = "80px", placeholder = "40")),
    div(style = "display: inline-block;", textInput(ns("ymax_input"), label = "ymax", width = "80px", placeholder = "64")),

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

    # North arrow input ----
    div(style = "display: inline-block;", selectInput(ns("arrow_position"), label = strong("Arrow Position"), choices = c("bottom-left","bottom-right","top-left","top-right"), selected = "bottom-left", width = "150px")),
    switchInput(ns("arrow_toggle"), label = NULL, onLabel = "Yes", offLabel = "No", value = TRUE, inline = FALSE),

    # Scale bar input ----
    div(style = "display: inline-block;", selectInput(ns("scalebar_position"), label = strong("Scalebar Position"), choices = c("bottom-left","bottom-right","top-left","top-right"), selected = "bottom-left", width = "150px")),
    switchInput(ns("scalebar_toggle"), label = NULL, onLabel = "Yes", offLabel = "No", value = TRUE, inline = FALSE),

    # Pie chart size ----
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

    # Map title ----
    div(style = "display: inline-block;", textInput(ns("title_input"), label = strong("Plot Title"), value = "", width = "295px")),
    div(style = "display: inline-block;", numericInput(ns("plot_title_size"), label = strong("Plot Title Size"), width = "100px", value = 15)),

    # Theme Options ----
    br(),
    div(style = "display: inline-block;", colourInput(ns("sea_input"), label = strong("Sea Colour"), value = "#deebf7")),
    div(style = "display: inline-block;", colourInput(ns("land_input"), label = strong("Land Colour"), value = "#d9d9d9")),
    div(style = "display: inline-block;", numericInput(ns("text_size"), label = strong("Axis Text Size"), width = "100px", value = 10)),
    div(style = "display: inline-block;", numericInput(ns("title_size"), label = strong("Axis Title Size"), width = "100px", value = 12)),

    # Advanced Theme Customisation ----
    div(style = "padding-bottom: 10px;",
      textAreaInput(
        inputId = ns("advanced_customisation_box"),
        label = strong("Advanced Theme Customisation"),
        value = "",
        height = "100px",
        placeholder = "axis.text.x = element_blank()\naxis.title.x = element_blank()\naxis.ticks.x = element_blank()"
      )
    )    
  )
}


#' @export
server <- function(id, admixture_df, coords_df) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    # Import Coordinate Reference System chosen by user (default: LAEA Europe)
    params_CRS <- eventReactive(input$crs_input, {
      # Convert EPSG 4326 to EPSG 3857
      str_replace(input$crs_input, "4326", "3857") %>%
        # Convert string to integer
        as.integer
    })

    # Import map boundary chosen by user (default is the boundary of the points in the coordinates file)
    params_bbox <- reactive({
      req(coords_df())
      if (input$xmin_input != "" && input$xmax_input != "" && input$ymin_input != "" && input$ymax_input != "") {
        return(
          st_bbox(c(xmin = as.double(input$xmin_input),
                    xmax = as.double(input$xmax_input),
                    ymin = as.double(input$ymin_input),
                    ymax = as.double(input$ymax_input)),
                    crs = st_crs(4326))
        )
      } else {
        return(
          coords_df() %>% 
            st_as_sf(coords = c("lon","lat")) %>%
            st_set_crs(4326) %>%
            st_bbox
        )  
      }
    })

    # Import expand axes chosen by user
    param_expand <- reactive(input$expand_switch)

    # Store the input IDs of the cluster colours outputUI (e.g. cluster_input1, cluster_input2, cluster_inputN)
    cluster_input_names <- reactive({
      req(admixture_df())
      clusters <- paste0("cluster_input", 1:ncol(select(admixture_df(), contains("cluster"))) )
      # print(clusters)
      return(clusters)
    })

    # Render the correct number of colour options to the UI
    output$colours_input <- renderUI({
      req(cluster_input_names(), admixture_df())
      labels <- paste0("Cluster ", 1:ncol(select(admixture_df(), contains("cluster"))) )
      # print(labels)
      
      map2(cluster_input_names(), labels, ~ div(style = "display: inline-block; width: 100px; margin-top: 5px;", colourInput(ns(.x), label = .y, value = "white")))
    })

    # Collect colours chosen by users
    user_cols <- reactive({
      req(cluster_input_names())
      colours <- map_chr(cluster_input_names(), ~ input[[.x]] %||% "")
      # print(colours)
      return(colours)
    })

    # Import pie chart size chosen by user
    pie_size <- eventReactive(input$piesize_input, {
      as.double(input$piesize_input)
    })

    # Import map title chosen by user
    param_title <- reactive(input$title_input)

    # Import land colour chosen by user
    user_land_col <- reactive(input$land_input)

    # Import theme options chosen by user
    map_theme <- eventReactive({
      input$sea_input
      input$text_size
      input$title_size
      input$plot_title_size}, {
        theme(
          axis.text = element_text(colour = "black", size = input$text_size),
          axis.title = element_text(colour = "black", size = input$title_size),
          panel.grid = element_line(colour = "white", size = 0.1),
          panel.background = element_rect(fill = input$sea_input),
          panel.border = element_rect(fill = NA, colour = "black", size = 0.3),
          plot.title = element_text(size = input$plot_title_size, face = "bold", margin = margin(0,0,10,0)),
          legend.title = element_blank()
        )
    })

    # Import advanced customisation theme options chosen by user
    # Format of returned string: "theme_update(axis.text = element_blank(),axis.title = element_blank(),..."
    advanced_custom <- eventReactive(input$advanced_customisation_box, {
        user_text <- paste0("theme_update(", input$advanced_customisation_box, ")")
        str_text <- str_replace_all(user_text, "\n", ",")
        # print(str_text)
        return(str_text)
    })

    # Return parameters as a named list
    return(
      list(
        params_CRS = params_CRS,
        params_bbox = params_bbox,
        param_expand = param_expand,
        params_clusters = cluster_input_names,
        param_cols = user_cols,
        param_pie_size = pie_size,
        param_title = param_title,
        param_land_col = user_land_col,
        param_map_theme = map_theme,
        param_advanced = advanced_custom
      )
    )
    
  })
}





