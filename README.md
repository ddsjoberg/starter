
<!-- README.md is generated from README.Rmd. Please edit that file -->

# starter

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/starter)](https://CRAN.R-project.org/package=starter)
[![Codecov test
coverage](https://codecov.io/gh/ddsjoberg/starter/branch/main/graph/badge.svg)](https://codecov.io/gh/ddsjoberg/starter?branch=main)
[![R-CMD-check](https://github.com/ddsjoberg/starter/workflows/R-CMD-check/badge.svg)](https://github.com/ddsjoberg/starter/actions)
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
#> v Creating 'C:/Users/sjobergd/AppData/Local/Temp/RtmpqO4Xio/My Project Folder/'
#> v Writing files 'README.md', '.gitignore', 'My Project Folder.Rproj'
#> v Initialising Git repo
#> v Initialising renv project
#> * Initializing project ...
#> * Discovering package dependencies ... Done!
#> * Copying packages into the cache ... Done!
#> The following package(s) will be updated in the lockfile:
#> 
#> # CRAN ===============================
#> - renv   [* -> 0.13.2]
#> 
#> * Lockfile written to 'C:/Users/sjobergd/AppData/Local/Temp/RtmpqO4Xio/My Project Folder/renv.lock'.
```

## Code of Conduct

Please note that the starter project is released with a [Contributor
Code of
Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
