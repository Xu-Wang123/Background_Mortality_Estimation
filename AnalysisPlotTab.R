
# load Data-------------------------------------------------------------------------------------------------------------
analysis_RPlot <- reactive({
  
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
      data_list[[i+1]]$age<-data_list[[i+1]]$down_age+i
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
        data_list[[i+1]][data_list[[i+1]]$country==country_dat[k],]$age<-ifelse(data_list[[i+1]][data_list[[i+1]]$country==country_dat[k],]$age > max(back_mort[back_mort$country==country_dat[k],]$age), max(back_mort[back_mort$country==country_dat[k],]$age), data_list[[i+1]][data_list[[i+1]]$country==country_dat[k],]$age) # change age(set age limit to the LT limit of each country)
        all_mort<-left_join(data_list[[i+1]],back_mort,by = c("country" = "country", "YOP_new" = "year", "age"="age","sex"="sex")) #left_join(a, b, by=), select necessary values from b to a by matching "by"
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
  } 
})
#-------------------------------survival curve-------------------------------------------

output_Plot<-reactive({
  if(is.null(input$file))
    return("No Data available")
  else
  {
    nfiles = nrow(input$file) 
    csv = list()
    for (i in 1 : nfiles)
    {
      
      csv[[i]] = read.csv(input$file$datapath[i])
    }
    data1<-csv[[1]]
    surv_fit1<-survfit(Surv(FUP,death== 1)~1, data=data1)
    dat2<-data.frame(surv_fit1$time,surv_fit1$surv*100,surv_fit1$lower*100,surv_fit1$upper*100)
    names(dat2)[1] <-"time"
    names(dat2)[2]<- "Sur_pro"
    names(dat2)[3]="pro_lower"
    names(dat2)[4]="pro_upper"
    dat2[nrow(dat2) + 1,] = c(0,100,100,100)
    
    g<-ggplot() + geom_smooth(data=data.frame(analysis_RPlot()),aes(data.frame(analysis_RPlot())[,1], data.frame(analysis_RPlot())[,2]*100), method='loess',se = F, col ="red", xlim = c(0, max(data.frame(analysis_RPlot())[,0.5])), main = "Estimated survival probability of the matched general population", breaks = seq(0, max(data.frame(analysis_RPlot())[,1])))+
      # geom_smooth(data=dat2,mapping=aes(x=time,y=Sur_pro), method='loess',col ="blue")+ 
      geom_ribbon(data=dat2,aes(x=time,y=Sur_pro,ymin=pro_lower, ymax=pro_upper), linetype=1, alpha=0.2)+ geom_step(data=dat2,mapping=aes(x=time,y=Sur_pro), linetype=1,color='black',alpha=1,stat = "identity",position = "identity",direction = "hv") + 
      # broom::geom_stepconfint(aes(ymin = dat2$pro_lower, ymax = dat2$pro_upper), alpha = 0.1) +
      scale_y_continuous(limits = c(0, 100), breaks = seq(0, 100, by = 10))+labs(x="Follow-up time (Years)",y="Accumulative Survival Probability (%) ",caption = "Individually matched for sex, age, calendar year, country, and censoring")
    print(g)
    }
  })
output$plot3 <- renderPlot({
  output_Plot()
})

#----------------------------------------------------------------------------------------

# output_Plot2<-reactive({
#  if(is.null(input$file))
#  return("No Data available")
#  else
#   {
#  g<-ggplot(data.frame(analysis_RPlot()),aes(data.frame(analysis_RPlot())[,1], data.frame(analysis_RPlot())[,2]*100)) + geom_smooth(method='loess',se = F, col ="red", xlim = c(0, max(data.frame(analysis_RPlot())[,1])), main = "Estimated survival probability of the matched general population", breaks = seq(0, max(data.frame(analysis_RPlot())[,1])))+scale_y_continuous(limits = c(0, 100), breaks = seq(0, 100, by = 10))+labs(x="Follow-up time (Years)",y="Accumulative Survival Probability (%) ",caption = "Individually matched for sex, age, calendar year, country, and censoring")
#  print(g)
#  }
#})


#------------------------------------------------------------------------------------------      
      

# output$plot3<-renderPlot({
#  analysis_RPlot()
#  })

output$download2 <- downloadHandler(
  
  # This function returns a string which tells the client
  # browser what name to use when saving the file.
  filename = function() {
    paste("BG-", Sys.Date(),".png", sep="")
  } 
  ,
  
  # This function should write data to a file given to it by
  # the argument 'file'.
  content = function(file) {
    png(file,width = 200*8, 
        height = 200*8,
        units = "px",
        res = 40*8,
        bg = "white")
    plot(output_Plot())
    dev.off()
    contentType = 'image/png'}
  
)

  #   
# ggplot(data.frame(analysis_RPlot()),aes(data.frame(analysis_RPlot())[,1], data.frame(analysis_RPlot())[,2]*100)) + geom_smooth(method='loess',se = F, col ="red", xlim = c(0, max(data.frame(analysis_RPlot())[,1])), main = "Estimated survival probability of the matched general population", breaks = seq(0, max(data.frame(analysis_RPlot())[,1])))+scale_y_continuous(limits = c(0, 100), breaks = seq(0, 100, by = 10))+labs(x="Follow-up time (Years)",y="Accumulative Survival Probability (%) ",caption = "Individually matched for sex, age, calendar year, country, and censoring")
    # })# draw the plot
    # dev.off()  # turn the device off
    
