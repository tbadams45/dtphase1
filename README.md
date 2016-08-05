# Climate Screening Worksheet
This package implements Phase 1 of the [Decision Tree Framework]( https://openknowledge.worldbank.org/handle/10986/22544), the climate screening worksheet, as a Shiny module.

To use, install with devtools:

```r 
if(!require("devtools")) {
 install.packages("devtools")
}
devtools::install_github("tbadams45/dtphase1")
```

Then use the `phase1UI` and `phase1` functions within your ui.R and server.R functions as outlined in the introduction to [shiny modules](http://shiny.rstudio.com/articles/modules.html).

```r
library(shiny)
library(dtphase1)
ui <- fluidPage(
 phase1UI("p1")
)
server <- function(input, output, session) {
  callModule(phase1, "p1")
}

shinyApp(ui = ui, server = server)
```