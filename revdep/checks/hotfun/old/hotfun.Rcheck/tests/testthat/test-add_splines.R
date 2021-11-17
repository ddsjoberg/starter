context("get_mode")

library(gtsummary)

test_that("add_spline function gives error if spline variable names exist", {

  # Error if not specifying variable names and they already exist
  expect_error(
    trial %>%
      hotfun::add_splines(variable = age) %>%
      hotfun::add_splines(variable = age),
    "*"
  )

  # No error if specifying variable names and default variable names already exist
  expect_error(
    trial %>%
      hotfun::add_splines(variable = age) %>%
      hotfun::add_splines(variable = age, new_names = c("sptest1", "sptest2", "sptest3")),
    NA
  )

  # Error if specifying variable names and they already exist
  expect_error(
    trial %>%
      hotfun::add_splines(variable = age, new_names = c("sptest1", "sptest2", "sptest3")) %>%
      hotfun::add_splines(variable = age, new_names = c("sptest1", "sptest2", "sptest3")),
    "*"
  )


})
