proj_dir <- fs::path(tempdir(), "My Project Folder")

test_that("create_project() works", {
  expect_error(
    create_project(
      path = proj_dir,
      open = FALSE # don't open project in new RStudio session
    ),
    NA
  )
})
