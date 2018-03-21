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
fielddata<-merge(abiotic,biomass,all.x=TRUE)

# load the map layers
# dsn is the data source name. This is typically the folder where the shapefile (and typically several other files with the same name, but different extension) are located
# layer is the name of the shapefile before the file extension
nafo.div.shelf_sf<-st_read(dsn="data\\map_layers",layer="nafo_div_shelf")
divisions_sf<-st_read(dsn="data\\map_layers\\Divisions",layer="Divisions")

# It is quite simple to look at the map layers...
# nafo.div.shelf
plot(nafo.div.shelf_sf)
# divisions
plot(divisions_sf)

# and adding new data to these maps is pretty easy as well:
trawls_sf = st_as_sf(fielddata, coords= c("long","lat")) %>%
  st_set_crs("+proj=longlat +datum=NAD83 +no_defs +ellps=GRS80 +towgs84=0,0,0")

# Can also use epsg codes (that include all the above data):
trawls_sf = st_as_sf(fielddata, coords= c("long","lat")) %>%
  st_set_crs(4269)

#You can view the whole dataset with plot:
plot(trawls_sf)


# To show the two sets of data (the points and the nafo.div.shelf) in the same plot, using base r, simply do the following:
makeTransparent<-function(someColor, alpha=100)
{
  newColor<-col2rgb(someColor)
  apply(newColor, 2, function(curcoldata){rgb(red=curcoldata[1], green=curcoldata[2],blue=curcoldata[3],alpha=alpha, maxColorValue=255)})
}

par(mfrow=c(1,1))
plot(nafo.div.shelf_sf$geometry)
plot(trawls_sf, add=TRUE,pch=19, cex=0.5,col=makeTransparent("black",alpha = 25))


# to show the values of a variable, we first have to create a colour scale for it
# doing this here using a colour gradient from the package RColorBrewer
pal<-brewer.pal(n=10,name="RdYlBu") # first create a colour palette with 10 intervals with the RdYlBu colour palette. I'm choosing to use 10 intervals just because I figured that makes sense. You can use anywhere from 3 to 11 intervals for this. Using other means, you can come up with finer scales or different colour patterns if you wanted to. The Rcolorbrewer colour schemes are often designed to avoid issues with colour blindness and to meet various "rules" associated with colour schemes. 
palinv<-pal[10:1] 
temp10<-classIntervals(var=trawls_sf$temp_bottom,n=10,style="equal")
temp10cols<-findColours(clI=temp10,pal=palinv)

# and then plot it
par(mfrow=c(1,1))
plot(nafo.div.shelf_sf$geometry)
plot(trawls_sf,col=makeTransparent(temp10cols,50),pch=19,cex=0.5,add=TRUE)
legend("topleft", fill = attr(temp10cols, "palette"),legend = names(attr(temp10cols, "table")), bty = "n")



#Subsetting ####

# how can we subset a shapefile - in this case a SpatialPolygonsDataFrame, so that we can do a bit better map...
plot(nafo.div.shelf_sf)
plot(field.spdf.trans,col=makeTransparent(temp10cols,50),pch=19,cex=0.5,add=TRUE)
# this plot isn't quite satisfying...


# first figure out what spatial extent we need
trawl_bbox = st_bbox(trawls_sf)
trawl_bbox
#    xmin     ymin     xmax     ymax 
# -58.1767  45.7817 -46.8567  55.3383 


# take a look at the original SpatialPolygon and the clipping polygon
plot(divisions)
plot(CP,border="red",add=TRUE)

# is it clear on how you'd do the trial and error to narrow this down?

# transform the clipping polygon so it matches the projection of the original (not really needed as there are no projections going on here, but it solves a warning message in gIntersection in a few lines)
CP.trans<-spTransform(CP, CRS(proj4string(divisions)))

# gIntersection is used to clip the polygon - you could also do this for points or lines 
out <- gIntersection(divisions, CP.trans, byid=TRUE)

# plotting everything up and throwing on a legend
plot(CP.trans) # included here only because it makes the figure look neater
plot(out,add=TRUE)
plot(field.spdf.trans,col=makeTransparent(temp10cols,50),pch=19,cex=0.5,add=TRUE)
legend("topright", fill = attr(temp10cols, "palette"),legend = names(attr(temp10cols, "table")), bty = "y",bg="white")

# Finally, we've got these nice polygons, can we come up with something to fill them? 
# We'll find the median water temperature by region (polygon)

