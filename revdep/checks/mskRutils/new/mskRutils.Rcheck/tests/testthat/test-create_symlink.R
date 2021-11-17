context("test-create_symlink")

test_that("create_symlink throws error with bad inputs", {
  expect_error(
    create_symlink(to = tempdir(), name = TRUE), "*"
  )

  expect_error(
    create_symlink(to = file.path(tempdir(), "NOT A DIR")), "*"
  )
})


