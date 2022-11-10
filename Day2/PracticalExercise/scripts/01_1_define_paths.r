####################################################################
# PHACR Training
#                                               
# Purpose: To specify file paths

# Data Used: none
#
#                                               
# Author: Emma Cumming
# Created: 2020-10-30
#
# Modified By: Benjamin Hetman, Pasha Marcynuk & Joanne Stares
# Date Modified: 2022-11-10
####################################################################

#Start by setting up your workspace. Note instructions are also available in the workbook associated with this exercise.
  #Within the IntroToR folder you created on Day 1, create a sub-folder for Day 2 called: "Exercise_Day2". For example: "C:\IntroToR\Exercise_Day2".
  #Create new folders within Exercise_Day2 called: "output";"data" "scripts"
  #Move the files for Day 2 to their corresponding folders
  #Note: If you do not name your folders as described above, 
         #you may need to modify the code that references these folder paths throughout the scripts for this exercise


#Create a new script (this one) inside your Exercise_Day2/scripts folder and name it "01_1_define_paths.R"

#Next we'll set up some variables containing the paths to your data, scripts, and output folders. 
#You'll see how this comes in handy later.

#This is your raw data folder. You will save any raw data used in this project in this folder. 
#If your folders have a different name or path as described above, replace the character strings
#below to match the subfolders on your machine.

data_folder <- here::here("Exercise_Day2", "data")

#This is your output folder. You will save any figures or data cuts, etc in this folder. 

output_folder <- here::here("Exercise_Day2", "output")

#This is your scripts folder. Keep all of your scripts (like this one) in here. 

scripts_folder <- here::here("Exercise_Day2", "scripts")

# Don't forget to save your script again after modifying it! 
