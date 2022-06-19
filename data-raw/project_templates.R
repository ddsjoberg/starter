## code to prepare project template goes here

# default template -------------------------------------------------------------
default_project_template <-
  list(
    readme = rlang::expr(list(
      template_filename =
        fs::path_package(package = "starter", "project_templates/default_readme.md"),
      filename = "README.md",
      glue = TRUE
    )),
    gitignore = rlang::expr(list(
      template_filename =
        fs::path_package(package = "starter", "project_templates/default_gitignore.txt"),
      filename = ".gitignore",
      glue = FALSE
    )),
    rproj = rlang::expr(list(
      template_filename =
        fs::path_package(package = "starter", "project_templates/default_rproj.Rproj"),
      filename = stringr::str_glue("{folder_name}.Rproj"),
      glue = FALSE
    )),
    # only add Rprofile if renv was used
    rprofile =
      rlang::expr(switch(
        renv,
        list(
          template_filename =
            fs::path_package(package = "starter",
                             "project_templates/default_rprofile.R"),
          filename = stringr::str_glue(".Rprofile"),
          glue = TRUE
        )
      ))
  )
attr(default_project_template, "label") <- "Default Project Template"


# analysis template ------------------------------------------------------------
analysis_project_template <-
  c(default_project_template,
    list(
      setup = rlang::expr(list(
        template_filename = fs::path_package("project_templates/analysis_template/setup.Rmd", package = "starter"),
        filename = glue::glue("scripts/10-setup_{folder_first_word}.Rmd"),
        copy = FALSE
      )),
      analysis = rlang::expr(list(
        template_filename = fs::path_package("project_templates/analysis_template/analysis.Rmd", package = "starter"),
        filename = glue::glue("scripts/20-analysis_{folder_first_word}.Rmd"),
        copy = FALSE
      )),
      report = rlang::expr(list(
        template_filename = fs::path_package("project_templates/analysis_template/report.Rmd", package = "starter"),
        filename = glue::glue("scripts/30-report_{folder_first_word}.Rmd"),
        copy = FALSE
      )),
      doc_template = rlang::expr(list(
        template_filename = fs::path_package("project_templates/analysis_template/doc_template.docx", package = "starter"),
        filename = "scripts/templates/doc_template.docx",
        copy = TRUE
      )),
      references = rlang::expr(list(
        template_filename = fs::path_package("project_templates/analysis_template/references.bib", package = "starter"),
        filename = glue::glue("scripts/templates/references.bib"),
        copy = TRUE
      )),
      derived_vars = rlang::expr(list(
        template_filename = fs::path_package("project_templates/analysis_template/derived_variables.xlsx", package = "starter"),
        filename = glue::glue("scripts/derived_variables.xlsx"),
        copy = TRUE
      )),
      sap = rlang::expr(list(
        template_filename = fs::path_package("project_templates/analysis_template/sap.docx", package = "starter"),
        filename = glue::glue("SAP - {folder_name}.docx"),
        copy = TRUE
      ))
    )
  )
attr(analysis_project_template, "label") <- "Analysis Project Template"




# save templates ---------------------------------------------------------------
project_templates <- list()
project_templates[["default"]] <- default_project_template
project_templates[["analysis"]] <- analysis_project_template
usethis::use_data(project_templates, overwrite = TRUE, internal = FALSE)
