#' survey_result UI Module
#'
#' @description Displays the generated survey URL along with a summary of the
#'   selected parameters, and provides a one-click copy button.
#'
#' @param id Internal module ID.
#' @noRd
mod_survey_result_ui <- function(id) {
  ns <- shiny::NS(id)

  shiny::tagList(
    # Hidden until a URL is generated
    shinyjs::hidden(
      bslib::card(
        id = ns("result_card"),
        bslib::card_header(
          class = "bg-success text-white fw-semibold",
          shiny::icon("circle-check"),
          " Your Survey URL"
        ),
        bslib::card_body(
          # URL display + copy button
          shiny::tags$div(
            class = "input-group mb-3",
            shiny::tags$input(
              id = ns("url_display"),
              type = "text",
              class = "form-control font-monospace",
              readonly = NA
            ),
            shiny::tags$button(
              id = ns("copy_btn"),
              class = "btn btn-outline-secondary",
              type = "button",
              onclick = sprintf(
                "navigator.clipboard.writeText(document.getElementById('%s').value)
                 .then(() => { Shiny.setInputValue('%s', Math.random()); });",
                ns("url_display"),
                ns("copied_trigger")
              ),
              shiny::icon("copy"),
              " Copy"
            )
          ),

          # Copy confirmation
          shinyjs::hidden(
            shiny::tags$div(
              id = ns("copy_confirm"),
              class = "alert alert-success py-1 mb-3",
              shiny::icon("check"),
              " URL copied to clipboard!"
            )
          ),

          shiny::hr(),

          # Summary table
          shiny::tags$h6(class = "text-muted text-uppercase", "Selections"),
          shiny::tableOutput(ns("summary_table")),

          shiny::hr(),
          shiny::tags$blockquote(
            class = "blockquote small text-muted border-start ps-3",
            shiny::tags$p(
              shiny::icon("lightbulb"),
              " Best practice: deliver your customised survey link in the same
      email as the output it relates to."
            )
          )
        )
      )
    )
  )
}

#' survey_result Server Module
#'
#' @param id Internal module ID.
#' @param result A reactive returning a named list with `url` and `summary`, as
#'   produced by [generate_survey_url()], or `NULL` when nothing has been
#'   generated yet.
#' @noRd
mod_survey_result_server <- function(id, result) {
  shiny::moduleServer(id, function(input, output, session) {
    ns <- session$ns

    # Show / hide card and populate fields when a result arrives
    shiny::observeEvent(result(), {
      res <- result()
      if (is.null(res)) {
        return()
      }

      shinyjs::show("result_card")
      shinyjs::hide("copy_confirm")

      # Inject URL into the read-only text input via JS
      shinyjs::runjs(sprintf(
        "document.getElementById('%s').value = '%s';",
        ns("url_display"),
        gsub("'", "\\'", res$url, fixed = TRUE)
      ))
    })

    # Summary table
    output$summary_table <- shiny::renderTable(
      {
        res <- result()
        shiny::req(res)
        data.frame(
          Field = c(
            "Support type",
            "Design type",
            "Analysis type",
            "AAGI node",
            "Organisation type"
          ),
          Selection = c(
            res$summary$support_type,
            res$summary$design_type,
            res$summary$analysis_type,
            res$summary$aagi_node,
            res$summary$organisation_type
          ),
          stringsAsFactors = FALSE,
          check.names = FALSE
        )
      },
      striped = TRUE,
      hover = TRUE,
      bordered = TRUE,
      width = "100%"
    )

    # Copy confirmation flash
    shiny::observeEvent(input$copied_trigger, {
      shinyjs::show("copy_confirm")
      shinyjs::delay(2500, shinyjs::hide("copy_confirm"))
    })
  })
}
