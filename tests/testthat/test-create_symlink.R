test_that("create_symlink() throws error when expected", {
  expect_error(
    create_symlink(to = letters, name = letters)
  )
  expect_error(
    create_symlink(to = letters, name = fs::path_package("starter"))
  )
  expect_error(
    create_symlink(to = letters, name = fs::path(fs::path_package("starter"), "rstudio", "addins.dcf"))
  )
  expect_error(
    create_symlink(to = fs::path(fs::path_package("starter"), "rstudio", "addins.dcf"))
  )
})
