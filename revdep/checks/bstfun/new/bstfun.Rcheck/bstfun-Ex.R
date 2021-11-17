pkgname <- "bstfun"
source(file.path(R.home("share"), "R", "examples-header.R"))
options(warn = 1)
options(pager = "console")
library('bstfun')

base::assign(".oldSearch", base::search(), pos = 'CheckExEnv')
base::assign(".old_wd", base::getwd(), pos = 'CheckExEnv')
cleanEx()
nameEx("add_cuminc_risktable")
### * add_cuminc_risktable

flush(stderr()); flush(stdout())

### Name: add_cuminc_risktable
### Title: Add risk table to 'cuminc()' plot
### Aliases: add_cuminc_risktable

### ** Examples

## Don't show: 
if (interactive()) (if (getRversion() >= "3.4") withAutoprint else force)({ # examplesIf
## End(Don't show)
library(cmprsk)
library(survival)

data(pbc)
# recode time
pbc$time.y <- pbc$time / 365.25
# recode status- switch competing events
pbc$status2 <- ifelse(pbc$status > 0, ifelse(pbc$status == 1, 2, 1), 0)
# recode stage for 3 groups
pbc$stage.3g <- ifelse(pbc$stage %in% c(1,2), "1-2", as.character(pbc$stage))


# Example 1 -------------------------------------
# CIR and KM for no strata
cif1 <- cuminc(ftime = pbc$time.y, fstatus = pbc$status2)
km1 <- survfit(Surv(pbc$time.y, pbc$status2 == 1) ~ 1)

# Plot and add risk table for no strata (numgrps=1)
windows(5, 5)
par(mfrow = c(1, 1),
    mar = c(12.5, 5.7, 2, 2),
    mgp = c(2, 0.65, 0))
plot(cif1,
     curvlab = c("recurred", "died"),
     xlim = c(0, 12), xaxt = "n")
axis(1, at = seq(0, 12, 3))

add_cuminc_risktable(cif1, km1,
                     timepts = seq(0, 12, 3),
                     lg = "",
                     numgrps = 1)

# Example 2 -------------------------------------
cif2 <- cuminc(ftime = pbc$time.y,
               fstatus = pbc$status2,
               group = pbc$sex)
km2 <- survfit(Surv(pbc$time.y, pbc$status2 == 1) ~ pbc$sex)

# Plot and add risk table for 2 groups (numgrps=2)
windows(5, 5)
par(mfrow = c(1, 1),
    mar = c(12.5, 5.7, 2, 2),
    mgp = c(2, 0.65, 0))

plot(cif2,
     curvlab = c("male", "female", "", ""),
     lty = c(1, 2, 0, 0),
     xlim = c(0, 12),
     xaxt = "n", col = c(1, 2, 0, 0))
axis(1, at = seq(0, 12, 3))

add_cuminc_risktable(cif2, km2,
                     timepts = seq(0, 12, 3),
                     lg = c("male", "female"),
                     numgrps = 2, col.list = c(1,2))

# Example 3 -------------------------------------
cif3 <- cuminc(ftime = pbc$time.y,
               fstatus = pbc$status2,
               group = pbc$stage.3g)
km3 <- survfit(Surv(pbc$time.y, pbc$status2 == 1) ~ pbc$stage.3g)
windows(6,6)
par(mfrow = c(1, 1),
    mar = c(14, 5.7, 2, 2), # change bottom margin
    mgp = c(2, 0.65, 0))

plot(cif3,
     curvlab = c("1-2", "3", "4", rep("",3)),
     lty = c(1, 2, 3, rep(0, 3)),
     xlim = c(0, 12),
     xaxt = "n", col = c(1, 2, 4, rep(0, 3)))
axis(1, at = seq(0, 12, 3))

add_cuminc_risktable(cif3, survfit = km3,
                     timepts = seq(0, 12, 3),
                     lg = c("1-2", "3", "4"),
                     numgrps = 3, col.list = c(1,2,4))
## Don't show: 
}) # examplesIf
## End(Don't show)



graphics::par(get("par.postscript", pos = 'CheckExEnv'))
cleanEx()
nameEx("add_inline_forest_plot")
### * add_inline_forest_plot

flush(stderr()); flush(stdout())

### Name: add_inline_forest_plot
### Title: Add inline forest plot
### Aliases: add_inline_forest_plot

### ** Examples

## Don't show: 
if (interactive()) (if (getRversion() >= "3.4") withAutoprint else force)({ # examplesIf
## End(Don't show)
library(gtsummary)

# Example 1 ----------------------------------
add_inline_forest_plot_ex1 <-
  lm(mpg ~ cyl + am + drat, mtcars) %>%
  tbl_regression() %>%
  add_inline_forest_plot()
## Don't show: 
}) # examplesIf
## End(Don't show)



cleanEx()
nameEx("add_sparkline")
### * add_sparkline

flush(stderr()); flush(stdout())

### Name: add_sparkline
### Title: Add Sparkline Figure
### Aliases: add_sparkline

