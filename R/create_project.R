#' Start a new project
#'
#' Creates a directory with the essential files for
#' a new project. The function can be used on existing project directories as well.
#' Existing files will *not* be overwritten; rather, the user will be prompted
#' whether to replace the existing file with the template file.
#'
#' @section Personalized Template:
#' Users can create a
#' personalized project template. Check out the
#' \href{https://www.danieldsjoberg.com/starter/articles/create_project.html}{vignette}
#' for step by step instructions.
#'
#' @param path A path. If it exists, it is used. If it does not exist, it is
#' created.
#' @param path_data A path. The directory where the secure data exist. Default is
#' `NULL`.  When supplied, a symbolic link to data folder will be created.
#' @param template A project template. See
#' \href{https://www.danieldsjoberg.com/starter/articles/create_project.html}{vignette}
#' for details.
#' @param git Logical indicating whether to create Git repository.  Default is `TRUE`
#' When `NA`, user will be prompted whether to initialise Git repo.
#' @param renv Logical indicating whether to add renv to a project.
#' Default is `TRUE`. When `NA` user is asked interactively for preference.
#' @param overwrite Logical indicating whether to overwrite existing files
#' if they exist.  Options are
#' `TRUE`, `FALSE`, and `NA` (aka ask interactively).  Default is `NA`
#' @param open Logical indicating whether to open new project in fresh RStudio
#' session
#' @param symlink Logical indicating whether to place a symbolic link
#' to the location in `path_data=`. Default is to place the symbolic link
#' if the project is a git repository.
#' @param renv.settings A list of renv settings passed to `renv::scaffold(settings=)`
#'
#' @author Daniel D. Sjoberg
#' @export
#' @returns NULL, places project template in new or existing directory
#' @examplesIf pkgdown::in_pkgdown()
#' # specifying project folder location (folder does not yet exist)
#' project_path <- file.path(tempdir(), "My Project Folder")
#'
#' # creating folder where secure data would be stored (typically will be a network drive)
#' secure_data_path <- file.path(tempdir(), "secure_data")
#' dir.create(secure_data_path)
#'
#' # creating new project folder
#' create_project(project_path, path_data = secure_data_path)
#' @seealso [`use_project_file()`]
#' @seealso [Vignette for `create_project()`](https://www.danieldsjoberg.com/starter/articles/create_project.html)

create_project <- function(path, path_data = NULL, template = "default",
                           git = TRUE, renv = TRUE, symlink = git,
                           renv.settings = NULL,
                           overwrite = NA, open = interactive()) {
  # check if template has function arg override --------------------------------
  if (!is.null(template) && !is.null(attr(template, "arg_override"))) {
    override_arg_list <- attr(template, "arg_override")

    # print note about args being set

    walk2(
      override_arg_list,
      names(override_arg_list),
      function(arg, name) {
        if (!identical(arg, eval(parse(text = name))))
          cli::cli_alert_success("Using template argument override {.code {paste(name, deparse(arg, width.cutoff = 200L), sep = ' = ')}}")
      }
    )
    list2env(override_arg_list, envir = rlang::current_env())
  }

  # ask user -------------------------------------------------------------------
  if (!isTRUE(git) && is_git(path)) git <- TRUE # if folder is already git, don't ask about it.

  if (is.na(git))
    git <- ifelse(!interactive(), TRUE, ui_yeah2("Initialise Git repo?"))
  if (is.na(renv))
    renv <- ifelse(!interactive(), TRUE, ui_yeah2("Initialise renv project?"))
  if (is.na(symlink))
    symlink <- ifelse(!interactive(), TRUE, ui_yeah2("Place symbolic link?"))

  # import template ------------------------------------------------------------
  template <- evaluate_project_template(template, path, git, renv, symlink)

  # writing files and folders --------------------------------------------------
  writing_files_folders(
    selected_template = template,
    path = path,
    overwrite = overwrite,
    path_data = path_data,
    git = git, renv = renv
  )

  # setting symbolic link if provided ------------------------------------------
  if (isTRUE(symlink) && !is.null(path_data)) {
    R.utils::createLink(
      target = glue::glue("{path_data}"),
      link = file.path(glue::glue("{path}"), "secure_data")
    )
    cli::cli_alert_success("Creating symbolic link to data folder {.file {path_data}}")
  }

  # initializing git repo ------------------------------------------------------
  initialise_git(git, path)

  # initializing renv project --------------------------------------------------
  if (isTRUE(renv)) {
    cli::cli_alert_success("Initialising {.pkg renv} project")
    # set up structure of renv project
    renv::scaffold(project = path, settings = renv.settings)
  }

  # if user added a path to a script, run it -----------------------------------
  if (!is.null(attr(template, "script_path"))) {
    cli::cli_alert_success("Sourcing template script")
    source(file = attr(template, "script_path"), local = rlang::current_env())
  }

  # finishing up ---------------------------------------------------------------
  # opening new R project
  if (isTRUE(open) && rstudioapi::isAvailable() && has_rproj(path)) {
    rstudioapi::openProject(path, newSession = TRUE)
  }
  return(invisible())
}

