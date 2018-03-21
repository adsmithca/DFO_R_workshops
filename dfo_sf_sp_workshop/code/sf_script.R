# A script to demonstrate how to map data in R using the sp packages

# load required packages
library(sf)
library(dplyr)
library(classInt)
library(RColorBrewer)
library(ggplot2)

# load the data
abiotic<-read.csv("data\\trawl_abiotic.csv")
biomass<-read.csv("data\\trawl_biomass.csv")

# probably makes sense to combine the two data.frames...
fielddata<- biomass %>%
  left_join(abiotic)

# load the map layers
# dsn is the data source name. This is typically the folder where the shapefile (and typically several other files with the same name, but different extension) are located
# layer is the name of the shapefile before the file extension
nafo.div.shelf_sf<-st_read(dsn="data\\map_layers",layer="nafo_div_shelf") %>%
  st_set_crs(4269) #this sets the projection string
divisions_sf<-st_read(dsn="data\\map_layers\\Divisions",layer="Divisions")%>%
  st_set_crs(4269)

# It is quite simple to look at the map layers...
# nafo.div.shelf
plot(nafo.div.shelf_sf)
# divisions
plot(divisions_sf)

# and adding new data to these maps is pretty easy as well:
trawl_sf = st_as_sf(fielddata, coords= c("long","lat")) %>%
  st_set_crs("+proj=longlat +datum=NAD83 +no_defs +ellps=GRS80 +towgs84=0,0,0")

# Can also use epsg codes (that include all the above data):
trawl_sf = st_as_sf(fielddata, coords= c("long","lat")) %>%
  st_set_crs(4269)

#You can view the whole dataset with plot:
plot(trawl_sf)


# To show the two sets of data (the points and the nafo.div.shelf) in the same plot, using base r, simply do the following:
makeTransparent<-function(someColor, alpha=100)
{
  newColor<-col2rgb(someColor)
  apply(newColor, 2, function(curcoldata){rgb(red=curcoldata[1], green=curcoldata[2],blue=curcoldata[3],alpha=alpha, maxColorValue=255)})
}

par(mfrow=c(1,1))
plot(nafo.div.shelf_sf$geometry)
plot(trawl_sf, add=TRUE,pch=19, cex=0.5,col=makeTransparent("black",alpha = 25))


# to show the values of a variable, we first have to create a colour scale for it
# doing this here using a colour gradient from the package RColorBrewer
pal<-brewer.pal(n=10,name="RdYlBu") # first create a colour palette with 10 intervals with the RdYlBu colour palette. I'm choosing to use 10 intervals just because I figured that makes sense. You can use anywhere from 3 to 11 intervals for this. Using other means, you can come up with finer scales or different colour patterns if you wanted to. The Rcolorbrewer colour schemes are often designed to avoid issues with colour blindness and to meet various "rules" associated with colour schemes. 
palinv<-pal[10:1] 
temp10<-classIntervals(var=trawl_sf$temp_bottom,n=10,style="equal")
temp10cols<-findColours(clI=temp10,pal=palinv)

# and then plot it
par(mfrow=c(1,1))
plot(nafo.div.shelf_sf$geometry)
plot(trawl_sf,col=makeTransparent(temp10cols,50),pch=19,cex=0.5,add=TRUE)
legend("topleft", fill = attr(temp10cols, "palette"),legend = names(attr(temp10cols, "table")), bty = "n")



#Subsetting ####
plot(nafo.div.shelf_sf$geometry)
plot(trawl_sf,
     col=makeTransparent(temp10cols,50),
     pch=19,
     cex=0.5,
     add=TRUE)

# this plot isn't quite satisfying...


# first figure out what spatial extent we need
trawl_bbox = st_bbox(trawl_sf)
trawl_bbox
#    xmin     ymin     xmax     ymax 
# -58.1767  45.7817 -46.8567  55.3383 

trawl_bbox = trawl_bbox + c(-2, -1,2,1)
trawl_bbox = trawl_bbox %>%
  st_as_sfc()%>%
  st_set_crs(4269)

# take a look at the original SpatialPolygon and the clipping polygon
plot(nafo.div.shelf_sf$geometry)
plot(trawl_bbox,border="red",add=TRUE)


# Now we can clip the division map to this bounding box by using
# the st_intersection function:
nafo.div.shelf_clipped_sf = nafo.div.shelf_sf %>%
  st_intersection(trawl_bbox)



# plotting everything up and throwing on a legend
par(mfrow=c(1,1))
plot(trawl_bbox) # included here only because it makes the figure look neater
plot(nafo.div.shelf_clipped_sf$geometry,add=TRUE)
plot(trawl_sf,col=makeTransparent(temp10cols,50),pch=19,cex=0.5,add=TRUE)
legend("topright", fill = attr(temp10cols, "palette"),legend = names(attr(temp10cols, "table")), bty = "y",bg="white")

# Finally, we've got these nice polygons, can we come up with something to fill them? 
# We'll find the median water temperature by region (polygon)

# We can combine a lot of the seperate steps we used in the prior analysis:
median_temp_map = trawl_sf %>%
  st_join(nafo.div.shelf_clipped_sf)%>%
  group_by(ZONE)%>%
  summarize(med.temp =median(temp_bottom,na.rm = T))%>%
  ungroup()%>%
  st_set_geometry(NULL) %>% #Removes the geometry type from this data
  left_join(nafo.div.shelf_clipped_sf)%>% #adds the geometry (the polygons) from the NAFO divisions
  st_as_sf() #turns it back into a 'sf' object

median_temp_map

# need to divide these up into intervals for a figure we're going to make
tempbrks<-classIntervals(median_temp_map$med.temp,n=4,style="fixed",fixedBreaks=seq(-2,4,1))
# get the colour associated with the interval
median_temp_map$colint<-findColours(tempbrks,palinv)


# plot everything up
plot(median_temp_map$geometry,col=median_temp_map$colint)
# note that we can access individual columns in the SpatialPolygonDataFrame for plotting purposes...
plot(trawl_sf,col=makeTransparent(temp10cols,50),pch=19,cex=0.5,add=TRUE)
