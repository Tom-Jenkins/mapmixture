#' Barplot Plotting Module: UI
#'
#' @noRd
#' @importFrom shiny NS tagList uiOutput plotOutput
#' @importFrom shinyjs runjs
mod_barplot_plot_ui <- function(id) {
  ns <- NS(id)
  tagList(

    # Set waiter spinner theme (https://shiny.john-coene.com/waiter/)
    waiter::waiter_set_theme(html = waiter::spin_loaders(15, color = "grey", style = "font-size: 50px;"), color = "#f5f5f5"),

    # Loading spinner ----
    waiter::autoWaiter(id = ns("admixture_barplot")),

    # Render a download button ----
    # uiOutput(ns("barplot_dropdown_download_bttn")),

    # Render admixture barplot ----
    plotOutput(ns("admixture_barplot"), width = "100%")
  )
}


#' Barplot Plotting Module: Server
#'
#' @noRd
#' @importFrom shiny moduleServer reactive observeEvent bindEvent showNotification renderPlot renderUI div icon strong textInput downloadButton downloadHandler observe
#' @importFrom shinyjs runjs
#' @importFrom ggplot2 theme element_blank element_rect element_line element_text margin rel unit
mod_barplot_plot_server <- function(id, bttn, admixture_df,
                                    user_bar_type, user_legend,
                                    cluster_cols, cluster_names,
                                    site_divider, divider_lwd,
                                    site_ticks, ticks_size

                                 ) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    # Clear any plots from plotOutput container ----
    # Must be outside the renderPlot observer
    # observeEvent(c(bttn()), priority = 2, {
    #   runjs("clearPlotOutput('bar')")
    # })


    # Create barplot as reactive ----
    output_barplot <- reactive({
      req(admixture_df())

      # Barplot
      plt <- structure_plot(
        admixture_df = admixture_df(),
        type = user_bar_type(),
        cluster_cols = cluster_cols(),
        cluster_names = cluster_names(),
        legend = user_legend(),
        site_dividers = site_divider(),
        divider_width = divider_lwd(),
        site_ticks = site_ticks(),
        site_ticks_size = ticks_size()
      )

      # Return plot
      return(plt)
    })

    # Render barplot on click of button ----
    observeEvent(bttn(), priority = 1, {
      req(admixture_df(), output_barplot())

      runjs("clearPlotOutput('bar')")

      runjs("
        // Select the element you want to click
        const pillsBar = document.querySelector('#options-pills-container > li:nth-child(2) > a');

        // Create a new click event
        const clickEvent = new Event('click', { bubbles: true });

        // Dispatch the click event on the element
        pillsBar.dispatchEvent(clickEvent);
      ")

      output$admixture_barplot <- renderPlot({
        output_barplot()
      }) |> bindEvent(x = _, bttn(), ignoreNULL = TRUE, ignoreInit = FALSE)

      # Delay by one second to allow rendering before switching tabs
      runjs("
        setTimeout( () => {

          // Select the element you want to click
          const navBar = document.querySelector('#app-tabset-panel > li:nth-child(2) > a');

          // Create a new click event
          const clickEvent = new Event('click', { bubbles: true });

          // Dispatch the click event on the element
          navBar.dispatchEvent(clickEvent);

          navBar.style.pointerEvents = 'auto';
        }, 1000)
      ")


      # Download button ---- TO DO
    })

  })
}
