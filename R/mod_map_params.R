#' Map Parameters Module: UI
#'
#' @noRd
mod_map_params_ui <- function(id) {
  ns <- shiny::NS(id)
  crs_data <- utils::read.csv(system.file("extdata", "EPSG_CRS.csv", package = "mapmixture"))
  shiny::tagList(

    # Coordinate Reference System (CRS) input ----
    shinyWidgets::pickerInput(
      inputId = ns("crs_input"),
      label = shiny::strong("Coordinate Reference System (EPSG)"),
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
    shiny::div(shiny::strong("Boundary Limits")),
    shiny::div(style = "display: inline-block;", shiny::textInput(ns("xmin_input"), label = "xmin", width = "80px", placeholder = "-15")),
    shiny::div(style = "display: inline-block;", shiny::textInput(ns("xmax_input"), label = "xmax", width = "80px", placeholder = "15")),
    shiny::div(style = "display: inline-block;", shiny::textInput(ns("ymin_input"), label = "ymin", width = "80px", placeholder = "40")),
    shiny::div(style = "display: inline-block;", shiny::textInput(ns("ymax_input"), label = "ymax", width = "80px", placeholder = "64")),

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
    shiny::div(shiny::strong("Cluster Colours")),
    shiny::uiOutput(ns("cluster_colours_ui")),
    shiny::uiOutput(ns("cluster_names_ui")),
    shiny::br(),

    # North arrow input ----
    shiny::div(style = "display: flex; margin-bottom: -20px;",
               shiny::div(style = "display: inline-block; margin-top: -20px;", shiny::selectInput(ns("arrow_position"), label = shiny::strong("Arrow Position"), choices = c("bottom-left","bottom-right","top-left","top-right"), selected = "top-left", width = "150px")),
               shiny::div(class = "px-1", style = "display: inline-block; margin-top: -20px;", shiny::numericInput(ns("arrow_size"), label = shiny::strong("Size"), min = 0, value = 1, step = 0.1, width = "80px")),
               shiny::div(style = "margin-top: 12px;", shinyWidgets::switchInput(ns("arrow_toggle"), label = NULL, onLabel = "ON", offLabel = "OFF", value = TRUE, inline = TRUE)),
    ),
    shiny::br(),

    # Scale bar input ----
    shiny::div(style = "display: flex;",
               shiny::div(style = "display: inline-block; margin-top: -30px;", shiny::selectInput(ns("scalebar_position"), label = shiny::strong("Scalebar Position"), choices = c("bottom-left","bottom-right","top-left","top-right"), selected = "top-left", width = "150px")),
               shiny::div(class = "px-1", style = "display: inline-block; margin-top: -30px;", shiny::numericInput(ns("scalebar_size"), label = shiny::strong("Size"), min = 0, value = 1, step = 0.1, width = "80px")),
               shiny::div(style = "margin-top: 2px;", shinyWidgets::switchInput(ns("scalebar_toggle"), label = NULL, onLabel = "ON", offLabel = "OFF", value = TRUE, inline = TRUE)),
    ),

    # Pie chart input ----
    shiny::div(style = "margin-top: -25px; display: flex;",
               shiny::div(
          shinyWidgets::numericInputIcon(
            inputId = ns("piesize_input"),
            label = shiny::strong("Pie Chart Size"),
            value = 2,
            min = 0,
            max = 20,
            step = 0.1,
            icon = shiny::icon("chart-pie"),
            help_text = "Please pick a number between 0 and 20",
            width = "150px"
          )
        ),
        shiny::div(class = "px-1", style = "display: inline-block;", shiny::numericInput(ns("pieopacity_input"), label = shiny::strong("Opacity"), width = "80px", min = 0, max = 1, value = 1, step = 0.05)),
        shiny::div(class = "px-1", style = "display: inline-block;", shiny::numericInput(ns("pieborder_input"), label = shiny::strong("Border"), width = "80px", min = 0, max = 2, value = 0.2, step = 0.01)),
    ),

    # Map title ----
    shiny::div(style = "display: inline-block;", shiny::textInput(ns("title_input"), label = shiny::strong("Plot Title"), value = "", width = "295px")),
    shiny::div(style = "display: inline-block;", shiny::numericInput(ns("plot_title_size"), label = shiny::strong("Plot Title Size"), width = "100px", min = 0, value = 15, step = 0.1)),

    # Theme Options ----
    shiny::br(),
    shiny::div(style = "display: inline-block;", colourpicker::colourInput(ns("sea_input"), label = shiny::strong("Sea Colour"), value = "#deebf7")),
    shiny::div(style = "display: inline-block;", colourpicker::colourInput(ns("land_input"), label = shiny::strong("Land Colour"), value = "#d9d9d9")),
    shiny::div(style = "display: inline-block;", shiny::numericInput(ns("text_size"), label = shiny::strong("Axis Text Size"), width = "100px", min = 0, value = 10, step = 0.1)),
    shiny::div(style = "display: inline-block;", shiny::numericInput(ns("title_size"), label = shiny::strong("Axis Title Size"), width = "100px", min = 0, value = 12, step = 0.1)),

    # Advanced Theme Customisation ----
    shiny::div(style = "padding-bottom: 10px;",
        shiny::textAreaInput(
          inputId = ns("advanced_customisation_box"),
          label = shiny::strong("Advanced Theme Customisation"),
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
#' @importFrom purrr %||%
mod_map_params_server <- function(id, admixture_df, coords_df){
  shiny::moduleServer(id, function(input, output, session){
    ns <- session$ns

    # Import Coordinate Reference System chosen by user (default: WGS 84 EPSG:4326) ----
    params_CRS <- shiny::reactive({
      shiny::req(input$crs_input)
      crs <- as.integer(input$crs_input)
      return(crs)
    })

    # Import map boundary chosen by user (default is the boundary of the points in the coordinates file) ----
    params_bbox <- shiny::reactive({
      shiny::req(coords_df())

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
    param_expand <- shiny::reactive(input$expand_switch)


    # Store the shiny input IDs of cluster colours (e.g. cluster_col1, cluster_col2, etc.) ----
    cluster_col_inputIDs <- shiny::reactive({
      shiny::req(admixture_df())
      inputIDs <- paste0("cluster_col", 1:(ncol(admixture_df())-2))
      # print(inputIDs)
      return(inputIDs)
    })

    # Render the correct number of cluster colour options to the UI ----
    output$cluster_colours_ui <- shiny::renderUI({
      shiny::req(admixture_df())

      # Default colours for pie charts
      pal <- grDevices::colorRampPalette(c("green","blue")) # green-blue colour palette
      cluster_cols <- pal(ncol(admixture_df())-2) # number of cluster colours for palette
      # print(cluster_cols)

      # Render colourInput, cluster labels and cluster colours to UI
      pmap_args <- list(cluster_col_inputIDs(), cluster_cols)
      purrr::pmap(pmap_args, ~ shiny::div(style = "display: inline-block; width: 100px; margin-top: 5px;",
                             colourpicker::colourInput(ns(..1), label = NULL, value = ..2)))
    })

    # Collect colours chosen by user ----
    user_cols <- shiny::reactive({
      shiny::req(cluster_col_inputIDs())
      colours <- purrr::map_chr(cluster_col_inputIDs(), ~ input[[.x]] %||% "")
      # print(colours)
      return(colours)
    })


    # Store the shiny input IDs of cluster names (e.g. cluster_name1, cluster_name2, etc.) ----
    cluster_name_inputIDs <- shiny::reactive({
      shiny::req(admixture_df())
      inputIDs <- paste0("cluster_name", 1:(ncol(admixture_df())-2))
      # print(inputIDs)
      return(inputIDs)
    })

    # Render the correct number of cluster names options to the UI ----
    output$cluster_names_ui <- shiny::renderUI({
      shiny::req(admixture_df())

      # Vector of cluster labels on UI (Cluster 1, Cluster 2, etc.)
      labels <- paste0("Cluster ", 1:(ncol(admixture_df())-2))
      # print(labels)

      # Render cluster names to UI
      pmap_args <- list(cluster_name_inputIDs(), labels)
      purrr::pmap(pmap_args, ~ shiny::div(style = "display: inline-block;",
                            textInput(ns(..1), label = NULL, value = ..2, width = "100px", placeholder = ..2)))
    })

    # Collect cluster names chosen by user ----
    user_cluster_names <- shiny::reactive({
      shiny::req(cluster_name_inputIDs())
      labels <- purrr::map_chr(cluster_name_inputIDs(), ~ input[[.x]] %||% "")
      # print(labels)
      return(labels)
    })


    # Import arrow position and toggle by user ----
    arrow_position <- shiny::reactive({
      if(input$arrow_position == "bottom-left") return("bl")
      if(input$arrow_position == "bottom-right") return("br")
      if(input$arrow_position == "top-left") return("tl")
      if(input$arrow_position == "top-right") return("tr")
    })
    arrow_size <- shiny::reactive(input$arrow_size)
    arrow_toggle <- shiny::reactive(input$arrow_toggle)

    # Import scalebar position and toggle by user ----
    scalebar_position <- shiny::reactive({
      if(input$scalebar_position == "bottom-left") return("bl")
      if(input$scalebar_position == "bottom-right") return("br")
      if(input$scalebar_position == "top-left") return("tl")
      if(input$scalebar_position == "top-right") return("tr")
    })
    scalebar_size <- shiny::reactive(input$scalebar_size)
    scalebar_toggle <- shiny::reactive(input$scalebar_toggle)

    # Import pie chart inputs chosen by user ----
    pie_size <- shiny::eventReactive(input$piesize_input, {
      as.double(input$piesize_input)
    })
    pie_opacity <- shiny::reactive(input$pieopacity_input)
    pie_border <- shiny::reactive(input$pieborder_input)

    # Import map title chosen by user ----
    param_title <- shiny::reactive(input$title_input)

    # Import land colour chosen by user ----
    user_land_col <- shiny::reactive(input$land_input)

    # Import theme parameters chosen by user ----
    sea_input <- shiny::reactive(input$sea_input)
    text_size <- shiny::reactive(input$text_size)
    title_size <- shiny::reactive(input$title_size)
    plot_title_size <- shiny::reactive(input$plot_title_size)

    # Import advanced customisation theme options chosen by user ----
    # Format of returned string: "axis.text = element_blank(),axis.title = element_blank(),..."
    advanced_custom <- shiny::eventReactive(input$advanced_customisation_box, {
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
