#' The application User Interface
#'
#' @param request Internal parameter for `{shiny}`.
#' @noRd
app_ui <- function(request) {
  shiny::tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),

    bslib::page_navbar(
      title = shiny::tagList(
        shiny::tags$img(
          src = "www/aagi_logo.svg",
          height = "30px",
          style = "margin-right:8px; vertical-align:middle;",
          alt = "AAGI"
        ),
        "Survey URL Generator"
      ),
      window_title = "AAGI Survey URL Generator",
      theme = bslib::bs_theme(
        version = 5,
        bootswatch = "flatly",
        primary = "#00808b", # AAGI teal
        secondary = "#B6D438" # AAGI bright green
      ),
      navbar_options = bslib::navbar_options(
        bg = "#00808b",
        theme = "dark"
      ),
      # ---- Main tab ----
      bslib::nav_panel(
        title = shiny::tagList(shiny::icon("link"), " Generate"),
        bslib::layout_columns(
          col_widths = c(5, 7),
          # Left: form
          mod_survey_form_ui("survey_form"),
          # Right: result
          mod_survey_result_ui("survey_result")
        )
      ),

      # ---- Help tab ----
      bslib::nav_panel(
        title = shiny::tagList(shiny::icon("circle-question"), " Help"),
        bslib::card(
          bslib::card_header(
            class = "bg-secondary text-white fw-semibold",
            "How to use this tool"
          ),
          bslib::card_body(
            shiny::tags$ol(
              shiny::tags$li(
                "Select the ",
                shiny::tags$strong("support type"),
                " you provided (experimental design or analysis)."
              ),
              shiny::tags$li(
                "Choose the specific ",
                shiny::tags$strong("design or analysis type"),
                " that appears based on your selection."
              ),
              shiny::tags$li(
                "Select your ",
                shiny::tags$strong("AAGI node"),
                " and the partner\u2019s ",
                shiny::tags$strong("organisation type"),
                "."
              ),
              shiny::tags$li(
                "Click ",
                shiny::tags$strong("Generate URL"),
                " to build the pre-filled survey link."
              ),
              shiny::tags$li(
                "Use the ",
                shiny::tags$strong("Copy"),
                " button to copy the URL to your clipboard."
              ),
              shiny::tags$li(
                "Paste the URL into your email alongside the deliverable."
              )
            ),
            shiny::hr(),
            shiny::tags$p(
              shiny::icon("circle-info"),
              " The survey is hosted on ",
              shiny::tags$a(
                "Qualtrics",
                href = "https://www.qualtrics.com",
                target = "_blank"
              ),
              ". Each URL embeds all contextual metadata so that respondents do
               not need to re-enter information you already know."
            )
          )
        )
      ),

      bslib::nav_spacer(),
      bslib::nav_item(
        shiny::tags$small(
          class = "text-white-50",
          paste0("v", golem::get_golem_version())
        )
      ),
      bslib::nav_item(
        shiny::actionButton(
          inputId = "stop_app",
          label = shiny::tagList(shiny::icon("circle-stop"), " Stop App"),
          class = "btn btn-sm btn-outline-light"
        )
      )
    )
  )
}

#' Add external resources to the UI
#'
#' Adds CSS/JS resources placed in `inst/app/www`.
#'
#' @noRd
golem_add_external_resources <- function() {
  golem::add_resource_path("www", app_sys("app/www"))

  shiny::tags$head(
    golem::favicon(ext = "png"),
    golem::bundle_resources(
      path = app_sys("app/www"),
      app_title = "AAGI Survey URL Generator"
    ),
    shinyjs::useShinyjs()
  )
}
