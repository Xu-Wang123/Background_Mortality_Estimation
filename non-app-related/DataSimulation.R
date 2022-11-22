# simulate example data, sample size 1000
# sex(binary, female 40%, male 60%), age (continous normal distribution, min 40, max 85, mean 60, sd=5), FUP (mean 15, min 3, max 25), country (4 countries: Australia 20%, Germany 40%, Belgium 30%, Canada 10%), year of treatment(integer: 1990-2020,mean 2012); mortality: Germany: 2%, Australia 2%, Belgium 1.5%, Canada 1.5%
library(truncnorm)
library(dplyr)
set.seed(2011)
age<-rtruncnorm(1000, a=40, b=85, mean=60, sd=5)
FUP<-rtruncnorm(1000, a=3, b=25, mean=12, sd=2.5)
down_age<-floor(age)
# 1 represent female, 0 male
set.seed(2012)
sex<-factor(x= rbinom(n=1000,size=1,prob=0.4),levels = 0:1, labels = c("male", "female")) %>% sample() 
# table(sex)
# 1 is Australia 20%-->200, 2 is Germany 40%-->400, 3 is Belgium 30%-->300, 4 is Canada 10%-->100)
set.seed(2013)
country<-factor(x= rep(1:4,c(200,400,300,100)) ,levels = 1:4, labels = c("Australia", "Germany","Belgium","Canada")) %>% sample() 
# table(country)
# shuffle the country
set.seed(2014)
YOP<- sample(c(1990:2020), 1000, replace = TRUE)
# assume 70 patients died
set.seed(2015)
death<-rbinom(n=1000,size=1,prob=0.15)%>%sample()

study_dat<-data.frame(country,age,down_age,sex,YOP, FUP,death)

write.csv(study_dat,"A_exampleData.csv")


