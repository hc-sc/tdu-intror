####################################################################
# PHACR Training
#                                               
# Purpose: To specify file paths

# Data Used: none
#
#                                               
# Author: Christopher Mill
# Created: 2020-10-22
#
# Modified By: Benjamin Hetman, Pasha Marcynuk & Joanne Stares 
# Date Last Modified: 2022-11-10
####################################################################

#Start by setting up your workspace. Minimize R and create a new folder on your computer called IntroToR
#Within the IntroToR folder create a subfolder for Day 1 of the course called: "Exercise_Day1". For example: "C:\IntroToR\Exercise_Day1".
#Create new folders within Exercise_Day1 called: "output";"data";"scripts"

#Move the scripts files for Day 1 to your scripts folder within the Exercise_Day1 folder.
#Move the data files for Day 1 to your data folder within the Exercise_Day1 folder


#Note: we are using a special package named "here" to help identify *relative* file paths. 
# The following line of code tells R where the current script lives in relation to the 
# project root directory (indicated by the .RProj file). This way, no matter where the
# folders are on your computer, your scripts will be able to find all the necessary
# files and folders. 


#Next we'll set up some variables containing the paths to your data, scripts, and output folders. You'll see how this comes in handy later.

#This is your raw data folder. You will save any raw data used in this project in this folder. 
data_folder <- here::here("Exercise_Day1", "data")

#This is your output folder. You will save any figures or data cuts, etc in this folder. 
output_folder <- here::here("Exercise_Day1", "output")

#This is your scripts folder. Keep all of your scripts (like this one) in here. 
scripts_folder <- here::here("Exercise_Day1", "scripts")
