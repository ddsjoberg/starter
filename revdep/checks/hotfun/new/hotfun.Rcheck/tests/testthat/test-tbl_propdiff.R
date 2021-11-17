context("tbl_propdiff")
library(dplyr)

set.seed(6038503)

# results_chisq <- tbl_propdiff(data = trial, y = "response", x = "trt", method = "chisq")
# results_exact <- tbl_propdiff(data = trial, y = "response", x = "trt", method = "exact")
# results_boot_sd <- tbl_propdiff(data = trial, y = "response", x = "trt", formula = "{y} ~ {x} + age", method = "boot_sd")
# results_boot_centile <- tbl_propdiff(data = trial, y = "response", x = "trt", formula = "{y} ~ {x} + age", method = "boot_centile")
#
# allresults <-
#   gtsummary::tbl_stack(list(results_chisq, results_exact, results_boot_sd, results_boot_centile),
#             group_header = c("Chi-squared", "Exact", "Bootstrap (SD)", "Bootstrap (Centile)"))

test_that("No errors/warnings with standard use", {
  expect_error(
    tbl_propdiff(data = trial, y = "response", x = "trt"),
    NA
  )

  expect_error(
    tbl_propdiff(data = trial, y = c("response", "death"), x = "trt"),
    NA
  )

  expect_error(
    tbl_propdiff(data = trial, method = "exact", y = "response", x = "trt"),
    NA
  )

  expect_error(
    tbl_propdiff(
      data = trial, y = "response", x = "trt", formula = "{y} ~ {x} + age + stage",
      method = "boot_centile", bootstrapn = 50
    ),
    NA
  )

  expect_error(
    tbl_propdiff(
      data = trial, y = "response", x = "trt", formula = "{y} ~ {x} + age + stage",
      method = "boot_sd", bootstrapn = 50
    ),
    NA
  )
})

test_that("Error if variables do not exist or temporary variables do exist", {
  expect_error(
    tbl_propdiff(trial, y = "response", x = "trt_new"),
    "*"
  )

  expect_error(
    tbl_propdiff(trial, y = "response_new", x = "trt"),
    "*"
  )

  expect_error(
    tbl_propdiff(trial, y = "response", x = "trt", formula = "{y} ~ {x} + age_new",
                 method = "boot_sd", bootstrapn = 50),
    "*"
  )
})

test_that("Message if no covariates given but 'boot_sd' or 'boot_centile' method selected", {
  expect_message(
    tbl_propdiff(trial, y = "response", x = "trt", method = "boot_sd", bootstrapn = 50),
    "*"
  )
})

test_that("Error if formula with covariates specified without multivariable method", {
  expect_error(
    tbl_propdiff(trial, y = "response", x = "trt", formula = "{y} ~ {x} + age", method = "exact"),
    "*"
  )

  expect_error(
    tbl_propdiff(trial, y = "response", x = "trt", formula = "{y} ~ {x} + age", method = "chisq"),
    "*"
  )

})

test_that("Error if `conf.level` outside of 0-1 range", {
  expect_error(
    tbl_propdiff(trial, y = "response", x = "trt", conf.level = 95),
    "*"
  )
})

test_that("Error if outcome or predictor has more or less than 2 non-missing levels", {
  expect_error(
    tbl_propdiff(
      data = trial %>% mutate(response2 = sample(c(0:2), size = nrow(trial), replace = TRUE)),
      y = "response2", x = "trt"
    ),
    "*"
  )

  expect_error(
    tbl_propdiff(
      data = trial %>% mutate(trt2 = sample(c(0:2), size = nrow(trial), replace = TRUE)),
      y = "response", x = "trt2"
    ),
    "*"
  )

  expect_error(
    tbl_propdiff(data = trial %>% mutate(trt2 = 0), y = "response", x = "trt2"),
    "*"
  )
})

