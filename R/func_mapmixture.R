#' Plot Pie Charts on Map
#'
#' @description
#' Plot admixture proportions as pie charts on a projected map.
#' In data sets where there are multiple individuals per site,
#' the function will calculate the mean average admixture proportion for each site.
#'
#' @param admixture_df data.frame or tibble containing admixture data (see examples).
#' @param coords_df data.frame or tibble containing coordinates data (see examples).
#' @param cluster_cols character vector of colours the same length as the number of clusters.
#' If `NULL`, a blue-green palette is used.
#' @param cluster_names character vector of names the same length as the number of clusters.
#' If `NULL`, the cluster column names are used.
#' @param boundary named numeric vector defining the map bounding. e.g. `c(xmin=-15, xmax=15, ymin=30, ymax=50)`.
#' If `NULL`, a default bounding box is calculated.
#' @param crs coordinate reference system. Default is the WGS 84 - World Geodetic System 1984 (EPSG:`4326`).
#' See `?sf::st_crs` for details.
#' @param basemap SpatRaster or sf object to use as the basemap. A SpatRaster object can be created from a file
#' using the `terra::rast()` function. A sf object can be created from a file
#' using the `sf::st_read()` function. If `NULL`, world country boundaries are used.
#' @param pie_size numeric value of zero or greater.
#' @param pie_border numeric value of zero or greater.
#' @param pie_opacity numeric value of zero to one.
#' @param land_colour string defining the colour of land.
#' @param sea_colour string defining the colour of sea.
#' @param expand expand axes (`TRUE` or `FALSE`).
#' @param arrow show arrow (`TRUE` or `FALSE`). Added using the `ggspatial::annotation_north_arrow()` function.
#' @param arrow_size numeric value of zero or greater.
#' @param arrow_position string defining the position of the arrow (`"tl"`, `"tr"`, `"bl"`, `"br"`).
#' @param scalebar show scalebar (`TRUE` or `FALSE`). Added using the `ggspatial::annotation_scale()` function.
#' @param scalebar_size numeric value of zero or greater.
#' @param scalebar_position string defining the position of the scalebar (`"tl"`, `"tr"`, `"bl"`, `"br"`).
#' @param plot_title string defining the main title of the plot.
#' @param plot_title_size numeric value of zero or greater.
#' @param axis_title_size numeric value of zero or greater.
#' @param axis_text_size numeric value of zero or greater.
#'
#' @return A ggplot object.
#' @export
#'
#' @examples
#' # Admixture Format 1
#' file <- system.file("extdata", "admixture1.csv", package = "mapmixture")
#' admixture1 <- read.csv(file)
#'
#' # Admixture Format 2
#' file <- system.file("extdata", "admixture2.csv", package = "mapmixture")
#' admixture2 <- read.csv(file)
#'
#' # Admixture Format 3
#' file <- system.file("extdata", "admixture3.csv", package = "mapmixture")
#' admixture3 <- read.csv(file)
#'
#' # Coordinates Format
#' file <- system.file("extdata", "coordinates.csv", package = "mapmixture")
#' coordinates <- read.csv(file)
#'
#' # Plot using default parameters
#' mapmixture(admixture1, coordinates)
#'
#' \donttest{# Plot using the ETRS89-extended / LAEA Europe coordinate reference system
#' mapmixture(admixture1, coordinates, crs = 3035)}
#'
#' \donttest{# Plot using custom parameters
#' mapmixture(
#'   admixture_df = admixture1,
#'   coords_df = coordinates,
#'   cluster_cols = c("#f1a340","#998ec3"),
#'   cluster_names = c("Group 1","Group 2"),
#'   crs = "+proj=merc +a=6378137 +b=6378137 +lat_ts=0 +lon_0=0 +x_0=0 +y_0=0 +units=m",
#'   boundary = c(xmin=-15, xmax=16, ymin=40, ymax=62),
#'   pie_size = 1.5,
#'   pie_border = 0.2,
#'   pie_opacity = 1,
#'   land_colour = "#d9d9d9",
#'   sea_colour = "#deebf7",
#'   expand = FALSE,
#'   arrow = TRUE,
#'   arrow_size = 1,
#'   arrow_position = "tl",
#'   scalebar = TRUE,
#'   scalebar_size = 1,
#'   scalebar_position = "tl",
#'   plot_title = "Mapmixture Figure",
#'   plot_title_size = 15,
#'   axis_title_size = 12,
#'   axis_text_size = 10
#' )}
mapmixture <- function(
  # Data input
  admixture_df, coords_df,
  # Parameter arguments
  cluster_cols = NULL, cluster_names = NULL,
  boundary = NULL, crs = 4326, basemap = NULL,
  pie_size = 1, pie_border = 0.2, pie_opacity = 1,
  land_colour = "#d9d9d9", sea_colour = "#deebf7",
  expand = FALSE,
  arrow = TRUE, arrow_size = 1, arrow_position = "tl",
  scalebar = TRUE, scalebar_size = 1, scalebar_position = "tl",
  plot_title = "", plot_title_size = 12,
  axis_title_size = 10, axis_text_size = 8) {


  # Download countries10.rda file to mapmixture extdata directory if not present
  # https://github.com/ropensci/rnaturalearthhires
  # tryCatch({
  #   filepath <- system.file("extdata", "countries10.rda", package = "mapmixture")
  #   if (filepath == "") {
  #     message("Downloading countries10 data from Natural Earth...")
  #     url <- "https://github.com/ropensci/rnaturalearthhires/raw/master/data/countries10.rda"
  #     desfile <- paste0(system.file("extdata", package = "mapmixture"), "/countries10.rda")
  #     utils::download.file(url, destfile = desfile, mode = "wb")
  #     message("Data downloaded to 'mapmixture/inst/extdata' folder.")
  #     }
  #   }, error = function(err) {
  #     # Print error message if an error occurs from downloading
  #     stop("Error downloading data from Natural Earth. Please check internet connection.")
  # })


  # Standardise input data ----
  tryCatch({
    admixture_df <- standardise_data(admixture_df, type = "admixture")
    coords_df <- standardise_data(coords_df, type = "coordinates")
  }, error = function(err) {
    # Print error message if an error occurs from invalid inputs
    stop("Invalid input: admixture_df and coord_df should be a data.frame or tibble in the correct format. Run ?mapmixture to check valid input formats.")
  })

  # Check coordinate site IDs exactly match admixture site IDs
  if ( all(coords_df[[1]] == unique(admixture_df[[1]])) == FALSE ) {
    stop("Site names in coordinates data frame do not match site names in admixture data frame. Check site names are not empty or NA and that they match.")
  }

  # Transform admixture data into a plotting format ----
  admixture_df <- transform_admix_data(admixture_df)

  # Merge admixture and coordinates data ----
  admix_coords <- merge_coords_data(coords_df, admixture_df)

  # Read in world boundaries
  # world_boundaries <- sf::st_read(system.file("extdata", "world.gpkg", package = "mapmixture"), quiet = TRUE)
  # load(system.file("extdata", "countries10.rda", package = "mapmixture"))
  world_boundaries <- rnaturalearthdata::countries50[, c("geometry")]

  # Transform world boundaries to CRS
  # world_boundaries <- sf::st_transform(get("countries10"), crs = crs)
  world_boundaries <- sf::st_transform(world_boundaries, crs = crs)

  # Transform coordinates in admix_coords object to CRS
  admix_coords <- transform_df_coords(admix_coords, crs = crs)

  # Calculate default bounding box if boundary parameter not set
  if (is.null(boundary)) {
    boundary <- calc_default_bbox(admix_coords, expand = 0.10)
  } else {
    # Transform boundary to CRS if boundary parameter is set
    boundary <- transform_bbox(boundary, crs)
  }
  # print(boundary)

  # Create a vector of default colours if cluster_cols parameter not set
  if (is.null(cluster_cols)) {
    pal <- grDevices::colorRampPalette(c("green","blue")) # green-blue colour palette
    cluster_cols <- pal(ncol(admix_coords)-3) # number of cluster colours for palette
  }

  # Create a vector of default cluster names if parameter not set
  if (is.null(cluster_names)) {
    cluster_names <- colnames(admix_coords)[4:ncol(admix_coords)]
  }

  # Do these validation checks if basemap object is not NULL
  if (!is.null(basemap)) {

    # stop if basemap if not a SpatRaster or sf object
    if (!(("SpatRaster" %in% class(basemap)) | ("sf" %in% class(basemap)))) {
      stop("basemap is not a SpatRaster or sf object. Please use terra::rast() to create a SpatRaster object or sf::st_read() to create a sf object.")
    }

    # stop if basemap is not a sf object
    # if (sf::st_crs(basemap) != sf::st_crs(crs)) {
    #   stop("CRS of basemap object does not match crs argument. Please use terra::project() to transform basemap to the correct CRS.")
    # }
  }

  # Initiate ggplot
  plt <- ggplot2::ggplot()

  # Add basemap using default world outlines if basemap parameter not set
  if (is.null(basemap)) {
    plt <- plt+
      ggplot2::geom_sf(data = sf::st_geometry(world_boundaries), colour = "black", fill = land_colour, linewidth = 0.1)
  }

  # Add basemap using basemap object supplied by user
  if (!is.null(basemap)) {

    # If basemap is a SpatRaster object ----
    if ("SpatRaster" %in% class(basemap)) {
      if (rlang::is_installed("terra")) {

        # 1. Get an extent of boundary object in WGS 84 (EPSG:4326)
        # 2. Crop basemap raster using this extent
        # 3. Reproject basemap to crs argument before plotting
        extent <- terra::project(terra::ext(boundary), paste0("epsg:",crs), paste0("epsg:",4326))
        basemap <- terra::crop(basemap, extent)
        basemap <- terra::project(basemap, paste0("epsg:", crs))
        plt <- plt+
          ggspatial::layer_spatial(basemap)
      } else {
        stop('Adding a raster basemap requires the terra package to be installed.\ninstall.packages("terra")')
      }
    }

    # If basemap is a sf object ----
    if ("sf" %in% class(basemap)) {

      # 1. Reproject basemap to crs argument before plotting
      basemap <- sf::st_geometry(sf::st_transform(basemap, crs = crs))
      plt <- plt+
        ggplot2::geom_sf(data = basemap, colour = "black", fill = land_colour, linewidth = 0.1)
    }
  }

  # Add pie charts to map
  plt <- plt+
    ggplot2::coord_sf(
      xlim = c(boundary[["xmin"]], boundary[["xmax"]]),
      ylim = c(boundary[["ymin"]], boundary[["ymax"]]),
      expand = expand,
      crs = crs
    )+
    add_pie_charts(
      df = admix_coords,
      admix_columns = 4:ncol(admix_coords),
      lat_column = "lat",
      lon_column = "lon",
      pie_size = pie_size,
      pie_colours = cluster_cols,
      border = pie_border,
      opacity = pie_opacity
    )+
    ggplot2::ggtitle(plot_title)+
    ggplot2::xlab("Longitude")+
    ggplot2::ylab("Latitude")+
    ggplot2::theme(
      axis.text = ggplot2::element_text(colour = "black", size = axis_text_size),
      axis.title = ggplot2::element_text(colour = "black", size = axis_title_size),
      panel.grid = ggplot2::element_line(colour = "white", linewidth = 0.1),
      panel.background = ggplot2::element_rect(fill = sea_colour),
      panel.border = ggplot2::element_rect(fill = NA, colour = "black", linewidth = 0.3),
      plot.title = ggplot2::element_text(size = plot_title_size, face = "bold",
                                         margin = ggplot2::margin(0,0,10,0))
    )


  # Add legend by creating a dummy point data set
  legend_data <- data.frame(
    cluster = colnames(admix_coords[4:ncol(admix_coords)]),
    x = rep(NA, length(admix_coords[4:ncol(admix_coords)])),
    y = rep(NA, length(admix_coords[4:ncol(admix_coords)]))
  )

  # Add legend to plot using a dummy point data set (not ideal but works)
  # NOTE: 02/11/2023: The legend key does not resize
  # The only way to resize is to add a guides(fill = guide_legend(override.aes = list(size = 3)))
  plt <- plt+
    ggplot2::geom_point(
      data = legend_data,
      ggplot2::aes(x = !!as.name("x"), y = !!as.name("y"), fill = !!as.name("cluster")),
      shape = 22, colour = "black", stroke = 0.3, size = 5 * pie_size , alpha = 0
    )+
    ggplot2::scale_fill_manual(values = cluster_cols, labels = stringr::str_to_title(cluster_names))+
    ggplot2::theme(
      legend.title = ggplot2::element_blank(),
      legend.key = ggplot2::element_rect(fill = NA),
      legend.text = ggplot2::element_text(vjust = 0.5),
    )+
    ggplot2::guides(fill = ggplot2::guide_legend(
      override.aes = list(alpha = 1))
    )

  # Add scale bar if true
  if (scalebar == TRUE) {
    height_size <- scalebar_size * 0.15
    width_size <- scalebar_size * 0.10
    text_size <- scalebar_size * 0.5
    plt <- plt+
      ggspatial::annotation_scale(
        data = world_boundaries,
        location = scalebar_position,
        width_hint = width_size,
        bar_cols = c("black","white"),
        line_width = 0.5,
        height = grid::unit(height_size, "cm"),
        text_cex = text_size
      )
  }

  # Add north arrow if true
  if (arrow == TRUE) {
    height_size <- arrow_size * 0.3
    width_size <- arrow_size * 0.3
    text_size <- arrow_size * 2
    pad_size <- ifelse(scalebar == TRUE & scalebar_position == arrow_position, arrow_size * 0.5, 0.25)
    plt <- plt+
      ggspatial::annotation_north_arrow(
        data = world_boundaries,
        which_north = "true",
        location = arrow_position,
        height = grid::unit(height_size, "cm"),
        width = grid::unit(width_size, "cm"),
        pad_y = grid::unit(pad_size, "cm"),
        style = ggspatial::north_arrow_orienteering(
          text_size = text_size,
          line_width = 0.5
        )
      )
  }

  # Return ggplot object
  return(plt)
}


