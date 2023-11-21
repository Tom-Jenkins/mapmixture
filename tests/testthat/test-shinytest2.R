# test_that("Shiny app successfully loads data and outputs map", {
#   app <- shinytest2::AppDriver$new(launch_mapmixture())
#   # app$set_window_size(width = 1895, height = 1086)
#
#   # Upload admixture file
#   app$upload_file(`file_upload-admixture_file` = "admixture1.csv")
#   output <- app$get_values()$output
#   # str(output)
#
#   # Check that colour and cluster names render to UI
#   expect_type(output$`map_params-cluster_colours_ui`$`html`, "character")
#   expect_type(output$`map_params-cluster_names_ui`$`html`, "character")
#
#   # Upload coordinates file
#   app$upload_file(`file_upload-coords_file` = "coordinates.csv")
#   # output <- app$get_values()$output
#   # str(output)
#
#   # Click the plot button
#   app$click("plot_bttn-plot_bttn")
#   output <- app$get_values()$output
#   # str(output)
#
#   # Check the map and download buttons render to UI
#   expect_type(output$`main_plot-admixture_map`, "list")
#   expect_type(output$`main_plot-dropdown_download_bttn`, "list")
#   app$expect_html("#main_plot-download_bttn")
#
#   # Check that filetype radio buttons change when clicked
#   app$click(selector = "#main_plot-filetype_radio_bttn1")
#   expect_true(print(app$get_js("document.getElementById('main_plot-filetype_radio_bttn1').checked")))
#   app$click(selector = "#main_plot-filetype_radio_bttn2")
#   expect_true(print(app$get_js("document.getElementById('main_plot-filetype_radio_bttn2').checked")))
#   app$click(selector = "#main_plot-filetype_radio_bttn3")
#   expect_true(print(app$get_js("document.getElementById('main_plot-filetype_radio_bttn3').checked")))
#
#   # Check that map downloads when download button is clicked
#   expect_no_error(app$get_download("download_bttn"))
#
#   # app$view()
# })
#
# test_that("Invalid file uploads render feedback messages to UI", {
#   app <- shinytest2::AppDriver$new(launch_mapmixture())
#
#   # Blank (NA) in site column
#   app$upload_file(`file_upload-admixture_file` = "admixture1_invalid_na1.csv")
#   app$expect_html("#admixture-error-message")
#
#   # Blank (NA) in individual column
#   app$upload_file(`file_upload-admixture_file` = "admixture1_invalid_na2.csv")
#   app$expect_html("#admixture-error-message")
#
#   # Blank (NA) in one cluster column
#   app$upload_file(`file_upload-admixture_file` = "admixture1_invalid_na3i.csv")
#   app$expect_html("#admixture-error-message")
#
#   # Blank (NA) in one or more cluster columns
#   app$upload_file(`file_upload-admixture_file` = "admixture1_invalid_na3ii.csv")
#   app$expect_html("#admixture-error-message")
#
#   # Incorrect data type in one cluster column
#   app$upload_file(`file_upload-admixture_file` = "admixture1_invalid_type1.csv")
#   app$expect_html("#admixture-error-message")
#
#   # Incorrect data type in one or more cluster columns
#   app$upload_file(`file_upload-admixture_file` = "admixture1_invalid_type2.csv")
#   app$expect_html(".error-message")
#
#   # One or more cluster rows do not sum to 1
#   # app$upload_file(`file_upload-admixture_file` = "admixture1_invalid_sum.csv")
#   # app$expect_html("#admixture-error-message")
#
#   # Invalid coordinates file
#   app$upload_file(`file_upload-admixture_file` = "admixture1.csv")
#   app$upload_file(`file_upload-coords_file` = "coordinates_invalid_file.csv")
#   app$expect_html(".error-message")
#
#   # Site names in coordinates file do not match that in the admixture file
#   app$upload_file(`file_upload-coords_file` = "coordinates_invalid_site_names.csv")
#   app$expect_html(".error-message")
#
#   # Blank (NA) in site column
#   app$upload_file(`file_upload-coords_file` = "coordinates_invalid_na1.csv")
#   app$expect_html(".error-message")
#
#   # Blank (NA) in lat column
#   app$upload_file(`file_upload-coords_file` = "coordinates_invalid_na2.csv")
#   app$expect_html(".error-message")
#
#   # Blank (NA) in lon column
#   app$upload_file(`file_upload-coords_file` = "coordinates_invalid_na3.csv")
#   app$expect_html(".error-message")
#
#   # Incorrect data type in lat column
#   app$upload_file(`file_upload-coords_file` = "coordinates_invalid_typeLat.csv")
#   app$expect_html(".error-message")
#
#   # Incorrect data type in lon column
#   app$upload_file(`file_upload-coords_file` = "coordinates_invalid_typeLon.csv")
#   app$expect_html(".error-message")
#
#   # app$view()
# })
#
# test_that("Admixture information modal renders when button is clicked", {
#   app <- shinytest2::AppDriver$new(launch_mapmixture())
#
#   # Click the admixture info button to open the modal
#   app$click(input = "file_upload-admixture_info_bttn")
#
#   # Check that modal has opened
#   app$expect_html("#shiny-modal-wrapper")
#
#   # Close the modal
#   app$click(selector = ".modal-close-bttn")
#
#   # app$view()
# })
#
# test_that("Coordinates information modal renders when button is clicked", {
#   app <- shinytest2::AppDriver$new(launch_mapmixture())
#
#   # Click the coords info button to open the modal
#   app$click(input = "file_upload-coords_info_bttn")
#
#   # Check that modal has opened
#   app$expect_html("#shiny-modal-wrapper")
#
#   # Close the modal
#   app$click(selector = ".modal-close-bttn")
#
#   # app$view()
# })
