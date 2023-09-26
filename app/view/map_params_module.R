# app/view/map_params_module.R

# Import R packages / functions into module
box::use(  
  shiny[moduleServer, NS, tagList, fluidRow, column, h2, h3, h4, tableOutput, renderTable, plotOutput, renderPlot, sidebarLayout, sidebarPanel, mainPanel, selectInput, reactive, observeEvent, eventReactive, observe, br, icon, req, textInput, div, strong, bindEvent, freezeReactiveValue, debounce, textAreaInput, numericInput, uiOutput, renderUI, reactiveValues, wellPanel, tabsetPanel, tabPanel, sliderInput, fileInput, span, isolate],
  shinyWidgets[pickerInput, searchInput, actionBttn, numericInputIcon, switchInput, materialSwitch, dropdown, dropdownButton, tooltipOptions, autonumericInput],
  colourpicker[colourInput],
  dplyr[group_by, summarise, n_distinct, arrange, select, filter],
  tidyr[contains],
  purrr[map, pmap, map_chr],
  stringr[str_to_lower, str_replace, str_replace_all],
  sf[st_bbox, st_crs, st_as_sf, st_as_sfc, st_transform, st_read, st_set_crs],
  rlang[`%||%`],
  ggplot2[theme, element_text, element_line, element_rect, element_blank, margin],
  shinyFeedback[useShinyFeedback, showFeedbackWarning, hideFeedback, feedbackWarning],
  vroom[vroom],
  grDevices[colorRampPalette],
)


