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
#' @param border_col string denoting colour of pie border.
#' @param opacity numeric value of zero to one.
#' @param pie_size vector of numeric values of zero or greater. Can be a single value or a vector the same length as the number of sites.
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
add_pie_charts <- function(
  df,
  admix_columns,
  lat_column,
  lon_column,
  pie_colours,
  border = 0.3,
  border_col = "black",
  opacity = 1,
  pie_size = 1,
  repel = FALSE,
  repel_force = 1,
  repel_spring = 0.05,
  repel_padding = 0.1,
  min_segment_len = 0
) {
  if (ncol(df) - 3 != length(pie_colours)) {
    stop(
      "Length of pie_colours is not equal to the number of clusters in data frame."
    )
  }

  coords <- df[c(lat_column, lon_column)]

  # Pie chart size formula (existing logic)
  radius <- dplyr::case_when(
    floor(log10(abs(coords$lat[1]))) + 1 <= 3 ~ 1 * pie_size,
    floor(log10(abs(coords$lat[1]))) + 1 > 3 ~ 80000 * pie_size,
  )

  # Expand radius to full vector
  if (length(radius) == 1) {
    radius_vec <- rep(radius, nrow(coords))
  } else {
    radius_vec <- radius
  }

  # --- Repulsion step ---
  if (repel) {
    repelled <- repel_pies(
      x = coords$lon,
      y = coords$lat,
      radius = radius_vec,
      force = repel_force,
      spring_force = repel_spring,
      padding = repel_padding
    )
    # Use displaced positions for pie placement
    plot_coords <- data.frame(lat = repelled$y, lon = repelled$x)
    # Store originals for leader lines
    orig_coords <- data.frame(lat = repelled$y_orig, lon = repelled$x_orig)
  } else {
    plot_coords <- coords
    orig_coords <- NULL
  }

  coord_list <- purrr::map(
    1:nrow(plot_coords),
    ~ c(plot_coords[., ]$lat, plot_coords[., ]$lon)
  )

  # Build pie charts (existing logic)
  df_long <- tidyr::pivot_longer(
    data = df,
    cols = dplyr::all_of(admix_columns),
    names_to = "cluster",
    values_to = "value"
  )

  pie_list <- purrr::map(
    unique(df$site),
    ~ build_pie_chart(
      df = df_long,
      location = .,
      cols = pie_colours,
      border = border,
      opacity = opacity,
      border_col = border_col
    )
  )

  # Annotation custom objects at displaced positions
  pie_annotation <- purrr::map(
    1:length(pie_list),
    ~ ggplot2::annotation_custom(
      grob = ggplot2::ggplotGrob(pie_list[[.]]),
      ymin = coord_list[[.]][1] - radius_vec[[.]],
      ymax = coord_list[[.]][1] + radius_vec[[.]],
      xmin = coord_list[[.]][2] - radius_vec[[.]],
      xmax = coord_list[[.]][2] + radius_vec[[.]]
    )
  )

  # --- Leader lines and origin points from original to displaced positions ---
  if (repel && !is.null(orig_coords)) {
    displaced <- sqrt(
      (plot_coords$lon - orig_coords$lon)^2 +
        (plot_coords$lat - orig_coords$lat)^2
    )
    threshold <- mean(radius_vec) * 0.01
    moved <- displaced > threshold

    if (any(moved)) {
      segments_df <- data.frame(
        x = orig_coords$lon[moved],
        y = orig_coords$lat[moved],
        xend = plot_coords$lon[moved],
        yend = plot_coords$lat[moved]
      )

      # Small point at original coordinate
      origin_points <- ggplot2::geom_point(
        data = segments_df,
        ggplot2::aes(x = x, y = y),
        colour = "black",
        fill = "black",
        size = 1.5,
        shape = 21,
        stroke = 0.3,
        inherit.aes = FALSE
      )

      # Leader line from origin to displaced pie
      leader_lines <- ggplot2::geom_segment(
        data = segments_df,
        ggplot2::aes(x = x, y = y, xend = xend, yend = yend),
        colour = "black",
        linewidth = 0.3,
        linetype = "solid",
        inherit.aes = FALSE
      )

      return(c(list(origin_points), list(leader_lines), pie_annotation))
    }
  }

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
#' @param border_col string denoting colour of pie border.
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
build_pie_chart <- function(
  df,
  location,
  cols = NULL,
  border = 0.3,
  opacity = 1,
  border_col = "black"
) {
  # Subset data.frame by site
  df_site <- subset(df, df$site == location)

  # Create a vector of default colours if cluster_cols parameter not set
  if (is.null(cols)) {
    pal <- grDevices::colorRampPalette(c("green", "blue")) # green-blue colour palette
    cols <- pal(nrow(df_site)) # number of cluster colours for palette
  }

  # Build pie chart for single-coloured pie charts (File Format 3)
  if (any(df_site$value == 1)) {
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
      r = ggplot2::unit(0.40, "npc"), # Issue #16
      gp = grid::gpar(
        col = border_col,
        fill = cluster_col,
        alpha = opacity,
        lwd = border + 0.4
      )
    )

    # Plot
    plt <- ggplot2::ggplot() +
      ggplot2::geom_point(
        ggplot2::aes(x = NA, y = NA),
        colour = "transparent"
      ) +
      ggplot2::annotation_custom(grob = circle) +
      ggplot2::theme_void()
    return(plt)

    # Build pie chart for multi-coloured pie charts (File Format 1 and 2)
  } else {
    plt <- ggplot2::ggplot(data = df_site) +
      ggplot2::geom_bar(
        ggplot2::aes(
          x = "",
          y = !!as.name("value"),
          fill = !!as.name("cluster")
        ),
        width = 1,
        stat = "identity",
        colour = border_col,
        show.legend = FALSE,
        linewidth = border,
        alpha = opacity
      ) +
      ggplot2::coord_polar(theta = "y") +
      ggplot2::scale_fill_manual(values = cols) +
      ggplot2::theme_void()
    return(plt)
  }
}
