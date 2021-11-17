pkgname <- "hotfun"
source(file.path(R.home("share"), "R", "examples-header.R"))
options(warn = 1)
options(pager = "console")
library('hotfun')

base::assign(".oldSearch", base::search(), pos = 'CheckExEnv')
base::assign(".old_wd", base::getwd(), pos = 'CheckExEnv')
cleanEx()
nameEx("add_splines")
### * add_splines

flush(stderr()); flush(stdout())

### Name: add_splines
### Title: Add spline terms to a data frame
### Aliases: add_splines

### ** Examples

trial %>%
  add_splines(age)



cleanEx()
nameEx("assign_timepoint")
### * assign_timepoint

flush(stderr()); flush(stdout())

### Name: assign_timepoint
### Title: Assign a timepoint to a long dataset with multiple measures
### Aliases: assign_timepoint

### ** Examples

ggplot2::economics_long %>%
  dplyr::group_by(variable) %>%
  dplyr::mutate(min_date = min(date)) %>%
  dplyr::ungroup() %>%
  assign_timepoint(
    id = "variable",
    ref_date = "min_date",
    measure_date = "date",
    timepoints = c(6, 12, 24),
    windows = list(c(-2, 2), c(-2, 2), c(-2, 2)),
    time_units = "months"
  ) %>%
  dplyr::filter(!is.na(timepoint))



cleanEx()
nameEx("auc_density")
### * auc_density

flush(stderr()); flush(stdout())

### Name: auc_density
### Title: Calculate exact AUCs based on the distribution of risk in a
###   population
### Aliases: auc_density

### ** Examples

auc_density(density = dbeta, shape1 = 1, shape2 = 1)



cleanEx()
nameEx("auc_histogram")
### * auc_histogram

flush(stderr()); flush(stdout())

### Name: auc_histogram
### Title: Calculate an AUC from a histogram
### Aliases: auc_histogram

### ** Examples

runif(10000) %>%
  hist(breaks = 250) %>%
  auc_histogram()



cleanEx()
nameEx("clean_mrn")
### * clean_mrn

flush(stderr()); flush(stdout())

### Name: clean_mrn
### Title: Check and Format MRNs
### Aliases: clean_mrn

### ** Examples

1000:1001 %>%
  clean_mrn()



cleanEx()
nameEx("count_map")
### * count_map

flush(stderr()); flush(stdout())

### Name: count_map
### Title: Checks variable creation for new derived variables at once
### Aliases: count_map

### ** Examples

count_map(
  mtcars,
  list(c("cyl", "am"), c("gear", "carb"))
)



cleanEx()
nameEx("count_na")
### * count_na

flush(stderr()); flush(stdout())

### Name: count_na
### Title: Assess pattern of missing data
### Aliases: count_na

### ** Examples

trial %>% count_na()



cleanEx()
nameEx("create_hot_project")
### * create_hot_project

flush(stderr()); flush(stdout())

### Name: create_hot_project
### Title: Start a new H.O.T. project
### Aliases: create_hot_project

### ** Examples

## Not run: 
##D \donttest{
##D # specifying project folder location (folder does not yet exist)
##D project_path <- fs::path(tempdir(), "My Project Folder")
##D 
##D # creating folder where secure data would be stored (typically will be a network drive)
##D secure_data_path <- fs::path(tempdir(), "secure_data")
##D dir.create(secure_data_path)
##D 
##D # creating new project folder
##D create_hot_project(project_path, path_data = secure_data_path)
##D }
## End(Not run)



cleanEx()
nameEx("egfr")
### * egfr

flush(stderr()); flush(stdout())

### Name: egfr_mdrd
### Title: Calculate eGFR
### Aliases: egfr_mdrd

### ** Examples

egfr_mdrd(creatinine = 1.2, age = 60, female = TRUE, aa = TRUE)



cleanEx()
nameEx("get_mode")
### * get_mode

flush(stderr()); flush(stdout())

### Name: get_mode
### Title: Calculates the mode(s) of a set of values
### Aliases: get_mode

### ** Examples

get_mode(trial$stage)
get_mode(trial$trt)
get_mode(trial$response)
get_mode(trial$grade)



cleanEx()
nameEx("list_labels")
### * list_labels

flush(stderr()); flush(stdout())

### Name: list_labels
### Title: Get variable labels and store in named list
### Aliases: list_labels

### ** Examples

list_labels(trial)



cleanEx()
nameEx("project_template")
### * project_template

flush(stderr()); flush(stdout())

### Name: project_template
### Title: H.O.T. project template
### Aliases: project_template
### Keywords: datasets

### ** Examples

cleanEx()
nameEx("set_derived_variables")
### * set_derived_variables

flush(stderr()); flush(stdout())

### Name: set_derived_variables
### Title: Apply variable labels to data frame
### Aliases: set_derived_variables

### ** Examples

## Not run: 
##D \donttest{
##D trial %>%
##D   set_derived_variables("derived_variables_sjoberg.xlsx")
##D }
## End(Not run)




cleanEx()
nameEx("tbl_propdiff")
### * tbl_propdiff

flush(stderr()); flush(stdout())

### Name: tbl_propdiff
### Title: Calculating unadjusted and adjusted differences in rates
### Aliases: tbl_propdiff

### ** Examples

tbl_propdiff(
  data = trial,
  y = "response",
  x = "trt"
)

tbl_propdiff(
  data = trial,
  y = "response",
  x = "trt",
  formula = "{y} ~ {x} + age + stage",
  method = "boot_sd",
  bootstrapn = 25
)



cleanEx()
nameEx("use_hot_file")
### * use_hot_file

flush(stderr()); flush(stdout())

### Name: use_hot_file
### Title: Write a template file
### Aliases: use_hot_file use_hot_gitignore use_hot_readme

### ** Examples

cleanEx()
nameEx("use_hot_rstudio_prefs")
### * use_hot_rstudio_prefs

flush(stderr()); flush(stdout())

### Name: use_hot_rstudio_prefs
### Title: Use H.O.T. RStudio Preferences
### Aliases: use_hot_rstudio_prefs

### ** Examples

## Not run: 
##D \donttest{
##D use_hot_rstudio_prefs()
##D }
## End(Not run)



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