# CRS options
crs_data <- vroom("./app/static/data/EPSG_CRS.csv") |> arrange(.data = _, region, epsg_code)
# epsg <- c(3035,3857,4326,27700)
# projection <- c("ETRS89-extended / LAEA Europe","WGS 84 / Pseudo-Mercator","WGS 84","OSGB36 / British National Grid")


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
        subtext = paste0("EPSG: ", crs_data$name)
      ),
      options = list("live-search" = TRUE, size = 10),
      # Update for v1.0.4
      choices = list(
        Africa = filter(crs_data, region == "Africa")$epsg_code,
        Americas = filter(crs_data, region == "Americas")$epsg_code,
        Antarctica = filter(crs_data, region == "Antarctica")$epsg_code,
        Arctic = filter(crs_data, region == "Arctic")$epsg_code,
        Asia = filter(crs_data, region == "Asia")$epsg_code,
        Europe = filter(crs_data, region == "Europe")$epsg_code,
        Oceania = filter(crs_data, region == "Oceania")$epsg_code,
        "Pacific Ocean" = filter(crs_data, region == "Pacific Ocean")$epsg_code,
        World = filter(crs_data, region == "World")$epsg_code
      ),
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
    br(),

    # North arrow input ----
    div(style = "display: flex; margin-bottom: -20px;",
      div(style = "display: inline-block; margin-top: -20px;", selectInput(ns("arrow_position"), label = strong("Arrow Position"), choices = c("bottom-left","bottom-right","top-left","top-right"), selected = "top-left", width = "150px")),
      div(class = "px-1", style = "display: inline-block; margin-top: -20px;", numericInput(ns("arrow_size"), label = strong("Size"), min = 0, value = 1, step = 0.1, width = "80px")),
      div(style = "margin-top: 12px;", switchInput(ns("arrow_toggle"), label = NULL, onLabel = "ON", offLabel = "OFF", value = TRUE, inline = TRUE)),
    ),
    br(),

    # Scale bar input ----
    div(style = "display: flex;",
      div(style = "display: inline-block; margin-top: -30px;", selectInput(ns("scalebar_position"), label = strong("Scalebar Position"), choices = c("bottom-left","bottom-right","top-left","top-right"), selected = "top-left", width = "150px")),
      div(class = "px-1", style = "display: inline-block; margin-top: -30px;", numericInput(ns("scalebar_size"), label = strong("Size"), min = 0, value = 1, step = 0.1, width = "80px")),
      div(style = "margin-top: 2px;", switchInput(ns("scalebar_toggle"), label = NULL, onLabel = "ON", offLabel = "OFF", value = TRUE, inline = TRUE)),
    ),

    # Pie chart input ----
    div(style = "margin-top: -25px; display: flex;",
      div(
        numericInputIcon(
          inputId = ns("piesize_input"),
          label = strong("Pie Chart Size"),
          value = 2,
          min = 0,
          max = 20,
          step = 0.1,
          icon = icon("chart-pie"),
          help_text = "Please pick a number between 0 and 20",
          width = "150px"
          )
        ),      
      div(class = "px-1", style = "display: inline-block;", numericInput(ns("pieopacity_input"), label = strong("Opacity"), width = "80px", min = 0, max = 1, value = 1, step = 0.05)),
      div(class = "px-1", style = "display: inline-block;", numericInput(ns("pieborder_input"), label = strong("Border"), width = "80px", min = 0, max = 2, value = 0.3, step = 0.01)),
    ),

    # Map title ----
    div(style = "display: inline-block;", textInput(ns("title_input"), label = strong("Plot Title"), value = "", width = "295px")),
    div(style = "display: inline-block;", numericInput(ns("plot_title_size"), label = strong("Plot Title Size"), width = "100px", min = 0, value = 15, step = 0.1)),

    # Theme Options ----
    br(),
    div(style = "display: inline-block;", colourInput(ns("sea_input"), label = strong("Sea Colour"), value = "#deebf7")),
    div(style = "display: inline-block;", colourInput(ns("land_input"), label = strong("Land Colour"), value = "#d9d9d9")),
    div(style = "display: inline-block;", numericInput(ns("text_size"), label = strong("Axis Text Size"), width = "100px", min = 0, value = 10, step = 0.1)),
    div(style = "display: inline-block;", numericInput(ns("title_size"), label = strong("Axis Title Size"), width = "100px", min = 0, value = 12, step = 0.1)),

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

    # Import Coordinate Reference System chosen by user (default: WGS 84 / Pseudo-Mercator)
    params_CRS <- reactive({
      req(input$crs_input)
      
      # If user selects EPSG 4326, convert to EPSG 3857, else use selected EPSG
      crs <- ifelse(input$crs_input == "4326",
                    str_replace(input$crs_input, "4326", "3857") |> as.integer(x = _),
                    input$crs_input |> as.integer(x = _))
      return(crs)
    })

    # Import map boundary chosen by user (default is the boundary of the points in the coordinates file)
    params_bbox <- reactive({
      req(coords_df())
      
      # User selected bounding box (Check inputs are valid)
      if (input$xmin_input != "" && input$xmax_input != "" && input$ymin_input != "" && input$ymax_input != "" && !is.na(as.double(input$xmin_input)) && !is.na(as.double(input$xmax_input)) && !is.na(as.double(input$ymin_input)) && !is.na(as.double(input$ymax_input))) {
        
        return(
          st_bbox(c(xmin = as.double(input$xmin_input),
                    xmax = as.double(input$xmax_input),
                    ymin = as.double(input$ymin_input),
                    ymax = as.double(input$ymax_input)),
                    crs = st_crs(4326))
        )
        
      # Default bounding box
      } else {
        return(
          coords_df() |> 
            st_as_sf(x = _, coords = c("lon","lat")) |>
            st_set_crs(x = _, 4326) |>
            st_bbox(obj = _)
        )  
      }
    })

    # Import expand axes chosen by user
    param_expand <- reactive(input$expand_switch)

    # Store the shiny input IDs of the cluster colours outputUI (e.g. cluster_input1, cluster_input2, cluster_inputN)
    cluster_input_names <- reactive({
      req(admixture_df())
      cluster_inputIDs <- paste0("cluster_input", 1:(ncol(admixture_df())-2)) 
      # print(cluster_inputIDs)
      return(cluster_inputIDs)
    })

    # Render the correct number of cluster colour options to the UI
    output$colours_input <- renderUI({
      req(cluster_input_names(), admixture_df())
      
      # Vector of  cluster labels on UI (Cluster 1, Cluster 2, etc.)
      labels <- paste0("Cluster ", 1:(ncol(admixture_df())-2))
      # print(labels)
      
      # Default colours for pie charts
      pal <- colorRampPalette(c("green","blue")) # green-blue colour palette
      cluster_cols <- pal(ncol(admixture_df())-2) # number of cluster colours for palette
      # print(cluster_cols)
      
      # Render colourInput, cluster labels and cluster colours to UI
      pmap_args <- list(cluster_input_names(), labels, cluster_cols)
      pmap(pmap_args, ~ div(style = "display: inline-block; width: 100px; margin-top: 5px;",
                            colourInput(ns(..1), label = ..2, value = ..3)))
    })
    
    # Collect colours chosen by users
    user_cols <- reactive({
      req(cluster_input_names())
      colours <- map_chr(cluster_input_names(), ~ input[[.x]] %||% "")
      # print(colours)
      return(colours)
    })

    # Import arrow position and toggle by user
    arrow_position <- reactive({
      if(input$arrow_position == "bottom-left") return("bl")
      if(input$arrow_position == "bottom-right") return("br")
      if(input$arrow_position == "top-left") return("tl")
      if(input$arrow_position == "top-right") return("tr")
    })
    arrow_size <- reactive(input$arrow_size)
    arrow_toggle <- reactive(input$arrow_toggle)

    # Import scalebar position and toggle by user
    scalebar_position <- reactive({
      if(input$scalebar_position == "bottom-left") return("bl")
      if(input$scalebar_position == "bottom-right") return("br")
      if(input$scalebar_position == "top-left") return("tl")
      if(input$scalebar_position == "top-right") return("tr")
    })
    scalebar_size <- reactive(input$scalebar_size)
    scalebar_toggle <- reactive(input$scalebar_toggle)

    # Import pie chart inputs chosen by user
    pie_size <- eventReactive(input$piesize_input, {
      as.double(input$piesize_input)
    })
    pie_opacity <- reactive(input$pieopacity_input)
    pie_border <- reactive(input$pieborder_input)

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
    # Format of returned string: "axis.text = element_blank(),axis.title = element_blank(),..."
    advanced_custom <- eventReactive(input$advanced_customisation_box, {
        user_text <- str_replace_all(input$advanced_customisation_box, "\n", ",")
        # print(str_text)
        return(user_text)
    })

    # Return parameters as a named list
    return(
      list(
        params_CRS = params_CRS,
        params_bbox = params_bbox,
        param_expand = param_expand,
        params_clusters = cluster_input_names,
        param_cols = user_cols,
        param_arrow_position = arrow_position,
        param_arrow_size = arrow_size,
        param_arrow_toggle = arrow_toggle,
        param_scalebar_position = scalebar_position,
        param_scalebar_size = scalebar_size,
        param_scalebar_toggle = scalebar_toggle,
        param_pie_size = pie_size,
        param_pie_opacity = pie_opacity,
        param_pie_border = pie_border,
        param_title = param_title,
        param_land_col = user_land_col,
        param_map_theme = map_theme,
        param_advanced = advanced_custom
      )
    )
    
  })
}





