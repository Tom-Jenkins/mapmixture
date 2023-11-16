test_that("structure_plot() outputs a ggplot object", {

  obj_admix1 <- data.frame(
    Site = c("London", "London", "Paris", "Paris", "Berlin", "Berlin",
             "Rome", "Rome", "Madrid", "Madrid"),
    Ind = c("London1", "London2", "Paris1", "Paris2", "Berlin1", "Berlin2",
            "Rome1", "Rome2", "Madrid1", "Madrid2"),
    Cluster1 = c(1.0, 0.9, 0.5, 0.5, 0.1, 0.1, 0, 0, 0, 0),
    Cluster2 = c(0, 0.10, 0.50, 0.40, 0.50, 0.40, 0.01, 0.01, 0.70, 0.80),
    Cluster3 = c(0, 0, 0, 0.10, 0.40, 0.50, 0.99, 0.99, 0.30, 0.20)
  )

  expect_no_error(structure_plot(obj_admix1, type = "structure"))
  expect_s3_class(structure_plot(obj_admix1, type = "structure"), "ggplot")

  expect_no_error(structure_plot(obj_admix1, type = "structure", flip_axis = TRUE))
  expect_s3_class(structure_plot(obj_admix1, type = "structure", flip_axis = TRUE), "ggplot")

  expect_no_error(structure_plot(obj_admix1, type = "structure", labels = "individual"))
  expect_s3_class(structure_plot(obj_admix1, type = "structure", labels = "individual"), "ggplot")

  expect_no_error(structure_plot(obj_admix1, type = "structure", labels = "individual", flip_axis = TRUE))
  expect_s3_class(structure_plot(obj_admix1, type = "structure", labels = "individual", flip_axis = TRUE), "ggplot")

  expect_no_error(structure_plot(obj_admix1, type = "facet"))
  expect_s3_class(structure_plot(obj_admix1, type = "facet"), "ggplot")
})
