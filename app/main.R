# app/main.R

# Import R packages / functions into module
box::use(
  shiny[moduleServer, NS, tags, fluidPage, fluidRow, span, h1, h2, h3, h4, strong, icon, p, a, sidebarLayout, sidebarPanel, mainPanel, fileInput, tabsetPanel, tabPanel, div, actionButton, splitLayout, br, renderTable, tableOutput, req, callModule, reactive, column, plotOutput, uiOutput, HTML],
  bslib[bs_theme],
  sf[st_read],
)

# Import modules
box::use(
  app/view/file_upload,
  app/view/info_modals_module,
  app/view/plot_bttn_module,
  app/view/map_params_module,
  app/view/map_plot_module,
  app/logic/file_format_html_content[file_format_content],
  app/logic/about_html_content[about_content],
)


# UI COMPONENTS
#' @export
ui <- function(id) {
  ns <- NS(id)
  
  fluidPage(

    # Bootstrap version and bootswatch theme ----
    theme = bs_theme(version = 5, bootswatch = "flatly"),

    # Navbar with title and links ----
    fluidRow(
      class = "custom-navbar",
      style = "background: #18bc9c; color: white; padding: 10px; margin-bottom: 5px;",
      span(
        span(icon("chart-pie", style = "margin-right: 5px;"), strong("Mapmixture v0.1")),
        a(
          style = "color: white;",
          href = "https://twitter.com/tom__jenkins",
          target = "_blank",
          span(style = "float: right;", icon("twitter", style = "margin-right: 5px;"), "Twitter"),
        ),        
        a(
          style = "color: white;",
          href = "https://github.com/Tom-Jenkins",
          target = "_blank",
          span(style = "float: right; margin-right: 20px;", icon("github", style = "margin-right: 5px;"), "GitHub")),
      ),
    ),

    # Sidebar layout with inputs (left) and outputs (right) ----
    sidebarLayout(

      # Sidebar panel for inputs ----
      sidebarPanel(
        class = "sidebar-container",

        div(
          class = "sidebar-nonparam-container",

          # File upload UI module ----
          file_upload$ui(ns("file_upload")),

          # Plot button UI module ----
          plot_bttn_module$ui(ns("plot_bttn_module")),
        ),
        
        # Tab panel for map and bar chart input parameters ----
        div(class = "nav-justified",
          tabsetPanel(
            type = "pills",
            id = "options-pills-container",
            tabPanel(
              class = "parameter-options-container",
              title = "Map Options",
              map_params_module$ui(ns("map_params_module")),
            ),
            # tabPanel(
            #   class = "nav-fill",
            #   title = "Bar Chart Options",
            # ),
          ),
        ),
      ),

      # Main panel for displaying outputs ----
      mainPanel(
        tabsetPanel(
          tabPanel(
            title = "Admixture Map",
            icon = icon("earth-europe"),
            map_plot_module$ui(ns("map_plot_module")),
          ),
          tabPanel(
            title = "File Format",
            icon = icon("file"),
            file_format_content(),
            br(),
          ),
          tabPanel(
            title = "Gallery",
            icon = icon("image"),
            # file_format_content(),
            br(),
          ),
          tabPanel(
            title = "About",
            icon = icon("circle-question"),
            about_content(),
          ),
        )
      )
    ),

    # Dynamically adjust height of sidebarPanel, options tabPanel, and the mainPanel depending on screen size ----
    tags$script(HTML(
      # Calculate maximum height of the container where the map will render based on the users screen height
      # Then set the height of sidebarPanel and MainPanel containers
      # Do these calculations and change the height of the container each time the window is resized
      # For example, when the user drags the browser from a laptop screen to a desktop screen (or vice versa)
      "
      const navbarHeight = document.querySelector('.custom-navbar').offsetHeight;
      const navbarHeightMargin = parseInt(window.getComputedStyle(document.querySelector('.custom-navbar')).getPropertyValue('margin-bottom'));
      const navtabsHeight = document.querySelector('.nav-tabs').offsetHeight;
      const sidebarNonParamContainerHeight = document.querySelector('.sidebar-nonparam-container').offsetHeight;
      const sidebarPillsHeight = document.getElementById('options-pills-container').offsetHeight;

      const sidebarContainerHeight = window.innerHeight - navbarHeight - navbarHeightMargin - 20;
      const sidebarOptionsContainerHeight = sidebarContainerHeight - sidebarNonParamContainerHeight - sidebarPillsHeight - 25;
      const mainContainerHeight = window.innerHeight - navbarHeight - navbarHeightMargin - navtabsHeight - 20;

      document.querySelector('.sidebar-container').style.height = `${sidebarContainerHeight}px`;
      document.querySelector('.parameter-options-container').style.height = `${sidebarOptionsContainerHeight}px`;
      document.getElementById('app-map_plot_module-admixture_map').style.height = `${mainContainerHeight}px`;


      window.addEventListener('resize', () => {
        document.getElementById('app-map_plot_module-admixture_map').textContent = '';

        const sidebarContainerHeight = window.innerHeight - navbarHeight - navbarHeightMargin - 20;
        const sidebarNonParamContainerHeight = document.querySelector('.sidebar-nonparam-container').offsetHeight;
        const sidebarPillsHeight = document.getElementById('options-pills-container').offsetHeight;
        const sidebarOptionsContainerHeight = sidebarContainerHeight - sidebarNonParamContainerHeight - sidebarPillsHeight - 25;

        document.querySelector('.sidebar-container').style.height = `${sidebarContainerHeight}px`;
        document.querySelector('.parameter-options-container').style.height = `${sidebarOptionsContainerHeight}px`;
        document.getElementById('app-map_plot_module-admixture_map').style.height = `${window.innerHeight - navbarHeight - navbarHeightMargin - navtabsHeight - 20}px`;
      });
      "
    )),
  )
}