### ** Examples

library(gtsummary)

add_sparkline_ex1 <-
  trial %>%
  select(age, marker) %>%
  tbl_summary(missing = "no") %>%
  add_sparkline()



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
nameEx("as_forest_plot")
### * as_forest_plot

flush(stderr()); flush(stdout())

### Name: as_forest_plot
### Title: Create Forest Plot
### Aliases: as_forest_plot

### ** Examples

library(gtsummary)
library(survival)

# Example 1 ----------------------------------
tbl_uvregression(
  trial[c("response", "age", "grade")],
  method = glm,
  y = response,
  method.args = list(family = binomial),
  exponentiate = TRUE
) %>%
as_forest_plot()

# Example 2 ------------------------------------
tbl <-
 coxph(Surv(ttdeath, death) ~ age + marker, trial) %>%
 tbl_regression(exponentiate = TRUE) %>%
 add_n()

as_forest_plot(tbl, col_names = c("stat_n", "estimate", "ci", "p.value"))

# Example 3 ----------------------------------
tbl %>%
modify_cols_merge(
  pattern = "{estimate} ({ci})",
  rows = !is.na(estimate)
) %>%
modify_header(estimate = "HR (95% CI)") %>%
as_forest_plot(
  col_names = c("estimate", "p.value"),
  boxsize = 0.2,
  col = forestplot::fpColors(box = "darkred")
)



cleanEx()
nameEx("as_ggplot")
### * as_ggplot

flush(stderr()); flush(stdout())

### Name: as_ggplot
### Title: Convert gt/gtsummary table to ggplot
### Aliases: as_ggplot

### ** Examples

library(gtsummary)
library(ggplot2)
library(patchwork)

# # convert gtsummary table to ggplot
# tbl <-
#  trial %>%
#  select(age, marker, trt) %>%
#  tbl_summary(by = trt, missing = "no") %>%
#  as_ggplot()
#
# # create basic ggplot
# gg <-
#  trial %>%
#  ggplot(aes(x = age, y = marker, color = trt)) +
#  geom_point()
#
# # stack tables using patchwork
# gg / tbl



cleanEx()
nameEx("assign_timepoint")
### * assign_timepoint

flush(stderr()); flush(stdout())

### Name: assign_timepoint
### Title: Assign a time point to a long data set with multiple measures
### Aliases: assign_timepoint

### ** Examples

ggplot2::economics_long %>%
  dplyr::group_by(variable) %>%
  dplyr::mutate(min_date = min(date)) %>%
  dplyr::ungroup() %>%
  assign_timepoint(
    id = variable,
    ref_date = min_date,
    measure_date = date,
    timepoints = c(6, 12, 24),
    windows = list(c(-2, 2), c(-2, 2), c(-2, 2)),
    time_units = "months"
  )



cleanEx()
nameEx("auc")
### * auc

flush(stderr()); flush(stdout())

### Name: auc
### Title: Calculate exact AUCs based on the distribution of risk in a
###   population
### Aliases: auc auc_density auc_histogram

### ** Examples

auc_density(density = dbeta, shape1 = 1, shape2 = 1)

runif(10000) %>%
  hist(breaks = 250) %>%
  auc_histogram()



cleanEx()
nameEx("cite_r")
### * cite_r

flush(stderr()); flush(stdout())

### Name: cite_r
### Title: Cite R and R Packages
### Aliases: cite_r

### ** Examples

# cite R and the tidyverse
cite_r(pkgs = "tidyverse")

# cite R and the tidyverse, but text only
cite_r(pkgs = "tidyverse", add_citations = FALSE)

# only cite R
cite_r(pkgs = NULL)



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
### Title: Check variable derivations
### Aliases: count_map

### ** Examples

