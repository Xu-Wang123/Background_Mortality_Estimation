# Make a seperate Tab for detailed instruction
# 4 Tabs, one for instruction; one for data upload and summary, one for results in the form of table, one for results in the form of figure
output$HelpTab <- renderPrint({
  fluidRow(
    column(2),
    column(8,
           h3(HTML(paste("<span style='color:",AGEblue,"; font-weight:bold; font-size:18pt; font-family:Arial'> How this App works </span>"))),
           fluidRow(
             column(
               6,
               h4("Aim"),
               HTML("This application provides a tool to <span style='color:", AGEblue,"'> estimate background mortality appropriately </span>
              by using individual-level parameters (<span style='color:",AGEblue,"'> sex, country, exact age and calendar year of each individual, </span> and
              <span style='color:",AGEblue,"'> censoring time </span>).
              The age and calendar year will be updated annually to get the new qx().
              <br>
              This App gives the estimated cumulative survival probabilities and the corresponding plot.However, we would recommend users to download the excel file and plot in their preferred format."
               ),
               br(),br(),
               h4("Structure"),
               HTML("
              This app consists of six tabs that can be selected on top of the page:
              <ol>
              <li> The disclosure tab: Things need to disclose </li>
              <li> The introduction tab: How this App works </li>
              <li> The tab <span style='color:",AGEblue,"'> 'Upload Data '</span>,
                   which provides the interface for data upload; Users can upload the two csv. files at the same time by clicking 'Browse' button and select the two files; The overview of each uploaded database is presented on the right side of the panel. </li>
              <li> The <span style='color:",AGEblue,"'>'Example Download'</span> tab: In this App, we provided two example datasets that can be used for reference; Please make sure Your_Data have same variable names with the example dataset. Otherwise it will not work.</li>
              <li> The <span style='color:",AGEblue,"'>'BG estimates: Table'</span> tab: the estimated cumulative survival probabilities at different follow-up years are presented in the form of table: 1st column is 'follow-up time' and 2nd column is 'cumulative survival probability' </li>
              <li> The <span style='color:",AGEblue,"'>'BG estimates: Figure'</span> tab: the estimated accumulative survival probabilities during follow-up are presented in the form of figure</li>
              </ol>
              "),
               br()),
             column(6,
                    h4("Instructions"),
                    bsCollapsePanel(
                      h5("Data"),
                      HTML(
                        paste("<ul>",
                              "<li> Two datasets are required to run the App:<span style='color:",AGEblue,"'> 'Your Study population data' </span> and <span style='color:",AGEblue,"'> 'Life tables to be used' </span> obtained from WHO or HMD.
                              Only .csv file is supported.So, please make sure you convert the file into proper format. To shorten the running time, we strongly recommend including nothing irrelevant in your data. 'Your Study population data' must have study ID, country, sex, age, year of treatment/diagnosis, follow-up time and survival status; 'Life tables to be used' must have country, sex, age, calendar year and qx.<span style='color:",AGEblue,"'> 'Please ensure the country's names and sex categories(male and female) are exactly the same between study population data and life table data. Uppercase and Lowercase should be same as well'</span>. Otherwise, the App will give you errors.",
                              "<li> Before you upload your data, make sure you name your database and variables appropriately.'Your Study population data' must be named as 'A_theNameYouWant1'; 'Life tables to be used' must be named as 'B_theNameYouWant2'. You can give whatever name you like after A_ and B_.",
                              "<li> In 'Your Study population data': length of follow-up should be named 'FUP', year of operation named 'YOP', age should be down rounded(e.g.,37.6 is 37 down-roundly) and named 'down_age'; the country where each participant comes should be named 'country' ; sex is named 'sex'. Each patient should be given a study-ID, which should be named 'ID'.",
                              "<li> In 'Life tables to be used':'country','age','year','sex','qx'. Year here is the calendar year. Please make sure all variables in 'Life tables to be used' have exactly same names with the corresponding variables in 'Your Study population data'. Otherwise, the App cannot work well. Please also make sure sex has been categorized into male and female in both databases.'Lowercase' or 'Uppercase' doesn't matter, but they have to be consistent in the two databases",
                              "</ul>")
                      )
                    ),
                    bsCollapsePanel(
                      h5("Methodology"),
                      HTML(
                        paste("<ul>",
                        "<li> In this App, all participants from study population will be individually matched with the general population based on sex, country, year of treatement/diagnosis, and age. Besides, censoring time for each participant will be used for calibrating background mortality, which means the qx after the censoring time will be excluded for estimation.",
                        "<li> Only sex, age, country, year and censoring time are considered because this information is widely accessible. We have to admit other factors, like race, socioeconomic status, etc, are also important for background mortality estimation. We have not included these factors here because of non-generalizability. We should account for factors as many as possible as long as they are avaliable for research.This App might need update in the future if more information is avaliable",
                        "</ul>" ))),
                    bsCollapsePanel(
                      h5("Results"),
                      HTML(
                        paste(
                          "<ul>",
                          "<li> One table and one figure will be computed after you upload your datasets: <span style='color:",AGEblue,"'> 'Your Study population data' </span> and <span style='color:",AGEblue,"'> 'Life tables to be used' </span>. They will appear automatically after you finish uploading. The table will be presented in 'Estimated Results' tab. The figure will be presented in 'Estimated Plots' tab.",
                          "<li> Users can download the 'tabl' from 'Estimated Results' tab and re-plot the figure on any other applicable software.",
                          "</ul>")
                      )
                    ),
                    bsCollapsePanel(
                      h5("Interpretation"),
                      HTML(
                        paste(
                          "<ul>",
                          "<li> We need the observed survival probability and the matched general population survival probability to interpret the comparability between study population and the matched general population. 95% confidence interval(95% CI) should be provided for observed survival probability.",
                          "<li> Usually, the matched general population survival probability should fall within or above the 95% CI of observed survival probability. ",
                          "<li> If it <span style='color:",AGEblue,"'> falls in the 95% CI</span>, it indicates the study population has<span style='color:",AGEblue,"'> comparable survival probability</span> with the general population.",
                          "<li> If it <span style='color:",AGEblue,"'> falls above the 95% CI</span>, it indicates the study population has<span style='color:",AGEblue,"'> lower survival probability</span> than the general population.",
                          "<li> In some special situations, the matched general population survival could be worse than the 'study population', which is implausible. It doesn't mean 'being sick' is a protective factor for survival, but indicate uncontrolled/matched underlying factors have caused selection bias. Careful evaluations should be given to study population regarding the source of bias.",
                          "</ul>"))),
#####################______________---------------_____________----------------____________--------
                    
                    
             ))
    ),
    column(2)
  )
})