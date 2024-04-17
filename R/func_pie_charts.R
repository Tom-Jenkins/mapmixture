#' Create Pie Charts
#'
#' @description
#' Internal function used to add pie charts to a ggplot object.
#' @keywords internal
#'
#' @param df data.frame (see examples).
#' @param admix_columns the columns of the data.frame containing admixture data.
#' @param lat_column string or integer representing the latitude column.
#' @param lon_column string or integer representing the longitude column.
#' @param pie_colours vector of colours the same length as the number of clusters.
#' @param border numeric value of zero or greater.
#' @param opacity numeric value of zero to one.
#' @param pie_size numeric value of zero or greater.
#'
#' @return A list of `annotation_custom()` objects.
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
#' df <- data.frame(
#'   site = c("London", "Paris", "Berlin", "Rome", "Madrid"),
#'   lat = c(6712008, 6249448, 6894700, 5146012, 4927165),
#'   lon = c(-13358.34, 261600.80, 1491681.18, 1390380.44, -411882.12),
#'   Cluster1 = c(0.95, 0.5, 0.1, 0, 0),
#'   Cluster2 = c(0.05, 0.45, 0.45, 0.01, 0.75),
#'   Cluster3 = c(0, 0.05, 0.45, 0.99, 0.25)
#' )
#'
#' add_pie_charts(df,
#'   admix_columns = 4:ncol(df),
#'   lat_column = "lat",
#'   lon_column = "lon",
#'   pie_colours = c("blue","purple","green"),
#'   border = 0.3,
#'   opacity = 1,
#'   pie_size = 1
#' )
add_pie_charts <- function(df, admix_columns, lat_column, lon_column, pie_colours,
                           border = 0.3, opacity = 1, pie_size = 1) {

  # Check the number of pie_colours is the same length as the number of clusters
  if ( ncol(df)-3 != length(pie_colours) ) {
    stop("Length of pie_colours is not equal to the number of clusters in data frame.")
  }

  # Subset coordinates
  coords <- df[c(lat_column, lon_column)]

  # Store coordinates as a list
  coord_list <- purrr::map(1:nrow(coords), ~ c(coords[., ]$lat, coords[., ]$lon))

  # Convert data.frame from wide to long format
  df_long <- tidyr::pivot_longer(
    data = df,
    cols = dplyr::all_of(admix_columns),
    names_to = "cluster",
    values_to = "value"
  )

  # Build pie charts for all sites and store as a list of ggplot objects
  pie_list <- purrr::map(unique(df$site), ~ build_pie_chart(
    df = df_long,
    location = .,
    cols = pie_colours,
    border = border,
    opacity = opacity
  ))

  # Pie chart size formula
  radius <- dplyr::case_when(
    # If absolute number has less than or equal to 3 digits
    floor(log10(abs(coords$lat[1]))) + 1 <= 3  ~ 0.5 * pie_size,
    # If absolute number has greater than 3 digits
    floor(log10(abs(coords$lat[1]))) + 1 > 3 && floor(log10(abs(coords$lat[1]))) ~ 80000 * pie_size,
  )

  # Convert pie chart ggplot objects to annotation custom geom objects
  pie_annotation <- purrr::map(1:length(pie_list), ~ ggplot2::annotation_custom(
    grob = ggplot2::ggplotGrob(pie_list[[.]]),
    ymin = coord_list[[.]][1] - radius,
    ymax = coord_list[[.]][1] + radius,
    xmin = coord_list[[.]][2] - radius,
    xmax = coord_list[[.]][2] + radius
  ))

  # Return list of annotation_custom objects
  return(pie_annotation)
}


#' Build Pie Chart
#'
#' @description
#' Internal function used to build a pie chart using ggplot
#' @keywords internal
#'
#' @param df data.frame (see examples).
#' @param location string containing the site to subset.
#' @param cols vector of colours the same length as the number of clusters.
#' @param border numeric value of zero or greater.
#' @param opacity numeric value of zero to one.
#'
#' @return A ggplot object.
#' @export
#'
#' @examples
#' df <- data.frame(
#'   site = c("London","London","London","Paris","Paris","Paris",
#'            "Berlin","Berlin","Berlin","Rome","Rome","Rome",
#'            "Madrid","Madrid","Madrid"),
#'   cluster = c("Cluster1","Cluster2","Cluster3","Cluster1","Cluster2","Cluster3",
#'               "Cluster1","Cluster2","Cluster3","Cluster1","Cluster2","Cluster3",
#'               "Cluster1","Cluster2","Cluster3"),
#'   value = c(0.95, 0.05, 0, 0.50, 0.45, 0.05, 0.10, 0.45, 0.45, 0,
#'             0.01, 0.99, 0, 0.75, 0.25)
#' )
#'
#' build_pie_chart(df, location = "London")
build_pie_chart <- function(df, location, cols = NULL, border = 0.3, opacity = 1){

  # Subset data.frame by site
  df_site <- subset(df, df$site == location)

  # Create a vector of default colours if cluster_cols parameter not set
  if (is.null(cols)) {
    pal <- grDevices::colorRampPalette(c("green","blue")) # green-blue colour palette
    cols <- pal(nrow(df_site)) # number of cluster colours for palette
  }

  # Build pie chart for single-coloured pie charts (File Format 3)
  if ( any(df_site$value == 1) ) {

    # Which cluster row has proportion of 1
    proportion1 <- df_site[which(df_site$value == 1), ]

    # Extract the cluster name
    cluster_name <- proportion1$cluster

    # Extract the cluster number
    cluster_number <- as.numeric(stringr::str_extract(cluster_name, "\\d+"))

    # Extract the corresponding colour
    cluster_col <- cols[cluster_number]

    # Create a circle using circleGrob
    circle <- grid::circleGrob(
      x = ggplot2::unit(0.5, "npc"),
      y = ggplot2::unit(0.5, "npc"),
      r = ggplot2::unit(0.35, "npc"),
      gp = grid::gpar(col = "black", fill = cluster_col, alpha = opacity, lwd = border)
    )

    # # Create a vertical line
    # line <- grid::linesGrob(
    #   x = c(0.5, 0.5),
    #   y = c(0.5, ggplot2::unit(0.5 + 0.35, "npc")),
    #   gp = grid::gpar(col = "black", lwd = border)
    # )
    #
    # # Draw the circle and the line
    # single_colour_pie <- grid::gTree(children = grid::gList(circle, line))

    # Plot
    plt <- ggplot2::ggplot() +
      ggplot2::geom_point(ggplot2::aes(x = NA, y = NA), colour = "transparent")+
      ggplot2::annotation_custom(grob = circle)+
      ggplot2::theme_void()
    return(plt)

  # Build pie chart for multi-coloured pie charts (File Format 1 and 2)
  } else {
    plt <- ggplot2::ggplot(data = df_site)+
      ggplot2::geom_bar(
        ggplot2::aes(x = "", y = !!as.name("value"), fill = !!as.name("cluster")),
        width = 1, stat = "identity", colour = "black",
        show.legend = FALSE, linewidth = border, alpha = opacity
      )+
      ggplot2::coord_polar(theta = "y")+
      ggplot2::scale_fill_manual(values = cols)+
      ggplot2::theme_void()
    return(plt)
  }
}
