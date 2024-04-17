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

  shiny::shinyApp(
    ui = app_ui,
    server = app_server,
    options = list(...)
  )
}
