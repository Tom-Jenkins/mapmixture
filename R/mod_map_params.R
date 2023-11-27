#' Map Parameters Module: UI
#'
#' @noRd
#' @importFrom shiny NS tagList strong textInput uiOutput br div selectInput numericInput textAreaInput
mod_map_params_ui <- function(id) {
  ns <- NS(id)
  crs_data <- utils::read.csv(system.file("extdata", "EPSG_CRS.csv", package = "mapmixture"))
  tagList(

    # Coordinate Reference System (CRS) input ----
    shinyWidgets::pickerInput(
      inputId = ns("crs_input"),
      label = strong("Coordinate Reference System (EPSG)"),
      width = "100%",
      selected = "4326",
      choicesOpt = list(
        subtext = paste0("EPSG: ", crs_data$name)
      ),
      options = list("live-search" = TRUE, size = 10),
      # Update for v1.0.4
      choices = list(
        Africa = subset(crs_data, crs_data[, 3] == "Africa")$epsg_code,
        Americas = subset(crs_data, crs_data[, 3] == "Americas")$epsg_code,
        Antarctica = subset(crs_data, crs_data[, 3] == "Antarctica")$epsg_code,
        Arctic = subset(crs_data, crs_data[, 3] == "Arctic")$epsg_code,
        Asia = subset(crs_data, crs_data[, 3] == "Asia")$epsg_code,
        Europe = subset(crs_data, crs_data[, 3] == "Europe")$epsg_code,
        Oceania = subset(crs_data, crs_data[, 3] == "Oceania")$epsg_code,
        "Pacific Ocean" = subset(crs_data, crs_data[, 3] == "Pacific Ocean")$epsg_code,
        World = subset(crs_data, crs_data[, 3] == "World")$epsg_code
      ),
    ),

    # Boundary limits input ----
    div(strong("Boundary Limits")),
    div(style = "display: inline-block;", textInput(ns("xmin_input"), label = "xmin", width = "80px", placeholder = "-15")),
    div(style = "display: inline-block;", textInput(ns("xmax_input"), label = "xmax", width = "80px", placeholder = "15")),
    div(style = "display: inline-block;", textInput(ns("ymin_input"), label = "ymin", width = "80px", placeholder = "40")),
    div(style = "display: inline-block;", textInput(ns("ymax_input"), label = "ymax", width = "80px", placeholder = "64")),

    # Expand axes on map switch ----
    shinyWidgets::switchInput(
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
    uiOutput(ns("cluster_colours_ui")),
    uiOutput(ns("cluster_names_ui")),
    br(),

    # North arrow input ----
    div(style = "display: flex; margin-bottom: -20px;",
        div(style = "display: inline-block; margin-top: -20px;", selectInput(ns("arrow_position"), label = strong("Arrow Position"), choices = c("bottom-left","bottom-right","top-left","top-right"), selected = "top-left", width = "150px")),
        div(class = "px-1", style = "display: inline-block; margin-top: -20px;", numericInput(ns("arrow_size"), label = strong("Size"), min = 0, value = 1, step = 0.1, width = "80px")),
        div(style = "margin-top: 12px;", shinyWidgets::switchInput(ns("arrow_toggle"), label = NULL, onLabel = "ON", offLabel = "OFF", value = TRUE, inline = TRUE)),
    ),
    br(),

    # Scale bar input ----
    div(style = "display: flex;",
        div(style = "display: inline-block; margin-top: -30px;", selectInput(ns("scalebar_position"), label = strong("Scalebar Position"), choices = c("bottom-left","bottom-right","top-left","top-right"), selected = "top-left", width = "150px")),
        div(class = "px-1", style = "display: inline-block; margin-top: -30px;", numericInput(ns("scalebar_size"), label = strong("Size"), min = 0, value = 1, step = 0.1, width = "80px")),
        div(style = "margin-top: 2px;", shinyWidgets::switchInput(ns("scalebar_toggle"), label = NULL, onLabel = "ON", offLabel = "OFF", value = TRUE, inline = TRUE)),
    ),

    # Pie chart input ----
    div(style = "margin-top: -25px; display: flex;",
        div(
          shinyWidgets::numericInputIcon(
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
        div(class = "px-1", style = "display: inline-block;", numericInput(ns("pieborder_input"), label = strong("Border"), width = "80px", min = 0, max = 2, value = 0.2, step = 0.01)),
    ),

    # Map title ----
    div(style = "display: inline-block;", textInput(ns("title_input"), label = strong("Plot Title"), value = "", width = "295px")),
    div(style = "display: inline-block;", numericInput(ns("plot_title_size"), label = strong("Plot Title Size"), width = "100px", min = 0, value = 15, step = 0.1)),

    # Theme Options ----
    br(),
    div(style = "display: inline-block;", colourpicker::colourInput(ns("sea_input"), label = strong("Sea Colour"), value = "#deebf7")),
    div(style = "display: inline-block;", colourpicker::colourInput(ns("land_input"), label = strong("Land Colour"), value = "#d9d9d9")),
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

#' Map Parameters Module: Server
#'
#' @noRd
#' @importFrom shiny moduleServer reactive req eventReactive
#' @importFrom purrr %||%
mod_map_params_server <- function(id, admixture_df, coords_df){
  moduleServer(id, function(input, output, session){
    ns <- session$ns

    # Import Coordinate Reference System chosen by user (default: WGS 84 EPSG:4326) ----
    params_CRS <- reactive({
      req(input$crs_input)
      crs <- as.integer(input$crs_input)
      return(crs)
    })

    # Import map boundary chosen by user (default is the boundary of the points in the coordinates file) ----
    params_bbox <- reactive({
      req(coords_df())

      # User selected bounding box (Check inputs are valid)
      if (input$xmin_input != "" && input$xmax_input != "" && input$ymin_input != "" && input$ymax_input != "" && !is.na(as.double(input$xmin_input)) && !is.na(as.double(input$xmax_input)) && !is.na(as.double(input$ymin_input)) && !is.na(as.double(input$ymax_input))) {

        return(
          sf::st_bbox(c(xmin = as.double(input$xmin_input),
                    xmax = as.double(input$xmax_input),
                    ymin = as.double(input$ymin_input),
                    ymax = as.double(input$ymax_input)),
                    crs = sf::st_crs(4326))
        )

        # Default bounding box
      } else {
        return( calc_default_bbox(coords_df(), expand = 0.10) )
      }
    })

    # Import expand axes chosen by user ----
    param_expand <- reactive(input$expand_switch)


    # Store the shiny input IDs of cluster colours (e.g. cluster_col1, cluster_col2, etc.) ----
    cluster_col_inputIDs <- reactive({
      req(admixture_df())
      inputIDs <- paste0("cluster_col", 1:(ncol(admixture_df())-2))
      # print(inputIDs)
      return(inputIDs)
    })

    # Render the correct number of cluster colour options to the UI ----
    output$cluster_colours_ui <- renderUI({
      req(admixture_df())

      # Default colours for pie charts
      pal <- grDevices::colorRampPalette(c("green","blue")) # green-blue colour palette
      cluster_cols <- pal(ncol(admixture_df())-2) # number of cluster colours for palette
      # print(cluster_cols)

      # Render colourInput, cluster labels and cluster colours to UI
      pmap_args <- list(cluster_col_inputIDs(), cluster_cols)
      purrr::pmap(pmap_args, ~ div(style = "display: inline-block; width: 100px; margin-top: 5px;",
                             colourpicker::colourInput(ns(..1), label = NULL, value = ..2)))
    })

    # Collect colours chosen by user ----
    user_cols <- reactive({
      req(cluster_col_inputIDs())
      colours <- purrr::map_chr(cluster_col_inputIDs(), ~ input[[.x]] %||% "")
      # print(colours)
      return(colours)
    })


    # Store the shiny input IDs of cluster names (e.g. cluster_name1, cluster_name2, etc.) ----
    cluster_name_inputIDs <- reactive({
      req(admixture_df())
      inputIDs <- paste0("cluster_name", 1:(ncol(admixture_df())-2))
      # print(inputIDs)
      return(inputIDs)
    })

    # Render the correct number of cluster names options to the UI ----
    output$cluster_names_ui <- renderUI({
      req(admixture_df())

      # Vector of cluster labels on UI (Cluster 1, Cluster 2, etc.)
      labels <- paste0("Cluster ", 1:(ncol(admixture_df())-2))
      # print(labels)

      # Render cluster names to UI
      pmap_args <- list(cluster_name_inputIDs(), labels)
      purrr::pmap(pmap_args, ~ div(style = "display: inline-block;",
                            textInput(ns(..1), label = NULL, value = ..2, width = "100px", placeholder = ..2)))
    })

    # Collect cluster names chosen by user ----
    user_cluster_names <- reactive({
      req(cluster_name_inputIDs())
      labels <- purrr::map_chr(cluster_name_inputIDs(), ~ input[[.x]] %||% "")
      # print(labels)
      return(labels)
    })


    # Import arrow position and toggle by user ----
    arrow_position <- reactive({
      if(input$arrow_position == "bottom-left") return("bl")
      if(input$arrow_position == "bottom-right") return("br")
      if(input$arrow_position == "top-left") return("tl")
      if(input$arrow_position == "top-right") return("tr")
    })
    arrow_size <- reactive(input$arrow_size)
    arrow_toggle <- reactive(input$arrow_toggle)

    # Import scalebar position and toggle by user ----
    scalebar_position <- reactive({
      if(input$scalebar_position == "bottom-left") return("bl")
      if(input$scalebar_position == "bottom-right") return("br")
      if(input$scalebar_position == "top-left") return("tl")
      if(input$scalebar_position == "top-right") return("tr")
    })
    scalebar_size <- reactive(input$scalebar_size)
    scalebar_toggle <- reactive(input$scalebar_toggle)

    # Import pie chart inputs chosen by user ----
    pie_size <- eventReactive(input$piesize_input, {
      as.double(input$piesize_input)
    })
    pie_opacity <- reactive(input$pieopacity_input)
    pie_border <- reactive(input$pieborder_input)

    # Import map title chosen by user ----
    param_title <- reactive(input$title_input)

    # Import land colour chosen by user ----
    user_land_col <- reactive(input$land_input)

    # Import theme parameters chosen by user ----
    sea_input <- reactive(input$sea_input)
    text_size <- reactive(input$text_size)
    title_size <- reactive(input$title_size)
    plot_title_size <- reactive(input$plot_title_size)

    # Import advanced customisation theme options chosen by user ----
    # Format of returned string: "axis.text = element_blank(),axis.title = element_blank(),..."
    advanced_custom <- eventReactive(input$advanced_customisation_box, {
      user_text <- stringr::str_replace_all(input$advanced_customisation_box, "\n", ",")
      # print(user_text)
      return(user_text)
    })

    # Return parameters as a named list ----
    return(
      list(
        params_CRS = params_CRS,
        params_bbox = params_bbox,
        param_expand = param_expand,
        params_cluster_names = user_cluster_names,
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
        param_sea_input = sea_input,
        param_text_size = text_size,
        param_title_size = title_size,
        param_plot_title_size = plot_title_size,
        param_advanced = advanced_custom
      )
    )

  })
}
