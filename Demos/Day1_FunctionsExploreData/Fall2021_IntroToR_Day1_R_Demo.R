##############################################################################
### Title: Intro to R - Day 1 Demo: Useful functions to get folks started
### Purpose: To walk through some useful functions with learners
### Author: J. Stares
### Last Updated: 2021-11-01
##############################################################################

#Source: 
#       https://bookdown.org/ndphillips/YaRrr/
#       https://dplyr.tidyverse.org/reference/case_when.html
#Includes:
# accessing help documentation
# setting yourself up
# saving data as csv
# useful functions for understanding your data once they are loaded

##############################################################################

#help documentation
library(help="base")
?install.packages
??yarrr
??pirates
??yarrr.guide


#install and load packages 
#install.packages("tidyverse")
library(tidyverse)
?tidyverse

library(yarrr)
??yarrr
yarrr.guide()
?pirates


##############################################################################
#working directory
getwd()
setwd("C:/IntroToR/Demo")
getwd()

#load, save, write data
tira <- read_csv("Fall2020_IntroToR_tira.csv")
save(tira, file="C:/IntroToR/Demo/tira.Rdata")
write_csv(tira, "C:/IntroToR/Demo/tira_copy.csv")

#name objects in work environment
ls()

#remove object from environment
rm(tira)

#view data; note built in data set in the yarrr package; also click on tira data set in workspace
names(pirates)
str(pirates)
glimpse(pirates)

View(pirates)
fix(pirates)

length(pirates)

class(pirates)

#print information about and portions of data
head(pirates)
tail(pirates)
pirates[25:35,]


length(pirates$grogg)

class(pirates$grogg)
mode(pirates$grogg)

class(pirates$favorite.pirate)
mode(pirates$favorite.pirate)

##############################################################################
#basic summarisation
summary(pirates)

pirates %>% 
  count(sword.type)

pirates %>%
  min(tchests)

mean(pirates$tchests)
min(pirates$tchests)
max(pirates$tchests)
median(pirates$tchests)
sum(pirates$tchests)

pirates %>% 
  summarise(avg.tchests = mean(tchests))

pirates %>% 
  summarise(avg.tchests = mean(tchests), min.tchests = min(tchests), 
            max.tchests = max(tchests), median.tchests = median(tchests),
            sum.tchests = sum(tchests)) 

pirates %>% 
  group_by(sword.type) %>% 
  summarise(avg.tchests = mean(tchests)) 

unique(pirates$sex)

table(pirates$headband,pirates$sex)

table(pirates$headband,pirates$sex) / sum(table(pirates$headband,pirates$sex))



##############################################################################
#manipulate data
library(dplyr)
pirates %>%
  rename(fav.pirate=favorite.pirate)
names(pirates)

pirates.data <- pirates %>%
  rename(fav.pirate=favorite.pirate)
names(pirates.data)

filter(pirates,fav.pixar=="Finding Nemo")

select(pirates, id, age, height, weight)

mutate(pirates, bmi = weight/(height/100)^2)

x <- 1:50
print(x)
case_when(
  x %% 35 == 0 ~ "fizz buzz",
  x %% 5 == 0 ~ "fizz",
  x %% 7 == 0 ~ "buzz",
  TRUE ~ as.character(x)
)

mutate(pirates, bmi = weight/(height/100)^2)

mutate(pirates, bmi.class = case_when(
  weight/(height/100)^2 < 18.5 ~ "underweight",
  weight/(height/100)^2 >=18.5 &  weight/(height/100)^2 < 25 ~ "healthy weight",
  weight/(height/100)^2 >=25 &  weight/(height/100)^2 < 30 ~ "overweight",
  weight/(height/100)^2 >=30 ~ "obese",
  TRUE ~ "unknown"))

pirates %>%
  filter(fav.pixar=="Finding Nemo") %>%
  select(id, age, height, weight) %>%
  mutate(bmi.class = case_when(
    weight/(height/100)^2 < 18.5 ~ "underweight",
    weight/(height/100)^2 >=18.5 &  weight/(height/100)^2 < 25 ~ "healthy weight",
    weight/(height/100)^2 >=25 &  weight/(height/100)^2 < 30 ~ "overweight",
    weight/(height/100)^2 >=30 ~ "obese",
    TRUE ~ "unknown"))


course.name<- "Introduction to R for Public Health Investigations"
str_sub(course.name, 23, 35)
str_sub(course.name, -14, -1)

class(pirates.data$tattoos)
pirates.data$tattoos <- as.character(pirates$tattoos)
pirates.data$tattoos <- as.numeric(pirates$tattoos)

#dates
x <- c("1jan1960", "2jan1960", "31mar1960", "30jul1960")
z <- as.Date(x, "%d%b%Y")
z[4]
mode(z)

##############################################################################
#Other useful functions

#na's
a <- c(1, 5, NA, 2, 10)
mean(a)
is.na(a)
mean(a)
mean(a, na.rm = TRUE)


#finally
print(pirates[50:75,])
history()



