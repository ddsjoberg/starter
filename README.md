
<!-- README.md is generated from README.Rmd. Please edit that file -->

# starter

<!-- badges: start -->

[![R-CMD-check](https://github.com/ddsjoberg/starter/workflows/R-CMD-check/badge.svg)](https://github.com/ddsjoberg/starter/actions)
[![Codecov test
coverage](https://codecov.io/gh/ddsjoberg/starter/branch/main/graph/badge.svg)](https://app.codecov.io/gh/ddsjoberg/starter?branch=main)
[![CRAN
status](https://www.r-pkg.org/badges/version/starter)](https://CRAN.R-project.org/package=starter)
<!-- badges: end -->

The **starter** package provides a toolkit for starting new projects.

## Installation

Install {starter} from CRAN with:

``` r
install.packages("starter")
```

Install the development version of {starter} from
[GitHub](https://github.com/ddsjoberg/starter) with:

``` r
# install.packages('devtools')
devtools::install_github("ddsjoberg/starter")
```

## Examples

Simple default template

``` r
library(starter)

create_project(
  path = fs::path(tempdir(), "My Project Folder"),
  open = FALSE # don't open project in new RStudio session
)
#> ✔ Using 'Default Project Template' template
#> ✔ Writing folder '~/My Project Folder/'
#> ✔ Writing files 'README.md', '.gitignore', 'My Project Folder.Rproj', '.Rprofile'
#> ✔ Initialising Git repo
#> ✔ Initialising renv project
#> * renv infrastructure has been generated for project "~/My Project Folder".
```

Template example typical used in an analysis framework.
Template includes a script to setup the data, perform analyses, and report the results.

``` r
create_project(
  path = fs::path(tempdir(), "My Project Folder"),
  template = project_templates[["analysis"]]
)

#> ✔ Using 'Analysis Project Template' template
#> ✔ Writing folder '~/My Project Folder/'
#> ✔ Creating '~/My Project Folder/scripts/'
#> ✔ Creating '~/My Project Folder/scripts/templates/'
#> ✔ Writing files 'README.md', '.gitignore', 'My Project Folder.Rproj', '.Rprofile', 'scripts/10-setup_my.Rmd', #> 'scripts/20-analysis_my.Rmd', 'scripts/30-report_my.Rmd', 'scripts/templates/doc_template.docx', #> 'scripts/templates/references.bib', 'scripts/derived_variables.xlsx', 'SAP - My Project Folder.docx'
#> ✔ Initialising Git repo
#> ✔ Initialising renv project
#> * renv infrastructure has been generated for project "~/My Project #> Folder".
#> ✔ Opening '~/My Project Folder/' in new RStudio session
```

## Code of Conduct

Please note that the starter project is released with a [Contributor
Code of
Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
