# starter 0.1.2

* Now evaluating the template attribute `"script_path"` to allow users to quote the file location.

# starter 0.1.1

* When `create_project(renv = TRUE)`, `renv::init()` has been switched to `renv::scaffold()`. This stops renv from initializing the project. The user must call `renv::hydrate()` in order to discover the packages used in the project's `*.R` and `*.Rmd` files and have them added to the `renv.lock` file.

* When a user specifies an attribute to the template list called `"script_path"`, the path is sourced.

# starter 0.1.0

* First release
