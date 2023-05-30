.find_project_root <- function(...) {
  # potential roots are the location of the RStudio Proj, git root, or the R package root
  potential_roots <-
    c(
      tryCatch(rprojroot::find_root(rprojroot::is_rstudio_project), error = function(e) NA_character_),
      tryCatch(rprojroot::find_root(rprojroot::is_vcs_root), error = function(e) NA_character_),
      tryCatch(rprojroot::find_root(rprojroot::is_r_package), error = function(e) NA_character_),
      tryCatch(rprojroot::find_root(rprojroot::is_remake_project), error = function(e) NA_character_),
      tryCatch(rprojroot::find_root(rprojroot::is_drake_project), error = function(e) NA_character_),
      tryCatch(rprojroot::find_root(rprojroot::is_pkgdown_project), error = function(e) NA_character_),
      tryCatch(rprojroot::find_root(rprojroot::is_projectile_project), error = function(e) NA_character_),
      tryCatch(rprojroot::find_root(rprojroot::is_testthat), error = function(e) NA_character_)
    ) %>%
    stats::na.omit()

  # keep longest directory as the root
  root <- potential_roots[nchar(potential_roots) == max(nchar(potential_roots))][1]

  fs::path(root, ...)
}
