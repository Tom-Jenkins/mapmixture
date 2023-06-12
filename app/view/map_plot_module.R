# app/view/map_plot_module.R

# Import R packages / functions into module
box::use(  
  shiny[moduleServer, NS, tagList, uiOutput, plotOutput, reactive, eventReactive, tableOutput, renderTable, req, observeEvent, renderUI, renderPlot, div, icon, debounce, freezeReactiveValue, isolate, fillPage, tags, HTML, img, column, fluidRow, downloadButton, downloadHandler, strong, br, h4, textInput, span, updateTextInput, bindEvent, showNotification],
  sf[st_as_sfc, st_transform, st_bbox],
  magrittr[`%>%`],
  ggplot2[ggplot, aes, geom_bar, scale_y_continuous, facet_wrap, scale_fill_manual, xlab, ylab, ggtitle, theme, element_blank, element_text, ggplotGrob, annotation_custom, coord_polar, theme_void, element_rect, element_line, geom_sf, coord_sf, theme_set, theme_update, margin, ggsave, unit],
  scatterpie[geom_scatterpie],
  shinyWidgets[actionBttn, dropdown, radioGroupButtons],
  waiter[useWaiter, autoWaiter, waiter_set_theme, spin_loaders],
  rlang[eval_tidy, parse_expr],
  shinyjs[useShinyjs, onevent, runjs],
  stringr[str_replace_all],
  shinyFeedback[useShinyFeedback, showFeedbackWarning, hideFeedback],
  ggspatial[annotation_north_arrow, north_arrow_orienteering, annotation_scale]
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
    useShinyjs(),
    useWaiter(),
    useShinyFeedback(),

    # Loading spinner ----
    autoWaiter(id = ns("admixture_map")),

    # Render a download button ----
    uiOutput(ns("dropdown_download_bttn")),

    # Render admixture map ----
    plotOutput(ns("admixture_map"), width = "100%")
  )
}


