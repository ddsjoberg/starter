context("test-create_msk_project")

test_that("create_msk_project works", {
  data_dir <- file.path(tempdir(), "Data")
  dir.create(data_dir)

  # default template
  expect_error(
    create_msk_project(
      path = file.path(tempdir(), "Project Folder"),
      path_data = data_dir,
      renv = TRUE,
      open = FALSE
    ),
    NA
  )
})



