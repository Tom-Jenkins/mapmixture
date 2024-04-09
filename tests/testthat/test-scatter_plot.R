test_that("scatter_plot() outputs a ggplot object", {

  file <- system.file("extdata", "pca_results.csv", package = "mapmixture")
  pca_results <- read.csv(file)

  # Define parameters
  ind_names <- row.names(pca_results)
  site_names <- rep(c("Pop1", "Pop2", "Pop3", "Pop4", "Pop5", "Pop6"), each = 100)
  region_names <- rep(c("Region1", "Region2"), each = 300)
  percent <- c(5.6, 4.5, 3.2, 2.0, 0.52)

  # Scatter plot
  expect_no_error(scatter_plot(pca_results, site_names))
  expect_s3_class(scatter_plot(pca_results, site_names), "ggplot")

  # Scatter plot with axes 1 and 3 and percent on axis labels
  expect_no_error(scatter_plot(pca_results, site_names, axes = c(1,3), percent = percent))
  expect_s3_class(scatter_plot(pca_results, site_names, axes = c(1,3), percent = percent), "ggplot")

  # Scatter plot with no centroids and segments
  expect_no_error(scatter_plot(pca_results, site_names, axes = c(1,2), percent = percent, centroids = FALSE, segments = FALSE))
  expect_s3_class(scatter_plot(pca_results, site_names, axes = c(1,2), percent = percent, centroids = FALSE, segments = FALSE), "ggplot")

  # Scatter plot with custom colours and coloured by other_group
  expect_no_error(scatter_plot(pca_results, site_names, other_group = region_names, percent = percent, colours = c("#f1a340","#998ec3")))
  expect_s3_class(scatter_plot(pca_results, site_names, other_group = region_names, percent = percent, colours = c("#f1a340","#998ec3")), "ggplot")

  # Scatter plot with individual labels
  expect_no_error(scatter_plot(pca_results, site_names, type = "labels", labels = rownames(pca_results)))
  expect_s3_class(scatter_plot(pca_results, site_names, type = "labels", labels = rownames(pca_results)), "ggplot")

  # Scatter plot with individual text
  expect_no_error(scatter_plot(pca_results, site_names, type = "text", labels = rownames(pca_results)))
  expect_s3_class(scatter_plot(pca_results, site_names, type = "text", labels = rownames(pca_results)), "ggplot")
})
