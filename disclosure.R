# disclosure

output$disclosure <- renderPrint({
  fluidRow(
    column(4, img(src = "heart_surgery_Wallpaper.png", height = 400, width = 300,align = "left")),
    column(8,
           h3(HTML(paste("<span style='color:",AGEblue,"; font-weight:bold; font-size:24pt'> From Erasmus MC, Rotterdam, the Netherlands </span>"))),
           fluidRow(
             column(
               4,
               HTML(
                 paste("<ul>",
                       br(),
                       "<li> This application was developed by </span> <span style='color:", AGEblue,"; font-weight:bold'> Dept. of Cardiothoracic Surgery </span> and </span> <span style='color:", AGEblue,"; font-weight:bold'> Dept. of Biostatistics </span> in Erasmus Medical Center, Rotterdam, The Netherlands.",
                       "<li> Developed by: 
                       <span style='color:", AGEblue,"; font-weight:bold'>Xu Wang </span> 
                       ,
                       <span style='color:", AGEblue,"; font-weight:bold'>Maximiliaan L. Notenboom</span>
                       ,
                       <span style='color:", AGEblue,"; font-weight:bold'>Kevin M. Veen</span> 
                       ,
                       <span style='color:", AGEblue,"; font-weight:bold'>Eleni-Rosalina Andrinopoulou</span> 
                       ,
                       <span style='color:", AGEblue,"; font-weight:bold'>Pepijn Grashuis</span>
                       ,
                       <span style='color:", AGEblue,"; font-weight:bold'>Jonathan R.G. Etnel</span>
                       ,
                       <span style='color:", AGEblue,"; font-weight:bold'>Ad J. J. C. Bogers</span>
                       ,
                       <span style='color:", AGEblue,"; font-weight:bold'>Johanna J.M. Takkenberg</span>",
                       "</ul>")
               )),
                    column(4,
                           h3(HTML(paste("<span style='color:",AGEblue,"; font-weight:bold; font-size:20pt'> Conflicts of Interest </span>"))),
                           HTML(
                        paste(
                          "<ul>",
                              "<li> <span style='color:",AGEblack,"; font-weight:bold'> Nothing to declare </span> ",
                              "<li> Only general characteristics have been considered (not all) in this App; Users should interpret their results based on their study population; Consulting statisticians is always recommended if any important inplausible estimations occur",
                              # "<li> Questions regarding the methodology or the use of the Shiny App can be addressed to <span style='color:",AGEblack,"; font-weight:bold; font-family:Arial'> Xu Wang</span> <span style='color:",AGEblue,"'> x.wang.1@erasmusmc.nl </span> and <span style='color:",AGEblack,"; font-weight:bold; font-family:Arial'> Eleni-Rosalina Andrinopoulou </span> <span style='color:",AGEblue,"'> e.andrinopoulou@erasmusmc.nl </span>", 
                          "</ul>")
                      )
                    ),
             )))
})