#' Calculate Default Bounding Box
#'
#' @description
#' Internal function to calculate a default bounding box for a set of longitude and latitude coordinates.
#' @keywords internal
#'
#' @param data data.frame or tibble containing three columns.
#' 1st column is a character vector of site names.
#' 2nd column is a numeric vector of latitude values.
#' 3rd column is a numeric vector of longitude values.
#' @param expand numeric value indicating how much % to increase the coordinates limits.
#'
#' @return A bbox object.
#' @export
#'
#' @examples
#' coords <- data.frame(
#'   site = c("Site1","Site2","Site3"),
#'   lat = c(40.0, 50.5, 60.5),
#'   lon = c(-1.0, 5.0, 10.5)
#' )
#' calc_default_bbox(coords, expand = NULL)
#' calc_default_bbox(coords, expand = 0.10)
calc_default_bbox <- function(data, expand = NULL){
  colnames(data) <- stringr::str_to_lower(colnames(data))

  # Expects longitude in column 3 and latitude in column 2
  bbox <- data |>
    sf::st_as_sf(x = _, coords = c(3, 2)) |>
    sf::st_set_crs(x = _, 4326) |>
    sf::st_bbox(obj = _)

  # Apply % increase if expand parameter is set
  if (!is.null(expand)) {
    bbox[["xmin"]] <- ifelse(
      bbox[["xmin"]] < 0,
      bbox[["xmin"]] + bbox[["xmin"]] * expand,
      bbox[["xmin"]] - bbox[["xmin"]] * expand
    )
    bbox[["xmax"]] <- ifelse(
      bbox[["xmax"]] < 0,
      bbox[["xmax"]] + abs(bbox[["xmax"]] * expand),
      bbox[["xmax"]] + bbox[["xmax"]] * expand
    )
    bbox[["ymin"]] <- ifelse(
      bbox[["ymin"]] < 0,
      bbox[["ymin"]] + bbox[["ymin"]] * expand,
      bbox[["ymin"]] - bbox[["ymin"]] * expand
    )
    bbox[["ymax"]] <- ifelse(
      bbox[["ymax"]] < 0,
      bbox[["ymax"]] + abs(bbox[["ymax"]] * expand),
      bbox[["ymax"]] + bbox[["ymax"]] * expand
    )
  }

  # Return bbox
  return(bbox)
}
