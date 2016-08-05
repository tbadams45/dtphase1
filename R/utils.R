# makes our life easier below since we make so many of these...
cp <- function(condition, ...){
  shiny::conditionalPanel(condition, list(...))
}