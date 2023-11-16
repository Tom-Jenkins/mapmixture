#' Launch Shiny App
#'
#' @description
#' Wrapper function used to start mapmixture shiny app.
#'
#' @param ... additional arguments passed to `shiny::runApp`.
#'
#' @export
#' @examples
#' if (interactive()){
#'   launch_mapmixture(launch.browser = TRUE)
#' }
launch_mapmixture <- function(...) {

  shiny::shinyApp(
    ui = app_ui,
    server = app_server,
    options = list(launch.browser = TRUE, ...)
  )
}
