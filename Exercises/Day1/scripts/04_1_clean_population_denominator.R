####################################################################
# PHACR Training
#                                               
# Purpose: To clean raw data

# Data Used: PHAC COVID-19 linelist and Statistics Canada population denominator
#
#                                               
# Author: Christopher Mill
# Created: 2020-10-22
####################################################################

#First we'll create an object called "provinces_short_names", and we'll replace the values in the raw data using the abbreviated names. 
#The "c" tells R that this is a character string, and specifying the abbreviations in this way makes this a named character vector.
provinces_short_names <- c("Alberta" = "AB", 
                           "British Columbia" = "BC",
                           "Manitoba" = "MB", 
                           "New Brunswick" = "NB", 
                           "Newfoundland and Labrador" = "NL", 
                           "Nova Scotia" = "NS", 
                           "Northwest Territories" = "NWT",
                           "Ontario" = "ON", 
                           "Prince Edward Island" = "PEI", 
                           "Quebec" = "QC", 
                           "Saskatchewan" = "SK", 
                           "Yukon" = "YK",
                           "Nunavut" = "NU")

#Now we'll create a new object that houses the clean population denominator data.
#Referencing the raw data called "canada_pop_denom_raw", select the columns that you need (GEO and VALUE), 
#and replace the long names with the short names. 
#you can also rename the column headings within the select statement. You can also use "rename" command before using "select". Try it!
#Note that the "%>%" symbol, called a "pipe", allows you to write statement sequentially. 
pop_denom_canada_clean <- canada_pop_denom_raw %>%
  select(province = GEO, PopTotal = VALUE) %>%
  mutate(province = str_replace_all(province, provinces_short_names))

