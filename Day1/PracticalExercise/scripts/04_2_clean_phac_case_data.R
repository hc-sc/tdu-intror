####################################################################
# PHACR Training
#                                               
# Purpose: To clean raw data

# Data Used: PHAC COVID-19 linelist
#
#                                               
# Author: Christopher Mill
# Created: 2020-10-22
#
# Modified By: Benjamin Hetman, Pasha Marcynuk & Joanne Stares
# Date Modified: 2022-01-05
####################################################################


#Now we're going to clean the phac raw data, that you've called "phac_raw"
#We will complete the following cleaning steps in the code below:

  #1.Create a new data frame and select and rename the columns that we need, 
  #2.Format the date column, and replace and update the province names, 
  #3.Filter the time frame that we want, 
  #4.Remove the "repatriated travellers", 
  #5.Join the population denominators to calculate rates,
  #6.Add a series of calculated metrics, 
  #7.Convert to "long form" data
  
#Create a new data frame called phac_clean based on the raw line list data (phac_raw). 
#The frame will contain the variables: prname, date, numconf, numdeaths, numtested. 
#However, prname will be renamed as location, numconf as total_cases, numdeaths as total_deaths, and numtested as total_tests.
phac_clean <- phac_raw %>%
  select(location = prname, 
         date, total_cases = numconf, 
         total_deaths = numdeaths, 
         total_tests = numtested) 

#Recode the character variable containing date information to a date variable, and replace province names with abbreviations (as in previous step).
  #The mutate function allows you to create a new column. 
  #Within the mutate function, we'll format the date, and replace the province names.
  #The "lubridate" package features a number of very useful and easy-to-use functions to format dates. 
  #Using the "dmy" function, we'll tell R that the data is formatted as "day-month-year"
  #The "stringr" package features a number of useful functions that you'll use to manipulate character strings.
  #In this case, we'll overwrite the "location" variable by replacing the abbreviated province names that we created previously, 
  #using the "str_replace_all" function.
  phac_clean <- phac_clean %>% 
    mutate(date = dmy(date), 
         location = str_replace_all(location, provinces_short_names))
  
#Filter the data to keep records with dates March 1 2020 and after and remove the "repatriated travellers"
  #Note the use of the "&", "!", and "%in%" operators which mean "and, "not" and "match"
  phac_clean <- phac_clean %>%
    filter(date >= ymd("2020-03-01") &
           !location %in% c("Repatriated travellers")) 
  
#Sort the data frame by location and date using the "arrange" function
  phac_clean <- phac_clean %>% 
    arrange(location, date)

#Join the population denominators to calculate rates
  #In order to calculate daily rates by jurisdiction, we need to first join our population denominator object
  #we'll do this by using the "left_join" function, and specify the match key columns
  phac_clean <- phac_clean %>% 
    left_join(pop_denom_canada_clean, by = c("location" = "province"))
  
#Not every province has a row for every date. We'll add rows for each date for each jurisdiction using the "pad" function,
  #and fill the missing values with the previous day's value
  #First use "group_by" to specify that we'll add values within groups, in this case, our "location" variable
  phac_clean <- phac_clean %>% group_by(location)
  #Then we will sort the data by date
  phac_clean <- phac_clean %>% arrange(date)
  #We can now use the the pad function to specify that we want rows for each day starting from "2020-03-01". Using "ymd", we tell R that it's a date formatted as year-month-day
  phac_clean <- phac_clean %>% pad(start_val = ymd("2020-03-01"), interval = "day") 
  #Use the "fill" function to fill variables in those new rows with values from the previous data, within jurisdictions
  phac_clean <- phac_clean %>% fill(total_cases,
                                    total_deaths,
                                    total_tests, 
                                    PopTotal)
  
#Add a series of calculated metrics,
  #Using "mutate", we'll add several metrics that we might want to plot, including rates. 
  #"round" tells R to round the value to the nearest specified digit, and in this case, let's use 2 digits.
  #"lag" is a handy command that allows you to calculate new daily cases counts from cumulative case counts. In practice, 
  #take previous day's value and substract from current value. Specify the default value is the first value in each jurisdiction
  #Remember the "group_by" function is still "on". 
  phac_clean <- phac_clean %>% 
    mutate(epi_week = epiweek(date),
           total_cases_per_million = round(total_cases/PopTotal*1000000, digits = 2),
           new_cases = total_cases - lag(total_cases, default = first(total_cases)),
           new_cases_smoothed = round(rollmean(new_cases, 7, fill = NA, align = "right"), digits = 2), 
           new_cases_per_million = round(new_cases/PopTotal*1000000, digits = 2), 
           new_cases_smoothed_per_million = round(rollmean(new_cases_per_million, 7, fill = NA, align = "right"), digits = 2),
           total_deaths_per_million = round(total_deaths/PopTotal*1000000, digits = 2), 
           new_deaths = total_deaths - lag(total_deaths, default = first(total_deaths)),
           new_deaths_smoothed = round(rollmean(new_deaths, 7, fill = NA, align = "right"), digits = 2),
           new_deaths_per_million = round(new_deaths/PopTotal*1000000, digits = 2),
           new_deaths_smoothed_per_million = round(rollmean(new_deaths_per_million, 7, fill = NA, align = "right"), digits = 2))
  #It's good practice to always specify "ungroup" when you no longer need to create new variables by your grouped variable
  phac_clean <- ungroup(phac_clean)
  
#Convert the data to long tidy format using the "pivot_longer" command. Within that function, specify the columns to collapse, and provide names of the new tidy columns.
  #Always convert to tidy data! Remember, every variable in a column, and every observation in a row
  phac_clean <- phac_clean %>% 
    pivot_longer(3:17, names_to = "metric", values_to = "value") 
  
#Create three new variables to add some flags that will make metric selection a little easier when we plot.
  phac_clean <- phac_clean %>% 
    mutate(cases_deaths = case_when(str_detect(metric, "cases") ~ "cases", 
                                    str_detect(metric, "deaths") ~ "deaths", 
                                    TRUE ~ "other"),
           count_rate = case_when(str_detect(metric, "million|thousand") ~ "rate", 
                                  str_detect(metric, "population|positive|positivity") ~ NA_character_,
                                  TRUE ~ "count"), 
           raw_smoothed = case_when(str_detect(metric, "smoothed") ~ "smoothed", 
                                    TRUE ~ "raw"))
  
