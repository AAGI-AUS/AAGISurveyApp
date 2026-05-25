test_that("survey_form module server returns a reactive", {
  shiny::testServer(
    mod_survey_form_server,
    args = list(),
    expr = {
      # No inputs set yet — result should be NULL
      expect_null(result())

      # Simulate valid S_A inputs and fire generate button
      session$setInputs(
        support_type      = "S_A",
        analysis_type     = "A_SP",
        aagi_node         = "UQ",
        organisation_type = "O_AGR",
        generate          = 1
      )
      res <- result()
      expect_type(res, "list")
      expect_true(startsWith(res$url, "https://"))
    }
  )
})

test_that("survey_form module shows notification when inputs are incomplete", {
  shiny::testServer(
    mod_survey_form_server,
    args = list(),
    expr = {
      # Fire generate with no selections
      session$setInputs(
        support_type      = "",
        aagi_node         = "",
        organisation_type = "",
        generate          = 1
      )
      # result should remain NULL after validation failure
      expect_null(result())
    }
  )
})
