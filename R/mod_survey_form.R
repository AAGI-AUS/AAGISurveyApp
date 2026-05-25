#' survey_form UI Module
#'
#' @description The main form for capturing survey parameters and generating a
#'   pre-filled Qualtrics URL.
#'
#' @param id Internal module ID.
#' @noRd
mod_survey_form_ui <- function(id) {
  ns <- shiny::NS(id)

  bslib::card(
    full_screen = FALSE,
    bslib::card_header(
      class = "bg-primary text-white fw-semibold",
      shiny::icon("link"),
      " Generate Survey URL"
    ),
    bslib::card_body(
      # --- Support type ---
      shiny::radioButtons(
        inputId = ns("support_type"),
        label = shiny::tags$span(
          shiny::icon("hand-holding-heart"),
          " Support type ",
          shiny::tags$span("*", class = "text-danger")
        ),
        choices = setNames(
          names(AAGISurvey::SUPPORT),
          unname(AAGISurvey::SUPPORT)
        ),
        selected = character(0)
      ),

      shiny::hr(),

      # --- Design type (shown only when S_D selected) ---
      shiny::conditionalPanel(
        condition = sprintf("input['%s'] == 'S_D'", ns("support_type")),
        shiny::selectInput(
          inputId = ns("design_type"),
          label = shiny::tags$span(
            shiny::icon("flask"),
            " Experimental design type ",
            shiny::tags$span("*", class = "text-danger")
          ),
          choices = c(
            "-- Select --" = "",
            setNames(names(AAGISurvey::DESIGN), unname(AAGISurvey::DESIGN))
          ),
          selected = ""
        )
      ),

      # --- Analysis type (shown only when S_A selected) ---
      shiny::conditionalPanel(
        condition = sprintf("input['%s'] == 'S_A'", ns("support_type")),
        shiny::selectInput(
          inputId = ns("analysis_type"),
          label = shiny::tags$span(
            shiny::icon("chart-bar"),
            " Analysis type ",
            shiny::tags$span("*", class = "text-danger")
          ),
          choices = c(
            "-- Select --" = "",
            setNames(names(AAGISurvey::ANALYSIS), unname(AAGISurvey::ANALYSIS))
          ),
          selected = ""
        )
      ),

      shiny::hr(),

      # --- AAGI node ---
      shiny::selectInput(
        inputId = ns("aagi_node"),
        label = shiny::tags$span(
          shiny::icon("university"),
          " AAGI node ",
          shiny::tags$span("*", class = "text-danger")
        ),
        choices = c(
          "-- Select --" = "",
          setNames(names(AAGISurvey::NODE), unname(AAGISurvey::NODE))
        ),
        selected = ""
      ),

      # --- Organisation type ---
      shiny::selectInput(
        inputId = ns("organisation_type"),
        label = shiny::tags$span(
          shiny::icon("building"),
          " Partner organisation type ",
          shiny::tags$span("*", class = "text-danger")
        ),
        choices = c(
          "-- Select --" = "",
          setNames(names(AAGISurvey::ORG), unname(AAGISurvey::ORG))
        ),
        selected = ""
      ),

      shiny::hr(),

      shiny::actionButton(
        inputId = ns("generate"),
        label = shiny::tagList(
          shiny::icon("wand-magic-sparkles"),
          " Generate URL"
        ),
        class = "btn-primary w-100"
      )
    )
  )
}

#' survey_form Server Module
#'
#' @param id Internal module ID.
#' @noRd
mod_survey_form_server <- function(id) {
  shiny::moduleServer(id, function(input, output, session) {
    ns <- session$ns

    # Reactive value that holds the last generated result
    result <- shiny::reactiveVal(NULL)

    shiny::observeEvent(input$generate, {
      # ---- collect inputs ----
      support_type <- input$support_type
      design_type <- if (support_type == "S_D") input$design_type else NULL
      analysis_type <- if (support_type == "S_A") input$analysis_type else NULL
      aagi_node <- input$aagi_node
      organisation_type <- input$organisation_type

      # ---- client-side validation ----
      errs <- character(0)
      if (!nzchar(support_type)) {
        errs <- c(errs, "Please select a support type.")
      }
      if (identical(support_type, "S_D") && !nzchar(design_type %||% "")) {
        errs <- c(errs, "Please select an experimental design type.")
      }
      if (identical(support_type, "S_A") && !nzchar(analysis_type %||% "")) {
        errs <- c(errs, "Please select an analysis type.")
      }
      if (!nzchar(aagi_node)) {
        errs <- c(errs, "Please select an AAGI node.")
      }
      if (!nzchar(organisation_type)) {
        errs <- c(errs, "Please select a partner organisation type.")
      }

      if (length(errs)) {
        shiny::showNotification(
          ui = shiny::tagList(
            shiny::tags$strong("Please fix the following:"),
            shiny::tags$ul(lapply(errs, shiny::tags$li))
          ),
          type = "error",
          duration = 8
        )
        return()
      }

      # ---- generate ----
      res <- tryCatch(
        generate_survey_url(
          support_type = support_type,
          design_type = design_type,
          analysis_type = analysis_type,
          aagi_node = aagi_node,
          organisation_type = organisation_type
        ),
        error = function(e) {
          shiny::showNotification(
            conditionMessage(e),
            type = "error",
            duration = 8
          )
          NULL
        }
      )
      result(res)
    })

    result # return the reactive so the parent / output module can consume it
  })
}
