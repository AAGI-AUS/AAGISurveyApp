test_that("build_url constructs a valid URL for design support", {
  url <- AAGISurvey:::build_url(
    base = "https://example.com/survey",
    support_type = "S_D",
    design_type = "D_SP",
    analysis_type = NULL,
    aagi_node = "CU",
    organisation_type = "O_GOV"
  )
  expect_true(startsWith(url, "https://example.com/survey?"))
  expect_match(url, "ST=S_D")
  expect_match(url, "DT=D_SP")
  expect_match(url, "AN=CU")
  expect_match(url, "OT=O_GOV")
  expect_match(url, "AT=") # blank analysis type
})

test_that("build_url constructs a valid URL for analysis support", {
  url <- AAGISurvey:::build_url(
    base = "https://example.com/survey",
    support_type = "S_A",
    design_type = NULL,
    analysis_type = "A_BIO",
    aagi_node = "AU",
    organisation_type = "O_ACA"
  )
  expect_match(url, "ST=S_A")
  expect_match(url, "AT=A_BIO")
  expect_match(url, "DT=") # blank design type
})

test_that("ensure_valid passes silently for valid inputs", {
  expect_invisible(AAGISurvey:::ensure_valid(
    "S_D",
    AAGISurvey:::SUPPORT,
    "support_type"
  ))
  expect_null(AAGISurvey:::ensure_valid(
    NULL,
    AAGISurvey:::SUPPORT,
    "support_type"
  ))
})

test_that("ensure_valid errors on invalid codes", {
  expect_error(
    AAGISurvey:::ensure_valid("INVALID", AAGISurvey:::SUPPORT, "support_type"),
    "Invalid support_type"
  )
})

test_that("generate_survey_url returns a list with url and summary", {
  res <- AAGISurveyApp:::generate_survey_url(
    support_type = "S_A",
    analysis_type = "A_ENV",
    aagi_node = "UWA",
    organisation_type = "O_GRO"
  )
  expect_type(res, "list")
  expect_named(res, c("url", "summary"))
  expect_true(nzchar(res$url))
  expect_equal(res$summary$aagi_node, "University of Western Australia")
})
