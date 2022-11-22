
# sidebarLayout(
#  sidebarPanel(
#   selectInput("select1", "Select the dataset", choices = c("A_studyData", "B_lifeTable")),
#   br(),
#    helpText("Only CSV files are provided"),
#    br(),
#    # helpText("No real data in example study dataset(Simulated)"),
#    # br(),
#    helpText(" Click the download button to download example databases"),
#    downloadButton('downloadData', 'Download')),
#    wellPanel(
#   uiOutput("select1") 
#   ))
  
output$downloadData1 <- downloadHandler(
    filename <- function() {
      paste("A_exampleData", "csv", sep=".")
    },
    
    content <- function(file) {
      file.copy("A_exampleData.csv", file)
    },
    contentType = "csv"
  )
  
output$downloadData2 <- downloadHandler(
  filename <- function() {
    paste("B_LifeTable_example", "csv", sep=".")
  },
  
  content <- function(file) {
    file.copy("B_LifeTable_example.csv", file)
  },
  contentType = "csv"
)
    #filename <- function() {
     # switch(input$select1,
      #       "A_studyData" = paste("A_studyData", "csv", sep="."),
       #      "B_lifeTable"= paste("B_lifeTable", "csv", sep="."))
      
    #},
    
    #content <- function(file) {
     # switch(input$select1,
      #       "A_studyData" = file.copy("A_studyData.csv", file),
       #      "B_lifeTable"= file.copy("B_lifeTable.csv", file))
      
 
    



