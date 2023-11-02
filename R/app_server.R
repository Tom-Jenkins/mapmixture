#' Application Server
#'
#' @noRd
#' @import shiny
#' @importFrom sf st_read

app_server <- function(input, output, session) {

  # File upload module ----
  mod_file_upload_outputs <- mod_file_upload_server("file_upload")

  # Extract data from file upload module ----
  admixture_data <- mod_file_upload_outputs[["admixture_data"]]
  coords_data <- mod_file_upload_outputs[["coords_data"]]

  # Capture button click events ----
  admixture_info_bttn <- mod_file_upload_outputs[["admixture_info_bttn"]]
  coords_info_bttn <- mod_file_upload_outputs[["coords_info_bttn"]]
  plot_bttn <- mod_plot_bttn_server("plot_bttn")[["plot_bttn"]]

  # Information modals module ----
  mod_info_modals_server("info_modals_module", admixture_info_bttn, coords_info_bttn)

  # Parameters modules ----
  mod_map_params_outputs <- mod_map_params_server("map_params", admixture_df = admixture_data, coords_df = coords_data)

  # Plot map module ----
  mod_main_plot_server(
    "main_plot",
    bttn = plot_bttn,
    admixture_df = admixture_data,
    coords_df = coords_data,
    user_CRS = mod_map_params_outputs[["params_CRS"]],
    user_bbox = mod_map_params_outputs[["params_bbox"]],
    user_expand = mod_map_params_outputs[["param_expand"]],
    user_title = mod_map_params_outputs[["param_title"]],
    cluster_cols = mod_map_params_outputs[["param_cols"]],
    cluster_names = mod_map_params_outputs[["params_cluster_names"]],
    arrow_position = mod_map_params_outputs[["param_arrow_position"]],
    arrow_size = mod_map_params_outputs[["param_arrow_size"]],
    arrow_toggle = mod_map_params_outputs[["param_arrow_toggle"]],
    scalebar_position = mod_map_params_outputs[["param_scalebar_position"]],
    scalebar_size = mod_map_params_outputs[["param_scalebar_size"]],
    scalebar_toggle = mod_map_params_outputs[["param_scalebar_toggle"]],
    user_land_col = mod_map_params_outputs[["param_land_col"]],
    pie_size = mod_map_params_outputs[["param_pie_size"]],
    pie_opacity = mod_map_params_outputs[["param_pie_opacity"]],
    pie_border = mod_map_params_outputs[["param_pie_border"]],
    sea_input = mod_map_params_outputs[["param_sea_input"]],
    text_size = mod_map_params_outputs[["param_text_size"]],
    title_size = mod_map_params_outputs[["param_title_size"]],
    plot_title_size = mod_map_params_outputs[["param_plot_title_size"]],
    user_advanced = mod_map_params_outputs[["param_advanced"]]
  )

}