count_map(
  mtcars,
  c(cyl, am), c(gear, carb)
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
nameEx("create_project")
### * create_project

flush(stderr()); flush(stdout())

### Name: create_project
### Title: Start a New Biostatistics project
### Aliases: create_project create_bst_project create_hot_project

### ** Examples

## Don't show: 
if (FALSE) (if (getRversion() >= "3.4") withAutoprint else force)({ # examplesIf
## End(Don't show)
# specifying project folder location (folder does not yet exist)
project_path <- fs::path(tempdir(), "My Project Folder")

# creating folder where secure data would be stored (typically will be a network drive)
secure_data_path <- fs::path(tempdir(), "secure_data")
dir.create(secure_data_path)

# creating new project folder
create_bst_project(project_path, path_data = secure_data_path)
## Don't show: 
}) # examplesIf
## End(Don't show)



cleanEx()
nameEx("egfr")
### * egfr

flush(stderr()); flush(stdout())

### Name: egfr
### Title: Calculate eGFR
### Aliases: egfr egfr_ckdepi egfr_mdrd

### ** Examples

egfr_mdrd(creatinine = 1.2, age = 60, female = TRUE, aa = TRUE)
egfr_ckdepi(creatinine = 1.2, age = 60, female = TRUE, aa = TRUE)



cleanEx()
nameEx("fix_database_error")
### * fix_database_error

flush(stderr()); flush(stdout())

### Name: fix_database_error
### Title: Function to make database fixes after import
### Aliases: fix_database_error

### ** Examples

df_fixes <-
  tibble::tribble(
    ~id, ~variable, ~value,
    "id == 1", "age", "56",
    "id == 2", "trt", "Drug C"
  )
trial %>%
  dplyr::mutate(id = dplyr::row_number()) %>%
  fix_database_error(
    engine = I,
    x = df_fixes
  )



cleanEx()
nameEx("followup_time")
### * followup_time

flush(stderr()); flush(stdout())

### Name: followup_time
### Title: Report Follow-up Among Censored Obs
### Aliases: followup_time

### ** Examples

library(survival)

followup_time(Surv(time, status), data = lung)

followup_time(
  Surv(time, status), data = lung,
  pattern = "{median} days",
  style_fun = ~gtsummary::style_sigfig(., digits = 4)
)



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
nameEx("here_data")
### * here_data

flush(stderr()); flush(stdout())

### Name: here_data
### Title: Find your data folder
### Aliases: here_data path_data get_data_date

### ** Examples

## Not run: 
##D here_data()
##D #> "C:/Users/SjobergD/GitHub/My Project/secure_data/2020-01-01"
##D 
##D here_data("Raw Data.xlsx")
##D #> "C:/Users/SjobergD/GitHub/My Project/secure_data/2020-01-01/Raw Data.xlsx"
##D 
##D path_data(path = "O:/My Project", "Raw Data.xlsx")
##D #> "O:/My Project/secure_data/2020-01-01/Raw Data.xlsx"
## End(Not run)



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
nameEx("project_templates")
### * project_templates

flush(stderr()); flush(stdout())

### Name: project_templates
### Title: Biostatistics project templates
### Aliases: project_templates
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

## Don't show: 
if (FALSE) (if (getRversion() >= "3.4") withAutoprint else force)({ # examplesIf
## End(Don't show)
trial %>%
  set_derived_variables("derived_variables_sjoberg.xlsx")
## Don't show: 
}) # examplesIf
## End(Don't show)



cleanEx()
nameEx("style_tbl_compact")
### * style_tbl_compact

flush(stderr()); flush(stdout())

### Name: style_tbl_compact
### Title: Compact Table Styling
### Aliases: style_tbl_compact

### ** Examples

style_tbl_compact_ex1 <-
  head(trial) %>%
  gt::gt() %>%
  style_tbl_compact()



cleanEx()
nameEx("tbl_likert")
### * tbl_likert

flush(stderr()); flush(stdout())

### Name: tbl_likert
### Title: Likert Summary Table
### Aliases: tbl_likert add_n.tbl_likert

### ** Examples

df <-
  tibble::tibble(
    f1 =
      sample.int(100, n = 3, replace = TRUE) %>%
      factor(levels = 1:3, labels = c("bad", "meh", "good")),
    f2 =
      sample.int(100, n = 3, replace = TRUE) %>%
      factor(levels = 1:3, labels = c("bad", "meh", "good")),
  )

tbl_likert_ex1 <-
  tbl_likert(df) %>%
  add_n()



cleanEx()
nameEx("theme_gtsummary_msk")
### * theme_gtsummary_msk

flush(stderr()); flush(stdout())

### Name: theme_gtsummary_msk
### Title: Set custom gtsummary themes
### Aliases: theme_gtsummary_msk

### ** Examples

theme_gtsummary_msk("hot")



cleanEx()
nameEx("use_bst_rstudio_prefs")
### * use_bst_rstudio_prefs

flush(stderr()); flush(stdout())

### Name: use_bst_rstudio_prefs
### Title: Use Biostatistics RStudio Preferences
### Aliases: use_bst_rstudio_prefs

### ** Examples

## Don't show: 
if (FALSE) (if (getRversion() >= "3.4") withAutoprint else force)({ # examplesIf
## End(Don't show)
use_bst_rstudio_prefs()
## Don't show: 
}) # examplesIf
## End(Don't show)



cleanEx()
nameEx("use_file")
### * use_file

flush(stderr()); flush(stdout())

### Name: use_file
### Title: Write a template file
### Aliases: use_file use_bst_file use_bst_gitignore use_bst_readme
###   use_hot_file use_hot_gitignore use_hot_readme use_hot_setup
###   use_hot_analysis use_hot_report

### ** Examples

cleanEx()
nameEx("use_varnames_as_labels")
### * use_varnames_as_labels

flush(stderr()); flush(stdout())

### Name: use_varnames_as_labels
### Title: Use Variable Names as Labels
### Aliases: use_varnames_as_labels

### ** Examples

library(gtsummary)

mtcars %>%
  select(mpg, cyl, vs, am, carb) %>%
  use_varnames_as_labels(caps = c(mpg, vs, am), exclude = cyl) %>%
  tbl_summary() %>%
  as_kable(format = "simple")



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
