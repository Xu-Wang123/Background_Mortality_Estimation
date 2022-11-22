# load packages
# need_packages <- c("dplyr", "stringr", "shiny","shinythemes","ggplot2","htmltools","shinyBS","survival")

# new_packages <- need_packages[!(need_packages %in% installed.packages()[, "Package"])]
# if (length(new.packages) > 0) install.packages(new_packages)
#p_load("dplyr", "stringr", "survival", "shiny","ggplot2","htmltools","shinyBS","shinythemes","survival")
# define ErasmusAGE colors
AGEyellow <- "#F28F00"
AGEblue <- "#004681"
AGEgreen <- "#59A83D"
AGEblack <- "black"
shinyServer(function(input, output, session){
  options(shiny.maxRequestSize = 20*1024^2)
  
  source("disclosure.R", local = T)
  source("HelpTab.R", local = T)
  source("dataTable.R", local = T)
  source("datDownload.R", local = T)
  source("AnalysisTab.R", local = T)
  source("AnalysisPlotTab.R", local = T)
})