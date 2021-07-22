#' Write a template file
#'
#' Rather than using `create_project()` to start a new project folder, you
#' may use `use_project_file()` to write a single file from any project template.
#' The functions `use_project_gitignore()` and `use_project_readme()` are shortcuts for
#' `use_project_file("gitignore")` and `use_project_file("readme")`.
#'
#' @param name Name of file to write.  Not sure of the files available to you?
#' Run the function without specifying a name, and all files available within the
#' template will print.
#' @param filename Optional argument to specify the name of the file to be written.
#' Paths/filename is relative to project base (e.g. `here::here()`)
#' @param open If `TRUE`, opens the new file.
#' @inheritParams create_project
#' @name use_project_file
#' @rdname use_project_file
#' @seealso [`create_project()`]
#' @seealso [Vignette for `create_project()`](https://www.danieldsjoberg.com/starter/articles/create_project.html)
#' @export
#' @returns NULL, places single template file in current working directory
#' @examples
#' # only run fn interactively, will place files in current working dir
#' if (interactive()) {
#'   # create gitignore file
#'   use_project_file("gitignore")
#'   use_project_gitignore()
#'
#'   # create README.md file
#'   use_project_file("readme")
#'   use_project_readme()
#' }

use_project_file <- function(name = NULL, filename = NULL,
                             template = NULL, open = interactive()) {
  # import template ------------------------------------------------------------
  path <- here::here()
  template <- evaluate_project_template(template, path, git = FALSE, renv = FALSE)

  # checking name is in selected template
  if (is.null(name) || !name %in% names(template)) {
    paste("Argument `name=` is not valid. Must be one of\n",
          paste(shQuote(names(template)), collapse = ", ")) %>%
    stop(call. = FALSE)
  }

  # only keeping file selected
  template <- template[name]

  # if file already exists, prompt user for new name
  filename <- filename %||% template[[name]]$filename

  if (fs::file_exists(fs::path(path, filename)) && interactive()) {
    ui_oops("File {ui_field(filename)} already exists.")
    filename <- readline("Please supply a new file name including extension [return to quit]. ")
    if (filename == "") {
      ui_oops("Aborting.")
      return(invisible())
    }
  }

  # replace the output filename in the template
  template[[name]]$filename <- fs::path_norm(filename)

  # writing file ---------------------------------------------------------------
  writing_files_folders(
    selected_template = template,
    path = path,
    overwrite = NA,
    path_data = NULL
  )

  # opening new file -----------------------------------------------------------
  if (open && fs::file_exists(template[[name]][["filename"]])) {
    usethis::edit_file(template[[name]][["filename"]])
  }

  return(invisible())
}

#' @rdname use_project_file
#' @export
use_project_gitignore <- function(filename = NULL, template = NULL) {
  use_project_file(name = "gitignore", filename = filename, template = template)
}

#' @rdname use_project_file
#' @export
use_project_readme <- function(filename = NULL, template = NULL) {
  use_project_file(name = "readme", filename = filename, template = template)
}

