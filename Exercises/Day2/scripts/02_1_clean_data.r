####################################################################
# PHACR Training
#                                               
# Purpose: To clean datasets and create variables

# Data Used: tb_cases.xlsx, tb_contacts.xlsx
#
#                                               
# Author: Emma Cumming
# Created: 2020-10-30
#
# Modified By: Benjamin Hetman, Pasha Marcynuk and Joanne Stares 
# Date Modified: 2022-01-12
####################################################################

# INSPECT
#utils::View(cases) # Shows data in a pop-up window that's easier to scroll through than other viewer
#utils::View(contacts)

# Using the str function, take a look at all the variables in your two dataframes (cases and contacts).
    #The str function shows the structure of your data frame and includes information on: 
          # the number of rows and columns
          # the column names, 
          # the class of each column (type of data stored -  i.e. character, numeric, etc.)
          # the first few observations of each variable

str(cases)
str(contacts)
  # Note which variables are characters and may need to be converted to factors

# CLEAN
# Convert string text variables into factor variables
cases[sapply(cases, is.character)] <- lapply(cases[sapply(cases, is.character)], as.factor)
contacts[sapply(contacts, is.character)] <- lapply(contacts[sapply(contacts, is.character)], as.factor)

  # If you want to view the levels you have just created you can use the sapply function with the level option
    # Note: Variables that are not classified as factors will have their level listed as "NULL"
  sapply(cases, levels)
  sapply(contacts, levels)

  
# CREATE VARIABLES
# Infectiousness
    # Create a variable to categorize the infectiousness of the cases based on Tb_type, Cavitation, and Smear2.
    # Like an if statement, the arguments are evaluated in order, so you must proceed from the most specific to the most general.
    # This variable creation uses dplyr's mutate and the case_when() function. The values you want your new variable to take follow the "~" symbol. 
cases <- cases %>% 
  mutate(Infectiousness = case_when(Tb_type == "Non-respiratory" ~ "Low",
                                    # Logic: If TB type is non-respiratory, infectiousness is low
                                    Cavitation == "Cavities" & Smear2 == "Positive" ~ "Very High",
                                    # Logic: If case has cavities and is smear positive, infectiousness is very high
                                    Cavitation == "No cavities" & Smear2 == "Positive" ~ "High",
                                    # Logic: If case has no cavities but is smear positive, infectiousness is high
                                    Smear2 == "Negative" & Tb_type == "Respiratory" ~ "Moderate"),
         # Logic: If case is smear negative but respiratory TB, case is moderately infectious
         Infectiousness = factor(Infectiousness, levels = c("Low", "Moderate", "High", "Very High"))) 
# Declaring this a factor variable lets you set the correct order the variable levels should appear in figures and charts.

# Check the levels you have just created to make sure they were coded correctly by creating a table
      # You can do this using the group_by function. 
      # Group the data by the new variable you just created (Infectiousness) 
      # and include counts of the variables you want to include in your check (Tb_type, Caviation, and Smear2).
cases %>%  group_by(Infectiousness) %>%  count(Tb_type, Cavitation, Smear2)

# Diagnosis month  
    # Create a new date variable called Diagnosis_month to display the diagnosis date as a year and month
cases <- cases %>% 
  mutate(Diagnosis_month = as.yearmon(Diagnosis_date))
table(cases$Diagnosis_month, cases$Diagnosis_date)

# Age group 
    # Create agegroups for both the case dataframe and the case-contact dataframe (called Agegroups)
    # Use the following age group categories: Less than 10 years; 10-19 years; 20-39 years; 40-59 years; 60+ years
    # Again, the mutate + case_when structure is used to create this variable. 
contacts <- contacts %>% mutate(Agegroup = case_when(
  Contact_age_years >= 60                            ~ "60+ years",
  Contact_age_years >= 40  & Contact_age_years <= 59 ~ '40-59 years',
  Contact_age_years >= 20  & Contact_age_years <= 39 ~ '20-39 years',
  Contact_age_years >= 10  & Contact_age_years <= 19 ~ "10-19 years",
  Contact_age_years <= 9                             ~ "Less than 10 years"),
  Agegroup = factor(Agegroup, levels = c("Less than 10 years", "10-19 years", "20-39 years", "40-59 years", "60+ years"))) # setting the order of this variable is key!

cases <- cases %>% mutate(Agegroup = case_when(
  Age_years >= 60 ~ "60+ years",
  Age_years >= 40  & Age_years <= 59 ~ '40-59 years',
  Age_years >= 20  & Age_years <= 39 ~ '20-39 years',
  Age_years >= 10 & Age_years <= 19 ~ "10-19 years",
  Age_years <= 9 ~ "Less than 10 years"),
  Agegroup = factor(Agegroup, levels = c("Less than 10 years", "10-19 years", "20-39 years", "40-59 years", "60+ years"))) 

# Check to see if you have correctly classified your age groups using the table function
    # Note: This is a base R function and not tidyverse 
    # so you need to add the dataframe name and a $ before every variable you include in your code (i.e. cases$Age_years) 
table(contacts$Contact_age_years, contacts$Agegroup)
table(cases$Age_years, cases$Agegroup)


