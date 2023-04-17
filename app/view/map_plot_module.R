# app/view/map_plot_module.R

# Import R packages / functions into module
box::use(  
  shiny[moduleServer, NS, tagList, uiOutput, plotOutput, reactive, eventReactive, tableOutput, renderTable, req, observeEvent, renderUI, renderPlot, div, icon, debounce, freezeReactiveValue, isolate],
  sf[st_as_sfc, st_transform, st_bbox],
  magrittr[`%>%`],
  ggplot2[ggplot, aes, geom_bar, scale_y_continuous, facet_wrap, scale_fill_manual, xlab, ylab, ggtitle, theme, element_blank, element_text, ggplotGrob, annotation_custom, coord_polar, theme_void, element_rect, element_line, geom_sf, coord_sf, theme_set, theme_update],
  scatterpie[geom_scatterpie],
  shinyWidgets[actionBttn, dropdown],
  waiter[autoWaiter, waiter_set_theme, spin_3k, spin_timer, spin_loaders, useWaiter],
  rlang[eval_tidy, parse_expr],
)

# Import custom R functions into module
box::use(
  app/logic/data_transformation[transform_data, prepare_pie_data, merge_coords_data, transform_bbox,],
)

# Set waiter spinner theme (https://shiny.john-coene.com/waiter/)
waiter_set_theme(html = spin_loaders(15, color = "grey", style = "font-size: 50px;"), color = "#f5f5f5")


#' @export
ui <- function(id) {
  ns <- NS(id)
  
  tagList(

    # Loading spinner ----
    autoWaiter(id = ns("admixture_map")),

    # Render a download button ----
    uiOutput(ns("download_bttn")),

    # Render admixture map ----
    plotOutput(ns("admixture_map"), height = "800px", width = "100%")
  )
}


#' @export
server <- function(id, bttn, admixture_df, coords_df, world_data, user_CRS, user_bbox, user_expand, cluster_cols, cluster_names, pie_size, user_title, user_land_col, map_theme, user_advanced) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    # Convert data.frame to long format for plotting with ggplot ----
    admixture_data <- reactive({
      req(admixture_df())
      transform_data(admixture_df())      
    })

    # Transform data into format required for scatterpie (returns a tibble) ----
    piedata <- reactive({ 
      prepare_pie_data(admixture_data())
    })
    
    # Merge coordinates data with piedata (returns a tibble) ----
    piecoords <- reactive({
      req(coords_df())
      merge_coords_data(coords_df(), piedata(), user_CRS())
    })

    # Transform bounding box to CRS chosen by user ----
    boundary <- reactive({
      transform_bbox(user_bbox(), user_CRS())
    })

    # Delays a reactive expression by X milliseconds ----
    boundary <- boundary %>% debounce(millis = 1000)

    # Transform world to CRS chosen by user ----
    world <- reactive({
      st_transform(world_data, crs = user_CRS())
    })


    # Render map on click of button ----
    observeEvent(bttn(), {
      req(piecoords(), world(), boundary())

      # Set ggplot theme ----
      theme_set(map_theme())

      # Update ggplot theme ----
      eval_tidy(parse_expr(user_advanced()))

      # Render plot ----
      output$admixture_map <- renderPlot({
        ggplot()+
          geom_sf(data = world(), colour = "black", fill = user_land_col(), size = 0.1)+
          coord_sf(xlim = c(boundary()[["xmin"]], boundary()[["xmax"]]),
                  ylim = c(boundary()[["ymin"]], boundary()[["ymax"]]),
                  expand = user_expand())+
          geom_scatterpie(aes(x=lon, y=lat, group=site), pie_scale = pie_size(), data=piecoords(), cols = colnames(piecoords())[4:ncol(piecoords())])+
          ggtitle(user_title())+
          xlab("Longitude")+
          ylab("Latitude")+
          scale_fill_manual(values = cluster_cols())
          # map_theme()
      })

      # Render download button ----
      output$download_bttn <- renderUI({
        div(style = "position: relative; margin-bottom: -20px; float: right;",
          dropdown(
            style = "simple", icon = icon("download"), status = "success", size = "sm", right = TRUE, width = "300px",
            actionBttn("download_map_bttn", label = "Download map"),
          )
        )
      })  
    })
    
    # Download render plot in image format chosen by user
    # CODE TO GO IN SEPARATE MODULE!

  })
}



