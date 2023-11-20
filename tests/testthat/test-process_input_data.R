test_that("read_input_data() outputs a data.frame with the expected number of columns", {

  obj <- read_input_data(system.file("extdata", "admixture1.csv", package = "mapmixture"))
  expect_s3_class(obj, "data.frame")
  expect_true(ncol(obj) >= 3)

  obj <- read_input_data(system.file("extdata", "admixture1.tsv", package = "mapmixture"))
  expect_s3_class(obj, "data.frame")
  expect_true(ncol(obj) >= 3)

  obj <- read_input_data(system.file("extdata", "admixture1.txt", package = "mapmixture"))
  expect_s3_class(obj, "data.frame")
  expect_true(ncol(obj) >= 3)

  obj <- read_input_data(system.file("extdata", "coordinates.csv", package = "mapmixture"))
  expect_s3_class(obj, "data.frame")
  expect_true(ncol(obj) == 3)

  expect_error(read_input_data("admixture1_invalid_ws"))
})

test_that("standardise_data() output a data.frame with the expected column names", {

  obj <- read_input_data(system.file("extdata", "admixture1.csv", package = "mapmixture"))
  obj <- standardise_data(obj, type = "admixture")
  expect_s3_class(obj, "data.frame")
  expect_identical(colnames(obj)[1:2], c("site", "ind"))
  expect_type(obj[[1]], "character")
  expect_type(obj[[2]], "character")
  expect_true(all(apply(obj[3:ncol(obj)], MARGIN = 2, FUN = is.numeric)))

  obj <- read_input_data(system.file("extdata", "coordinates.csv", package = "mapmixture"))
  obj <- standardise_data(obj, type = "coordinates")
  expect_s3_class(obj, "data.frame")
  expect_identical(colnames(obj)[1:3], c("site", "lat", "lon"))
  expect_type(obj[[1]], "character")
  expect_true(all(apply(obj[2:3], MARGIN = 2, FUN = is.numeric)))
})
