####################################################################
# PHACR Training
#                                               
# Purpose: Create formatted table of case site of infection

# Data Used: tb_cases
#
#                                               
# Author: Emma Cumming
# Created: 2020-10-30

# Modified By: Pasha Marcynuk
# Date Modified: 2020-12-15
####################################################################

#Create a formatted table showing frequency of TB case site of infection. Use flextable()
# fabulous documentation: https://davidgohel.github.io/flextable/articles/overview.html

# Similarly to figures with ggplot2, first you need to SUMMARIZE your data into a frequency table
# For this table, we want to get counts by site of infection, so we group_by site of infection. 
case_site_infection <-  cases %>% 
  group_by(Site_infection) %>%  # the drop = FALSE is useful in padding your summary table to include ZERO counts. Otherwise they will not display in tables or figures.
  summarise(Count = n())
    #If you want to view the frequency table you have just created either:
        #click on the new data frame you have created called case_site_infection 
        #or write the code: case_site_infection

# Create totals row
# To add a totals row we create a one-row table (call it "totals_site) that does not group by any variable, to get the total count. 
totals_site_infection = cases %>% 
  summarise(Count = n()) %>%              # Gives total count of cases
  mutate(Site_infection = "Total") %>%    # Create a new column in order to match with the frequency table you've created earlier, so you can append this totals row to it.
  select(Site_infection , Count)          # Limit the columns to match the frequency table you created earlier.
    #If you want to view the table you have just created either:
        #click on the new data frame you have created called totals_site_infection 
        #or write the code: totals_site_infection

# Bind table with totals row
case_site_infection <- rbind(case_site_infection, totals_site_infection) ; rm(totals_site_infection) # smush the site table with the totals row!
                                                                                                     # The rm function is used to remove unneeded objects. 

# Create a flextable - they are very customizable:  https://davidgohel.github.io/flextable/articles/overview.html
tab_case_site_infection <- flextable(case_site_infection) %>%
  bg(bg = "#E6E6E6", part = "header") %>%                       # assign the background (bg) colour of the header. 
  bold(part = "header") %>%                                     # make the header bold       
  fontsize(size = 10, part = "all") %>%                         # make font size 10 in all parts of the table: header, body, and footer
  font(part = "all", fontname = "Arial") %>%                    # change the font type
  align(align = "center", part = "all") %>%                     # Make text in the body centre-justified
  set_header_labels(Site_infection = "Site of infection" ) %>%  # change the column heading name for site_infection to "Site of Infection" so that it's formatted nicely
  align(j=c("Site_infection"), align = "left") %>%              # make the first column left aligned
  bold( i = 6,  bold = TRUE, part = "body") %>%                 # make row 6 bold!
  width(j = 1, width = 1.5) %>%                                 # set first column to 1.5 inches wide
  set_caption(" Site of TB infection", style = "Table Caption", autonum = "autonum"  )  # Set the caption title for this figure, which will appear as a numbered caption in Word.
# Print the table
tab_case_site_infection

rm(case_site_infection) # remove unneeded objects. 
