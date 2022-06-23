####################################################################
# PHACR Training
#                                               
# Purpose: Plot epi curve using incidence package

# Data Used: tb_cases
#
#                                               
# Author: Emma Cumming
# Created: 2020-10-30

# Modified By: Pasha Marcynuk
# Date Modified: 2020-12-17
####################################################################

## Bonus: Incidence package
#The incidence package developed by the R Epidemics Consortium, allows you to make epidemiologist-friendly epicurves using line list data with dates.
# (https://www.repidemicsconsortium.org/incidence/)

# Create an epi curve showing week of symptom onset, with infectiousness levels coded different colours
# Check date format and convert to "Date" format if necessary
# class(cases$`Symptom_date`)
cases$Symptom_date = as.Date(cases$Symptom_date, format = "%d-%m-%Y") # This package likes dates formatted as Date, not POSIXct (type ?POSIXct in console to learn more)

# Create a format theme for epicurve using ggplot2 language
my_theme <- theme_minimal(base_size = 12) +                                                     # sets the background theme to minimal (i.e. no background, annotations, etc.)
  theme(panel.grid.minor = element_blank()) +
  theme(legend.position="bottom") +                                                             # moves legend to bottom
  theme(axis.text.x = element_text(angle = 0, hjust = 0.5, vjust = 0.25, color = "black"))      # adjusts the formatting of the axis text

# Create incidence object based on symptom onset date per 7 day interval, grouped by infectiousness
i.7 <- incidence(cases$Symptom_date, interval = 7, groups = cases$Infectiousness )              #incidence, 7 day

# Plot the incidence object (to create the epi curve!)
plot(i.7, show_cases = TRUE, border = "black", labels_week = TRUE) +
  my_theme + 
  scale_y_continuous(breaks=seq(0, 3, 1)) +                                            # Change y axis scale 
  scale_fill_manual(values=c("green", "yellow", "orange", "red")) +                    # Sets colours of infectiousness variable levels
  labs(x = "ISO week of symptom onset" , y = "Case count", fill="Infectiousness") +    # Customize labels
  coord_fixed(ratio = 7)                                                               # Turns individual cases as squares, accounting for 7 days per square along x axis.

# Save the resulting plot as an image in your outputs folder
ggsave(path=output_folder, filename = "plot_cases_epiweek.jpeg", width = 7, height = 2)
