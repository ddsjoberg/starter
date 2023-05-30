
test_that("create_project() works", {
  proj_dir <- fs::path(tempdir(), "My Project Folder with symlink")
  data_dir <- fs::path(tempdir(), "secure_data")
  fs::dir_create(data_dir)
  expect_error(
    create_project(
      path = proj_dir,
      path_data = data_dir,
      git = TRUE,
      renv = FALSE,
      symlink = TRUE,
      open = FALSE # don't open project in new RStudio session
    ),
    NA
  )

  proj_dir <- fs::path(tempdir(), "My Project Folder")
  expect_error(
    create_project(
      path = proj_dir,
      git = NA,
      renv = NA,
      symlink = NA,
      open = FALSE # don't open project in new RStudio session
    ),
    NA
  )

  override_template <- project_templates[["default"]]
  attr(override_template, "arg_override") <- list(git = FALSE, renv = FALSE)
  expect_error(
    create_project(
      path = proj_dir,
      template = override_template,
      overwrite = TRUE,
      open = FALSE # don't open project in new RStudio session
    ),
    NA
  )

  # save existing wd
  oldwd <- getwd()
  setwd(proj_dir)
  expect_error(
    use_project_gitignore(),
    NA
  )
  expect_error(
    use_project_readme(),
    NA
  )
  setwd(oldwd)

  # expecting error message
  expect_error(
    create_project(
      path = proj_dir,
      template = quote(stop()),
      overwrite = TRUE,
      git = FALSE,
      renv = FALSE,
      open = FALSE # don't open project in new RStudio session
    )
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
                  template_filename = .find_project_root(),
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
