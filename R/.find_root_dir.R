

.root_dir <- function(...) {
  tryCatch(
    rprojroot::is_rstudio_project$find_file(...),
    error = function(e) {
      tryCatch(
        rprojroot::is_git_root$find_file(...),
        error = function(e) {
          cli::cli_abort("Cannot determine the root directory. Aborting...")
        }
      )
    }
  )
}
