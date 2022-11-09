# load packages
need_packages <- c("pacman","dplyr", "stringr", "shiny","ggplot2","htmltools","shinyBS","webshot","plotly","survival")


new_packages <- need_packages[!(need_packages %in% installed.packages()[, "Package"])]
if (length(new.packages) > 0) install.packages(new_packages)
library(pacman)
p_load("dplyr", "stringr", "survival", "shiny","ggplot2","htmltools","shinyBS","webshot","plotly")

# define ErasmusAGE colors
AGEyellow <- "#F28F00"
AGEblue <- "#004681"
AGEgreen <- "#59A83D"



shinyServer(function(input, output, session){
  
  options(shiny.maxRequestSize = 20*1024^2)
  
  source("HelpTab.R", local = T)
  source("dataTable.R", local = T)
  source("AnalysisTab.R", local = T)
  source("AnalysisPlotTab.R", local = T)
})