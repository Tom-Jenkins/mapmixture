#' Transform Bounding Box Coordinates
#'
#' @description
#' Internal function used to transform latitude and longitude coordinates
#' from a bounding box to a target coordinate reference system.
#'
#' @param bbox a named numeric vector of length four, with `xmin`, `ymin`, `xmax` and `ymax` values.
#' @param CRS a numeric value representing an ESPG.
#'
#' @return A transformed named numeric vector
#' @export
#'
#' @examples
#' bbox <- c(xmin = -3.70, ymin = 40.42, xmax = 13.40, ymax = 52.52)
#' transform_bbox(bbox, 3035)
transform_bbox <- function(bbox, CRS) {

  bbox |>
    sf::st_bbox(obj = _, crs = 4326) |>
    sf::st_as_sfc(x = _) |>
    sf::st_transform(x = _, crs = CRS) |>
    sf::st_bbox(obj = _)
}

#' Transform Admixture Data
#'
#' @description
#' Internal function used to transform admixture data into the correct format for plotting.
#'
#' @param data A data.frame or tibble.
#'
#' @return A data.frame or tibble.
#' @export
#'
#' @examples
#' # Admixture Format 1
#' df_admix <- data.frame(
#'   Site = c("London", "London", "Paris", "Paris", "Berlin", "Berlin",
#'    "Rome", "Rome", "Madrid", "Madrid"),
#'   Ind = c("London1", "London2", "Paris1", "Paris2", "Berlin1", "Berlin2",
#'    "Rome1", "Rome2", "Madrid1", "Madrid2"),
#'   Cluster1 = c(1.0, 0.9, 0.5, 0.5, 0.1, 0.1, 0, 0, 0, 0),
#'   Cluster2 = c(0, 0.10, 0.50, 0.40, 0.50, 0.40, 0.01, 0.01, 0.70, 0.80),
#'   Cluster3 = c(0, 0, 0, 0.10, 0.40, 0.50, 0.99, 0.99, 0.30, 0.20)
#' )
#'
#' transform_admix_data(df_admix)
transform_admix_data <- function(data) {

  # Convert headers to lowercase
  colnames(data) <- stringr::str_to_lower(colnames(data))

  # Convert wide to long format
  df <- tidyr::pivot_longer(data, cols = c(3:ncol(data)), names_to = "cluster", values_to = "admixture")

  # Calculate mean admixture proportions for each site
  df <- stats::aggregate(x = df["admixture"], by = list(site = df$site, cluster = df$cluster), FUN = mean)

  # Convert to the format required for scatterpie
  df <- tidyr::pivot_wider(df, names_from = 2, values_from = 3)

  # Order rows by site
  df <- dplyr::arrange(df, df[["site"]])

  # Return data.frame
  return(df)
}

#' Merge coordinates and admixture data
#'
#' @description
#' Internal function used to join coordinates and admixture pie data.
#'
#' @param coord_df A data.frame of site names and coordinates.
#' @param admix_df A data.frame of site names and admixture data.
#'
#' @return `data.frame`
#' @export
#'
#' @examples
#' # Admixture Format 1
#' df_admix <- data.frame(
#'   Site = c("London", "Paris", "Berlin", "Rome", "Madrid"),
#'   Cluster1 = c(0.95, 0.5, 0.1, 0, 0),
#'   Cluster2 = c(0.05, 0.45, 0.45, 0.01, 0.75),
#'   Cluster3 = c(0, 0.05, 0.45, 0.99, 0.25)
#' )
#'
#' # Coordinates Format
#' df_coords <- data.frame(
#'   Site = c("London", "Paris", "Berlin", "Rome", "Madrid"),
#'   Lat = c(51.51, 48.85, 52.52, 41.90, 40.42),
#'   Lon = c(-0.12, 2.35, 13.40, 12.49, -3.70)
#' )
#'
#' merge_coords_data(df_coords, df_admix)
merge_coords_data <- function(coord_df, admix_df) {

  # Convert headers to lowercase
  colnames(coord_df) <- stringr::str_to_lower(colnames(coord_df))
  colnames(admix_df) <- stringr::str_to_lower(colnames(admix_df))

  # Join admixture with coordinates by site column
  admix_coords <- dplyr::left_join(x = coord_df, y = admix_df, by = "site")

  # Return tibble
  return(admix_coords)
}

#' Transform Coordinates in Data Frame
#'
#' @description
#' Internal function used to transform latitude and longitude coordinates in
#' admixture data.frame.
#'
#' @param df a data.frame containing site names, lat and lon coordinates and admixture data.
#' @param crs a coordinate reference system.
#'
#' @return a data.frame with coordinates transformed.
#' @export
#'
#' @examples
#' df <- data.frame(
#'   site = c("London", "Paris", "Berlin", "Rome", "Madrid"),
#'   lat = c(51.51, 48.85, 52.52, 41.90, 40.42),
#'   lon = c(-0.12, 2.35, 13.40, 12.49, -3.70),
#'   Cluster1 = c(0.95, 0.5, 0.1, 0, 0),
#'   Cluster2 = c(0.05, 0.45, 0.45, 0.01, 0.75),
#'   Cluster3 = c(0, 0.05, 0.45, 0.99, 0.25)
#' )
#'
#' transform_df_coords(df, crs = 3857)
transform_df_coords <- function(df, crs) {

  # Transform coordinates to CRS
  transformed_df <- df |>
    sf::st_as_sf(x = _, coords = c("lon", "lat")) |>
    sf::st_set_crs(x = _, 4326) |>
    sf::st_transform(x = _, crs = crs)

  # Prepare data.frame for plotting
  transformed_df <- data.frame(
    site = transformed_df$site,
    lat = sf::st_coordinates(transformed_df)[,"Y"],
    lon = sf::st_coordinates(transformed_df)[,"X"],
    sf::st_drop_geometry(transformed_df[2:ncol(transformed_df)])
  )

  # Return transformed object
  return(transformed_df)
}