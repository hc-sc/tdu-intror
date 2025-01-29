####################################################################
# PHACR Training
#                                               
# Purpose: Social network diagram with tidygraph package

# Data Used: tb_cases, tb_contacts
#
#                                               
# Author: Emma Cumming
# Created: 2020-10-30

# Modified By: Pasha Marcynuk
# Date Modified: 2020-12-15
####################################################################

# We are using the package tidygraph: [link](https://www.data-imaginist.com/2017/introducing-tidygraph/)

# First, we need to wrangle our cases and contacts data frames into node and edge data frames.
## This can be done in a thousand ways! The code below is just one way to do this. 

# Create an edge data frame (This depicts the relationship between the cases and the contacts)
edges <-  contacts %>% select(CaseID2, ContactID2) %>%    # we only need 2 variables for the edge data frame: the ids of cases and contacts
  rename(from = CaseID2, to = ContactID2) %>%             # rename columns to "from" and "to" 
  arrange(from,to)                                        # reorder the columns

#Create a node data frame 
# Pare down the case-contact list to show unique contacts only, excluding cases who are named as contacts
nodes_a <-  contacts %>%                                                                  # Create a node data frame called nodes_a from your contacts data
  filter(!grepl("CASE", ContactID))  %>%                                                  # Exclude all rows that contain "CASE" text string in the ContactID. 
  select(ContactID2, Gender, Contact_location, Agegroup, Contact_age_years) %>%           # Select the variables we need
  rename(ID = ContactID2, Location = Contact_location, Age_years = Contact_age_years) %>% # New name = Old name
  distinct() %>%                                                                          # De-duplicate: Select only unique rows 
  mutate(Classification = "Contact")                                                      # Create a new column and assign everyone the classification of 'Contact'

nodes_b <- cases %>%                                                                      #Create a node data frame called nodes_b from your cases data
  select(CaseID2, Gender, Location, Agegroup, Age_years) %>%
  rename(ID = CaseID2) %>%
  mutate(Classification = "Case")                                                         # Create a new col and assign all the classification of 'Case'

nodes <- rbind(nodes_a, nodes_b) ; rm(nodes_a, nodes_b)    # Bind the two matching data frames together. To do this, columns must have the same names and be in the same order.

# The next step is to convert our edge table into a tbl_graph object structure. Here, we use the as_tbl_graph() function from tidygraph; 
    #it can take many different types of input data, such as data.frame, matrix, dendrogram, igraph, etc.
# Rename edges and nodes (just for clarity in coding)
nodes_full <- nodes %>% 
  select(ID, Classification, Location ) %>% 
  arrange(ID)                                                     # Sort by ID
edges_full <- edges 

# Create tidygraph network object
network_full <- tbl_graph(nodes = nodes_full,                     # Tell tidygraph which data frame corresponds to nodes & edges
                          edges = edges_full, directed = FALSE)   # Relationships are non-directional in this case    


# Define labels that will appear on the graph
label_full <- nodes_full %>%
  select(ID) %>%    # ID is what we want to display as labels
  pull()

# Create network plot (note how similar this is to calling a ggplot!)
network_full %>%
  ggraph() +
  geom_edge_link0(color = "#bdbdbd") +                              # The colour of the lines connecting edges
  geom_node_point(aes(colour = Location, shape = Classification),   # The colour is dependent on Location, the shape on Classification              
                  alpha = 1,                                        # Transparency of the points
                  size = 4) +                                       # Size of the points 
  scale_fill_brewer(type = "qual",                                  # Colour palette selection
                    palette = 5) +
  geom_node_text(label = label_full,                                # Calling in the labels (called label_full) you defined a step earlier
                 repel = TRUE,                                      # So labels do not overlap
                 point.padding = 0.1, 
                 segment.color = NA) +
  theme(panel.background = element_blank(),                         # Theme formatting
        plot.title = element_text(size = 20), 
        legend.position = "bottom") +
  scale_shape_manual(values = c(15,16))                             # sets which shapes you want for points- see link for more options:
                                                                        # http://sape.inf.usi.ch/quick-reference/ggplot2/shape

# Save the resulting plot as an image in the outputs folder. Note that we want it to be pretty large (6"x7") on the page. 
ggsave(path = output_folder, filename= "plot_sna_location.jpeg", width = 6, height = 7)
