
# if renv project & it's bare, print message to record pkgs in R and Rmd scripts
if (file.exists("renv.lock") &&
    length(setdiff(installed.packages(.libPaths()[1])[, 1], "renv")) == 0L) {
  message("* Discover packages with `renv::install('rmarkdown'); renv::hydrate()`")
  message("* Add discovered packages to `renv.lock` with `renv::snapshot()`")
}
