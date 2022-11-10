##############################################################################
### Title: Intro to R - Day 1 Demo: Useful functions to get folks started
### Purpose: To walk through some useful functions with learners
### Author: J. Stares
### Last Updated: 2022-11-10
##############################################################################

#Source: 
#       https://bookdown.org/ndphillips/YaRrr/
#       
#Includes:
# accessing help documentation
# exploring your data
# getting started with data processing
# Extras (other helpful things)

#Instructions for demo - go as far as possible in 15 mins
#This script is made available to course participants for further reference
##############################################################################

#access help documentation using the library function (or the help tab in the lower right)
library(help="base")

#can also use ? to access help information for both packages and specific functions
?base
?table #Cross Tabulation and Table Creation


#help regarding a package (or a function in a package) you have not installed and loaded, use two question marks
??yarrr #yarr package

#Again, if you've never installed a particular package, you will need to install 
#before you access it. You only need to install it once, after that you can 
#access it with the library statement 

#install.packages("yarrr")
#we will use the pirates dataframe from this package
library(yarrr)

#we will need the dplyr (a tidyverse core) package for many of the examples below
library(dplyr)

##############################################################################
#Explore your data

#for illustrative purposes we will create a new object - a dataframe called 'pirate.data'
#from the built in dataframe 'pirates' from the yarrr package

pirate.data <- pirates

#note that we can see it in the environment

#we can access names of each of the columns in data with the names function
names(pirate.data)

#we can view other details about this dataframe and its content using the 
#structure function 
str(pirate.data)

#and glimpse function
glimpse(pirate.data)

#we can open the dataframe to view it by double clicking on it in the environment
#or with the view function
View(pirate.data)

#with the fix function we can open the dataframe, and edit it
fix(pirate.data)

#return the number of variables in the dataframe with the length function
length(pirate.data)

#return the object type with the class function
class(pirate.data)

#print information about and portions of the data
#print the first 6 rows of data in the console with the head function
head(pirate.data)

#print the last 6 rows of data in the console with the tail function
tail(pirate.data)

#print specific rows of data in the console using indexing (location)
#in this case rows 25 to 35
pirate.data[25:35,]

#return the number of values in a variable with the length function
#note that this does count NAs - for details on how to count NAs and vice versa
#see "extras" at the end of this script

length(pirate.data$grogg)

#to see the class of the variables itself use the class function
class(pirate.data$grogg)

#to see the storage type of the variable use the mode function
mode(pirate.data$grogg)

#mode and class will typically agree with each other except in special cases, such as dates for example
#add a new 'date' variable to the dataframe which consists of a date value representing today's date
pirate.data$date <- Sys.Date()
head(pirate.data$date)

#date is a date variable
class(pirate.data$date)

#the values stored in the date variable are numeric
mode(pirate.data$date)


##############################################################################
#getting started with basic descriptions

#to get the frequency of values in a character variable we can use the count function 
pirate.data %>% 
  count(sword.type)

#we can use the summarise / summarize function (synonym!) 
#to obtain descriptive statistics of numeric variables
#this function creates a dataframe - we can create a new object, or print in the console

#print in console
pirate.data %>% 
  summarise(avg.tchests = mean(tchests))

#create data.frame
results <- pirate.data %>% 
  summarise(avg.tchests = mean(tchests), min.tchests = min(tchests), 
            max.tchests = max(tchests), median.tchests = median(tchests),
            sum.tchests = sum(tchests)) 

#include the group_by function to slice the data 
pirate.data %>% 
  group_by(sword.type) %>% 
  summarise(avg.tchests = mean(tchests)) 

#crosstab using the group_by, tally, and spread functions (dplyr method)
pirate.data %>%
  group_by(sword.type, headband) %>%
  tally() %>%
  spread(headband, n)


##############################################################################
#getting started with data processing 

#converting a numeric variable to character and back to numeric again
#i.e., demonstrating the as.character and as.numeric functions
class(pirate.data$tattoos)
pirate.data$tattoos <- as.character(pirate.data$tattoos)
pirate.data$tattoos <- as.numeric(pirate.data$tattoos)

#rename favorite.pirate - change to fav.pirate with the rename function
#remember, for the edits to the dataframe to stick, we must make sure that we are 
#writing them to the dataframe object pirate.data

pirate.data <- pirates %>%
  rename(fav.pirate=favorite.pirate)

#check out your change
names(pirate.data)

#we can obtain a specific subset of the data with the filter function 
coolest.pirates <- filter(pirate.data,fav.pixar=="Finding Nemo")

#similarly, we can subset data by selecting specific variables
most.piratey.pirates <- select(coolest.pirates, id, sword.time, tchests, parrots)

#inventing a calculation, a nonsense measure looking at treasure chests in relation to sword time 
#for demonstrative purposes
most.piratey.pirates <- mutate(most.piratey.pirates, treasure.swordtime = tchests/sword.time)

#let's classify the pirates based on how piratey they are
#as defined by the number of parrots they have

most.piratey.pirates <- mutate(most.piratey.pirates, most.piratey = case_when(
  parrots <= 1 ~ "least piratey",
  parrots >=2 &  parrots <= 3 ~ "piratey",
  parrots >=4 &  parrots <= 10 ~ "very piratey",
  parrots >=11 ~ "most piratey pirates",
  TRUE ~ "unknown"))

#we can see there are 3 pirates (most piratey pirates) in particular we want to 
#invite aboard our pirate ship
most.piratey.pirates %>% 
  count(most.piratey)


#stitching everything from above (filter, select, mutate, case_when) with the pipe operator
#there are no intermediate dataframe as we move from pirate.data to most.piratey.pirates
most.piratey.pirates<- pirate.data %>%
  filter(fav.pixar=="Finding Nemo") %>%
  select(id, sword.time, tchests, parrots) %>%
  mutate(most.piratey.pirates, most.piratey = case_when(
    parrots <= 1 ~ "least piratey",
    parrots >=2 &  parrots <= 3 ~ "piratey",
    parrots >=4 &  parrots <= 10 ~ "very piratey",
    parrots >=11 ~ "most piratey pirates",
    TRUE ~ "unknown"))

#same as above
most.piratey.pirates %>% 
  count(most.piratey)


################################################################################
#Extras - other helpful things - for course participants to review

#working with na's, or missing data
B <- c(1, 5, NA, 2, 10)
mean(B)
is.na(B)
mean(B)
mean(B, na.rm = TRUE)


#to count NAs with the length function
A <- c(1, 2, 3, NA)
length(A)
length(A[!is.na(A)])
length(A[is.na(A)])


#working with substrings (i.e., returning specific parts of a character value)
course.name<- "Introduction to R for Public Health Investigations"
str_sub(course.name, 23, 35)
str_sub(course.name, -14, -1)


#demonstrating again how dates work
#we are creating an object which is a list of character date values
x <- c("1jan1960", "2jan1960", "31mar1960", "30jul1960")
mode(x)
#we will turn the character values to date values with the as.Date function
#note that these operations can be repeated upon variables in a dataframe by specifying
#the specific variable to convert to a date variable from charater 

z <- as.Date(x, "%d%b%Y")
mode(z)
