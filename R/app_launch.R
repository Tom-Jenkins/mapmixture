#' Launch Shiny App
#'
#' @description
#' Wrapper function used to start `mapmixture` interactive app.
#'
#' App tested with the following package versions:
#'
#' shiny v1.8.0,
#' shinyFeedback v0.4.0,
#' shinyjs v2.1.0,
#' shinyWidgets 0.8.4,
#' bslib 0.7.0,
#' colourpicker 1.3.0,
#' htmltools v0.5.8.1,
#' waiter 0.2.5.
#'
#' @param ... additional arguments passed to `shiny::runApp()`.
#'
#' @return No return value.
#' @export
#'
#' @examples
#' if (interactive()){
#'   launch_mapmixture(launch.browser = TRUE)
#' }
launch_mapmixture <- function(...) {

  # List of required packages
  required_packages <- c(
    "shiny", "shinyFeedback", "shinyjs", "shinyWidgets",
    "bslib", "colourpicker", "htmltools", "waiter"
  )

  # Check for missing packages
  missing_packages <- setdiff(required_packages, utils::installed.packages()[, "Package"])

  # If there are missing packages, stop and inform the user
  if (length(missing_packages) > 0) {
    stop(
      "The following packages are required but not installed: ",
      paste(missing_packages, collapse = ", "),
      ". Please install them before running `launch_mapmixture()`."
    )
  }

  # Launch app
  shiny::shinyApp(
    ui = app_ui,
    server = app_server,
    options = list(...)
  )
}
