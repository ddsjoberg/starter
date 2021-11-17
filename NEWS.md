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
