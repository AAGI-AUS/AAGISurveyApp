# AAGISurveyApp

A [golem](https://thinkr-open.github.io/golem/)-based Shiny application that
wraps the `AAGISurvey` R package, providing a point-and-click interface for
generating pre-filled AAGI partner feedback survey URLs.

## Project layout

```
AAGISurveyApp/
├── R/
│   ├── AAGISurveyApp-package.R   # package-level docs & imports
│   ├── app_config.R              # golem config helper
│   ├── app_server.R              # top-level server
│   ├── app_ui.R                  # top-level UI (bslib navbar)
│   ├── constants.R               # SUPPORT / DESIGN / ANALYSIS / NODE / ORG
│   ├── globals.R                 # globalVariables() declarations
│   ├── mod_survey_form.R         # module: input form
│   ├── mod_survey_result.R       # module: URL display & copy
│   ├── run_app.R                 # run_app() entry point
│   ├── utils_golem.R             # thin golem wrappers
│   └── utils_survey.R           # pure survey logic (ensure_valid, build_url, generate_survey_url)
├── inst/
│   ├── app/www/                  # static assets (logo, CSS, JS)
│   └── golem-config.yml
├── tests/
│   └── testthat/
│       ├── test-utils_survey.R
│       └── test-mod_survey_form.R
├── dev/
│   ├── 01_start.R                # one-time setup helpers
│   ├── 02_dev.R                  # dev iteration helpers
│   └── 03_deploy.R               # deployment helpers
├── app.R                         # rsconnect / Posit Connect entry point
└── DESCRIPTION
```

## Quick start

```r
# Install dependencies
remotes::install_deps()

# Load and run
pkgload::load_all()
AAGISurveyApp::run_app()
```

## Adding the AAGI logo

Place a PNG named `aagi_logo.png` (and optionally `favicon.png`) inside
`inst/app/www/`. The UI references it at `www/aagi_logo.png`.

## Deployment

See `dev/03_deploy.R` for shinyapps.io and Posit Connect instructions, or use
`golem::add_dockerfile()` to containerise.
