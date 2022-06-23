####################################################################
# PHACR Training
#                                               
# Purpose: Plot contacts by age and gender

# Data Used: tb_contacts
#
#                                               
# Author: Emma Cumming
# Created: 2020-10-30

# Modified By: Pasha Marcynuk
# Date Modified: 2020-12-02
####################################################################

# Make a frequency table of contact age group and gender counts
contacts %>% 
  group_by(Agegroup, Gender) %>%
  summarise(Count = n()) %>%
    # If you want to run just the frequency table you can use the following code:
      # contacts %>% group_by(Agegroup, Gender) %>%  summarise(Count = n()) 
  
# Pipe the frequency table into a ggplot  
  ggplot(aes(x= Agegroup, y = Count, fill = Gender)) +    # Fill = gender, which means plot will be stratified by gender
  geom_bar(stat="identity", position = "dodge")+          # Stat = identity required for bar plots. Position = dodge means bars will sit beside each other, not stacked
  theme_minimal() +
  ylab("# Contacts") + xlab("Age group") +
  scale_fill_manual(values=c("green", "orange"))          # Select colours for gender. You can also use hex colour codes. Google "R colours" for a ton of options. 
                                                          # To check order of the Gender levels use the code: levels(contacts$Gender) 

# Save the resulting graph as an image in the outputs folder

ggsave(path = output_folder, filename="plot_contacts_agegender_count.jpeg", width=7, height=4)


####################################################################

# Age group and gender proportions
# Frequency table
contacts %>% 
  group_by(Agegroup, Gender) %>%
  summarise(Count = n()) %>%
  ungroup() %>%                                            # If you don't "ungroup", proportions will be calculated within the first listed grouped variable, Agegroup. Try excluding this code to see what you get.
  mutate(Proportion = round(100*Count/sum(Count),1)) %>%   # Create a variable that calculates proportions (denom = overall total) 
    # If you want to run just the frequency table you can use the following code:
        # contacts %>% group_by(Agegroup, Gender) %>%  
          # summarise(Count = n()) %>% ungroup() %>% 
          # mutate(Proportion = round(100*Count/sum(Count),1))  

# Make plot
ggplot(aes(x= Agegroup, y = Proportion, fill = Gender)) + 
  geom_bar(stat="identity", position = "dodge")+
  theme_minimal() +
  ylab("% total contacts") + xlab("Age group") +
  scale_fill_manual(values=c("green", "orange")) +
  geom_text(aes(label=paste0(Proportion, "%")), position=position_dodge(width=0.9), vjust=-0.25)   # This adds text labels to the bars- here I wanted to show the Proportion variable value, plus the % sign. 

# Save plot
#ggsave(filename = paste0(output_folder, "/plot_contacts_agegender_prop.jpeg"), width = 7, height = 4)
ggsave(path = output_folder, filename="plot_contacts_agegender_prop.jpeg", width = 7, height = 4)



####################################################################

# Figure panel, one for location on or off reserve
# Frequency table
contacts %>% 
  group_by(Agegroup, Gender, Contact_location, .drop = FALSE) %>%  # the drop = FALSE is useful in padding your summary table to include ZERO counts. Otherwise they will not display in tables or figures.
  summarise(Count = n()) %>%
    # If you want to run just the frequency table you can use the following code:
      # contacts %>% group_by(Agegroup, Gender, Contact_location, .drop=FALSE) %>%  summarise(Count = n()) 

# Make plot  
ggplot(aes(x= Agegroup, y = Count, fill = Gender)) + 
  geom_bar(stat="identity", position = position_dodge(preserve = "single"))+  # The preserve = "single" option ensures that the bars are all the same width. 
  theme_minimal() +
  ylab("# Contacts") + xlab("Age group") +
  scale_fill_manual(values=c("green", "orange")) + 
  facet_wrap(vars(Contact_location), nrow =2 ) # This creates a panel with 2 rows based on one variable

# Save plot
ggsave(path=output_folder, filename="plot_contacts_location.jpeg", width = 7, height = 4)
