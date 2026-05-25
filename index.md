# AAGISurveyApp

A [{golem}](https://thinkr-open.github.io/golem/)-based Shiny
application that wraps the `AAGISurvey` R package, providing a
point-and-click interface for generating pre-filled AAGI partner
feedback survey URLs. This does not replace
[{AAGISurvey}](https://aagi-aus.github.io/AAGISurvey/), but simply
provides another user-friendly interface to it for creating survey URLs.
If you do not have {AAGISurvey} installed, it will be installed when you
install {AAGISurveyApp}.

## Quick start

{AAGISurveyApp} is available through the
[R-Universe](https://r-universe.dev/search) with pre-built binaries.

To get started:

### Enable the AAGI R-universe

``` r

options(
  repos = c(
    AAGI = 'https://aagi-aus.r-universe.dev',
    CRAN = 'https://cloud.r-project.org'
  )
)
```

### Install

``` r

install.packages("AAGISurveyApp")
```

### Using the app

Start R, it doesn’t matter if it’s RStudio, Positron, Nvim-R, an R
console, VSCode, etc. but it should be a local session on your own
computer. Once you’ve started R, load the library and launch the app.

``` r

library(AAGISurveyApp)
run_app()
```

A new browser window or tab will open for you to click through and
create the survey URL. Once complete and you’ve copied the URL you can
click on the “Stop App” button in the upper right and close the browser
window.
