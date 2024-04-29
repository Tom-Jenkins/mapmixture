#' PCA or DAPC Scatter Plot
#'
#' @description
#' Plot a scatter plot of PCA or DAPC results.
#'
#' @param dataframe data.frame or tibble containing results from a PCA or DAPC (see examples).
#' @param group_ids character vector of IDs representing the group each row belongs to.
#' This is used to colour the scatter plot and (optionally) add centroids and segments.
#' E.g. a vector of site names, a vector of biological categories such as male or female, etc.
#' @param other_group secondary character vector of IDs defining how to colour the scatter plot.
#' E.g. a vector of country names (see examples).
#' If `NULL`, scatter plot is coloured by group_ids.
#' @param type string defining whether to show points (`"points"`), labels (`"labels"`), or text (`"text"`).
#' @param ... additional arguments passed to `ggplot2::geom_point` when `type = "points"`,
#' or to `ggplot2::geom_label` when `type = "labels"`,
#' or to `ggplot2::geom_text` when `type = "text"`.
#' @param axes integer vector of length two defining which axes to plot.
#' @param colours character vector of colours the same length as the number of
#' groups defined in group_ids or other_group.
#' @param centroids add centroids to plot (`TRUE` or `FALSE`).
#' @param segments add segments to plot (`TRUE` or `FALSE`).
#' @param point_size numeric value for point size.
#' @param point_type numeric value for point type (shape).
#' @param centroid_size numeric value for centroid label size.
#' @param labels character vector of IDs defining labels when `type = "label"` or `type = "text"`.
#' If `NULL`, row names are used (integers from 1:nrow(dataframe)).
#' @param xlab string defining x axis label.
#' @param ylab string defining y axis label.
#' @param percent numeric vector the same length as `ncol(dataframe)` defining the
#' percentage of variance explained by each axis.
#' @param plot_title string defining the main title of the plot.
#' @param hvline_type integer or string defining linetype (`1` or `"dotted"`).
#' Input `0` for no horizontal and vertical lines.
#' @param hvline_size integer defining linewidth.
#' @param hvline_colour string defining line colour.
#'
#' @return A ggplot object.
#' @export
#'
#' @examples
#' # Results from a Principal Components Analysis
#' file <- system.file("extdata", "pca_results.csv", package = "mapmixture")
#' pca_results <- read.csv(file)
#'
#' # Define parameters
#' ind_names <- row.names(pca_results)
#' site_names <- rep(c("Pop1", "Pop2", "Pop3", "Pop4", "Pop5", "Pop6"), each = 100)
#' region_names <- rep(c("Region1", "Region2"), each = 300)
#' percent <- c(5.6, 4.5, 3.2, 2.0, 0.52)
#'
#' # Scatter plot
#' scatter_plot(pca_results, site_names)
#'
#' # Scatter plot with axes 1 and 3 and percent on axis labels
#' scatter_plot(pca_results, site_names, axes = c(1,3), percent = percent)
#'
#' # Scatter plot with no centroids and segments
#' scatter_plot(pca_results, site_names, axes = c(1,2), percent = percent,
#'              centroids = FALSE, segments = FALSE)
#'
#' # Scatter plot with custom colours and coloured by other_group
#' scatter_plot(pca_results, site_names, other_group = region_names,
#'              percent = percent, colours = c("#f1a340","#998ec3"))
#'
#' # Scatter plot with individual labels
#' scatter_plot(pca_results, site_names, type = "labels",
#'              labels = rownames(pca_results))
#'
#' # Scatter plot with individual text
#' scatter_plot(pca_results, site_names, type = "text",
#'              labels = rownames(pca_results))
scatter_plot <- function(
    dataframe, group_ids, other_group = NULL, type = "points", ...,
    labels = NULL,
    axes = c(1,2), colours = NULL, centroids = TRUE, segments = TRUE,
    point_size = 3, point_type = 21, centroid_size = 3,
    hvline_type = "dotted", hvline_size = 0.5, hvline_colour = "black",
    xlab = "Axis", ylab = "Axis", percent = NULL,
    plot_title = ""
  ) {

  # Subset dataframe column using the axes parameter
  df <- dataframe[, axes]

  # Add group names if parameter is set
  if (!is.null(group_ids)) {
    df$group_ids = group_ids
  }

  # Add other group names if parameter is set
  if (!is.null(other_group)) {
    df$other_group = other_group
  }

  # Set custom x and y labels if percent parameter is set
  if (!is.null(percent)) {

    # X axis label
    xlab <- paste0(xlab, " ", axes[1], " (", format(percent[axes[1]], nsmall = 1), " %)")

    # Y axis label
    ylab <- paste0(ylab, " ", axes[2], " (", format(percent[axes[2]], nsmall = 1), " %)")

  } else {
    # Set x and y labels to default
    xlab <- paste(xlab, axes[1])
    ylab <- paste(ylab, axes[2])
  }


  # POINTS SCATTER PLOT ----
  if (type == "points") {

    # Set colour_by to the group used to colour the scatter plot
    colour_by <- ifelse(is.null(other_group), "group_ids", "other_group")

    # Scatter plot ----
    plt <- ggplot2::ggplot(
      data = df,
      ggplot2::aes(x = !!as.name(colnames(df)[1]), y = !!as.name(colnames(df)[2]))
    )+
      # Zero horizontal and vertical lines
      ggplot2::geom_hline(yintercept = 0, linetype = hvline_type, linewidth = hvline_size, colour = hvline_colour)+
      ggplot2::geom_vline(xintercept = 0, linetype = hvline_type, linewidth = hvline_size, colour = hvline_colour)+
      # Title
      ggplot2::ggtitle(plot_title)+
      # Labels
      ggplot2::labs(x = xlab, y = ylab)

    # Add points and colour by group_ids parameter ----
    if (colour_by == "group_ids") {

      # Calculate centroid (mean average) positions for each group
      centroid_df <- stats::aggregate(
        x = cbind(df[[1]], df[[2]]) ~ group_ids,
        FUN = mean,
        data = df
      )

      # Edit column names of centroid data frame
      colnames(centroid_df)[2:3] <- c("cen1", "cen2")

      # Add centroid coordinates to main data frame
      df <- dplyr::left_join(df, centroid_df, by = "group_ids")

      # Add segments if parameter is TRUE
      if (segments == TRUE) {
        plt <- plt+
          ggplot2::geom_segment(
            data = df,
            ggplot2::aes(
              xend = !!as.name("cen1"), yend = !!as.name("cen2"),
              colour = !!as.name("group_ids")
            ),
            linewidth = 0.3,
            show.legend = FALSE
          )
      }

      # Points
      plt <- plt+
        ggplot2::geom_point(
          ggplot2::aes(fill = !!as.name("group_ids")),
          size = point_size, shape = point_type, ...
        )

      # Add centroids if parameter is TRUE
      if (centroids == TRUE) {
        plt <- plt+
          ggplot2::geom_label(
            data = centroid_df,
            ggplot2::aes(
              x = !!as.name("cen1"), y = !!as.name("cen2"),
              label = !!as.name("group_ids"), fill = !!as.name("group_ids")
            ),
            size = centroid_size, alpha = 0.9, label.padding = ggplot2::unit(0.15, "lines"),
            show.legend = FALSE
          )
      }
    }

    # Add points and colour by other_group parameter ----
    if (colour_by == "other_group") {

      # Calculate centroid (mean average) positions for each group
      centroid_df <- stats::aggregate(
        x = cbind(df[[1]], df[[2]]) ~ group_ids + other_group,
        FUN = mean,
        data = df
      )

      # Edit column names of centroid data frame
      colnames(centroid_df)[3:4] <- c("cen1", "cen2")

      # Add centroid coordinates to main data frame
      df <- dplyr::left_join(df, centroid_df, by = "group_ids")

      # Add segments if parameter is TRUE
      if (segments == TRUE) {
        plt <- plt+
          ggplot2::geom_segment(
            data = df,
            ggplot2::aes(
              xend = !!as.name("cen1"), yend = !!as.name("cen2"),
              colour = !!as.name("other_group")
            ),
            linewidth = 0.3,
            show.legend = FALSE
          )
      }

      # Points
      plt <- plt+
        ggplot2::geom_point(
          ggplot2::aes(fill = !!as.name("other_group")),
          size = point_size, shape = point_type, ...
        )

      # Add centroids if parameter is TRUE
      if (centroids == TRUE) {
        plt <- plt+
          ggplot2::geom_label(
            data = centroid_df,
            ggplot2::aes(
              x = !!as.name("cen1"), y = !!as.name("cen2"),
              label = !!as.name("group_ids"), fill = !!as.name("other_group")
            ),
            size = centroid_size, alpha = 0.9, label.padding = ggplot2::unit(0.15, "lines"),
            show.legend = FALSE
          )
      }
    }

    # Add custom colours if parameter is set ----
    if (!is.null(colours)) {
      plt <- plt+
        ggplot2::scale_fill_manual(values = colours)+
        ggplot2::scale_colour_manual(values = colours)
    }
  }


  # LABELS SCATTER PLOT ----
  if (type == "labels") {

    # Add individual names if parameter is set
    if (is.null(labels)) {
      df$labels <- rownames(df)
    } else {
      df$labels <- labels
    }

    # Scatter plot
    plt <- ggplot2::ggplot(
      data = df,
      ggplot2::aes(
        x = !!as.name(colnames(df)[1]),
        y = !!as.name(colnames(df)[2]),
        label = !!as.name("labels"),
        fill = !!as.name("group_ids")
      )
    )+
      # Zero horizontal and vertical lines
      ggplot2::geom_hline(yintercept = 0, linetype = hvline_type, linewidth = hvline_size, colour = hvline_colour)+
      ggplot2::geom_vline(xintercept = 0, linetype = hvline_type, linewidth = hvline_size, colour = hvline_colour)+
      # Title
      ggplot2::ggtitle(plot_title)+
      # Labels
      ggplot2::labs(x = xlab, y = ylab)

    # Labels
    plt <- plt+
      ggplot2::geom_label(
        ...
      )

    # Remove "a" from legend
    plt <- plt+
      ggplot2::guides(fill = ggplot2::guide_legend(
        override.aes = ggplot2::aes(label = "")
      )
    )

    # Add custom colours if parameter is set
    if (!is.null(colours)) {
      plt <- plt+
        ggplot2::scale_fill_manual(values = colours)
    }
  }


  # TEXT SCATTER PLOT ----
  if (type == "text") {

    # Add individual names if parameter is set
    if (is.null(labels)) {
      df$labels <- rownames(df)
    } else {
      df$labels <- labels
    }

    # Scatter plot
    plt <- ggplot2::ggplot(
      data = df,
      ggplot2::aes(
        x = !!as.name(colnames(df)[1]),
        y = !!as.name(colnames(df)[2]),
        label = !!as.name("labels"),
        colour = !!as.name("group_ids")
      )
    )+
      # Zero horizontal and vertical lines
      ggplot2::geom_hline(yintercept = 0, linetype = hvline_type, linewidth = hvline_size, colour = hvline_colour)+
      ggplot2::geom_vline(xintercept = 0, linetype = hvline_type, linewidth = hvline_size, colour = hvline_colour)+
      # Title
      ggplot2::ggtitle(plot_title)+
      # Labels
      ggplot2::labs(x = xlab, y = ylab)

    # Text
    plt <- plt+
      ggplot2::geom_text(
        ...,
        show.legend = FALSE
      )

    # Add a transparent point aesthetic and use this as the legend
    plt <- plt+
      ggplot2::geom_point(ggplot2::aes(fill = !!as.name("group_ids")), alpha = 0)+
      ggplot2::guides(colour = ggplot2::guide_legend(
        override.aes = list(alpha = 1, shape = 21, size = 6, colour = "black"))
      )

    # Add custom colours if parameter is set
    if (!is.null(colours)) {
      plt <- plt+
        ggplot2::scale_colour_manual(values = colours)
    }
  }


  # Add a default ggplot theme ----
  plt <- plt+
    ggplot2::theme(
      legend.title = element_blank(),
      legend.position = "right",
      legend.text = element_text(size = 10),
      legend.key = element_blank(),
      legend.key.size = unit(0.7, "cm"),
      panel.border = element_rect(colour = "black", fill = NA, linewidth = 1),
      panel.background = element_blank(),
    )

  return(plt)
}
