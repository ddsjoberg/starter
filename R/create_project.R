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
#' @param template Project template.
#' @param git Logical indicating whether to create Git repository.  Default is `TRUE`
#' When `NA`, user will be prompted whether to initialise Git repo.
#' @param renv Logical indicating whether to add renv to a project.
#' Default is `TRUE`. When `NA` which interactively asks user preference.
#' @param overwrite Overwrite any existing files if they exist.  Options are
#' `TRUE`, `FALSE`, and `NA` (aka ask interactively).  Default is `NA`
#' @param open Logical indicating whether to open new project in fresh RStudio
#' session
#'
#' @author Daniel D. Sjoberg
#' @export
#' @returns NULL, places project template in new or existing directory
#' @examples
#' # specifying project folder location (folder does not yet exist)
#' project_path <- fs::path(tempdir(), "My Project Folder")
#'
#' # creating folder where secure data would be stored (typically will be a network drive)
#' secure_data_path <- fs::path(tempdir(), "secure_data")
#' fs::dir_create(secure_data_path)
#'
#' # creating new project folder
#' create_project(project_path, path_data = secure_data_path)
#' @seealso [`use_project_file()`]
#' @seealso [Vignette for `create_project()`](https://www.danieldsjoberg.com/starter/articles/create_project.html)

create_project <- function(path, path_data = NULL, template = "default",
                           git = TRUE, renv = TRUE, overwrite = NA,
                           open = interactive()) {
  # ask user -------------------------------------------------------------------
  if (is.na(git))
    git <- ifelse(!interactive(), TRUE, ui_yeah("Initialise Git repo?",
                                                n_no = 1, shuffle = FALSE))
  if (is.na(renv))
    renv <- ifelse(!interactive(), TRUE, ui_yeah("Initialise renv project?",
                                                 n_no = 1, shuffle = FALSE))

  # import template ------------------------------------------------------------
  template <- evaluate_project_template(template, path, git, renv)

  # writing files and folders --------------------------------------------------
  writing_files_folders(
    selected_template = template,
    path = path,
    overwrite = overwrite,
    path_data = path_data,
    git = git, renv = renv
  )

  # setting symbolic link if provided ------------------------------------------
  if (!is.null(path_data)) {
    R.utils::createLink(
      target = glue::glue("{path_data}"),
      link = fs::path(glue::glue("{path}"), "secure_data")
    )
    ui_done("Creating symbolic link to data folder {ui_path(path_data)}")
  }

  # initializing git repo ------------------------------------------------------
  initialise_git(git, path)

  # initializing renv project --------------------------------------------------
  if (isTRUE(renv)) {
    ui_done("Initialising {ui_field('renv')} project")
    # set up sctruture of renv project
    renv::scaffold(project = path)
  }

  # if user added a path to a script, run it -----------------------------------
  if (!is.null(attr(template, "script_path"))) {
    ui_done("Sourcing template script")
    source(file = attr(template, "script_path"), local = rlang::current_env())
  }

  # finishing up ---------------------------------------------------------------
  # opening new R project
  if (open) {
    if (usethis::proj_activate(path)) {
      on.exit()
    }
  }
  return(invisible())
}

