####################################################################
# PHACR Training
#                                               
# Purpose: To clean raw data

# Data Used: PHAC COVID-19 linelist
#
#                                               
# Author: Christopher Mill
# Created: 2020-10-22
#
# Modified By: Benjamin Hetman, Pasha Marcynuk & Joanne Stares
# Date Modified: 2022-01-05
####################################################################

#Let's visualize the daily case data, and we'll do this using the ggplot2 package. 
#ggplot2 is based on the grammar of graphics, which is a tool / framework that allows us to 
#concisely describe the components of a graphic
#We'll first start with the clean dataset, extract the elements we need for our plot, and then construct the plot in a layered fashion

#Create a new dataframe that contains only data to be graphed for Ontario
  #Select the columns we need from the phac_clean dataset: date, location, metric and value)
ONnew_daily_cases_data <- phac_clean %>%
  select(date, location, metric, value)

#Filter the data by locations and desired metrics to graph. In this case we are interested in new_cases and new_cases_smoothed 
ONnew_daily_cases_data <- ONnew_daily_cases_data %>%
  filter(location %in% c("ON") & 
           metric %in% c("new_cases", "new_cases_smoothed"))

#Now we'll reshape the data to wide format for plotting.
ONnew_daily_cases_data <- ONnew_daily_cases_data %>%
  pivot_wider(names_from = "metric", values_from = "value")

#The data is ready for plotting, and we'll do this using functions from the ggplot2 package
#Create an epi curve of new ON cases by day and a 7-day moving average.
  #First we'll define our x and y axes in the aesthetic layer 
  ONnew_daily_cases_plot <- ggplot(data=ONnew_daily_cases_data, aes(x = date, 
                            y = new_cases)) +
  #add a bar graph layer, and specify in the "stat" argument that no transformation is required,
  #and specify the color of the bars (fill) in hex code. Note that R will assign a color if you simply spell the color in English.
  geom_bar(stat = "identity", 
           fill = "#d9d9d9") +
  #let's add a line layer that represents the 7-day moving average
  #in the line layer, specify the x and y axes in the aesthetic argument, then specify the color and size of the line.
  geom_line(aes(x = date, 
                y = new_cases_smoothed), 
            color = "#d95f02", 
            size = 1.5) +
  #bonus data viz point... add a point to the end of the line. 
  geom_point(data = phac_clean %>%
               select(date, location, metric, value) %>%
               filter(location %in% c("ON") & 
                        metric %in% c("new_cases_smoothed")) %>%
               pivot_wider(names_from = "metric", values_from = "value") %>%
               filter(date == max(date)), 
             aes(x = date, y = new_cases_smoothed),
             size = 3, 
             color = "#d95f02") +
  #ggplot2 comes with several built-in themes. See which one you prefer. 
  #I tend to modify the "theme_minimal" theme in the subsequent "theme" statement
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 0, hjust = 0.5, size = 10), 
          axis.text.y = element_text(size = 10),
          plot.title = element_text(size = 14), 
          axis.title.x = element_text(size = 12, margin = margin(t = 20, r = 0, b = 0, l = 0)),  
          axis.title.y = element_text(size = 12, margin = margin(t = 0, r = 20, b = 0, l = 0)), 
          plot.caption = element_text(size = 12, margin = margin(t = 20, r = 0, b = 0, l = 0)),
          legend.position = "none", 
          panel.grid.minor = element_blank(), 
          panel.grid.minor.x = element_blank(),
          panel.grid.major.x = element_blank()) +
  #Specify that you want to show date axis increments in months. You can also specify any number of months
  #Also specify the format of the labels to be abbreviated using %b. 
  scale_x_date(date_breaks = "1 months",
               date_labels = "%b") +
  #Add a plot title and axes titles: Graph title - New daily diagnosed COVID-19 cases in ON; X-axis - Time (days); 
  #Y-axis: New daily confirmed cases
  ggtitle("New daily diagnosed COVID-19 cases in ON") +
  xlab("Time (days)") +
  ylab("New daily confirmed cases")

  
#You've stored your plot as an object, so run this line to see our plot in the viewer window
  ONnew_daily_cases_plot

#Save your plot as a png to your output folder using "ggsave". Name it "ONnew_daily_cases_plot" 
  #and automatically add today's date to the name.
  #To automatically add today's date we can use the Sys.Date() function. We create an object called today and assign it to be Sys.Date()
  today <- Sys.Date()
  #Now we can save our plot
  ggsave(paste0(output_folder, "/ONnew_daily_cases_plot_", today, ".png"), 
       plot = ONnew_daily_cases_plot,
       width = 11, 
       height = 7, 
       units = "in")  

  
