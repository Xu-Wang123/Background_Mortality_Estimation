need_packages <- c("dplyr", "pacman","stringr", "shiny","shinythemes","ggplot2","htmltools","shinyBS","survival","broom")

new_packages <- need_packages[!(need_packages %in% installed.packages()[, "Package"])]
if (length(new.packages) > 0) install.packages(new_packages)
library(pacman)
p_load("dplyr", "stringr", "survival", "shiny","ggplot2","htmltools","shinyBS","shinythemes","survival","broom")
#library(shiny)
#library(stringr)
#library(dplyr)
#library(shinyBS)
#library(ggplot2)
#library(shinythemes)
#library(survival)
#library(htmltools)

AGEyellow <- "#F28F00"
AGEblue <- "#004681"
AGEgreen <- "#59A83D"
AGEblack <- "black"
blue2<-"deepskyblue2"

shinyUI(fluidPage(
  theme = shinytheme("spacelab"),
  # tags$head(tags$link(rel = "stylesheet", type = "text/css", href = "mycss.css")),
  titlePanel(HTML(paste("<span style='color:",AGEblue,"; font-weight:bold'> Background Mortality Estimation<span>"))),
  img(src = "EMC_logo.png", height = 100, width = 180,align = "right"),
  tabsetPanel(
    tabPanel(HTML(paste("<span style='color:",blue2,"; font-weight:bold'> Disclosure <span>")),
             uiOutput("disclosure")
    ),
    # Tab: How this works...--------------------------------------------------------------------------------------------
    tabPanel(HTML(paste("<span style='color:",blue2,"; font-weight:bold'> How this App works <span>")), uiOutput("HelpTab")
    ),
    
    # Tab: Data Upload panel(sidebar) ---------------------------------------------------------------------------------
    tabPanel(HTML(paste("<span style='color:",blue2,"; font-weight:bold'> Upload Data <span>")),
             fluidRow(
               column(4, # left column +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                      wellPanel(
                        fileInput("file","Upload the file", multiple = T), # fileinput() function is used to get the file upload contorl option
                        helpText("Default max. file size is 20 MB"),
                        helpText("Select the read.table parameters below"),
                        checkboxInput(inputId = 'header', label = 'Header', value = TRUE),
                        checkboxInput(inputId = "stringAsFactors", "stringAsFactors", FALSE),
                        radioButtons(inputId = 'sep', label = 'Separator', choices = c("Comma" = "," , "Semicolon" = ";", "Tab"= "\t", "Space"= " "), selected = ','),
                        uiOutput("selectfile")
             )),
               column(8,
                      wellPanel(h4("Check out your uploaded datasets"),
                        uiOutput("table")) # end of overall fluid row
    ))), # end of tabPanel 'Upload Data and Summary'
    
    # Tab: Data Summary-------------------------------------------------------------------------------------------------------
   #--------------------------------- Tab of example data downlood, still struggling its solution, need to look at it 
    tabPanel(HTML(paste("<span style='color:",blue2,"; font-weight:bold'> Example Download <span>")), 
             br(),
             br(),
             downloadLink('downloadData1', HTML(paste("<span style='color:",AGEblue,";font-size:12pt; font-weight:bold'>Download patients data example<span>"))),
             br(),
             br(),
             br(),
             downloadLink('downloadData2', HTML(paste("<span style='color:",AGEblue,"; font-size:12pt;font-weight:bold'>Download life table<span>"))),
             uiOutput("example") # in the ui.R
    ),
   #---------------------------------
    tabPanel(HTML(paste("<span style='color:",blue2,"; font-weight:bold'> BG estimates:Table <span>")), downloadButton('download', 'Download the Table'),
             uiOutput("newdata") # in the ui.R
    ),
    tabPanel(HTML(paste("<span style='color:",blue2,"; font-weight:bold'> BG estimates:Figure <span>")), downloadButton('download2', 'Download the Figure'),
             plotOutput("plot3") # in the ui.R
    ))
  ) ) # end of tabsetPanel # end of shinyUI(fluidPage(

