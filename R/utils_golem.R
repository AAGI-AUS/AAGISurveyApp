# Thin wrappers around golem utilities used throughout the app.

#' Return a path relative to the installed package's inst/ directory
#' @noRd
app_sys <- function(...) {
  system.file(..., package = "AAGISurveyApp")
}

#' Wrapper so run_app() can pass golem options cleanly
#' @noRd
with_golem_options <- function(app, golem_opts = list()) {
  golem::with_golem_options(app = app, golem_opts = golem_opts)
}

#' Thin wrapper for AAGISurvey::generate_survey_url
#'
#' Since AAGISurvey::create_survey_url() is interactive-only (it uses
#' \CRANpkg{cli} menus and \CRANpkg{clipr}), we need our own thin wrapper.
#'
#' @returns a list with the survey URL and summary of the survey type.
#' @keywords Internal
#' @noRd
generate_survey_url <- function(
  aagi_node,
  organisation_type,
  support_type,
  design_type = NULL,
  analysis_type = NULL
) {
  survey_url <- AAGISurvey::build_url(
    base = "https://curtin.au1.qualtrics.com/jfe/form/SV_eXLvfgMz58RktQa",
    support_type = support_type,
    design_type = design_type,
    analysis_type = analysis_type,
    aagi_node = aagi_node,
    organisation_type = organisation_type
  )

  survey_summary <- list(
    support_type = paste(AAGISurvey:::SUPPORT[support_type], collapse = " + "),
    design_type = if (!is.null(design_type) && nzchar(design_type)) {
      AAGISurvey:::DESIGN[[design_type]]
    } else {
      "\u2014"
    },
    analysis_type = if (!is.null(analysis_type) && nzchar(analysis_type)) {
      AAGISurvey:::ANALYSIS[[analysis_type]]
    } else {
      "\u2014"
    },
    aagi_node = AAGISurvey:::NODE[[aagi_node]],
    organisation_type = AAGISurvey:::ORG[[organisation_type]]
  )
  list(url = survey_url, summary = survey_summary)
}
