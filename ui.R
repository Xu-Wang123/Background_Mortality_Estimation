if (!"shinyBS" %in% installed.packages()[, "Package"]) {
install.packages("shinyBS")
}
library(shiny)
library(shinyBS) # this has to be here, doesn't work if loaded from server.R

AGEblue <- "#004681"

shinyUI(fluidPage(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "mycss.css")
  ),
  titlePanel(HTML(paste("<span style='color:",AGEblue,"; font-weight:bold'> Background Mortality Estimation<span>"))),
  tabsetPanel(
    
    # Tab: How this works...--------------------------------------------------------------------------------------------
    tabPanel("How this App works...",
             uiOutput("HelpTab")
    ),
    
    # Tab: Data Upload panel(sidebar) ---------------------------------------------------------------------------------
    tabPanel("Upload Data",
             fluidRow(
               column(8, # left column +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                      wellPanel(
                        fileInput("file","Upload the file", multiple = T), # fileinput() function is used to get the file upload contorl option
                        helpText("Default max. file size is 20 MB"),
                        helpText("Select the read.table parameters below"),
                        checkboxInput(inputId = 'header', label = 'Header', value = TRUE),
                        checkboxInput(inputId = "stringAsFactors", "stringAsFactors", FALSE),
                        radioButtons(inputId = 'sep', label = 'Separator', choices = c("Comma" = "," , "Semicolon" = ";", "Tab"= "\t", "Space"= " "), selected = ','),
                        uiOutput("selectfile")
             ) # end of overall fluid row
    ))), # end of tabPanel 'Upload Data and Summary'
    
    # Tab: Data Summary-------------------------------------------------------------------------------------------------------
    
    tabPanel("Data Table", 
             uiOutput("table") # in the ui.R
    ),
    tabPanel("Data Analysis (Table)", downloadButton('download', 'Download the Table'),
             uiOutput("newdata") # in the ui.R
    ),
    tabPanel("Data Analysis (Figure)", downloadButton('download2', 'Download the Figure'),
             plotOutput("plot3") # in the ui.R
    ))
  )) # end of tabsetPanel # end of shinyUI(fluidPage(

