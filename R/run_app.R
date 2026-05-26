#' Run the Shiny Application
#'
#' @param ... Arguments passed to [shiny::shinyApp()].
#' @export
run_app <- function(...) {
  with_golem_options(
    app = shiny::shinyApp(
      ui = app_ui,
      server = app_server
    ),
    golem_opts = list(...)
  )
}
