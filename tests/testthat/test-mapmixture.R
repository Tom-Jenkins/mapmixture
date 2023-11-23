test_that("mapmixture() outputs a ggplot object", {

  obj_admix1 <- data.frame(
    Site = c("London", "London", "Paris", "Paris", "Berlin", "Berlin",
             "Rome", "Rome", "Madrid", "Madrid"),
    Ind = c("London1", "London2", "Paris1", "Paris2", "Berlin1", "Berlin2",
            "Rome1", "Rome2", "Madrid1", "Madrid2"),
    Cluster1 = c(1.0, 0.9, 0.5, 0.5, 0.1, 0.1, 0, 0, 0, 0),
    Cluster2 = c(0, 0.10, 0.50, 0.40, 0.50, 0.40, 0.01, 0.01, 0.70, 0.80),
    Cluster3 = c(0, 0, 0, 0.10, 0.40, 0.50, 0.99, 0.99, 0.30, 0.20)
  )
  obj_coords <- data.frame(
    Site = c("London", "Paris", "Berlin", "Rome", "Madrid"),
    Lat = c(51.51, 48.85, 52.52, 41.90, 40.42),
    Lon = c(-0.12, 2.35, 13.40, 12.49, -3.70)
  )

  expect_no_error(mapmixture(obj_admix1, obj_coords))
  expect_s3_class(mapmixture(obj_admix1, obj_coords), "ggplot")


  obj_admix2 <- data.frame(
    Site = c("London", "Paris", "Berlin", "Rome", "Madrid"),
    Ind = c("London", "Paris", "Berlin", "Rome", "Madrid"),
    Cluster1 = c(0.95, 0.5, 0.1, 0, 0),
    Cluster2 = c(0.05, 0.45, 0.45, 0.01, 0.75),
    Cluster3 = c(0, 0.05, 0.45, 0.99, 0.25)
  )

  expect_no_error(mapmixture(obj_admix2, obj_coords))
  expect_s3_class(mapmixture(obj_admix2, obj_coords), "ggplot")


  obj_admix3 <- data.frame(
    Site = c("London", "Paris", "Berlin", "Rome", "Madrid"),
    Ind = c("London", "Paris", "Berlin", "Rome", "Madrid"),
    Cluster1 = c(1, 1, 0, 0, 0),
    Cluster2 = c(0, 0, 1, 0, 1),
    Cluster3 = c(0, 0, 0, 1, 0)
  )

  expect_no_error(mapmixture(obj_admix3, obj_coords))
  expect_s3_class(mapmixture(obj_admix3, obj_coords), "ggplot")


  obj_admix4 <- data.frame(
    Site = c("London", "Paris", "Berlin", "Rome", "Madrid"),
    Ind = c("London", "Paris", "Berlin", "Rome", "Madrid"),
    Cluster1 = c(1, 1, 0, 0, 0),
    Cluster2 = c(0, 0, 1, 0, 1),
    Cluster3 = c(0, 0, 0, 1, 0)
  )
  obj_coords2 <- data.frame(
    Site = c("London_error", "Paris", "Berlin", "Rome", "Madrid"),
    Lat = c(51.51, 48.85, 52.52, 41.90, 40.42),
    Lon = c(-0.12, 2.35, 13.40, 12.49, -3.70)
  )

  expect_error(mapmixture(obj_admix4, obj_coords2))
})

test_that("calc_default_bbox() outputs a correct bbox object", {

  obj <- data.frame(
    site = c("Site1","Site2","Site3"),
    lat = c(40.0, 50.5, 60.5),
    lon = c(-1.0, 5.0, 10.5)
  )

  expect_s3_class(calc_default_bbox(obj), "bbox")
  expect_length(calc_default_bbox(obj), 4)
})
