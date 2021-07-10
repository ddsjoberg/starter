
<!-- README.md is generated from README.Rmd. Please edit that file -->

# starter

<!-- badges: start -->

[![R-CMD-check](https://github.com/ddsjoberg/starter/workflows/R-CMD-check/badge.svg)](https://github.com/ddsjoberg/starter/actions)
[![Codecov test
coverage](https://codecov.io/gh/ddsjoberg/starter/branch/main/graph/badge.svg)](https://codecov.io/gh/ddsjoberg/starter?branch=main)
[![r-universe](https://ddsjoberg.r-universe.dev/badges/starter)](https://ddsjoberg.r-universe.dev/ui#builds)
<!-- [![CRAN status](https://www.r-pkg.org/badges/version/starter)](https://CRAN.R-project.org/package=starter) -->
<!-- badges: end -->

The **starter** package provides a toolkit for starting new projects.

## Installation

You can install {starter} from
[GitHub](https://github.com/ddsjoberg/starter) with:

``` r
# install.packages("devtools")
devtools::install_github("ddsjoberg/starter")
```

## Example

``` r
library(starter)

create_project(
  path = fs::path(tempdir(), "My Project Folder"),
  open = FALSE # don't open project in new RStudio session
)
#> v Using 'Default Project Template' template
#> v Writing folder 'C:/Users/sjobergd/AppData/Local/Temp/RtmpG22ExG/My Project Folder/'
#> v Writing files 'README.md', '.gitignore', 'My Project Folder.Rproj', '.Rprofile'
#> v Initialising Git repo
#> v Setting active project to '<no active project>'
#> v Initialising renv project
#> * renv infrastructure has been generated for project "C:/Users/sjobergd/AppData/Local/Temp/RtmpG22ExG/My Project Folder".
```

## Code of Conduct

Please note that the starter project is released with a [Contributor
Code of
Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
