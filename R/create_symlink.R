#' Establish symbolic link between folders
#'
#' The `starter_symlink()` function is an OS agnostic function that creates symbolic
#' links between two folders. The function is, at its core, a wrapper for the
#' `R.utils::createLink()` function with opinionated
#' defaults. The function must be called in an environment where the working
#' directory is known (e.g. using `*.Rproj`, `setwd()`, etc.).
#'
#' A symbolic link is a special kind of file that points to another file/folder.
#' A symbolic link does not contain the data in the target file. It simply points
#' to another entry somewhere in the file system. This allows symbolic links
#' to link to directories or files on remote network locations. Depending
#' on your operating system, a link may not establish if the originating
#' path is a network drive.
#'
#' @param to target file or directory to which the shortcut should point to.
#' @param name symbolic link folder name. Default folder name is `"secure_data"``
#' @inheritDotParams R.utils::createLink
#' @seealso [R.utils::createLink()]
#' @export
#' @author Daniel D. Sjoberg
#' @returns NULL, Places the path or pathname to the link.
#' @examples
#' # only run fn interactively, will place symbolic link in current working dir
#' if (interactive()) {
#'   # Using `starter_symlink()` to establish a symbolic link to a
#'   # mapped networked data folder.
#'   # The default name of the symlink folder is 'secure_data'
#'   create_symlink("O:/Outcomes/Project Folder/Data")
#' }

create_symlink <- function(to, name = "secure_data", ...) {
  # checking inputs ------------------------------------------------------------
  # checking folder name a string of length 1
  if (!rlang::is_string(name)) {
    cli::cli_alert_danger("Argument {.field {name}} must be a string of length one.")
    stopifnot(rlang::is_string(name))
  }

  # checking if location is an existing folder
  if (dir.exists(name)) {
    cli::cli_alert_danger("{.file {name}} is an existing folder, and symbolic link cannot be placed.")
    stop()
  }

  # checking if a link/file already exists
  if (is.symlink(name) || file.exists(name)) {
    cli::cli_alert_danger("{.file {name}} is an existing symbolic link or file, and a new symbolic link cannot be placed.")
    cli::cli_alert_danger("Delete the file or update the {.field name} argument and re-run {.code create_symlink()}.")
    stop()
  }

  # checking to argument is a path ---------------------------------------------
  if (!isTRUE(dir.exists(to))) {
    cli::cli_alert_danger("{.file {to}} is not an existing directory path.")
    cli::cli_ul("Update the {.field to} argument and re-run {.code create_symlink()}.")
    stop()
  }

  # checking for networked drives on Windows -----------------------------------
  # checking if working on Windows and trying to create symbolic link on mapped
  # drive this may cause problems on a windows machine
  msg <- NULL
  if (Sys.info()[["sysname"]] == "Windows") {
    # grabbing drive name of project folder
    drive_here <- substr(.find_project_root(), 1, 2)

    # getting list of mapped network drives
    drive_mapped <-
      system("net use", intern = TRUE) %>% # grabbing all mapped drives
      {regmatches(., gregexpr('[A-Z]:', text = .))} %>% # extracting the drive letter
      discard(rlang::is_empty) %>% # removing NAs
      setdiff("C:") %>%
      unlist()

    # saving message to print is warning or error occurs
    if(drive_here %in% drive_mapped) {
      msg <- paste(
        "It looks like you've attempted to save a symbolic link on a\n",
        "mapped network drive. This often causes issues when working in\n",
        "Windows. If you encounter an error, consider moving your GitHub\n",
        "repo to your local C: drive, and establishing the link there."
      )
    }
  }

  # wrapping createLink --------------------------------------------------------
  tryCatch(
    {
      R.utils::createLink(link = .find_project_root(name), target = to, ...)
      paste0("Symbolic link placed connecting {.file {name}} to\n",
             "{.file {to}}") %>%
        cli::cli_alert_success()
    },
    error = function(e) {
      # displaying note about windows and symbolic links if error occurred
      if(!is.null(msg)) cli::cli_alert_danger(msg)
      stop(e)
    }
  )

  invisible()
}


is.symlink <- function(path) isTRUE(nzchar(Sys.readlink(path), keepNA = TRUE))
