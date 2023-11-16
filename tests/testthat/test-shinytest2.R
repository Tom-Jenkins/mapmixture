test_that("launch_mapmixture() successfully loads data and outputs map", {
  app <- shinytest2::AppDriver$new(launch_mapmixture())
  # app$set_window_size(width = 1895, height = 1086)

  app$upload_file(`file_upload-admixture_file` = "admixture_data.csv")
  output <- app$get_values()$output
  # str(output)
  expect_type(output$`map_params-cluster_colours_ui`$`html`, "character")
  expect_type(output$`map_params-cluster_names_ui`$`html`, "character")

  app$upload_file(`file_upload-coords_file` = "coordinates.csv")
  # output <- app$get_values()$output
  # str(output)

  app$click("plot_bttn-plot_bttn")
  output <- app$get_values()$output
  # str(output)
  expect_type(output$`main_plot-admixture_map`, "list")
  expect_type(output$`main_plot-dropdown_download_bttn`, "list")
})
