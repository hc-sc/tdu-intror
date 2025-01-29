####################################################################
# PHACR Training
#                                               
# Purpose: To load data

# Data Used: PHAC COVID-19 linelist and Statistics Canada population denominator
#
#                                               
# Author: Christopher Mill
# Created: 2020-10-22
#
# Modified By: Benjamin Hetman, Pasha Marcynuk & Joanne Stares
# Date Modified: 2022-01-04
####################################################################

#This script will load the data that lives in your data folder. 
#You can also load data directly from a website if a link to the csv file is directly available. 

#Import the PHAC COVID-19 data into your R session.
#In the statement below, you will use the "read_csv" function to load the data. 
#We can wrap the relative file path using here() inside the read_csv() function. 


phac_raw <- read_csv(here("Exercise_Day1", "data", "covid19.csv"))


#Similarly, you can load the Statistics Canada population denominators using the "read_csv" function, and the "url" command.
#First create a new character vector X and assign to it the web location where the csv is located
x <- "https://www150.statcan.gc.ca/t1/tbl1/en/dtl!downloadDbLoadingData.action?pid=1710000901&latestN=0&startDate=20200101&endDate=20200101&csvLocale=en&selectedMembers=%5B%5B2%2C3%2C4%2C5%2C6%2C7%2C8%2C9%2C10%2C11%2C12%2C14%2C15%5D%5D&checkedLevels="
#Then create a vector called canada_pop_demon_raw and assign the csv file from the website url above.
canada_pop_denom_raw <-read_csv(url(x))
#
#CONDENSED CODE: You could have also combined the previous two steps into one line of code.
#canada_pop_denom_raw <- read_csv(url("https://www150.statcan.gc.ca/t1/tbl1/en/dtl!downloadDbLoadingData.action?pid=1710000901&latestN=0&startDate=20200101&endDate=20200101&csvLocale=en&selectedMembers=%5B%5B2%2C3%2C4%2C5%2C6%2C7%2C8%2C9%2C10%2C11%2C12%2C14%2C15%5D%5D&checkedLevels="))

