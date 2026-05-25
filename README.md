# AAGISurveyApp

A [golem](https://thinkr-open.github.io/golem/)-based Shiny application that
wraps the `AAGISurvey` R package, providing a point-and-click interface for
generating pre-filled AAGI partner feedback survey URLs.

## Quick start

{AAGISurveyApp} is available through the [R-Universe](https://r-universe.dev/search) with pre-built binaries.

To get started:

### Enable this universe

```r
options(
  repos = c(
    AAGI = 'https://aagi-aus.r-universe.dev',
    CRAN = 'https://cloud.r-project.org'
  )
)
```


### Install

```r
install.packages("AAGISurveyApp")
```
