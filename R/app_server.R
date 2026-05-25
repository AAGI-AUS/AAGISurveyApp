#' The application server-side logic
#'
#' @param input,output,session Internal parameters for `{shiny}`.
#' @noRd
app_server <- function(input, output, session) {
  # ---- Survey form module ----
  # Returns a reactive holding the generated URL result (or NULL)
  result <- mod_survey_form_server("survey_form")

  # ---- Result display module ----
  mod_survey_result_server("survey_result", result = result)

  shiny::observeEvent(input$stop_app, {
    shiny::stopApp()
  })
}
