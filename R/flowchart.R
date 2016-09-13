#' Generate the phase 1 flowchart for the shiny app.
#'
#' Make sure you update the flowchart.png that's used in the report as well...
get_flowchart <- function(){
  DiagrammeR::grViz("
    digraph flowchart {

      # a graph statement
      graph [overlap = true, fontsize = 10]

      # node statements
      node [shape = box, fontname = Helvetica]

      subgraph row1 {
      rank = 'same'
      lifetime [label = 'Is this project long lived\n(i.e. lifetime greater than 20 years)?'];
      no_need1 [id = 'no_need1' label = 'No need to proceed to phase 2' style = 'filled' fillcolor = 'LightPink'];
      }

      subgraph row2 {
      rank = 'same'
      project_type [label = 'What kind of project is it?'];
      proceed2 [id = 'proceed2' label = 'Proceed to Phase 2' style = 'filled' fillcolor = 'LightGreen'];
      }

      subgraph row3 {
      rank = 'same'
      water_alloc [label = 'Does the policy have water allocation effects \n (e.g. via price changes or laws)?'];
      no_need2 [id = 'no_need2' label = 'No need to proceed to phase 2' style = 'filled' fillcolor = 'LightPink'];
      }

      subgraph row4 {
      rank = 'same'
      reversible [label = 'Is the policy easily reversible\n upon further information?'];
      no_need3 [id = 'no_need3' label = 'No need to proceed to phase 2' style = 'filled' fillcolor = 'LightPink'];
      }

      proceed [label = 'Proceed to Phase 2' style = 'filled' fillcolor = 'LightGreen'];

      # edge statements
      lifetime     -> no_need1 [label = ' No']
      lifetime     -> project_type [label = ' Yes']
      project_type -> no_need2 [label = ' Education/Training']
      project_type -> proceed2 [label = ' Infrastructure']
      project_type -> water_alloc [label = ' Policy']
      water_alloc  -> no_need2 [label = ' No']
      water_alloc  -> reversible [label = ' Yes']
      reversible   -> no_need3 [label = ' Yes']
      reversible   -> proceed [label = ' No']
    }
  ")
}