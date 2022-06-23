##############################################################################
### Title: R code Snippits for Code Mechanics at Intro to R
### Purpose: This is code used in the Code Mechanics activity on day 1 of 
### Introduction to R for Public Health Investigations
### Author: J. Stares
### Last Updated: 2021-10-29
##############################################################################

#Source: https://bookdown.org/ndphillips/YaRrr/

##############################################################################
#thoughts - flip demo and activity in order.... have learners practice functions 
# used to explore data on the pirates data set. Give each group a set of functions

##############################################################################
#plot data

library(yarrr)
library(ggplot2)
g <- ggplot(pirates, aes(sword.type))+
  geom_bar()
g

g <- ggplot(pirates, aes(fav.pixar))+
  geom_bar()
g

##############################################################################
#summarize data

library(yarrr)
library(dplyr)
pirates %>% 
  group_by(eyepatch) %>%
  summarise(avg = mean(tattoos))

pirates %>% 
  group_by(eyepatch) %>%
  summarise(avg = mean(tattoos), 
            median = median(tattoos))

##############################################################################
#rename variable

library(yarrr)
library(dplyr)

pirates %>%
  rename(fav.pirate=favorite.pirate)

pirates %>%
  rename(fav.pirate=favorite.pirate, treasure.chests=tchests)

##############################################################################
#Write data

library(yarrr)
write.csv(pirates, "C:/IntroToR/pirates.csv")

library(writexl)
write_xlsx(pirates, "C:/IntroToR/pirates.xlsx")


