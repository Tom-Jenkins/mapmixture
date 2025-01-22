#' STRUCTURE Barplot
#'
#' @description
#' Plot a traditional STRUCTURE barplot or
#' a facet barplot from individual admixture proportions.
#'
#' @param admixture_df data.frame or tibble containing admixture data (see examples).
#' @param type show a traditional STRUCTURE barplot ("structure")
#' or a facet barplot ("facet").
#' @param cluster_cols character vector of colours the same length as the number of clusters.
#' If `NULL`, a blue-green palette is used.
#' @param cluster_names character vector of names the same length as the number of clusters.
#' If `NULL`, the cluster column names are used.
#' @param legend add legend at position (`"none"`, `"top"`, `"right"`, `"bottom"` or `"left"`).
#' Default is to hide legend.
#' @param labels show labels at the site level or the
#' individual level ("site" or "individual").
#' @param site_dividers add dotted lines that divide sites (TRUE or FALSE).
#' @param divider_width width of site divider lines.
#' @param divider_col colour of site divider lines.
#' @param divider_type linetype of site divider line.
#' @param ylabel string for y label.
#' @param site_order character vector of site labels used to customise the order of sites.
#' If `NULL`, sites are ordered alphabetically.
#' @param display_site_labels display site labels (TRUE or FALSE).
#' @param site_labels_size numeric value for site label size.
#' @param site_labels_x numeric value for site label horizontal position.
#' @param site_labels_y numeric value for site label vertical position.
#' @param site_labels_angle numeric value for rotating angle of site label.
#' @param site_ticks show ticks when labels = "site".
#' @param site_ticks_size numeric value for site tick size.
#' @param flip_axis flip the axes so that the plot is vertical (TRUE or FALSE).
#' Default is FALSE (horizontal barplot).
#' @param facet_col number of columns to display for facet barplot.
#' @param facet_row number of rows to display for facet barplot.
#'
#' @return A ggplot object.
#' @export
#'
#' @examples
#' # Admixture Format 1
#' file <- system.file("extdata", "admixture1.csv", package = "mapmixture")
#' admixture1 <- read.csv(file)
#'
#' structure_plot(admixture1, type = "structure")
#' structure_plot(admixture1, type = "facet", facet_col = 5)
structure_plot <- function(admixture_df,
    type = "structure", cluster_cols = NULL, cluster_names = NULL,
    legend = "none",
    labels = "site", flip_axis = FALSE,
    ylabel = "Proportion",
    site_dividers = TRUE, divider_width = 1, divider_col = "white", divider_type = "dashed",
    site_order = NULL, display_site_labels = TRUE, site_labels_size = 2,
    site_labels_x = 0, site_labels_y = -0.025,
    site_labels_angle = 0,
    site_ticks = TRUE, site_ticks_size = -0.01,
    facet_col = NULL, facet_row = NULL
  ) {

  # Check valid input file
  if ( !"data.frame" %in% class(admixture_df) ) {
    stop("Invalid input: admixture_df should be a data.frame or tibble in the correct format. Run ?structure_plot to check valid input format.")
  }

  # Cluster column order
  cluster_col_order <- colnames(admixture_df)[3:ncol(admixture_df)]

  # Standardise input data ----
  admixture_df <- standardise_data(admixture_df, type = "admixture")

  # Number of clusters
  num_clusters <- ncol(admixture_df)-2

  # Edit the names of the first two column headings
  colnames(admixture_df)[1] <- "site"
  colnames(admixture_df)[2] <- "ind"

  # Convert data.frame from wide to long format
  df_long <- tidyr::pivot_longer(
    data = admixture_df,
    cols = 3:ncol(admixture_df),
    names_to = "cluster",
    values_to = "value"
  )

  # Sort data.frame by site and then by individual
  # df_long <- dplyr::arrange(df_long, df_long[["site"]], df_long[["ind"]])
  # df_long <- dplyr::arrange(df_long, df_long[["site"]])
  # print(df_long)

  # Convert site and individual column to factor
  df_long$site <- factor(df_long$site, levels = unique(df_long$site))
  df_long$ind <- factor(df_long$ind, levels = unique(df_long$ind))
  # print(str(df_long))

  # Change the positional order of sites if parameter is set
  # First check that character vector is valid
  if (!is.null(site_order)) {
    if (all(site_order %in% unique(df_long$site))) {
      df_long$site <- factor(df_long$site, levels = site_order)
      df_long <- dplyr::arrange(df_long, df_long[["site"]])
      df_long$ind <- factor(df_long$ind, levels = unique(df_long$ind))
    } else {
      stop("one or more site labels in site_order do not match site labels in admixture_df.\nTry running: site_order %in% unique(admixture_df[[1]])")
    }
  }

  # Character vector of site labels
  site_labels <- as.character(unique(df_long$site))

  # Character vector of default colours if cluster_cols parameter not set
  if (is.null(cluster_cols)) {
    pal <- grDevices::colorRampPalette(c("green","blue")) # green-blue colour palette
    cluster_cols <- pal(num_clusters) # number of cluster colours for palette
  }

  # Create a vector of default cluster names if parameter not set
  if (is.null(cluster_names)) {
    cluster_names <- cluster_col_order
  }

  # Execute this code if type = "structure" ----
  if(type == "structure") {

    # Sample size per site in the correct order
    sample_size_order <- dplyr::count(df_long, !!as.name("site"))$n / num_clusters
    cum_ind <- cumsum(sample_size_order)

    # Calculate the location of lines to divide individuals by site
    site_divider_lines <- cum_ind[-length(cum_ind)]

    # Calculate the middle location to place each site label
    first_position <- (1 + cum_ind[1]) / 2
    remaining_positions <- (cum_ind[-length(cum_ind)] + cum_ind[-1]) / 2 + 0.5
    site_position <- c(first_position, remaining_positions)

    # Traditional STRUCTURE plot
    structure_plt <- ggplot2::ggplot(data = df_long)+
      ggplot2::geom_bar(
        ggplot2::aes(x = !!as.name("ind"), y = !!as.name("value"), fill = !!as.name("cluster")),
        stat = "identity",
        width = 1
      )+
      ggplot2::scale_y_continuous(expand = c(0,0))+
      ggplot2::scale_fill_manual(values = cluster_cols, labels = stringr::str_to_title(cluster_names))+
      ggplot2::ylab(paste0(ylabel,"\n"))+
      ggplot2::theme(
        panel.grid = ggplot2::element_blank(),
        panel.background = ggplot2::element_blank(),
        legend.position = legend,
        legend.title = ggplot2::element_blank(),
      )

    # Add site divider lines if TRUE
    if (site_dividers) {
      structure_plt <- structure_plt+
        ggplot2::annotate(
          "segment",
          x = site_divider_lines + 0.5, xend = site_divider_lines + 0.5,
          y = 0, yend = Inf,
          color = divider_col, linetype = divider_type, linewidth = divider_width
        )
    }

    # Flip axis if FALSE
    if (!flip_axis) {

      # Add site labels
      if (labels == "site") {
        if (display_site_labels) {
          structure_plt <- structure_plt+
            ggplot2::annotate("label",
              x = site_position+site_labels_x,
              y = rep(site_labels_y, length(site_position)),
              label = site_labels, label.size = 0, fill = NA,
              vjust = 0, color = "black", size = site_labels_size, angle = site_labels_angle
            )
        }
        structure_plt <- structure_plt+
          ggplot2::theme(
            axis.text.x = ggplot2::element_blank(),
            axis.ticks.x = ggplot2::element_blank(),
            axis.title.x = ggplot2::element_blank(),
            plot.margin = ggplot2::margin(t = 10, r = 10, b = 10, l = 10, unit = "pt"),
          )
      }

      # Add site ticks
      if (site_ticks) {
        structure_plt <- structure_plt+
          ggplot2::annotate("segment",
            x = site_position, xend = site_position,
            y = rep(site_ticks_size, length(site_position)), yend = 0,
            colour = "black", linewidth = 0.8
          )
      }

      # Add individual labels
      if (labels == "individual") {
        structure_plt <- structure_plt+
          ggplot2::theme(
            axis.text.x = ggplot2::element_text(size = 10, angle = 90, vjust = 0.5),
            axis.title.x = ggplot2::element_blank(),
            plot.margin = margin(t = 10, r = 10, b = 20, l = 10, unit = "pt"),
          )
      }
    }

    # Flip axis if TRUE
    if (flip_axis) {

      # Add site labels
      if (labels == "site") {
        if (display_site_labels) {
          structure_plt <- structure_plt+
            ggplot2::annotate("label",
                              x = site_position+site_labels_y,
                              y = rep(site_labels_x, length(site_position)),
                              label = site_labels, label.size = 0, fill = NA,
                              vjust = 0.25, color = "black", size = site_labels_size
            )
        }
        structure_plt <- structure_plt+
          ggplot2::coord_flip()+
          ggplot2::theme(
            axis.text.y = ggplot2::element_blank(),
            axis.ticks.y = ggplot2::element_blank(),
            axis.title.y = ggplot2::element_blank(),
            axis.text.x = ggplot2::element_text(size = 10),
            # Bug: labels are still hidden even when left margin is expanded
            plot.margin = ggplot2::margin(t = 10, r = 10, b = 0, l = 50, unit = "pt"),
          )
      }

      # Add site ticks
      if (site_ticks) {
        structure_plt <- structure_plt+
          ggplot2::annotate("segment",
            x = site_position, xend = site_position,
            y = rep(site_ticks_size, length(site_position)), yend = 0,
            colour = "black", linewidth = 0.8
          )
      }

      # Add individual labels
      if (labels == "individual") {
        structure_plt <- structure_plt+
          ggplot2::coord_flip()+
          ggplot2::theme(
            axis.title.y = ggplot2::element_blank(),
            axis.text.y = ggplot2::element_text(vjust = 0.25),
            axis.text.x = ggplot2::element_text(size = 10),
            axis.title.x = ggplot2::element_text(size = 12),
            plot.margin = margin(t = 10, r = 15, b = 0, l = 30, unit = "pt"),
          )
      }
    }

    # Return
    return(structure_plt)
  }


  # Execute this code if type = "facet" ----
  if(type == "facet") {

    # Facet bar chart
    facet_plt <- ggplot2::ggplot(data = df_long)+
      ggplot2::geom_bar(
        ggplot2::aes(x = !!as.name("ind"), y = !!as.name("value"), fill = !!as.name("cluster")),
        stat = "identity",
        width = 1
      )+
      ggplot2::scale_y_continuous(expand = c(0,0))+
      ggplot2::facet_wrap(~ site, scales = "free", nrow = facet_row, ncol = facet_col)+
      ggplot2::scale_fill_manual(values = cluster_cols, labels = stringr::str_to_title(cluster_names))+
      ggplot2::ylab(paste0(ylabel,"\n"))+
      ggplot2::theme(
        axis.text.x = ggplot2::element_blank(),
        axis.ticks.x = ggplot2::element_blank(),
        axis.title.x = ggplot2::element_blank(),
        strip.text = ggplot2::element_text(colour="black", size=12),
        panel.grid = ggplot2::element_blank(),
        panel.background = ggplot2::element_blank(),
        legend.position = legend,
        legend.title = ggplot2::element_blank(),
      )

    # Return
    return(facet_plt)
  }
}