evaluate_project_template <- function(template, path, git, renv) {
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
    {ui_done("Using {ui_value(.)} template")}

  script_path <- attr(template, "script_path") %>% eval()

  # eval() quoted template list ------------------------------------------------
  tryCatch({
    selected_template <- eval_nested_lists(template, path, git, renv)
  },
  warning = function(w) {warning(w)},
  error = function(e) {
    ui_oops(
      paste(
        "There was as error evaluating the the list defining the project template.",
        "If this is a template stored in the package, please file",
        "a GitHub Issue illustrating the error. If this is a personal template,",
        "review the vignette on creating a personal project template."
      ) %>%
        stringr::str_wrap()
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
      !fs::file_exists(attr(selected_template, "script_path"))) {
    paste("Template attribute 'script_path' must be a file location.") %>%
      stop(call. = FALSE)
  }

  for (i in names(selected_template)) {
    # check each files meta data is a named list
    if (!rlang::is_list(selected_template[[i]]) ||
        !rlang::is_named(selected_template[[i]]))
      glue::glue("Template meta data for {ui_field(i)} must be a named list.") %>%
      stop(call. = FALSE)
    # check the named list has the correct names
    if (!setequal(names(selected_template[[i]]), c("template_filename", "filename", "glue")) &&
        !setequal(names(selected_template[[i]]), c("template_filename", "filename", "copy")))
      glue::glue("Expecting elements of template list {ui_field(i)} to have ",
                 "names {ui_value(c('template_filename', 'filename', 'glue'))}.") %>%
      stop(call. = FALSE)
    # check the types for each element are correct
    copy_or_glue <- names(selected_template[[i]]) %>% intersect(c("glue", "copy"))
    if (!rlang::is_string(selected_template[[i]][["template_filename"]]) ||
        !rlang::is_string(selected_template[[i]][["filename"]]) ||
        !rlang::is_logical(selected_template[[i]][[copy_or_glue]]))
      glue::glue("Expecting elements of template list {ui_field(i)} to have specific classes: ",
                 "{ui_value('template_filename')} and  {ui_value('filename')} must be strings ",
                 "and {ui_value(copy_or_glue)} logical.") %>%
      stop(call. = FALSE)
    # check the template file exists
    if (!fs::file_exists(selected_template[[i]][["template_filename"]]))
      glue::glue("Template file {ui_value(selected_template[[i]][['template_filename']])} ",
                 "does not exist.") %>%
      stop(call. = FALSE)

  }
}

# this function iterates over each element of
# nested lists, and evaluates the quote or expr
eval_nested_lists <- function(template, path, git, renv) {
  template <- eval_if_call_or_expr(template, path, git, renv)
  if (!rlang::is_list(template)) return(template)

  # iterating over list to evaluate quoted/expr elements
  for (i in seq_len(length(template))) {
    if (rlang::is_list(template[[i]])) {
      for (j in seq_len(length(template[[i]]))) {
        template[[i]][[j]] <- eval_if_call_or_expr(template[[i]][[j]], path, git, renv)
      }
      # remove empty elements after evaluating
      template[[i]] <- purrr::compact(template[[i]])
    }
    else template[[i]] <- eval_if_call_or_expr(template[[i]], path, git, renv)
  }

  # remove empty elements after evaluating and return
  purrr::compact(template)
}

eval_if_call_or_expr <- function(x, path, git, renv)  {
  # strings that may be needed in the evaluation of some strings
  folder_name <- basename(path)
  if (rlang::is_call(x) || rlang::is_expression(x)) x <- eval(x)
  x
}

writing_files_folders <- function(selected_template, path,
                                  overwrite, path_data, git, renv) {
  # creating the base project folder -------------------------------------------
  if (!dir.exists(path)) {
    fs::dir_create(path, recurse = TRUE)
    ui_done("Writing folder {ui_path(path)}")
  }

  # symbolic link text ----------------------------------------------------------
  # if folder location of data provided creating symbolic link text
  symbolic_link <-
    ifelse(
      !is.null(path_data),
      stringr::str_glue('starter::create_symlink(to = "{fs::path_norm(path_data)}")'),
      'starter::create_symlink(to = "<secure data path>")'
    )
  folder_name <- basename(path)

  # creating project folder(s) -------------------------------------------------
  selected_template %>%
    purrr::map_chr(purrr::pluck, "filename") %>%
    dirname() %>%
    purrr::discard(~. == ".") %>%
    unique() %>%
    purrr::walk(
      function(.x) {
        if (!fs::dir_exists(fs::path(path, .x))) {
          fs::dir_create(fs::path(path, .x), recurse = TRUE)
          ui_done("Creating {ui_path(fs::path(path, .x))}")
        }
      }
    )

  # tibble of each file in template --------------------------------------------
  df_files <-
    tibble::tibble(file_abbrv = names(selected_template)) %>%
    dplyr::rowwise() %>%
    dplyr::mutate(
      filename = selected_template[[.data$file_abbrv]]$filename,
      template_file_path = selected_template[[.data$file_abbrv]]$template_filename,
      glue = selected_template[[.data$file_abbrv]]$glue,
      file_exists = fs::file_exists(fs::path(.env$path, .data$filename))
    )
  df_files$write_file <-
    seq_len(nrow(df_files)) %>%
    purrr::map_lgl(
      function(i) {
        if (!df_files$file_exists[i]) return(TRUE)
        if (isTRUE(overwrite)) return(TRUE)
        if (!isTRUE(overwrite)) return(FALSE)
        if (!interactive()) return(FALSE)
        msg <- paste("{ui_path(df_files$filename[i])} already exists.",
                     "Would you like to overwrite it?")
        return(ui_yeah(msg))
      }
    )

  # remove files we will not write ---------------------------------------------
  df_files <- df_files %>% dplyr::filter(.data$write_file)

  # writing template files to folder -------------------------------------------
  purrr::walk(
    seq_len(nrow(df_files)),
    function(i) {
      # if glue file contents, importing as string, evaluating glue::glue, and writing to file
      if (df_files$glue[i]) {
        readr::read_file(df_files$template_file_path[i]) %>%
          glue::glue(.open = "{{", .close = "}}") %>%
          readr::write_file(file = fs::path(path, df_files$filename[i]))
      }
      # if just copying (no glue), copying file to project folder
      else {
        file.copy(
          from = df_files$template_file_path[i],
          to = fs::path(path, df_files$filename[i]),
          overwrite = TRUE
        )
      }
    }
  )
  ui_done("Writing files {ui_value(df_files$filename)}")
}

initialise_git <- function(git, path) {
  # initializing git repo ------------------------------------------------------
  if (isTRUE(git)) {
    ui_done("Initialising {ui_field('Git')} repo")
    # if there is an error setting up, printing note about the error
    tryCatch({
      # Configure Git repository
      usethis::with_project(
        path = path,
        gert::git_init(path = path),
        setwd = FALSE,
        quiet = TRUE
      )
    },
    error = function(e) {
      ui_oops(
        paste(
          "There was an error in {ui_code('gert::git_init()')} while",
          "initialising the Git repo.",
          "Have you installed Git and set it up?",
          "Refer to the book 'Happy Git and GitHub for the useR'",
          "for step-by-step instructions on getting started with Git."
        ) %>%
          stringr::str_wrap()
      )
      ui_code_block("https://happygitwithr.com/install-git.html")
      # setting git to FALSE as no git repo exists
      git <- FALSE
    })
  }
}

copy_to_glue <- function(x) {
  purrr::map(
    x,
    ~switch(
      "copy" %in% names(.x),
      purrr::list_modify(.x, glue = !.x$copy, copy = NULL)
    ) %||% .x
  )
}
