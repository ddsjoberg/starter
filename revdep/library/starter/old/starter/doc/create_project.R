## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)
library(dplyr)

## ---- message=FALSE-----------------------------------------------------------
# loading packages
library(starter)

# specifying project folder location (folder does not yet exist)
project_path <- fs::path(tempdir(), "My Project Folder")

## ---- comment=""--------------------------------------------------------------
create_project(
  path = project_path,
  open = FALSE # don't open project in new RStudio session
)

## ---- comment = "", echo=FALSE------------------------------------------------
readr::read_file(fs::path(project_path, "README.md")) %>% cat()

## ---- comment = "", echo=FALSE------------------------------------------------
readr::read_file(fs::path(project_path, ".gitignore")) %>% cat()

## ---- comment = "", echo=FALSE------------------------------------------------
readr::read_file(system.file("project_templates/default_readme.md", package = 'starter')) %>% cat()

## -----------------------------------------------------------------------------
my_template <-
  quote(list(
    gitignore = list(),
    readme = list(),
    rproj = list()
  ))

## ---- eval=FALSE--------------------------------------------------------------
#  readme <- list(
#    template_filename = system.file("project_templates/default_readme.md", package = "starter"),
#    filename = "README.md",
#    glue = TRUE
#  )

## ---- eval=FALSE--------------------------------------------------------------
#  rproj <- list(
#    template_filename = system.file("project_templates/default_rproj.Rproj", package = "starter"),
#    filename = glue::glue("{folder_name}.Rproj"),
#    glue = FALSE
#  )

## -----------------------------------------------------------------------------
my_template <- quote(list(
  readme = list(
    template_filename = system.file("project_templates/default_readme.md", package = "starter"), 
    filename = "README.md",
    glue = TRUE
  ),
  rproj = list(
    template_filename = system.file("project_templates/default_rproj.Rproj", package = "starter"), 
    filename = glue::glue("{folder_name}.Rproj"),
    glue = FALSE
  ),
  
gitignore = list(
  template_filename = system.file("project_templates/default_gitignore.txt", package = "starter"), 
  filename = "gitignore.txt", 
  glue = TRUE
)
))

## -----------------------------------------------------------------------------
attr(my_template, "label") <- "My Very 1st Project Template"

## ---- include=FALSE, echo=FALSE-----------------------------------------------
unlink(project_path, recursive = TRUE)

## -----------------------------------------------------------------------------
create_project(
  path = project_path,
  template = my_template # metadata list created above
)