#Create a similar figure for QC  
  #Create a new dataframe that contains only data to be graphed for Quebec
  #Select the columns we need from the phac_clean dataset: date, location, metric and value)
  QCnew_daily_cases_data <- phac_clean %>%
    select(date, location, metric, value)
  
  #Filter the data by locations and desired metrics to graph. In this case we are interested in new_cases and new_cases_smoothed 
  QCnew_daily_cases_data <- QCnew_daily_cases_data %>% 
    filter(location %in% c("QC") & 
             metric %in% c("new_cases", "new_cases_smoothed"))
  
  #Now we'll reshape the data to wide format for plotting.
  QCnew_daily_cases_data <- QCnew_daily_cases_data %>% 
    pivot_wider(names_from = "metric", values_from = "value")
  
  #The data is ready for plotting, and we'll do this using functions from the ggplot2 package
  #Create an epi curve of new QC cases by day and a 7-day moving average.
  #First we'll define our x and y axes in the aesthetic layer 
  QCnew_daily_cases_plot <- ggplot(data=QCnew_daily_cases_data, aes(x = date, 
                                                                    y = new_cases)) +
    #add a bar graph layer, and specify in the "stat" argument that no transformation is required,
    #and specify the color of the bars (fill) in hex code. Note that R will assign a color if you simply spell the color in English.
      #Changed the bars to green
    geom_bar(stat = "identity", 
             fill = "#52BE80") +
    #let's add a line layer that represents the 7-day moving average
    #in the line layer, specify the x and y axes in the aesthetic argument, then specify the color and size of the line.
      #Changed the line to blue
    geom_line(aes(x = date, 
                  y = new_cases_smoothed), 
              color = "#2980B9", 
              size = 1.5) +
    #bonus data viz point... add a point to the end of the line. 
    geom_point(data = phac_clean %>%
                 select(date, location, metric, value) %>%
                 filter(location %in% c("QC") & 
                          metric %in% c("new_cases_smoothed")) %>%
                 pivot_wider(names_from = "metric", values_from = "value") %>%
                 filter(date == max(date)), 
               aes(x = date, y = new_cases_smoothed),
               size = 3, 
               color = "#2980B9") +
    #Set the theme
      #Changed the Plot title size, the x and y axis title size, and the axis label size
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 0, hjust = 0.5, size = 10), 
          axis.text.y = element_text(size = 10),
          plot.title = element_text(size = 14), 
          axis.title.x = element_text(size = 12, margin = margin(t = 20, r = 0, b = 0, l = 0)),  
          axis.title.y = element_text(size = 12, margin = margin(t = 0, r = 20, b = 0, l = 0)), 
          plot.caption = element_text(size = 12, margin = margin(t = 20, r = 0, b = 0, l = 0)),
          legend.position = "none", 
          panel.grid.minor = element_blank(), 
          panel.grid.minor.x = element_blank(),
          panel.grid.major.x = element_blank()) +
    #Specify that you want to show date axis increments in months. You can also specify any number of months
    #Also specify the format of the labels to be abbreviated using %b. 
    scale_x_date(date_breaks = "1 months",
                 date_labels = "%b") +
    #Add a plot title and axes titles: Graph title - New daily diagnosed COVID-19 cases in QC; X-axis - Time (days); 
    #Y-axis: New daily confirmed cases
    ggtitle("New daily diagnosed COVID-19 cases in QC") +
    xlab("Time (days)") +
    ylab("New daily confirmed cases") 
  
  #You've stored your plot as an object, so run this line to see our plot in the viewer window
  QCnew_daily_cases_plot
  
  #Save your plot as a png to your output folder using "ggsave". Name it "QCnew_daily_cases_plot" 
  #and automatically add today's date to the name.
  #To automatically add today's date we can use the Sys.Date() function. We create an object called today and assign it to be Sys.Date()
  today <- Sys.Date()
  #Now we can save our plot
  ggsave(paste0(output_folder, "/QCnew_daily_cases_plot_", today, ".png"), 
         plot = QCnew_daily_cases_plot,
         width = 11, 
         height = 7, 
         units = "in")  

#Create a multipanel figure with ON and QC
  #Use the ggarrange function to combine and layout multiple graphs in one figure
  #The ncol and nrow option tells R how many rows and colomns you want in your figure. In this case we want 2 columns and 1 row
  ALLnew_daily_cases_plot <- ggarrange(ONnew_daily_cases_plot, QCnew_daily_cases_plot,
                                       hjust=2.5,
                                       ncol = 2, nrow = 1)  
  #To display your results:
  ALLnew_daily_cases_plot
  
  #Export the figure with annotations (i.e. title, and axis labels)
  ggsave(paste0(output_folder, "/ALLnew_daily_cases_plot_", today, ".png"), 
           plot = annotate_figure(ALLnew_daily_cases_plot,
                             top = text_grob("New daily diagnosed COVID-19 cases by province",
                                             face = "bold", size = 16)),
         width = 14, 
         height = 11, 
         units = "in")

  














    


