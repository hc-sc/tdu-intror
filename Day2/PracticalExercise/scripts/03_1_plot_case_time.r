####################################################################
# PHACR Training
#                                               
# Purpose: Plot cases over time and save output

# Data Used: tb_cases
#
#                                               
# Author: Emma Cumming
# Created: 2020-10-30

# Modified By: Pasha Marcynuk
# Date Modified: 2020-12-01
####################################################################

# Cases by month

# First SUMMARISE the case data into a frequency table of case count per month of diagnosis.
cases %>% 
  group_by(Diagnosis_month) %>%
  summarise(Count = n()) %>%
    # If you just want to run the frequency table you can use the following code:
      # cases %>% group_by(Diagnosis_month) %>%  summarise(Count = n()) 

# Then pipe this frequency table into a GGPLOT command for a bar plot, with y-axis as Diagnosis Month and y-axis as Count.    
  ggplot(aes(x=as.Date(Diagnosis_month), y=Count)) + 
  geom_bar(stat="identity")+                               # stat="identity" allows the heights of the bars to equal a value in the data, rather than counts. 
  scale_x_date(date_labels = "%b %Y") +                    # Month and year date format ex "Aug 2020". Good reference: https://www.r-bloggers.com/2013/08/date-formats-in-r/
  theme_minimal() +                                        # Tweaks the figure colours and formatting to a preset theme. You can try out various themes: https://ggplot2.tidyverse.org/reference/ggtheme.html
  #ggtitle("TB case diagnoses, May-October 2013 ") +       # You can have titles, but here we prefer to add titles in R Markdown text.
  ylab("Case count") + xlab("Month and Year of Diagnosis") # X and Y axis labels

# last, SAVE the resulting figure in your specified output folder. 
## Hint: the paste0() function just pastes together any text strings you provide, with no spaces between. 
## Below, we paste together the output folder file path with a name for the plot we have just created.
ggsave(path= output_folder, filename = "plot_cases_month.jpeg", width = 7, height = 4)

#######################################################################

# Cases by month, by gender

# SUMMARISE
cases %>% 
  # To further stratify the figure by Gender, we need to add Gender in the group_by() call. 
  group_by(Diagnosis_month, Gender) %>% 
  summarise(Count = n()) %>%
    # If you want to run just the frequency table you can use the following code:
      # cases %>% group_by(Diagnosis_month, Gender) %>%  summarise(Count = n()) 
# CREATE GGPLOT  
  ggplot(aes(x=as.Date(Diagnosis_month), fill = Gender, y = Count)) +   # In bar plots, you can colour-stratify by another variable by specifying "fill=" in the aes() call. 
  geom_bar(stat="identity", position = "stack") +                       # Position = "stack" will give a stacked bar chart, rather than a side-by-side one (i.e. position = "dodge")
  scale_x_date(date_labels = "%b %Y") +
  theme_minimal() + 
  ylab("Case count") + xlab("Month and Year of Diagnosis") +
  scale_fill_manual(values=c("green", "orange"))                       # Here we are specifying what we want the Fill colours to be. You can also use Hex colour codes. 
                                                                       # The order you list these colours will match the order of any factor variable. 
                                                                       # You can check the order of Gender using the levels() function
                                                                          # levels(cases$Gender)
# SAVE OUTPUT
ggsave(path = output_folder, filename ="plot_cases_month_gender.jpeg", width = 7, height = 4) # saves the most recent plot

#######################################################################

# Monthly cases by infectiousness
# MAKE FREQUENCY TABLE
cases %>% 
  group_by(Diagnosis_month, Infectiousness) %>%                      # This time we are grouping by month and infectiousness. 
  summarise(Count = n()) %>% 
    # If you want to run just the frequency table you can use the following code:
      # cases %>% group_by(Diagnosis_month, Infectiousness) %>%  summarise(Count = n()) 
# CREATE GGPLOT  
  ggplot(aes(x=as.Date(Diagnosis_month), fill = Infectiousness, y = Count)) + 
  geom_bar(stat="identity", position = "stack")+
  scale_x_date(date_labels = "%b %Y") +
  theme_minimal() +
  ylab("Case count") + xlab("Month and Year of Diagnosis") +
  scale_fill_manual(values=c("green", "yellow", "orange", "red"))    # These colours will match with the factor order of the infectiousness variable. 
                                                                     # You can check the order by: levels(cases$Infectiousness)
# SAVE OUTPUT
ggsave(path = output_folder, filename = "/plot_cases_month_infectiousness.jpeg", width = 7, height = 4) # saves the most recent plot

#######################################################################

# Try out different themes. 
# https://ggplot2.tidyverse.org/reference/ggtheme.html
# theme_classic()