test_that("x, y and covariates can be character, numeric, logical or factor", {
  expect_error(
    tbl_propdiff(
      data = trial %>% mutate(response = as.character(response)),
      y = "response", x = "trt"
    ),
    NA
  )

  expect_error(
    tbl_propdiff(
      data = trial %>% mutate(response = as.character(response)),
      y = "response", x = "trt", formula = "{y} ~ {x} + age", method = "boot_sd", bootstrapn = 50
    ),
    NA
  )

  expect_error(
    tbl_propdiff(
      data = trial %>% mutate(trt = as.numeric(as.factor(trt))),
      y = "response", x = "trt"
    ),
    NA
  )

  expect_error(
    tbl_propdiff(
      data = trial %>% mutate(trt = as.numeric(as.factor(trt))),
      y = "response", x = "trt", formula = "{y} ~ {x} + age", method = "boot_sd", bootstrapn = 50
    ),
    NA
  )

  expect_error(
    tbl_propdiff(
      data = trial %>% mutate(grade = as.character(grade)),
      y = "response", x = "trt", formula = "{y} ~ {x} + grade", method = "boot_sd", bootstrapn = 50
    ),
    NA
  )

  expect_error(
    tbl_propdiff(
      data = trial %>% mutate(response = as.logical(response)),
      y = "response", x = "trt", method = "exact"
    ),
    NA
  )

  expect_error(
    tbl_propdiff(
      data = trial %>% mutate(response = as.logical(response)),
      y = "response", x = "trt", formula = "{y} ~ {x} + grade",
      method = "boot_sd", bootstrapn = 50
    ),
    NA
  )

  expect_error(
    tbl_propdiff(
      data = trial %>% mutate(trt2 = as.logical(dplyr::if_else(trt == "Drug A", 1, 0))),
      y = "response", x = "trt2", method = "exact"
    ),
    NA
  )

})

test_that("No errors if outcome variable does not have a label", {
  expect_error(
    tbl_propdiff(
      data = trial %>% mutate(response2 = sample(c(0, 1), size = nrow(trial), replace = TRUE)),
      y = "response2", x = "trt"
    ),
    NA
  )
})

test_that("No errors when using different confidence levels", {
  expect_error(
    tbl_propdiff(data = trial, y = "response", x = "trt", conf.level = 0.90),
    NA
  )

  expect_error(
    tbl_propdiff(
      data = trial, y = "response", x = "trt", formula = "{y} ~ {x} + age + stage",
      method = "boot_centile", conf.level = 0.90, bootstrapn = 50
    ),
    NA
  )

  expect_error(
    tbl_propdiff(
      data = trial, y = "response", x = "trt", formula = "{y} ~ {x} + age + stage",
      method = "boot_sd", conf.level = 0.90, bootstrapn = 50
    ),
    NA
  )
})

test_that("`estimate_fun` and `pvalue_fun` are functions", {
  expect_error(
    tbl_propdiff(
      data = trial, y = "response", x = "trt",
      estimate_fun = "style_percent"
    ),
    "*"
  )

  expect_error(
    tbl_propdiff(
      data = trial, y = "response", x = "trt",
      pvalue_fun = "style_pvalue"
    ),
    "*"
  )
})

test_that("Using fct_rev() correctly calculates difference", {

  # Univariate
  expect_equal(
    tbl_propdiff(
      data = trial, y = "response", x = "trt"
    ) %>% purrr::pluck("table_body") %>%
      pull(estimate_2),
    tbl_propdiff(
      data = trial %>% mutate(trt = forcats::fct_rev(trt)),
      y = "response", x = "trt"
    ) %>% purrr::pluck("table_body") %>%
      pull(estimate_2) * -1
  )

  # Multivariable methods without covariates
  expect_equal(
    tbl_propdiff(
      data = trial, y = "response", x = "trt",
      formula = "{y} ~ {x}",
      method = "boot_centile", bootstrapn = 10
    ) %>% purrr::pluck("table_body") %>%
      pull(estimate_2),
    tbl_propdiff(
      data = trial %>% mutate(trt = forcats::fct_rev(trt)),
      y = "response", x = "trt",
      formula = "{y} ~ {x}",
      method = "boot_centile", bootstrapn = 10
    ) %>% purrr::pluck("table_body") %>%
      pull(estimate_2) * -1
  )

  # Multivariable
  expect_equal(
    tbl_propdiff(
      data = trial, y = "response", x = "trt",
      formula = "{y} ~ {x} + age",
      method = "boot_centile", bootstrapn = 10
    ) %>% purrr::pluck("table_body") %>%
      pull(estimate_2),
    tbl_propdiff(
      data = trial %>% mutate(trt = forcats::fct_rev(trt)),
      y = "response", x = "trt",
      formula = "{y} ~ {x} + age",
      method = "boot_centile", bootstrapn = 10
    ) %>% purrr::pluck("table_body") %>%
      pull(estimate_2) * -1
  )

})
