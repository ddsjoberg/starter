
# if renv project & it's bare, print message to record pkgs in R and Rmd scripts
if (file.exists("renv.lock") &&
    (!"renv" %in% utils::installed.packages()[, 1] ||
      length(setdiff(names(renv:::renv_lockfile_read(file = "renv.lock")$Packages), "renv")) == 0L)) {
    message("* Your 'renv' project is not yet setup.")
    message("* Discover and record packages with `renv::install('rmarkdown'); renv::hydrate(); renv::snapshot()`")
}
