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


test_that("test checks on template structure", {
  expect_error(
    check_template_structure(letters)
  )

  expect_error(
    as.list(letters) %>%
      setNames(letters) %>%
      check_template_structure()
  )

  expect_error(
    list(a = list(gitignore = "test")) %>%
      check_template_structure()
  )

  # don't error with 'copy' name
  expect_error(
    list(a = list(filename = "test",
                  template_filename = here::here(),
                  copy = TRUE)) %>%
    check_template_structure(),
    NA
  )

  # check for bad type in glue element
  expect_error(
    list(a = list(filename = "test",
                  template_filename = "test",
                  copy = "TRUE")) %>%
      check_template_structure(),
  )
  expect_error(
    list(a = list(filename = "test",
                  template_filename = "test",
                  copy = TRUE)) %>%
      check_template_structure(),
  )
})
