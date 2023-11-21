# Script to deploy Shiny app to shinyapps.io
# Run rsconnect::deploy() to deploy

# Load packages
library(bslib)
library(colourpicker)
library(dplyr)
library(ggplot2)
library(ggspatial)
library(htmltools)
library(pkgload)
library(purrr)
library(rlang)
library(sf)
library(shiny)
library(shinyFeedback)
library(shinyjs)
library(shinyWidgets)
library(stringr)
library(tidyr)
library(waiter)

# Launch app
pkgload::load_all(export_all = FALSE, helpers = FALSE, attach_testthat = FALSE)
launch_mapmixture()
