#' Create the UI for Phase 1.
#'
#' This creates all of the UI for our Phase 1 climate screening worksheet. You
#' should call it in the ui function of your shiny app.
#'
#' @param id the ID that will be used to uniquely identify all of the ui
#'   components in the shiny module. Must be the same as the id used in \code{callModule}.
#'
#' @return UI components that collectively represent the climate screening worksheet of Phase 1.
#'
#' @examples
#' \dontrun{
#' # minimal example
#' ui <- fluidPage(
#'   phase1UI("p1")
#' )
#' server <- function(input, output, session) {
#'  callModule(phase1, "p1")
#' }
#' }
#' @importFrom magrittr "%>%"
#' @export
phase1UI <- function(id){
  ns <- shiny::NS(id)

  shiny::fluidPage(
    shiny::titlePanel("Phase 1 - Climate Response Worksheet: Quantifying Climate Uncertainty"),

    shiny::h2("Project Title:"),
    shiny::textInput(ns("title"), label = NULL),

    shiny::includeMarkdown(system.file("text/intro.md", package="dtphase1")),

    shiny::includeMarkdown(system.file("text/fourc_choices.md", package="dtphase1")),
    shiny::tags$textarea(id = ns("text_choices"), rows=3, cols=80, ""),
    shiny::includeMarkdown(system.file("text/fourc_consequences.md", package="dtphase1")),
    shiny::tags$textarea(id = ns("text_consequences"), rows=3, cols=80, ""),
    shiny::includeMarkdown(system.file("text/fourc_connections.md", package="dtphase1")),
    shiny::tags$textarea(id = ns("text_connections"), rows=3, cols=80, ""),
    shiny::includeMarkdown(system.file("text/fourc_uncertainties.md", package="dtphase1")),
    shiny::tags$textarea(id = ns("text_uncertainties"), rows=3, cols=80, ""),

    shiny::includeMarkdown(system.file("text/phase2-necessary.md", package="dtphase1")),

    shiny::radioButtons(ns("lifetime"),
      "Is this project long lived (i.e. lifetime greater than 20 years)?",
      c("None selected" = "N/A", "Yes" = "Yes", "No" = "No"),
      inline = TRUE),

    cp(condition = sprintf("input['%s'] == 'Yes'", ns("lifetime")),
      shiny::radioButtons(ns("project_type"), "What kind of project is it?",
        c("None selected" = "N/A",
          "Water Infrastructure" = "Infrastructure",
          "Water Policy" = "Policy",
          "Education/Training" = "Other"),
        inline = TRUE)
    ),

    cp(condition = sprintf("input['%s'] == 'Yes' && input['%s'] == 'Policy'", ns("lifetime"), ns("project_type")),
      shiny::radioButtons(ns("water_alloc"), "Does the policy involve water price changes, or allocation to irrigation or domestic demands?",
        c("None selected" = "N/A",
          "Yes" = "Yes",
          "No" = "No"),
        inline = TRUE)
    ),

    cp(condition = sprintf("input['%s'] == 'Yes' && input['%s'] == 'Policy' && input['%s'] == 'Yes'",
      ns("lifetime"), ns("project_type"), ns("water_alloc")),
      shiny::radioButtons(ns("reversible"),
        "Is the policy easily easily reversible should it prove unfavorable?",
        c("None selected" = "N/A",
          "Yes" = "Yes",
          "No"  = "No"),
        inline = TRUE)
    ),

    # No need
    cp(condition = sprintf("(input['%s'] == 'No') || (input['%s'] == 'Yes' && input['%s'] == 'Other') || (input['%s'] == 'Yes' && input['%s'] == 'Policy' && input['%s'] == 'No') || (input['%s'] == 'Yes' && input['%s'] == 'Policy' && input['%s'] == 'Yes' && input['%s'] == 'Yes')",
      ns("lifetime"),
      ns('lifetime'), ns('project_type'),
      ns('lifetime'), ns('project_type'), ns('water_alloc'),
      ns('lifetime'), ns('project_type'), ns('water_alloc'), ns('reversible')), #close sprintf
      shiny::p("Based on your evaluation,", shiny::tags$strong("there is no need to proceed to Phase 2 for this project."))
    ),

    # proceed
    cp(condition = sprintf("(input['%s'] == 'Infrastructure' && input['%s'] == 'Yes') || (input['%s'] == 'No' && input['%s'] == 'Yes' && input['%s'] == 'Policy' && input['%s'] == 'Yes')",
      ns("project_type"), ns("lifetime"),
      ns("reversible"), ns("water_alloc"), ns("project_type"), ns("lifetime")), #close sprintf
      shiny::p("Based on your evaluation,", shiny::tags$strong("this project requires a Phase 2 sensitivity analysis."))
    ),

    shiny::downloadButton(
      outputId = ns("downloader"),
      label = "Download PDF"
    ),

    get_flowchart()
    # neither of these seem to work as intended.
    # shiny::fluidRow(shiny::img(src = system.file("flowchart.png", package="dtphase1")))
    # shiny::fluidRow(shiny::img(src = "www/flowchart.png"))

  ) #close fluidPage
}

#' The server component of our phase 1 Shiny module.
#'
#' This function should be called using \code{callModule} in the server function
#' of your shiny app. It handles the downloading of the report.
#'
#' In callModule, use the template \code{callModule(phase1, id)}, where id is
#' the same string that you use in phase1UI.
#'
#' @param input mandatory param by Shiny
#' @param output mandatory param by Shiny
#' @param session mandatory param by Shiny
#'
#' @examples
#' \dontrun{
#' # minimal example
#' ui <- fluidPage(
#'   phase1UI("p1")
#' )
#' server <- function(input, output, session) {
#'  callModule(phase1, "p1")
#' }
#' }
#'
#' @export
phase1 <- function(input, output, session) {
  output$downloader <- shiny::downloadHandler(
    "climate-response-worksheet.pdf",
    content =
      function(file)
      {
        rmarkdown::render(
          input = system.file("report_file.Rmd", package = "dtphase1"),
          output_file = system.file("built_report.pdf", package = "dtphase1")
        )
        readBin(con = system.file("built_report.pdf", package = "dtphase1"),
          what = "raw",
          n = file.info(system.file("built_report.pdf", package = "dtphase1"))[, "size"]) %>%
          writeBin(con = file)
      }
  )
}