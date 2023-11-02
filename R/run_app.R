#' Run Mapmixture Shiny App
#'
#' @description
#' Wrapper function used to start mapmixture shiny app.
#'
#' @param ... additional arguments to pass to `shiny::runApp` call.
#'
#' @export
launch_mapmixture <- function(...) {
  shiny::shinyApp(
    ui = app_ui,
    server = app_server,
    options = list(launch.browser = TRUE, ...)
  )
}