# First step is to figure out which polygon each observation is resting in
pt.assign<-over(x=field.spdf.trans,y=out)
# x is the location of the queries
# y is the layer from which the geometries or attributes are queried
# not used, but could also include the logical "returnList". This would return a list for each query so the we could get all the polygons overlayen by a point in the cases were the point is right on the edge or vertex of some polygons. I'm skipping this because it's somewhat unimportant for this exercise (plus a lot of hassle to deal with). When you only get one value per query (as is done here) it only provides the last identified polygon that a point (or line or polyon) was identified as being in based on the algorithm used to evaluate this.
# pt.assign contains the assigned polygon for each point

# you can get the data.frame behind the field.spdf.trans SpatialPointsDataFrame using as.data.frame
retrievepts<-as.data.frame(field.spdf.trans)

# connect the point assignments with the data.frame
retrievepts<-cbind(retrievepts,pt.assign)

# get the median water temp by polygon
# my solution using plyr
median.temp<-ddply(retrievepts,.(pt.assign),summarise,med.temp=median(temp_bottom,na.rm=TRUE))
# Eric's solution using dplyr
median.temp2<-retrievepts %>% 
  group_by(pt.assign) %>%
  summarise(med.temp=median(temp_bottom, na.rm=TRUE)) %>%
  ungroup()

# need to divide these up into intervals for a figure we're going to make
tempbrks<-classIntervals(median.temp2$med.temp,n=6,style="fixed",fixedBreaks=seq(-2,4,1))
# get the colour associated with the interval
median.temp2$colint<-findColours(tempbrks,palinv)

# now the hard part... need to have a data.frame with the same number of rows and order as the original spatial polygon...
# first get the polygon ID slots in order
# this is the way I did it, but apparently the function has been depreciated and we're supposed to use sapply instead
polygonidvec<-getSpPPolygonsIDSlots(out) 
# the way you are supposed to do it now...
polygonidvec<-sapply(slot(out,"polygons"),function(x) slot(x,"ID"))
# apply is a function that acts like a for loop and is applied to a data.frame and then returns a vector of results e.g.

# example<-data.frame(col1=1:10,col2=11:20)
# results<-rep(NA,10)
# for (i in 1:10){
#   results[i]<-example[i,1]+example[i,2]
# }
# results
# apply(example,1,sum)

# sapply is a variant of apply that is applied to a list and applies a function to each list element. 
# Spatial data is stored in what is called a s4 class of object. Components of the object are stored in "slots". The slot function allows you to access a particular slot within the S4 object. 
getClass("SpatialPolygons")
# In this case, we want to access the data stored in the "polygons" slot. That's what slot(out,"polygons") is getting us. It turns out that the the "polygons" slot contains a list of S4 objects - one S4 object for each polygon in this layer with there being 533 in the out layer - one for each of the 533 polygons making up the layer.  
# In this case, the sapply is going to do something to each of the 533 S4 objects in the polygon slot. 
# The thing that is going to be done to each object is "function(x) slot(x,"ID")". For this function x equals one of the S4 objects from the list of 533 S4 objects for this layer. Slot here behaves just like it did before, but this time it's getting the contents of the "ID" slot for each S4 object.  


# next create the dataframe we are going to end up adding to the polygon
newdf<-data.frame(id=polygonidvec)

# also need a smaller data.frame with our median water temps. For this one, it's the median.temp data.frame from the ddply/dplyr solution. The pt.assign column contains the index of the row.names that we want. We are going to use this to create a common column for merging the two...

# creating the shared column
median.temp2$id<-polygonidvec[median.temp2$pt.assign]
# merging
newdf<-merge(x=newdf,y=median.temp2,all.x=TRUE)
# x = the first data.frame you want to merge
# y = the second data.frame you want to merge
# all.x=TRUE means I want to keep every element of x regardless of whether it merges with anything in y. 

# create the row.names
row.names(newdf)<-newdf$id
# clean-up data.frame
newdf<-newdf[,c("pt.assign","med.temp","colint")]

# build the SpatialPolygonsDataFrame -
newSPDF<-SpatialPolygonsDataFrame(Sr=out,data=newdf)
# Sr is an object of class SpatialPolygons
# data = a data.frame; the number of rows should be equal to the number of polygons in object Sr

# plot everything up
plot(newSPDF,col=newSPDF$colint)
# note that we can access individual columns in the SpatialPolygonDataFrame for plotting purposes...
plot(field.spdf.trans,col=makeTransparent(temp10cols,50),pch=19,cex=0.5,add=TRUE)
