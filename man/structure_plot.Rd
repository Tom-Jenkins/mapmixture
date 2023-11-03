% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/func_bar_chart.R
\name{structure_plot}
\alias{structure_plot}
\title{STRUCTURE Barplot}
\usage{
structure_plot(
  admixture_df,
  type = "structure",
  cluster_cols = NULL,
  site_dividers = TRUE,
  labels = "site",
  site_ticks = TRUE,
  flip_axis = FALSE,
  facet_col = NULL,
  facet_row = NULL
)
}
\arguments{
\item{admixture_df}{a data.frame or tibble containing admixture data (see examples).}

\item{type}{show a traditional STRUCTURE barplot ("structure")
or a facet barplot ("facet").}

\item{cluster_cols}{a character vector of colours the same length as the number of clusters.
If \code{NULL}, a blue-green palette is used.}

\item{site_dividers}{add dotted lines that divide sites (TRUE or FALSE).}

\item{labels}{show labels at the site level or the
individual level ("site" or "individual").}

\item{site_ticks}{show ticks when labels = "site".}

\item{flip_axis}{flip the axes so that the plot is vertical (TRUE or FALSE).
Default is FALSE (horizontal barplot).}

\item{facet_col}{number of columns to display for facet barplot.}

\item{facet_row}{number of rows to display for facet barplot.}
}
\value{
A ggplot object.
}
\description{
Plot a traditional STRUCTURE barplot or
a facet barplot from individual admixture proportions.
}
\examples{
# Admixture Format 1
file <- system.file("extdata", "admixture1.csv", package = "mapmixture")
admixture1 <- read.csv(file)

structure_plot(admixture1, type = "structure")
}