evaluate_project_template <- function(template, path, git, renv, symlink) {
  if (is.null(template)) template <-  project_templates[["default"]]
  if (rlang::is_string(template)) {
    template <-
      switch(
        template,
        "default" = project_templates[["default"]]
      ) %||%
      project_templates[["default"]]
  }
  attr(template, "label") %||%
    "User-defined Template" %>%
    {cli::cli_alert_success("Using {.val {.}} template")}

  script_path <- attr(template, "script_path") %>% eval()

  # eval() quoted template list ------------------------------------------------
  tryCatch({
    selected_template <- eval_nested_lists(template, path, git, renv)
  },
  warning = function(w) {warning(w)},
  error = function(e) {
    cli::cli_alert_danger(
      paste(
        "There was as error evaluating the the list defining the project template.\n",
        "If this is a template stored in the package, please file\n",
        "a GitHub Issue illustrating the error. If this is a personal template,\n",
        "review the vignette on creating a personal project template."
      )
    )
    stop(e)
  })

  # old name for glue was copy, update it --------------------------------------
  selected_template <- copy_to_glue(selected_template)

  # adding script path attribute back ------------------------------------------
  attr(selected_template, "script_path") <- script_path

  # checking imported template is named list -----------------------------------
  check_template_structure(selected_template)

  # return evaluated template --------------------------------------------------
  selected_template
}

# check the structure of the passed template object
check_template_structure <- function(selected_template) {
  # check input is a named list
  if (!rlang::is_list(selected_template) || !rlang::is_named(selected_template)) {
    stop("Expecting a named list in `template=`", call. = FALSE)
  }

  if (!is.null(attr(selected_template, "script_path")) &&
      !file.exists(attr(selected_template, "script_path"))) {
    paste("Template attribute 'script_path' must be a file location.") %>%
      stop(call. = FALSE)
  }

  for (i in names(selected_template)) {
    # check each files meta data is a named list
    if (!rlang::is_list(selected_template[[i]]) ||
        !rlang::is_named(selected_template[[i]]))
      glue::glue("Template meta data for '{i}' must be a named list.") %>%
      stop(call. = FALSE)
    # check the named list has the correct names
    if (!setequal(names(selected_template[[i]]), c("template_filename", "filename", "glue")) &&
        !setequal(names(selected_template[[i]]), c("template_filename", "filename", "copy")))
      glue::glue("Expecting elements of template list '{i}' to have ",
                 "names {paste(shQuote(c('template_filename', 'filename', 'glue'), type = 'csh'), collapse = ', ')}.") %>%
      stop(call. = FALSE)
    # check the types for each element are correct
    copy_or_glue <- names(selected_template[[i]]) %>% intersect(c("glue", "copy"))
    if (!rlang::is_string(selected_template[[i]][["template_filename"]]) ||
        !rlang::is_string(selected_template[[i]][["filename"]]) ||
        !rlang::is_logical(selected_template[[i]][[copy_or_glue]]))
      glue::glue("Expecting elements of template list '{i}' to have specific classes: ",
                 "'template_filename') and  'filename' must be strings ",
                 "and {copy_or_glue} logical.") %>%
      stop(call. = FALSE)
    # check the template file exists
    if (!file.exists(selected_template[[i]][["template_filename"]]))
      glue::glue("Template file '{selected_template[[i]][['template_filename']]}' ",
                 "does not exist.") %>%
      stop(call. = FALSE)

  }
}

# this function iterates over each element of
# nested lists, and evaluates the quote or expr
eval_nested_lists <- function(template, path, git, renv) {
  template <- eval_if_call_or_expr(template, path, git, renv)
  if (!rlang::is_list(template)) return(template)

  template_evaluated <-
    vector(mode = "list", length = length(template)) %>%
    stats::setNames(names(template)) %>%
    map(~list())
  # iterating over list to evaluate quoted/expr elements
  for (i in seq_len(length(template))) {
    if (rlang::is_list(template[[i]])) {
      for (j in seq_len(length(template[[i]]))) {
        template_evaluated[[i]][j] <-
          eval_if_call_or_expr(template[[i]][[j]], path, git, renv) %>%
          list() %>%
          stats::setNames(names(template[[i]][j]))
      }
      # remove empty elements after evaluating
      template_evaluated[i] <-
        compact(template[[i]]) %>%
        list() %>%
        stats::setNames(names(template[i]))
    }
    else template_evaluated[i] <-
        eval_if_call_or_expr(template[[i]], path, git, renv) %>%
        list() %>%
        stats::setNames(names(template[i]))
  }

  # remove empty elements after evaluating and return
  compact(template_evaluated)
}

