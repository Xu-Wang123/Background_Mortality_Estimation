
# load Data-------------------------------------------------------------------------------------------------------------
analysis_R <- reactive({
  
  if(is.null(input$file))
    return()
  else 
  {
    nfiles = nrow(input$file) 
    csv = list()
    for (i in 1 : nfiles)
    {
      
      csv[[i]] = read.csv(input$file$datapath[i])
    }
    data1<-csv[[1]] 
    fup_time<-seq(0,floor(max(data1$FUP)),by=1) # set the fup time the biggest integer in the length of FUP; Here, users should change "ross_dat2$TimeLastFupDate"in the form of "data$FUP_var"according to their own data
    data_list<-vector(mode = "list", length = length(fup_time))
    data_list
    class(data_list)
    data1$YOP<-as.numeric(data1$YOP)
    for (i in 0:floor(max(data1$FUP))){
      data_list[[i+1]]<-data1
      data_list[[i+1]]$age2<-data_list[[i+1]]$down_age+i
      data_list[[i+1]]$YOP_new<-data_list[[i+1]]$YOP+i
      data_list
    }
    ####################################### life table usage
    back_mort<-csv[[2]] 
    country_dat<-unique(data1$country) 
    match_mor <- vector(mode = "list", length = length(fup_time))
    match_mor
    class(match_mor)
    ################################################## individual match(update age and update calendar Y)
    for (k in 1:length(country_dat)){
      for (i in 0:floor(max(data1$FUP))){
        data_list[[i+1]][data_list[[i+1]]$country==country_dat[k],]$YOP_new<-ifelse(data_list[[i+1]][data_list[[i+1]]$country==country_dat[k],]$YOP_new > max(back_mort[back_mort$country==country_dat[k],]$year), max(back_mort[back_mort$country==country_dat[k],]$year), data_list[[i+1]][data_list[[i+1]]$country==country_dat[k],]$YOP_new) #this part change the year in each country's 18 fup dataframes(if the Ydoop_new > the newest LT table avaliable year--> change it to the newest LT year)
        data_list[[i+1]][data_list[[i+1]]$country==country_dat[k],]$age2<-ifelse(data_list[[i+1]][data_list[[i+1]]$country==country_dat[k],]$age2 > max(back_mort[back_mort$country==country_dat[k],]$age), max(back_mort[back_mort$country==country_dat[k],]$age), data_list[[i+1]][data_list[[i+1]]$country==country_dat[k],]$age2) # change age(set age limit to the LT limit of each country)
        all_mort<-left_join(data_list[[i+1]],back_mort,by = c("country" = "country", "YOP_new" = "year", "age2"="age","sex"="sex")) #left_join(a, b, by=), select necessary values from b to a by matching "by"
        match_mor[[i+1]]<-all_mort
        match_mor
      }
    } 
    
    ################################################ extract qx
    qx_fup1<- data.frame(matrix(ncol =length(fup_time), nrow = length(match_mor[[1]]$ID)))# how many patients/rows in your data
    for (i in 0:floor(max(match_mor[[1]]$FUP))){
      new_qx<-assign(paste0("qx_", i), match_mor[[i+1]]$qx) 
      qx_fup1[,i+1]<-new_qx
      qx_fup1
    }
    # qx_fup1 contains matched dynamic individual-level+ lost fup consideration mortaility for all patients in Ross data(from 0 to max (follow-up) integer)
    
    b<-cbind(col_FUP=floor(match_mor[[1]]$FUP), cbind(X0 = 0, qx_fup1))
    lost_fup<- data.frame(matrix(ncol =length(fup_time), nrow = nrow(match_mor[[1]])))
    for (i in 1:nrow(b)){
      e<-b[i,1]+2
      f=e-1
      lost_fup[i,1:f]<-b[i,2:e]
    }
    # by running above functions, we re-pick up qx based on length of FUP in each observed patient
    colname<-vector(mode = "character", length = length(fup_time))
    for (i in 0:floor(max(data1$FUP))){
      colname[i+1]<-paste("q",i,sep = "_")
      colname
    }
    
    colnames(lost_fup)<-colname
    # calculate cumulative survival probablity
    vect1<-vector(mode = "numeric", length = ncol(lost_fup))
    accu_surv1<-vector(mode = "numeric", length = ncol(lost_fup))
    for (i in 1:ncol(lost_fup)){ 
      vect1[i]<-1-mean(lost_fup[,i],na.rm = TRUE) # 1- mean mqx= mean surv pro
      vect1
    } # qx for each follow-up interval
    
    
    for (i in 1:ncol(lost_fup)){ 
      accu_surv1[i]<-prod(vect1[1:i]) # surv pro_k*surv pro_k+1 == accumulative surv pro_k+1
      accu_surv1
    }
    
    (final_back_sur1<-data.frame(fup_time,accu_surv1))
    # write_xlsx(final_back_sur1,"individual_dynamic_D.xlsx")
    
    # do.call(rbind, csv) # rbind the datasets
    
  }
})
## Display the analyzed Results
output$newdata <- renderTable({
  analysis_R()
})

## DownloadHandler to download the merged dataset to local system
output$download <- downloadHandler(
  
  # This function returns a string which tells the client
  # browser what name to use when saving the file.
  filename = function() {
    fileext = switch(input$sep,
                     "," = "csv",
                     ";" = "csv",
                     "\t" = "txt",
                     " " = "doc")
    paste("BG_mortality", fileext, sep = ".") # example : iris.csv, iris.doc, iris.txt
    
  },
  
  # This function should write data to a file given to it by
  # the argument 'file'.
  content = function(file) {
    
    # Write to a file specified by the 'file' argument
    write.table(analysis_R(), file, sep = input$sep,
                row.names = FALSE)
  }
)


