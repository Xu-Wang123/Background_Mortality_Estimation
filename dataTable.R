
output$filedf <- renderTable({
  if(is.null(input$file)){return ()}
  input$file # the file input data frame object that contains the file attributes
  
})

output$selectfile <- renderUI({
  if(is.null(input$file)) {return()}
  list(hr(), 
       helpText("Select the files for which you need to see data and summary stats"),
       selectInput("Select", "Select", choices=input$file$name)
  )
})

output$table <- renderTable({ 
  if(is.null(input$file)){return()}
  read.table(file=input$file$datapath[input$file$name==input$Select], sep=input$sep, header = input$header, stringsAsFactors = input$stringAsFactors)
  
})