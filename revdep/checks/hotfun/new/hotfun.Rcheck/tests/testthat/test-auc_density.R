context("auc_density")

test_that("No errors/warnings with standard use", {
  expect_error(
    auc_density(density = dbeta, shape1 = 1, shape2 = 1),
    NA
  )
})
