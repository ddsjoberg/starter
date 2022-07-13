analysis_project_template <-
  list(
    readme = rlang::expr(list(
      template_filename = fs::path_package("project_templates/default_readme.md", package = "starter"),
      filename = "README.md",
      copy = FALSE
    )),
    gitignore = rlang::expr(list(
      template_filename = fs::path_package("project_templates/default_gitignore.txt", package = "starter"),
      filename = ".gitignore",
      copy = TRUE
    )),
    rproj = rlang::expr(list(
      template_filename = fs::path_package("project_templates/default_rproj.Rproj", package = "starter"),
      filename = glue::glue("_rstudio_project.Rproj"),
      copy = TRUE
    )),
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
    )),
    # only add Rprofile if renv was used
    rprofile =
      rlang::expr(switch(renv,
                         list(
                           template_filename =
                             fs::path_package(package = "starter", "project_templates/default_rprofile.R"),
                           filename = glue::glue(".Rprofile"),
                           glue = TRUE
                         )
      ))
  )
