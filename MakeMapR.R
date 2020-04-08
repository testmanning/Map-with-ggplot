




# Title:  MakeMapR.R
# 07 Nov 2019
# Author: Tim Assal
# This script will laod sevceral shapefiles and create a series of maps using ggplot2

##########################################
# Prior to this excercise, create a new RStudio Project in a new working directory, name of your choice
# Then in Finder or WindowsExplorer, create two sub directories: "SourceData" and "Figures"
# Place all data into the "SourceData" directory
#########################################

#packages

#install packages if they have not been on your machine
#install.packages(c("raster", "ggplot2", "sf", "gridExtra"))


#load libraries
library(raster)
library(ggplot2)
library(sf)
library(gridExtra)

#######################
# Map 1 - KSU Campus Buildings
#######################

###
#load shapefiles
###
KSU_Campus <- st_read("SourceData/KSU_Boundary.shp")
KSU_Buildings <- st_read("SourceData/KSU_Buildings.shp")

###
# Make Map
###
Map1<-ggplot() +
  #load campus boundary first
  geom_sf(data = KSU_Campus, size = 0.25, color = "black", fill = "gray80") + 
  #load buildings second - ggplot adds each layer in order, so we want buildings on top
  geom_sf(data = KSU_Buildings, size = 0.5, color = "darkblue", fill = "yellow") +
  coord_sf()+
  #add labels
  labs(title = "Kent State University Campus",
       subtitle = "Building Footprints - 2019", 
       caption = "Data Sources: KSU Data (Map It!); OH Data (Ohio DOT)")
Map1 #plot map
ggsave("Figures/KSU_Map.jpg", Map1, width=8, height=4, dpi=300) #save map
#######################


#######################
# Map 2 - Kent Vicinity Map
#######################

#Let's create a second map so we know were in Ohio Kent is located

###
#load shapefiles
###
OH_County <- st_read("SourceData/OH_Counties.shp")
OH_Kent <- st_read("SourceData/Kent_OH_Boundary.shp")

###
# Make Map
###
Map2<-ggplot() +
  #load county boundaries first
  geom_sf(data = OH_County, size = 0.25, color = "black", fill = "gray80") + 
  #load Kent boundary second - ggplot adds each layer in order
  geom_sf(data = OH_Kent, size = 0.25, color = "black", fill = "red") +
  #here is a different way to add a title
  ggtitle("Location Map") + 
  #let's hide the axis ticks and labels since we aren't worried about those details at this scale
  theme(axis.ticks = element_blank(), axis.text.x = element_blank(), axis.text.y=element_blank())
Map2

# Not bad, but if we show the town of Kent as a polygon is probably won't scale well

# Let's convert the Kent polygon to a centroid, then we'll show it on the map as a point
OH_Kent_Centroid <- st_geometry(st_centroid(OH_Kent))

###
# Make another map
###

inset.map<-ggplot() +
  #load county boundaries first
  geom_sf(data = OH_County, size = 0.25, color = "black", fill = "gray80") + 
  #load Kent centroid; we'll display as a square (shape = 15)
  geom_sf(data = OH_Kent_Centroid, size = 1, color = "red", shape= 15) +
  ggtitle("Kent Location Map") + 
  theme(axis.ticks = element_blank(), axis.text.x = element_blank(), 
        axis.text.y=element_blank(),
        panel.border = element_rect(colour = "black", fill=NA, size=1))
inset.map

# Much better!
#######################

#######################
# Map 3 - Composite Map
#######################

# Now let's put the two maps together into a composite map
# Since we already wrote the two maps to objects, we can simply call them here and arrange using gridExtra
# We'll have two columns, specify the order and the width of each map
composite_map<-grid.arrange(Map1, inset.map, ncol=2, widths=c(7,3))
composite_map
ggsave("Figures/Composite_map.jpg", composite_map, width=8, dpi=300)
#######################
