#' Main Map Plotting Module: UI
#'
#' @noRd
#' @importFrom shiny NS tagList uiOutput plotOutput
#' @importFrom shinyjs runjs
mod_main_plot_ui <- function(id) {
  ns <- NS(id)
  tagList(

    # Set waiter spinner theme (https://shiny.john-coene.com/waiter/)
    waiter::waiter_set_theme(html = waiter::spin_loaders(15, color = "grey", style = "font-size: 50px;"), color = "#f5f5f5"),

    # Loading spinner ----
    waiter::autoWaiter(id = ns("admixture_map")),

    # Render a download button ----
    uiOutput(ns("dropdown_download_bttn")),

    # Render admixture map ----
    plotOutput(ns("admixture_map"), width = "100%")
  )
}


#' Main Map Plotting Module: Server
#'
#' @noRd
#' @importFrom shiny moduleServer reactive observeEvent bindEvent showNotification renderPlot renderUI div icon strong textInput downloadButton downloadHandler observe
#' @importFrom shinyjs runjs
#' @importFrom ggplot2 theme element_blank element_rect element_line element_text margin rel unit
mod_main_plot_server <- function(id, bttn, admixture_df, coords_df,
                                 user_CRS, user_bbox, user_expand,
                                 cluster_cols, cluster_names,
                                 arrow_position, arrow_size, arrow_toggle,
                                 scalebar_position, scalebar_size, scalebar_toggle,
                                 pie_size, pie_opacity, pie_border,
                                 user_title, user_land_col,
                                 sea_input, text_size, title_size, plot_title_size,
                                 user_advanced) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    # Clear any plots from plotOutput container ----
    # Must be outside the renderPlot observer AND
    #   have coords_df() inside observer to fix coords_file feedback bug
    # observeEvent(c(bttn(), coords_df()), priority = 2, {
    #   runjs("clearPlotOutput('map')")
    # })

    # Create map as reactive ----
    output_map <- reactive({
      req(admixture_df(), coords_df())

      # Map
      plt <- mapmixture(
        admixture_df = admixture_df(),
        coords_df = coords_df(),
        cluster_cols = cluster_cols(),
        cluster_names = cluster_names(),
        boundary = user_bbox(),
        crs = user_CRS(),
        pie_size = pie_size(),
        pie_border = pie_border(),
        pie_opacity = pie_opacity(),
        land_colour = user_land_col(),
        sea_colour = sea_input(),
        expand = user_expand(),
        arrow = arrow_toggle(),
        arrow_size = arrow_size(),
        arrow_position = arrow_position(),
        scalebar = scalebar_toggle(),
        scalebar_size = scalebar_size(),
        scalebar_position = scalebar_position(),
        plot_title = user_title(),
        plot_title_size = plot_title_size(),
        axis_text_size = text_size(),
        axis_title_size = title_size()
      )

      # Return plot
      if (user_advanced() == "") return(plt)

      # Add advanced theme customisation if the box is not empty
      if (user_advanced() != "") {
        tryCatch({
          update_theme <- paste0("theme(", user_advanced(), ")")
          # print(update_theme)
          plt <- plt+ rlang::eval_tidy(rlang::parse_expr(update_theme))
          return(plt)
        }, error = function(err) {
          showNotification(
            ui = htmltools::HTML("<p>Invalid Advanced Theme Customisation. See <a href='https://ggplot2.tidyverse.org/reference/theme.html' target='_blank' class='text-danger'>theme</a> for valid options.</p>"),
            duration = 10,
            type = "err"
          )
          runjs("document.getElementById('main_plot-dropdown_download_bttn').classList.add('hidden');")
        })
      }
    })


    # Render map on click of button ----
    observeEvent(bttn(), priority = 1, {
      req(admixture_df(), coords_df(), output_map())

      runjs("clearPlotOutput('map')")

      runjs("
        // Select the element you want to click
        const pillsMap = document.querySelector('#options-pills-container > li:nth-child(1) > a');

        // Create a new click event
        const clickEvent = new Event('click', { bubbles: true });

        // Dispatch the click event on the element
        pillsMap.dispatchEvent(clickEvent);
      ")

      # Render plot ----
      output$admixture_map <- renderPlot({
        output_map()
      }) |> bindEvent(x = _, bttn(), ignoreNULL = TRUE, ignoreInit = FALSE)

      # Delay by one second to allow rendering before switching tabs
      runjs("
        setTimeout( () => {

          // Select the element you want to click
          const navMap = document.querySelector('#app-tabset-panel > li:nth-child(1) > a');

          // Create a new click event
          const clickEvent = new Event('click', { bubbles: true });

          // Dispatch the click event on the element
          navMap.dispatchEvent(clickEvent);
        }, 1000)
      ")

      # Render download button and internal components ----
      runjs("document.getElementById('main_plot-dropdown_download_bttn').classList.remove('hidden');")
      output$dropdown_download_bttn <- renderUI({
        div(id = "map_download_bttn_display", style = "position: relative; margin-bottom: -20px; float: right; margin-top: 1px;",
            shinyWidgets::dropdown(
              style = "simple", icon = icon("download"), status = "success", size = "sm", right = TRUE, width = "300px",
              strong("Download Map", class = "fs-4 text-success"),
              shinyWidgets::radioGroupButtons(
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
              htmltools::HTML("
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
        shinyFeedback::showFeedbackWarning("plot_width", text = NULL, icon = NULL)
      } else { shinyFeedback::hideFeedback("plot_width") }
    })

    # Height parameter feedback warning
    observeEvent(input$plot_height, {
      if (input$plot_height == "" || input$plot_height == "0" || is.na(as.numeric(input$plot_height))) {
        shinyFeedback::showFeedbackWarning("plot_height", text = NULL, icon = NULL)
      } else { shinyFeedback::hideFeedback("plot_height") }
    })

    # DPI parameter feedback warning
    observeEvent(input$plot_dpi, {
      if (input$plot_dpi == "" || input$plot_dpi == "0" || is.na(as.numeric(input$plot_dpi))) {
        shinyFeedback::showFeedbackWarning("plot_dpi", text = NULL, icon = NULL)
      } else { shinyFeedback::hideFeedback("plot_dpi") }
    })


    # Parameter validation for PNG and JPEG
    observeEvent(c(input$filetype_radio_bttn, input$plot_width, input$plot_height, input$plot_dpi), {

      # Do this for PNG and JPEG validation
      if (input$filetype_radio_bttn == "PNG" || input$filetype_radio_bttn == "JPEG") {
        if (input$plot_width == "" || input$plot_width == "0" || is.na(as.numeric(input$plot_width)) ||
            input$plot_height == "" || input$plot_height == "0" || is.na(as.numeric(input$plot_height)) ||
            input$plot_dpi == "" || input$plot_dpi == "0" || is.na(as.numeric(input$plot_dpi))) {
          # Activate disabled state
          runjs("document.getElementById('main_plot-download_bttn').classList.add('disabled')")
        } else {
          # Deactivate disabled state
          runjs("document.getElementById('main_plot-download_bttn').classList.remove('disabled')")
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
          runjs("document.getElementById('main_plot-download_bttn').classList.add('disabled')")
        } else {
          # Deactivate disabled state
          runjs("document.getElementById('main_plot-download_bttn').classList.remove('disabled')")
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
        ifelse(input$filetype_radio_bttn == "PNG", paste0("Mapmixture_figure", ".png"),
               ifelse(input$filetype_radio_bttn == "JPEG", paste0("Mapmixture_figure", ".jpeg"), paste0("Mapmixture_figure", ".pdf"))
        )
      },
      content = function(file) {

        # Export as PNG file ----
        if(input$filetype_radio_bttn == "PNG") {
          # Activate spinner while download in progress
          runjs("document.getElementById('spinner-download').classList.remove('hidden');")
          ggplot2::ggsave(
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
          ggplot2::ggsave(
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
          ggplot2::ggsave(
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
