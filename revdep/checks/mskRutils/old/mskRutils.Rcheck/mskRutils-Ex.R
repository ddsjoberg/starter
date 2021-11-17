pkgname <- "mskRutils"
source(file.path(R.home("share"), "R", "examples-header.R"))
options(warn = 1)
options(pager = "console")
library('mskRutils')

base::assign(".oldSearch", base::search(), pos = 'CheckExEnv')
base::assign(".old_wd", base::getwd(), pos = 'CheckExEnv')
cleanEx()
nameEx("create_msk_project")
### * create_msk_project

flush(stderr()); flush(stdout())

### Name: create_msk_project
### Title: Start a new project
### Aliases: create_msk_project

### ** Examples

# specifying project folder location (folder does not yet exist)
project_path <- fs::path(tempdir(), "My Project Folder")

# creating folder where secure data would be stored (typically will be a network drive)
secure_data_path <- fs::path(tempdir(), "secure_data")
dir.create(secure_data_path)

# creating new project folder
create_msk_project(project_path, path_data = secure_data_path)



cleanEx()
nameEx("default_project_template")
### * default_project_template

flush(stderr()); flush(stdout())

### Name: default_project_template
### Title: Default project template
### Aliases: default_project_template
### Keywords: datasets

### ** Examples

create_msk_project(
  path = file.path(tempdir(), "Sjoberg New Project"),
  template = mskRutils::default_project_template
)



cleanEx()
nameEx("grapes-not_in-grapes")
### * grapes-not_in-grapes

flush(stderr()); flush(stdout())

### Name: %not_in%
### Title: Inverted version of '%in%'
### Aliases: %not_in%

### ** Examples

1 %not_in% 1:10  #returns FALSE
"b" %not_in% 1:10  #returns TRUE



cleanEx()
nameEx("has_msk_network_access")
### * has_msk_network_access

flush(stderr()); flush(stdout())

### Name: has_msk_network_access
### Title: Check for MSK Network Access
### Aliases: has_msk_network_access

### ** Examples

has_msk_network_access()



cleanEx()
nameEx("use_covr_badge")
### * use_covr_badge

flush(stderr()); flush(stdout())

### Name: use_covr_badge
### Title: Code Coverage Badge
### Aliases: use_covr_badge

### ** Examples

## Not run: 
##D # Add the following line to the README.Rmd file of a package on GitHub
##D ![Coverage](`r mskRutils::use_covr_badge()`)
## End(Not run)



cleanEx()
nameEx("use_github_msk_release")
### * use_github_msk_release

flush(stderr()); flush(stdout())

### Name: use_github_msk_release
### Title: Draft a GitHub release for a MSK package
### Aliases: use_github_msk_release

### ** Examples




cleanEx()
nameEx("use_msk_file")
### * use_msk_file

flush(stderr()); flush(stdout())

### Name: use_msk_file
### Title: Write a template file
### Aliases: use_msk_file use_msk_gitignore use_msk_readme

### ** Examples




cleanEx()
nameEx("use_rstudio")
### * use_rstudio

flush(stderr()); flush(stdout())

### Name: use_msk_rspm
### Title: Set Rstudio preferences
### Aliases: use_msk_rspm use_rstudio_preferences
###   use_rstudio_keyboard_shortcut

### ** Examples


# # Set MSK RStudio Package Manager repository
# use_msk_rspm()

# # Set RStudio defaults for best practices
# use_rstudio_preferences()

# # Set mskRutils keyboard shortcuts
# use_rstudio_keyboard_shortcut()



### * <FOOTER>
###
cleanEx()
options(digits = 7L)
base::cat("Time elapsed: ", proc.time() - base::get("ptime", pos = 'CheckExEnv'),"\n")
grDevices::dev.off()
###
### Local variables: ***
### mode: outline-minor ***
### outline-regexp: "\\(> \\)?### [*]+" ***
### End: ***
quit('no')
