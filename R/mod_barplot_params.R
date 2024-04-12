#' Barplot Parameters Module: UI
#'
#' @noRd
#' @importFrom shiny NS tagList strong div br uiOutput numericInput radioButtons
mod_barplot_params_ui <- function(id) {
  ns <- NS(id)
  tagList(

    # Type of barplot to display (structure or facet) button ----
    shinyWidgets::radioGroupButtons(
      inputId = ns("bar_type_bttn"),
      label = strong("Barplot Type"),
      choices = c("Structure", "Facet"),
      status = "secondary param-bttn-100px",
      individual = TRUE,
    ),

    # Choose cluster colours input ----
    div(strong("Cluster Colours")),
    uiOutput(ns("bar_cluster_colours_ui")),
    uiOutput(ns("bar_cluster_names_ui")),
    br(),

    # Barplot legend ----
    div(style = "display: flex; margin-bottom: -20px;",
        div(style = "display: inline-block; margin-top: -20px;", selectInput(ns("bar_legend_position"), label = strong("Legend Position"), choices = c("right","top","left","bottom"), selected = "right", width = "150px")),
        div(class = "px-1", style = "margin-top: 12px;", shinyWidgets::switchInput(ns("bar_legend_switch"), label = "Legend", onLabel = "ON", offLabel = "OFF", value = TRUE, inline = TRUE)),
    ),
    br(),

    # Y label ----
    textInput(
      inputId = ns("bar_y_label"),
      label = strong("Y Label"),
      value = "Proportion",
      width = "275px"
    ),

    # Labels to display (sites or individuals) button ----
    shinyWidgets::radioGroupButtons(
      inputId = ns("bar_labels_bttn"),
      label = strong("Display Labels"),
      choices = c("Site", "Individual"),
      status = "secondary param-bttn-100px",
      individual = TRUE,
    ),

    # Site order ----
    textInput(
      inputId = ns("bar_site_order"),
      label = strong("Site Order"),
      value = NULL,
      width = "295px"
    ),

    # Site dividers switch ----
    shinyWidgets::switchInput(
      inputId = ns("bar_site_dividers_switch"),
      label = "Site Dividers",
      value = TRUE,
      onStatus = "primary",
      size = "normal",
      inline = TRUE,
      labelWidth = "88px"
    ),

    # Divider width ----
    div(
      style = "display: inline-block;",
      numericInput(
        inputId = ns("bar_divider_width"),
        label = NULL,
        value = 1,
        min = 0,
        max = 5,
        step = 0.1,
      )
    ),
    br(),

    # Site labels size, x and y positions ----
    div(style = "display: inline-block;", numericInput(ns("bar_site_labs_size"), label = strong("Site Size"), width = "80px", min = 0, value = 2)),
    div(style = "display: inline-block;", numericInput(ns("bar_site_labs_x"), label = strong("Site X"), width = "80px", value = 0)),
    div(style = "display: inline-block;", numericInput(ns("bar_site_labs_y"), label = strong("Site Y"), width = "80px", value = 1, min = -2, max = 2, step = 0.1)),
    br(),

    # Site ticks ----
    shinyWidgets::switchInput(
      inputId = ns("bar_site_ticks"),
      label = "Ticks",
      value = TRUE,
      onStatus = "primary",
      size = "normal",
      inline = TRUE,
      labelWidth = "88px"
    ),

    # Site ticks size ----
    div(
      style = "display: inline-block;",
      numericInput(
        inputId = ns("bar_site_ticks_size"),
        label = NULL,
        value = 1,
        min = -5,
        max = 5,
        step = 0.1,
        width = "80px"
      )
    ),
    br(),

    # Flip axis switch ----
    shinyWidgets::switchInput(
      inputId = ns("bar_flip_axes_switch"),
      label = "Flip Axes",
      value = FALSE,
      onStatus = "primary",
      size = "normal",
      inline = FALSE,
      labelWidth = "88px"
    ),

    # Facet Grid ----
    div(style = "display: inline-block;", numericInput(ns("bar_facet_col"), label = strong("Facet Col"), width = "80px", min = 1, value = NULL)),
    div(style = "display: none; ", numericInput(ns("bar_facet_row"), label = strong("Facet Row"), width = "80px", min = 1, value = NULL)),
  )
}


