#' Open RStudio Project
#'
#' If path has an `*.Rproj` file, the project is opened in a new RStudio IDE session.
#'
#' @param path folder path
#' @inheritParams create_project
#'
#' @return NULL
#' @export
#'
#' @examplesIf interactive()
#' open_rstudio_project(path = tempfile())
open_rstudio_project <- function(path, open = TRUE) {
  if (isTRUE(open) && rstudioapi::isAvailable() && has_rproj(path)) {
    rstudioapi::openProject(path, newSession = TRUE)
  }
  invisible()
}

