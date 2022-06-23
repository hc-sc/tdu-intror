####################################################################
# PHACR Training
#                                               
# Purpose: Create table of case & contact location on/off reserve

# Data Used: tb_cases, tb_contacts
#
#                                               
# Author: Emma Cumming
# Created: 2020-10-30

# Modified By: Pasha Marcynuk
# Date Modified: 2020-12-18
####################################################################

# Bonus: Create a table showing location of cases and contacts on and off reserve.
# You need to wrangle data a bit in advance!

# First create a new data frames called location_cases that includes the location of all the cases (on or off reserve) and their classification (i.e. case)
location_cases <-  cases %>% 
  select(Location) %>%                      # Extract the location column from the cases data frame
  mutate(Classification = "Cases")          # Create a new column "Classification" and have it read "Cases" for all rows. 

# Create a contact dataframe called location_contacts with the same columns you created for cases above (Classification and Location)
location_contacts <-  contacts %>% 
  filter(!grepl("CASE", ContactID))  %>%    # Exclude all rows that contain "CASE" text string in the ContactID. look up grepl for more info- very handy! Type ?grepl into console.
  distinct() %>%                            # Select only unique rows
  select(Contact_location) %>%              # Extract only Location column 
  rename(Location = Contact_location) %>%   # New name = Old name
  mutate(Classification = "Contacts")       # Create new col "Classification" and have it read "Contacts" for all rows

# Bind case location list and contact location lists together so that the cases and contacts are in one column in a data frame
location <- rbind(location_cases, location_contacts) ; rm(location_cases, location_contacts)  # rm function removes objects no longer needed (location_cases, location_contacts)

# Now summarize the new location list into a frequency table with count and percent of cases and contacts on and off reserve
location <- location %>% 
  group_by(Classification, Location) %>%
  summarise(Count = n()) %>%
  mutate(Percent = round(100*Count/sum(Count),1)) # Create a column with the % location among contacts or cases- this calculation relies on the group_by variable order. 

# Display the frequency table in a nicely formatted flextable
tab_location <- flextable(location) %>%
  bg(bg = "#E6E6E6", part = "header") %>%              # Header background colour 
  bold(part = "header") %>%                            # Header font bolded
  fontsize(size = 10, part = "all") %>%                # Set font size for entire table
  font(part = "all", fontname = "Arial") %>%           # Set font to Arial
  align(align = "center", part = "body") %>%           # Center the body of the table
  align(align = "center", part = "header") %>%         # Center the header of the table
  align(j=c("Location"), align = "left") %>%           # Set the first column (Location) to be left-justified
  set_header_labels(Percent = "Percent (%)") %>%       # Change header label
  merge_v(j = c(1,2)) %>%                              # Vertically merge duplicate rows, so they don't repeat  
  set_caption(" Residential location of TB cases and contacts", style = "Table Caption", autonum = "autonum" ) %>%    #Set Table title
  fix_border_issues() %>%                             # Merging can sometimes remove outer border lines- this fixes that somehow. hide this code to see what I mean. 
  autofit()                                           # Makes column widths nice

tab_location

rm(location)                                          # Removes objects no longer needed
