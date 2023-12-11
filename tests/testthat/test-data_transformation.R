test_that("transform_bbox() outputs a named numeric vector of length 4", {

  obj <- transform_bbox(c(xmin = -3.70, ymin = 40.42, xmax = 13.40, ymax = 52.52), 3035)
  expect_length(obj, 4)
  expect_contains(names(obj), c("xmin", "xmin", "ymin", "ymax"))
})

test_that("transform_admix_data() outputs a data.frame", {

  obj <- data.frame(
    Site = c("London", "London", "Paris", "Paris", "Berlin", "Berlin",
             "Rome", "Rome", "Madrid", "Madrid"),
    Ind = c("London1", "London2", "Paris1", "Paris2", "Berlin1", "Berlin2",
            "Rome1", "Rome2", "Madrid1", "Madrid2"),
    Cluster1 = c(1.0, 0.9, 0.5, 0.5, 0.1, 0.1, 0, 0, 0, 0),
    Cluster2 = c(0, 0.10, 0.50, 0.40, 0.50, 0.40, 0.01, 0.01, 0.70, 0.80),
    Cluster3 = c(0, 0, 0, 0.10, 0.40, 0.50, 0.99, 0.99, 0.30, 0.20)
  )

  expect_s3_class(obj, "data.frame")
})

test_that("merge_coords_data() outputs a data.frame with the correct format", {

  obj_admix <- data.frame(
    Site = c("London", "Paris", "Berlin", "Rome", "Madrid"),
    Cluster1 = c(0.95, 0.5, 0.1, 0, 0),
    Cluster2 = c(0.05, 0.45, 0.45, 0.01, 0.75),
    Cluster3 = c(0, 0.05, 0.45, 0.99, 0.25)
  )
  obj_coords <- data.frame(
    Site = c("London", "Paris", "Berlin", "Rome", "Madrid"),
    Lat = c(51.51, 48.85, 52.52, 41.90, 40.42),
    Lon = c(-0.12, 2.35, 13.40, 12.49, -3.70)
  )
  obj <- merge_coords_data(obj_coords, obj_admix)

  expect_s3_class(obj, "data.frame")
  expect_identical(colnames(obj)[1:3], c("site", "lat", "lon"))
})

test_that("transform_df_coords() outputs a data.frame with the correct format", {

  obj <- data.frame(
    site = c("London", "Paris", "Berlin", "Rome", "Madrid"),
    lat = c(51.51, 48.85, 52.52, 41.90, 40.42),
    lon = c(-0.12, 2.35, 13.40, 12.49, -3.70),
    Cluster1 = c(0.95, 0.5, 0.1, 0, 0),
    Cluster2 = c(0.05, 0.45, 0.45, 0.01, 0.75),
    Cluster3 = c(0, 0.05, 0.45, 0.99, 0.25)
  )

  expect_s3_class(obj, "data.frame")
  expect_identical(colnames(obj)[1:3], c("site", "lat", "lon"))
})
