#' Read Input Data
#'
#' @description
#' Internal function used to read in data from admixture or coordinates input file.
#' @keywords internal
#'
#' @param file path to input file.
#'
#' @return A data.frame object.
#' @export
#'
#' @examples
#' file_path <- system.file("extdata", "admixture1.csv", package = "mapmixture")
#' read_input_data(file_path)
read_input_data <- function(file) {

  # File extension
  ext <- tools::file_ext(file)
  # print(ext)

  # Read in file according to the field separator character
  df <- switch(ext,
    csv = utils::read.table(file, sep = ",", header = TRUE),
    tsv = utils::read.table(file, sep = "\t", header= TRUE),
    txt = utils::read.table(file, sep = "\t", header = TRUE),
    stop("Invalid file. Please upload a valid .csv, .tsv, or .txt file.")
  )

  # Return data.frame
  return(df)
}


#' Standardise Input Data
#' @description
#' Internal function used to standardise the output from `mapmixture::read_input_data()`.
#' @keywords internal
#'
#' @param df a data.frame.
#' @param type type of file to process (`"admixture"` or `"coordinates"`).
#'
#' @return A data.frame object.
#' @export
#'
#' @examples
#' # Standardise admixture data
#' df_admix <- data.frame(
#'   Site = c("London", "London", "Paris", "Paris", "Berlin", "Berlin",
#'    "Rome", "Rome", "Madrid", "Madrid"),
#'   Ind = c("London1", "London2", "Paris1", "Paris2", "Berlin1", "Berlin2",
#'    "Rome1", "Rome2", "Madrid1", "Madrid2"),
#'   Cluster1 = c(1.0, 0.9, 0.5, 0.5, 0.1, 0.1, 0, 0, 0, 0),
#'   Cluster2 = c(0, 0.10, 0.50, 0.40, 0.50, 0.40, 0.01, 0.01, 0.70, 0.80),
#'   Cluster3 = c(0, 0, 0, 0.10, 0.40, 0.50, 0.99, 0.99, 0.30, 0.20)
#' )
#' standardise_data(df_admix, type = "admixture")
#'
#' # Standardise coordinates data
#' df_coords <- data.frame(
#'   Site = c("London", "Paris", "Berlin", "Rome", "Madrid"),
#'   Lat = c(51.51, 48.85, 52.52, 41.90, 40.42),
#'   Lon = c(-0.12, 2.35, 13.40, 12.49, -3.70)
#' )
#' standardise_data(df_coords, type = "coordinates")
standardise_data <- function(df, type = "admixture") {

  # Process admixture tibble
  if (type == "admixture") {

    # Rename first and second column names
    colnames(df)[1] <- "site"
    colnames(df)[2] <- "ind"

    # Convert first two columns to character type
    df[[1]] <- as.character(df[[1]])
    df[[2]] <- as.character(df[[2]])

    # Order alphabetically by site
    # df <- df[order(df$site, df$ind), ]
    df <- df[order(df$site), ]

    # Convert all column names to lower case
    colnames(df) <- stringr::str_to_lower(colnames(df))

    # GitHub Issue #28 (changed cluster1 to cluster01, cluster2 to cluster02, etc.)
    # Rename cluster columns to cluster01-clusterN
    num_clusters <- ncol(df)-2
    colnames(df)[3:ncol(df)] <- sprintf("cluster%02d", 1:num_clusters)
  }

  # Process coordinates tibble
  if (type == "coordinates") {

    # Rename first, second and third column names
    colnames(df)[1] <- "site"
    colnames(df)[2] <- "lat"
    colnames(df)[3] <- "lon"

    # Convert first column to character type
    df[[1]] <- as.character(df[[1]])

    # Order alphabetically by site
    df <- df[order(df$site), ]

    # Convert all column names to lower case
    colnames(df) <- stringr::str_to_lower(colnames(df))
  }

  # Return tibble
  return(df)
}
