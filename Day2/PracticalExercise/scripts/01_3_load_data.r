####################################################################
# PHACR Training
#                                               
# Purpose: To load data

# Data Used: none
#
#                                               
# Author: Emma Cumming
# Created: 2020-11-05
#
# Modified By: Benjamin Hetman, Pasha Marcynuk 
# Date Modified: 2022-01-12
####################################################################

# Load case line list and contact tracing(case-contact relationship) line list
  #trim_ws=TRUE tells R to removed leading and trailing white spaces 
  #col_names=TRUE tells R to use the first row as column names
  #na="Unknown" tells R to treat the string value "Unknown" as na or missing values. By default, readxl treats blank cells as missing data.

cases <- read_excel(here("Exercise_Day2","data", "tb_cases.xlsx"), trim_ws = TRUE, col_names = TRUE, na = "Unknown")

contacts <- read_excel(here("Exercise_Day2","data","tb_contacts.xlsx"), trim_ws = TRUE, col_names = TRUE, na = "Unknown")

