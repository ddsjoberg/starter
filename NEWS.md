# starter 0.1.14

* Removed dependency on the {here} package and replaced with {rprojroot}.

# starter 0.1.13

* Added `mustWork = FALSE` argument to a `normalizePath()` call to avoid warning when `path_data=` is not a local folder (e.g. no warnings when a SharePoint location is passed for the data location).

# starter 0.1.12

* Removed `browser()` that was left in the package from a previous debugging session.

# starter 0.1.11

* Removed {usethis} dependency. Moved {fs} and {readr} from 'Imports' to 'Suggests'.

* Environment update to ensure function runs without error when `create_project()` asks about over-writing an existing file.

* Updated messaging symbols when symbolic link is placed (#37)

# starter 0.1.10

* Updated the sample `.Rprofile` template file with improved checking of the renv project status before messaging users. Previously, we checked the installed packages for the project; if no packages (except renv) were installed, the user saw a message about hydrating the package. But this message would appear each time an existing project was cloned to a new machine where `renv::restore()` had yet to be run. We now check the `renv.lock` file for the recorded packages instead of installed packages. (#27)

* Removed {tibble}, {stringr}, and {purrr} dependencies.

* Better messaging when placing a project skeleton into a folder that is already a git repo: users won't be asked if they want to create a git repo when it already exists. (#26)

* Exporting the project templates in `project_templates`. `project_templates[["default"]]` is a simple example of template usage, and `project_templates[["analysis"]]` is a template including scripts to prepare an analysis project. (#28)

# starter 0.1.9

* Added `{{folder_first_word}}` to objects available to use in the project templates. Evaluates to the first "word" in the folder name, where the word separator is either a space or hyphen.

* Added `create_project(renv.settings=)` argument.

* No longer using `renv::scaffold(settings = list(snapshot.type = 'all'))` as the default.

* Improved messaging in the default `.Rprofile` template file to finish setting up the renv project.

# starter 0.1.8

* Fix for the `use_project_file()` function when the template has an element that evaluates to `NULL` (which resulted in an indexing error). (#19)

# starter 0.1.7

* Allowing users to use their template to override function arguments in `create_project()`. This way, if the user never uses git, for example, this can be communicated in the template, rather than needing to change the function argument every time.

* Added `create_project(symlink=)` argument indicating whether or not to place a symbolic link to the folder indicated in `create_project(path_data=).`

* Updated `.Rprofile` start-up message for new repositories to include the `renv::snapshot()` step.

# starter 0.1.6

* Updated `create_symlink()` to pass the full path to `R.utils::createLink(link=)` instead of just the folder name. This solves an issue when creating symbolic links without full admin rights.

# starter 0.1.5

* Default snapshot type is now 'all'.

* Removed 'rstudioapi' package dependency.

* Bug fix in `create_project(overwrite=)` where existing files were not being prompted with inquiry whether to overwrite.

* Documentation updates.

# starter 0.1.4

* Documentation updates and tidying up for CRAN submission.

* Removed path normalization RStudio add-in.

# starter 0.1.3

* No longer tracking the latest release of the rstudio.prefs package on GitHub, because it causes an issue with renv.

# starter 0.1.2

* Now evaluating the template attribute `"script_path"` to allow users to quote the file location.

# starter 0.1.1

* When `create_project(renv = TRUE)`, `renv::init()` has been switched to `renv::scaffold()`. This stops renv from initializing the project. The user must call `renv::hydrate()` in order to discover the packages used in the project's `*.R` and `*.Rmd` files and have them added to the `renv.lock` file.

* When a user specifies an attribute to the template list called `"script_path"`, the path is sourced.

# starter 0.1.0

* First release