# SERVER COMPONENTS
#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    # Load static data ----
    world_data <- st_read("./app/static/data/world.gpkg")

    # File upload module ----
    file_upload_mod_outputs <- file_upload$server("file_upload")

    # Import data from file upload module ----
    admixture_data <- file_upload_mod_outputs[["admixture_data"]]
    coords_data <- file_upload_mod_outputs[["coords_data"]]

    # Capture button click events ----
    admixture_info_bttn <- file_upload_mod_outputs[["admixture_info_bttn"]]
    coords_info_bttn <- file_upload_mod_outputs[["coords_info_bttn"]]
    plot_bttn <- plot_bttn_module$server("plot_bttn_module")[["plot_bttn"]]

    # Information modals module ----
    info_modals_module$server("info_modals_module", admixture_info_bttn, coords_info_bttn)

    # Map parameters module ----
    map_params_mod_outputs <- map_params_module$server("map_params_module", admixture_df = admixture_data, coords_df = coords_data)

    # Import map parameters ----
    selected_CRS <- map_params_mod_outputs[["params_CRS"]]
    selected_bbox <- map_params_mod_outputs[["params_bbox"]]
    selected_expand <- map_params_mod_outputs[["param_expand"]]
    selected_cols <- map_params_mod_outputs[["param_cols"]]
    selected_clusters <- map_params_mod_outputs[["params_clusters"]]
    selected_arrow_position <- map_params_mod_outputs[["param_arrow_position"]]
    selected_arrow_toggle <- map_params_mod_outputs[["param_arrow_toggle"]]
    selected_scalebar_position <- map_params_mod_outputs[["param_scalebar_position"]]
    selected_scalebar_toggle <- map_params_mod_outputs[["param_scalebar_toggle"]]
    selected_pie_size <- map_params_mod_outputs[["param_pie_size"]]
    selected_title <- map_params_mod_outputs[["param_title"]]
    selected_land_col <- map_params_mod_outputs[["param_land_col"]]
    selected_map_theme <- map_params_mod_outputs[["param_map_theme"]]
    selected_advanced <- map_params_mod_outputs[["param_advanced"]]

    # Map plot module ----
    map_plot_module$server(
      "map_plot_module",
      bttn = plot_bttn,
      admixture_df = admixture_data,
      coords_df = coords_data,
      world_data = world_data,
      user_CRS = selected_CRS,
      user_bbox = selected_bbox,
      user_expand = selected_expand,
      user_title = selected_title,
      cluster_cols = selected_cols,
      cluster_names = selected_clusters,
      arrow_position = selected_arrow_position,
      arrow_toggle = selected_arrow_toggle,
      scalebar_position = selected_scalebar_position,
      scalebar_toggle = selected_scalebar_toggle,
      user_land_col = selected_land_col,
      pie_size = selected_pie_size,
      map_theme = selected_map_theme,
      user_advanced = selected_advanced
    )

    # # Render admixture table
    # output$admixture_table <- renderTable({
    #   req(admixture_data())
    #   admixture_data()
    # })

    # # Render coords table
    # output$coords_table <- renderTable({
    #   req(coords_data())
    #   coords_data()
    # })
  })
}
