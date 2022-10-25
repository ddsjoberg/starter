#' @importFrom dplyr %>%
#' @importFrom rlang %||% .data .env
#' @keywords internal
"_PACKAGE"

# similar to usethis::ui_yeah(), but no usethis dep
ui_yeah2 <- function(x, .envir = parent.frame()) {
  cli::cli_alert_warning(x, .envir = .envir)
  utils::menu(c("Yes", "No"), "") %>%
    {dplyr::case_when(
      . == 1L ~ TRUE,
      . == 2L ~ FALSE
    )}
}

# allowing for the use of the dot when piping
utils::globalVariables(".")

# The following block is used by usethis to automatically manage
# roxygen namespace tags. Modify with care!
## usethis namespace: start
## usethis namespace: end
NULL