eval_if_call_or_expr <- function(x, path, git, renv)  {
  # strings that may be needed in the evaluation of some strings
  folder_name <- basename(path)
  folder_first_word <-
    strsplit(x = folder_name, split = ' |-')[[1]][1] %>%
    tolower()
  if (rlang::is_call(x) || rlang::is_expression(x)) x <- eval(x)
  x
}

writing_files_folders <- function(selected_template, path,
                                  overwrite, path_data, git, renv) {
  # creating the base project folder -------------------------------------------
  if (!dir.exists(path)) {
    dir.create(path, recursive = TRUE)
    cli::cli_alert_success("Writing folder {.file {path}}")
  }

  # symbolic link text ----------------------------------------------------------
  # if folder location of data provided creating symbolic link text
  symbolic_link <-
    ifelse(
      !is.null(path_data),
      glue::glue('starter::create_symlink(to = "{normalizePath(path_data, winslash = \"/\", mustWork = FALSE)}")'),
      'starter::create_symlink(to = "<secure data path>")'
    )
  folder_name <- basename(path)

  # creating project folder(s) -------------------------------------------------
  selected_template %>%
    map_chr("filename") %>%
    dirname() %>%
    discard(~. == ".") %>%
    unique() %>%
    walk(
      function(.x) {
        if (!dir.exists(file.path(path, .x))) {
          dir.create(file.path(path, .x), recursive = TRUE)
          cli::cli_alert_success("Creating {.file {file.path(path, .x)}}")
        }
      }
    )

  # tibble of each file in template --------------------------------------------
  df_files <-
    dplyr::tibble(file_abbrv = names(selected_template)) %>%
    dplyr::rowwise() %>%
    dplyr::mutate(
      filename = selected_template[[.data$file_abbrv]]$filename,
      template_file_path = selected_template[[.data$file_abbrv]]$template_filename,
      glue = selected_template[[.data$file_abbrv]]$glue,
      file_exists = file.exists(file.path(.env$path, .data$filename))
    )
  df_files$write_file <-
    seq_len(nrow(df_files)) %>%
    map_lgl(
      function(i) {
        if (!df_files$file_exists[i]) return(TRUE)
        if (isTRUE(overwrite)) return(TRUE)
        if (isFALSE(overwrite)) return(FALSE)
        if (!interactive()) return(FALSE)
        msg <- paste("{.file {df_files$filename[i]}} already exists.",
                     "Would you like to overwrite it?")
        return(ui_yeah2(msg))
      }
    )

  # remove files we will not write ---------------------------------------------
  df_files <- df_files %>% dplyr::filter(.data$write_file)

  # writing template files to folder -------------------------------------------
  walk(
    seq_len(nrow(df_files)),
    function(i) {
      # if glue file contents, importing as string, evaluating glue::glue, and writing to file
      if (df_files$glue[i]) {
        readLines(df_files$template_file_path[i]) %>%
          paste(collapse = "\n") %>%
          glue::glue(.open = "{{", .close = "}}") %>%
          writeLines(con = file.path(path, df_files$filename[i]))
      }
      # if just copying (no glue), copying file to project folder
      else {
        file.copy(
          from = df_files$template_file_path[i],
          to = file.path(path, df_files$filename[i]),
          overwrite = TRUE
        )
      }
    }
  )
  cli::cli_alert_success("Writing files {.val {df_files$filename}}")
}

initialise_git <- function(git, path) {
  # initializing git repo ------------------------------------------------------
  if (isTRUE(git) && !is_git(path)) {
    cli::cli_alert_success("Initialising {.field Git} repo")
    # if there is an error setting up, printing note about the error
    tryCatch({
      # Configure Git repository
      gert::git_init(path = path)
    },
    error = function(e) {
      cli::cli_alert_danger(
        paste(
          "There was an error in {.code gert::git_init()} while\n",
          "initialising the Git repo.\n",
          "Have you installed Git and set it up?\n",
          "Refer to the book 'Happy Git and GitHub for the useR'\n",
          "for step-by-step instructions on getting started with Git."
        )
      )
      cli::cli_alert("{.url https://happygitwithr.com/install-git.html}")
      # setting git to FALSE as no git repo exists
      git <- FALSE
    })
  }
}

copy_to_glue <- function(x) {
  map(
    x,
    ~switch(
      "copy" %in% names(.x),
      modifyList(.x, val = list(glue = !.x$copy, copy = NULL))
    ) %||% .x
  )
}


is_git <- function(path = ".") {
  dir.exists(path) && dir.exists(paths = file.path(path, ".git"))
}

has_rproj <- function(path) {
  files <- list.files(path = path)

  isTRUE(any(grepl(x = files, pattern = "\\.Rproj$")))
}