#' Barplot Parameters Module: Server
#'
#' @noRd
#' @importFrom shiny moduleServer reactive req eventReactive updateNumericInput
mod_barplot_params_server <- function(id, admixture_df){
  moduleServer(id, function(input, output, session){
    ns <- session$ns

    # Import barplot type chosen by user ----
    params_bar_type <- reactive({
      if(input$bar_type_bttn == "Structure") return("structure")
      if(input$bar_type_bttn == "Facet") return("facet")
    })

    # Import legend and legend position ----
    params_legend <- reactive({
      # If TRUE return legend position. If FALSE return "none".
      if (input$bar_legend_switch) {
        return(input$bar_legend_position)
      } else {
        return("none")
      }
    })

    # Store the shiny input IDs of cluster colours (e.g. cluster_col1, cluster_col2, etc.) ----
    cluster_col_inputIDs <- reactive({
      req(admixture_df())
      inputIDs <- paste0("bar_cluster_col", 1:(ncol(admixture_df())-2))
      # print(inputIDs)
      return(inputIDs)
    })

    # Render the correct number of cluster colour options to the UI ----
    output$bar_cluster_colours_ui <- renderUI({
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
      inputIDs <- paste0("bar_cluster_name", 1:(ncol(admixture_df())-2))
      # print(inputIDs)
      return(inputIDs)
    })

    # Render the correct number of cluster names options to the UI ----
    output$bar_cluster_names_ui <- renderUI({
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

    # Import label types chosen by user ----
    user_bar_labels <- reactive({
      if(input$bar_labels_bttn == "Site") return("site")
      if(input$bar_labels_bttn == "Individual") return("individual")
    })

    # Import site order chosen by user ---- TODO

    # Import site divider chosen by user ----
    user_divider <- reactive(input$bar_site_dividers_switch)
    user_divider_lwd <- reactive(input$bar_divider_width)

    # Import ticks and tick size chosen by user ----
    user_ticks <- reactive(input$bar_site_ticks)
    user_ticks_size <- reactive({
      return(-0.01 - input$bar_site_ticks_size/500)
    })

    # Import site labels size, x and y positions ----
    user_site_labs_size <- reactive(input$bar_site_labs_size)
    user_site_labs_x <- reactive(input$bar_site_labs_x)
    user_site_labs_y <- reactive({
      return(-0.025 - input$bar_site_labs_y/100)
    })

    # Import flip axis chosen by user ----
    user_flip_axes <- reactive(input$bar_flip_axes_switch)

    # Import facet grid chosen by user ----
    user_facet_col <- reactive({
      if (is.na(input$bar_facet_col)) return(NULL)
      if (!is.na(input$bar_facet_col)) return(input$bar_facet_col)
    })
    user_facet_row <- reactive({
      if (is.na(input$bar_facet_row)) return(NULL)
      if (!is.na(input$bar_facet_row)) return(input$bar_facet_row)
    })

    # Import y label chosen by user ----
    user_y_label <- reactive(input$bar_y_label)

    # Update facet_col with the maximum number of sites
    observeEvent(admixture_df(), {
      updateNumericInput(
        session = session,
        inputId = "bar_facet_col",
        max = length(unique(admixture_df()[[1]]))
      )
    })


    # Return parameters as a named list ----
    return(
      list(
        param_bar_type = params_bar_type,
        param_legend = params_legend,
        param_cluster_names = user_cluster_names,
        param_cols = user_cols,
        param_divider = user_divider,
        param_divider_lwd = user_divider_lwd,
        param_ticks = user_ticks,
        param_ticks_size = user_ticks_size,
        param_site_labs_size = user_site_labs_size,
        param_site_labs_x = user_site_labs_x,
        param_site_labs_y = user_site_labs_y,
        param_bar_labels = user_bar_labels,
        param_flip_axes = user_flip_axes,
        param_facet_col = user_facet_col,
        param_facet_row = user_facet_row,
        param_y_label = user_y_label
      )
    )

  })
}
