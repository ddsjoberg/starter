context("count_map")

test_that("No Errors/Warning with standard use", {
  expect_error(
    trial %>% count_map(list(c("stage", "grade"), c("grade", "response"))),
    NA
  )
  expect_warning(
    trial %>% count_map(list(c("stage", "grade"), c("grade", "response"))),
    NA
  )
})

test_that("Works for a single vector", {
  expect_error(
    trial %>% count_map(c("stage", "grade")),
  NA
  )
})

test_that("Gives error for incorrect variable names", {
  expect_error(
    trial %>% count_map(list(c("tstage", "grade"))),
    "*"
  )

  expect_error(
    trial %>% dplyr::mutate(..n.. = 1) %>% count_map(list(c("..n..", "grade"))),
    "*"
  )
})
