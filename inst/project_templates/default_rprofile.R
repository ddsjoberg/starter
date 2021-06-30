
# if renv project & bare, print message to record pkgs in R and Rmd scripts
if (file.exists("renv.lock") &&
    length(setdiff(installed.packages(.libPaths()[1])[, 1], "renv")) == 0L) {
  message("* Discover packages with `renv::install('rmarkdown'); renv::hydrate()`")
}
