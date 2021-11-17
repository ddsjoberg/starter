context("auc_histogram")

test_that("No errors/warnings with standard use", {
  expect_error(
    runif(10000) %>% hist(breaks = 250) %>% auc_histogram(),
    NA
  )
})