#' @export
server <- function(id, bttn, admixture_df, coords_df, world_data, user_CRS, user_bbox, user_expand, cluster_cols, cluster_names, arrow_position, arrow_size, arrow_toggle, scalebar_position, scalebar_size, scalebar_toggle, pie_size, pie_opacity, user_title, user_land_col, map_theme, user_advanced) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    # Transform data into format required for scatterpie (returns a tibble) ----
    piedata <- reactive({
      req(admixture_df())
      tr_admixture_data <- transform_data(admixture_df()) 
      prepare_pie_data(tr_admixture_data)     
    })
    
    # Merge coordinates data with piedata (returns a tibble) ----
    piecoords <- reactive({
      req(coords_df())
      merge_coords_data(coords_df(), piedata(), user_CRS())
    }) 

    # Calculate default boundary points and transform to CRS chosen by user ----
    boundary <- reactive({
      transform_bbox(user_bbox(), user_CRS())
    })

    # Transform world to CRS chosen by user ----
    world <- reactive({
      st_transform(world_data, crs = user_CRS())
    }) 


    # Clear any plots from plotOutput container ----
    # Must be outside the renderPlot observer and have piecoords() inside observer to fix coords_file feedback bug
    observeEvent(c(bttn(), piecoords()), priority = 2, {
      runjs("App.clearPlotOutput()")
    })
    

    # Store plot in reactive ----
    output_map <- reactive({

      # Default plot
      plt <- ggplot()+
        geom_sf(data = world(), colour = "black", fill = user_land_col(), size = 0.1)+
        coord_sf(xlim = c(boundary()[["xmin"]], boundary()[["xmax"]]),
                ylim = c(boundary()[["ymin"]], boundary()[["ymax"]]),
                expand = user_expand())+
        geom_scatterpie(aes(x=lon, y=lat, group=site), pie_scale = pie_size(), data = piecoords(), cols = colnames(piecoords())[4:ncol(piecoords())], size = 0.3, alpha = pie_opacity())+
        ggtitle(user_title())+
        xlab("Longitude")+
        ylab("Latitude")+
        scale_fill_manual(values = cluster_cols(), labels = str_replace_all(colnames(piecoords())[4:ncol(piecoords())], "cluster", "Cluster"))

      # Add north arrow
      if (arrow_toggle() == TRUE) {
        height_size <- arrow_size() * 0.4
        width_size <- arrow_size() * 0.4
        text_size <- arrow_size() * 4
        pad_size <- arrow_size() * 0.5
        plt <- plt+
          annotation_north_arrow(
            data = world(),
            which_north = "true",
            location = arrow_position(),
            height = unit(height_size, "cm"),
            width = unit(width_size, "cm"),
            pad_y = unit(pad_size, "cm"),
            style = north_arrow_orienteering(text_size = text_size)
          )
      }  
      
      # Add scale bar
      if (scalebar_toggle() == TRUE) {
        height_size <- scalebar_size() * 0.15
        width_size <- scalebar_size() * 0.10
        text_size <- scalebar_size() * 0.5
        plt <- plt+
          annotation_scale(
            data = world(),
            location = scalebar_position(),
            width_hint = width_size,
            bar_cols = c("black","white"),
            height = unit(height_size, "cm"),
            text_cex = text_size
          )
      }
      
      return(plt)        
    }) %>% bindEvent(bttn(), ignoreNULL = TRUE, ignoreInit = FALSE)     


    # Render map on click of button ----
    observeEvent(bttn(), priority = 1, {
      req(output_map())

      # Set ggplot theme ----
      theme_set(map_theme())

      # Update ggplot theme ----
      tryCatch({
        eval_tidy(parse_expr(user_advanced()))
      }, error = function(err) {
        # Show error message if user enters any invalid ggplot theme parameters
        showNotification(
          # ui = paste0("Invalid Advanced Theme Customisation. ", err),
          ui = HTML("<p>Invalid Advanced Theme Customisation. See <a href='https://ggplot2.tidyverse.org/reference/theme.html' target='_blank' class='text-danger'>theme</a> for valid options.</p>"),
          duration = 10,
          type = "err"
        )
      })

      # Render plot ----
      output$admixture_map <- renderPlot({
        output_map()
      })
      

      # Render download button and internal components ----
      output$dropdown_download_bttn <- renderUI({
        div(style = "position: relative; margin-bottom: -20px; float: right;",
          dropdown(
            style = "simple", icon = icon("download"), status = "success", size = "sm", right = TRUE, width = "300px",
            strong("Download Map", class = "fs-4 text-success"),
            radioGroupButtons(
              inputId = ns("filetype_radio_bttn"),
              label = strong("Choose File Type:"),
              choices = c("PNG","JPEG", "PDF"),
              status = "secondary"
            ),
            div(style = "display: inline-block;", id = "plot_width_id", textInput(ns("plot_width"), label = strong("Width"), width = "75px", value = "10", placeholder = "inches")),
            div(style = "display: inline-block;", id = "plot_height_id", textInput(ns("plot_height"), label = strong("Height"), width = "75px", value = "10", placeholder = "inches")),
            div(style = "display: inline-block;", id = "plot_dpi_id", textInput(ns("plot_dpi"), label = strong("DPI"), width = "75px", value = "600", placeholder = "res")),
            downloadButton(ns("download_bttn"), label = " Download",  class = "btn-success"),

            # HTML code to render a bootstrap spinner next to download button (hidden by default)
            HTML("
              <div style='position: fixed; display: inline; margin-left: 25px; margin-top: 2px;'>
                <div id='spinner-download' class='spinner-border text-primary hidden' role='status'>
                  <span class='sr-only'>Loading...</span>
                </div>
              </div>"  
            )
          )
        )
      })

    })
     


    # Toggle parameter feedback and disabled state on textInput and button elements ----
    
    # Width parameter feedback feedback warning
    observeEvent(input$plot_width, {
      if (input$plot_width == "" || input$plot_width == "0" || is.na(as.numeric(input$plot_width))) {
        showFeedbackWarning("plot_width", text = NULL, icon = NULL)
      } else { hideFeedback("plot_width") }
    })

    # Height parameter feedback warning
    observeEvent(input$plot_height, {
      if (input$plot_height == "" || input$plot_height == "0" || is.na(as.numeric(input$plot_height))) {
        showFeedbackWarning("plot_height", text = NULL, icon = NULL)
      } else { hideFeedback("plot_height") }
    })

    # DPI parameter feedback warning
    observeEvent(input$plot_dpi, {
      if (input$plot_dpi == "" || input$plot_dpi == "0" || is.na(as.numeric(input$plot_dpi))) {
        showFeedbackWarning("plot_dpi", text = NULL, icon = NULL)
      } else { hideFeedback("plot_dpi") }
    })


    # Parameter validation for PNG and JPEG
    observeEvent(c(input$filetype_radio_bttn, input$plot_width, input$plot_height, input$plot_dpi), {

      # Do this for PNG and JPEG validation
      if (input$filetype_radio_bttn == "PNG" || input$filetype_radio_bttn == "JPEG") {
        if (input$plot_width == "" || input$plot_width == "0" || is.na(as.numeric(input$plot_width)) || 
          input$plot_height == "" || input$plot_height == "0" || is.na(as.numeric(input$plot_height)) ||
          input$plot_dpi == "" || input$plot_dpi == "0" || is.na(as.numeric(input$plot_dpi))) {
            # Activate disabled state
            runjs("document.getElementById('app-map_plot_module-download_bttn').classList.add('disabled')")
        } else {
          # Deactivate disabled state
          runjs("document.getElementById('app-map_plot_module-download_bttn').classList.remove('disabled')")
        }
      }
    })

    # Parameter validation for PDF
    observeEvent(c(input$filetype_radio_bttn, input$plot_width, input$plot_height), {

      # Do this for PDF validation
      if (input$filetype_radio_bttn == "PDF") {
        if (input$plot_width == "" || input$plot_width == "0" || is.na(as.numeric(input$plot_width)) || 
          input$plot_height == "" || input$plot_height == "0" || is.na(as.numeric(input$plot_height))) {
            # Activate disabled state
            runjs("document.getElementById('app-map_plot_module-download_bttn').classList.add('disabled')")
        } else {
          # Deactivate disabled state
          runjs("document.getElementById('app-map_plot_module-download_bttn').classList.remove('disabled')")
        }
      }
    })


    # Toggle DPI element display when file type buttons are clicked ----
    observeEvent(input$filetype_radio_bttn, {

      # Do this when PDF button is clicked
      if (input$filetype_radio_bttn == "PDF") {
        # Hide DPI element
        runjs("document.getElementById('plot_dpi_id').style.display = 'none';")
      }

      # Do this when PNP or JPEG button is clicked
      if (input$filetype_radio_bttn == "PNG" || input$filetype_radio_bttn == "JPEG") {
        # Display DPI element
        runjs("document.getElementById('plot_dpi_id').style.display = 'inline-block';")
      }
    })

   
    # Download map when button is clicked ----
    output$download_bttn <- downloadHandler(
      filename = function() {
          ifelse(input$filetype_radio_bttn == "PNG", paste0("Mapmixture_map", ".png"),
            ifelse(input$filetype_radio_bttn == "JPEG", paste0("Mapmixture_map", ".jpeg"), paste0("Mapmixture_map", ".pdf"))
          )
        },
      content = function(file) {

        # Export as PNG file ----
        if(input$filetype_radio_bttn == "PNG") {
          # Activate spinner while download in progress
          runjs("document.getElementById('spinner-download').classList.remove('hidden');")
          ggsave(
            plot = output_map(),
            filename = file,
            device = "png",
            width = as.numeric(input$plot_width),
            height = as.numeric(input$plot_height),
            dpi = as.numeric(input$plot_dpi),
            units = "in"
          )
          # Deactivate spinner when download finished
          runjs("document.getElementById('spinner-download').classList.add('hidden');")
        }
        
        # Export as JPEG file ----
        if(input$filetype_radio_bttn == "JPEG") {
          # Activate spinner while download in progress
          runjs("document.getElementById('spinner-download').classList.remove('hidden');")
          ggsave(
            plot = output_map(),
            filename = file,
            device = "jpeg",
            width = as.numeric(input$plot_width),
            height = as.numeric(input$plot_height),
            dpi = as.numeric(input$plot_dpi),
            units = "in"
          )
          # Deactivate spinner when download finished
          runjs("document.getElementById('spinner-download').classList.add('hidden');")
        }

        # Export as PDF file ----
        if(input$filetype_radio_bttn == "PDF") {
          # Activate spinner while download in progress
          runjs("document.getElementById('spinner-download').classList.remove('hidden');")
          ggsave(
            plot = output_map(),
            filename = file,
            device = "pdf",
            width = as.numeric(input$plot_width),
            height = as.numeric(input$plot_height),
            units = "in"
          )
          # Deactivate spinner when download finished
          runjs("document.getElementById('spinner-download').classList.add('hidden');")
        }
      }
    )

  })
}



