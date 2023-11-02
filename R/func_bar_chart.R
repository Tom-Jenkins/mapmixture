#' STRUCTURE Bar Chart
#'
#' @description
#' Internal function used to create a traditional STRUCTURE plot or
#' a facet bar chart based on admixture proportions.
#'
#' @param df a data frame (see examples).
#'
#' @return A ggplot object.
#' @export
#'
#' @examples
#' df <- data.frame(
#'   site = c("Berlin", "Berlin", "London", "London", "Madrid", "Madrid",
#'           "Paris", "Paris", "Rome", "Rome"),
#'   ind = c("Berlin1", "Berlin2", "London1", "London2", "Madrid1", "Madrid2",
#'           "Paris1", "Paris2", "Rome1", "Rome2"),
#'   cluster1 = c(0.1, 0.1, 1.0, 0.9, 0.0, 0.0, 0.5, 0.5, 0.0, 0.0),
#'   cluster2 = c(0.50, 0.40, 0.00, 0.10, 0.70, 0.80, 0.50, 0.40, 0.01, 0.01),
#'   cluster3 = c(0.40, 0.50, 0.00, 0.00, 0.30, 0.20, 0.00, 0.10, 0.99, 0.99)
#' )
#'
#' df <- data.frame(
#'   site = c(rep("Site1", 30), rep("Site2", 30),
#'            rep("Site3", 30), rep("Site4", 30)),
#'   ind = c(paste0("site1_", 1:30), paste0("site2_", 1:30),
#'           paste0("site3_", 1:30), paste0("site4_", 1:30)),
#'   cluster1 = c(rep(0.5, 30), rep(0.25, 30), rep(0.05, 30), rep(0.05, 30)),
#'   cluster2 = c(rep(0.25, 30), rep(0.50, 30), rep(0.25, 30), rep(0.05, 30)),
#'   cluster3 = c(rep(0.20, 30), rep(0.20, 30), rep(0.20, 30), rep(0.50, 30)),
#'   cluster4 = c(rep(0.05, 30), rep(0.05, 30), rep(0.50, 30), rep(0.40, 30))
#' )
#'
#' structure_plot(df, type = "structure")
structure_plot <- function(df, type = "structure", colours = NULL,
                           site_dividers = TRUE, labels = "site",
                           flip_axis = FALSE,
                           facet_col = NULL, facet_row = NULL) {

  # Number of clusters
  num_clusters <- length(colnames(df[3:length(df)]))

  # Edit the names of the first two column headings
  colnames(df)[1] <- "site"
  colnames(df)[2] <- "ind"

  # Convert data.frame from wide to long format
  df_long <- tidyr::pivot_longer(
    data = df,
    cols = 3:ncol(df),
    names_to = "cluster",
    values_to = "value"
  )

  # Create a vector of default colours if cluster_cols parameter not set
  if (is.null(colours)) {
    pal <- grDevices::colorRampPalette(c("green","blue")) # green-blue colour palette
    colours <- pal(num_clusters) # number of cluster colours for palette
  }


  # Execute this code if type = "structure" ----
  if(type == "structure") {

    # Calculate the location of lines to divide individuals by site
    cum_ind <- cumsum(dplyr::count(df, site)$n)
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
      ggplot2::scale_fill_manual(values = colours)+
      ggplot2::ylab("Admixture proportion\n")+
      ggplot2::theme(
        panel.grid = ggplot2::element_blank(),
        panel.background = ggplot2::element_blank(),
        legend.position = "none",
      )

    # Add site divider lines if TRUE
    if (site_dividers) {
      structure_plt <- structure_plt+
        ggplot2::geom_vline(
          xintercept = site_divider_lines + 0.5,
          color = "white", linetype = "dashed", linewidth = 1
        )
    }

    # Flip axis if FALSE
    if (!flip_axis) {

      # Add site labels and ticks
      if (labels == "site") {
        structure_plt <- structure_plt+
          ggplot2::annotate("text",
            x = site_position,
            y = rep(-0.03, length(site_position)),
            label = unique(df$site),
            vjust = 0, color = "black", size = 5, angle = 0
          )+
          ggplot2::annotate("segment",
            x = site_position, xend = site_position,
            y = rep(-0.008, length(site_position)), yend = 0,
            colour = "black", linewidth = 1
          )+
          ggplot2::theme(
            axis.text.x = ggplot2::element_blank(),
            axis.ticks.x = ggplot2::element_blank(),
            axis.title.x = ggplot2::element_blank(),
            plot.margin = margin(t = 10, r = 10, b = 15, l = 10, unit = "pt"),
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

    # Flip axis if TRUE  *** MARGIN ON SITE LABELS NOT WORKING ***
    if (flip_axis) {

      # Add site labels and ticks
      if (labels == "site") {
        structure_plt <- structure_plt+
          ggplot2::coord_flip()+
          ggplot2::annotate("text",
            x = site_position,
            y = rep(-0.025, length(site_position)),
            label = unique(df$site),
            vjust = 0.25, color = "black", size = 5,
          )+
          ggplot2::annotate("segment",
            x = site_position, xend = site_position,
            y = rep(-0.008, length(site_position)), yend = 0,
            colour = "black", linewidth = 1
          )+
          ggplot2::theme(
            axis.text.y = ggplot2::element_blank(),
            axis.ticks.y = ggplot2::element_blank(),
            axis.title.y = ggplot2::element_blank(),
            plot.margin = margin(t = 10, r = 10, b = 0, l = 100, unit = "pt"),
          )
      }

      # Add individual labels
      if (labels == "individual") {
        structure_plt <- structure_plt+
          ggplot2::coord_flip()+
          ggplot2::theme(
            axis.title.y = ggplot2::element_blank(),
            axis.text.y = ggplot2::element_text(vjust = 0.25),
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
      ggplot2::scale_fill_manual(values = colours)+
      ggplot2::ylab("Admixture proportion")+
      ggplot2::theme(
        axis.text.x = ggplot2::element_blank(),
        axis.ticks.x = ggplot2::element_blank(),
        axis.title.x = ggplot2::element_blank(),
        strip.text = ggplot2::element_text(colour="black", size=12),
        panel.grid = ggplot2::element_blank(),
        panel.background = ggplot2::element_blank(),
        legend.position = "none",
      )

    # Return
    return(facet_plt)
  }
}
