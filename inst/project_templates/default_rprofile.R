
# if renv project & it's bare, print message to record pkgs in R and Rmd scripts
if (file.exists("renv.lock") &&
    length(setdiff(installed.packages(.libPaths()[1])[, 1], "renv")) == 0L) {
  # if cli available, print a pretty message to finish setting up renv
  if ("cli" %in% installed.packages()[, 1]) {
    cli::cli_alert_danger("Your {.pkg renv} project is {.strong not} yet setup.")
    cli::cli_alert_warning("Discover and record packages with {.code renv::install('rmarkdown'); renv::hydrate(); renv::snapshot()}")
  }
  # otherwise print a base R message to finish setting up renv
  else {
    message("* Your 'renv' project is not yet setup.")
    message("* Discover and record packages with `renv::install('rmarkdown'); renv::hydrate(); renv::snapshot()`")
  }
}
