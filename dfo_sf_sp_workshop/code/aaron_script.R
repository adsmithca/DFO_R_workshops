# A script to demonstrate how to map data in R using the sp packages

# load required packages
require(sp)
require(rgdal)
require(classInt)
require(RColorBrewer)
require(RgoogleMaps)
require(raster)
require(dplyr)
require(rgeos)

# load the data
abiotic<-read.csv("dfo_sf_sp_workshop\\data\\trawl_abiotic.csv")
biomass<-read.csv("dfo_sf_sp_workshop\\data\\trawl_biomass.csv")

# check out the abiotic and biomass data
head(abiotic)
head(biomass)

# probably makes sense to combine the two data.frames...
fielddata<-merge(abiotic,biomass,all.x=TRUE)

# load the map layers
# dsn is the data source name. This is typically the folder where the shapefile (and typically several other files with the same name, but different extension) are located
# layer is the name of the shapefile before the file extension
nafo.div.shelf<-readOGR(dsn="dfo_sf_sp_workshop\\data\\map_layers",layer="nafo_div_shelf")
divisions<-readOGR(dsn="dfo_sf_sp_workshop\\data\\map_layers\\Divisions",layer="Divisions")

# It is quite simple to look at the map layers...
# nafo.div.shelf
plot(nafo.div.shelf)
# divisions
plot(divisions)

# plotting data on these maps is a bit more complicated

# at the most basic level we can create a SpatialPoints object 
# essentially coordinates, without any other info...
# first step is to create a matrix of longs and lats (note that longitude has to be first; further note that a matrix is distinct from a dataframe!!!)
trawl_mat<-cbind(fielddata$long, fielddata$lat)

# at some point you have to give the points a projection so that the computer knows how to position the points when plotting them with another layer

# you can get an overview of the coordinate reference system (CRS) in R from this document: https://www.nceas.ucsb.edu/~frazier/RSpatialGuides/OverviewCoordinateReferenceSystems.pdf

# working from that document, you could then come up with a projection for your points by hand when you create a SpatialPoints object (coordinates without data)

# projection typed in by hand;the CRS function formats the projection for use in SpatialPoints
trawls.sp<-SpatialPoints(coords=trawl_mat, proj4string=CRS("+proj=longlat +datum=NAD83 +no_defs +ellps=GRS80 +towgs84=0,0,0"))
# coords is a matrix of coordinates for your points
# proj4string is spatial projection string of class CRS

# The easier way to give your points a projection is to use the projection of an underlying layer. In this case, nafo.div.shelf or divisions. We can get that using the "proj4string" function.
proj4string(nafo.div.shelf)
proj4string(divisions)
# just have to give proj4string an existing projected layer

# there is no difference between the two projections, so we can use either one

# to create a SpatialPoints class object using an existing projection (in this case the nafo.div.shelf object), simply provide a set of points and the projection...

# Initially just say that the points are unprojected lats and longs
trawls.sp1<-SpatialPoints(coords=trawl_mat, proj4string=CRS("+proj=longlat")) 

# Then transform the unprojected points. You can also do this for data that has already been projected but you want to show it in a different projection
trawls.sp1.trans<-spTransform(x=trawls.sp1, CRSobj=CRS(proj4string(nafo.div.shelf)))
# x is the object to be transformed
# CRSobj is an object of class CRS which the object to be tranformed is being transformed to

# To show the two sets of data (the points and the nafo.div.shelf) in the same plot, using base r, simply do the following:
plot(nafo.div.shelf)
plot(trawls.sp, add=TRUE)

# at this point I want to take a brief aside to introduce a really cool and useful short function that Nick Sabbe developed on StackOVerflow (https://stackoverflow.com/questions/8047668/transparent-equivalent-of-given-color)... 

# This function lets you choose a colour and how transparent it should be...
makeTransparent<-function(someColor, alpha=100)
{
  newColor<-col2rgb(someColor)
  apply(newColor, 2, function(curcoldata){rgb(red=curcoldata[1], green=curcoldata[2],blue=curcoldata[3],alpha=alpha, maxColorValue=255)})
}

# Gives a bit better idea as to the density of the samplying at different points
plot(nafo.div.shelf)
plot(trawls.sp,pch=19,col=makeTransparent("black",10),add=TRUE, cex=0.5)


# Points are nice, but it would be good if we can include some data as well...
# For  it is generally a good idea to give the row names of the coordinates and data.frame some names that will be used to link them...
trawl_mat<-cbind(fielddata$long, fielddata$lat) # same command as used on line 33
row.names(trawl_mat)<-fielddata$trawl_id

# clean up the data.frame a bit for use here (e.g. take out the stuff being used elsewhere)
trawl_clean<-fielddata[,which(!colnames(fielddata) %in% c("trawl_id","long","lat"))]
row.names(trawl_clean)<-fielddata$trawl_id

# create the SpatialPointsDataFrame
field.spdf<-SpatialPointsDataFrame(coords=trawl_mat, data=trawl_clean, proj4string = CRS("+proj=longlat"), match.ID=TRUE)
# coords is a matrix with the spatial coordinates
# data is a data.frame with the data you want linked to the coordinates. Number of rows in the data needs to equal number of rows in coords
# proj4string is the projection string for the data
# match.ID = TRUE means that assuming the coords and data both have specified (as opposed to automatically generated) rownames the data and coords are matched by rownames.

# transforming the SpatialPointsDataFrame
field.spdf.trans<-spTransform(field.spdf,CRS(proj4string(nafo.div.shelf)))

# to show the values of a variable, we first have to create a colour scale for it
# doing this here using a colour gradient from the package RColorBrewer
pal<-brewer.pal(n=10,name="RdYlBu") # first create a colour palette with 10 intervals with the RdYlBu colour palette. I'm choosing to use 10 intervals just because I figured that makes sense. You can use anywhere from 3 to 11 intervals for this. Using other means, you can come up with finer scales or different colour patterns if you wanted to. The Rcolorbrewer colour schemes are often designed to avoid issues with colour blindness and to meet various "rules" associated with colour schemes. 

# I then invert the colour order because I think red should be "warm" and blue should be cold
palinv<-pal[10:1] 

# Our colour scheme is going to divide the points into 10 intervals. Now we have to actually divide the points into the 10 intervals...

# I've decided to use equal intervals because it is just basic temperature data
temp10<-classIntervals(var=field.spdf.trans$temp_bottom,n=10,style="equal")
# var is the data field that I want to split up into intervals
# n is the number of intervals
# style is how I want to split things up into intervals, there are many other options for this

# finally, combine the intervals with the colours
temp10cols<-findColours(clI=temp10,pal=palinv)
# clI is a classIntervals object (produced by the classIntervals function above)
# pal is a vector of at least two colour names

# and then plot it
plot(nafo.div.shelf)
plot(field.spdf.trans,col=makeTransparent(temp10cols,50),pch=19,cex=0.5,add=TRUE)

# and you can add a scale...
legend("topleft", fill = attr(temp10cols, "palette"),legend = names(attr(temp10cols, "table")), bty = "n")

# Can you redo this for one of the other variable - say shrimp? Come up with a sensible interval scheme and appropriate colours. 


# Sometimes it's better to stick this on a Google Map rather than trying to mess around with shape files...

# first create a data.frame with your markers + we'll give our colours for water temperatures...

# need to redo the process we did above for plotting on shapefiles as the observation order got altered when we made a SpatialPointsDataFrame and Google Maps doesn't deal the way I want it to with missing data...
# first I get rid of any observations with missing bottom temperatures
fieldtemps<-fielddata[which(!is.na(fielddata$temp_bottom)),]
# split the temperatures into intervals like we did before
fieldtemp10<-classIntervals(var=fieldtemps$temp_bottom,n=10,style="equal")
# get the colour for each observation
fieldtemp10col<-findColours(fieldtemp10,palinv)

# This is just a data.frame to hold everything for the plot. You probably could skip this step if you wanted to. I'm keeping this for a short exercise in a few steps...
mymarkers=cbind.data.frame(lat=fieldtemps$lat,lon=fieldtemps$lon,col=fieldtemp10col)
# First step is to find your basemap. To do this, you need to know the extent of your data points e.g. make a bounding box...
bb<-qbbox(lat=mymarkers[,"lat"],lon=mymarkers[,"lon"])

# download the map - this step is commented out because most people here won't have access to the internet while working on this
#mymap<-GetMap.bbox(bb$lonR,bb$latR,destfile="dfo_sf_sp_workshop\\data\\firstmap.png",maptype="satellite")

# Saving the mapfile for later use offline
#save(mymap,file="newfmap.Rdata")

# reloading the data for use offline
mymap<-get(load("newfmap.Rdata"))
tmp<-PlotOnStaticMap(mymap,lat=mymarkers[,"lat"],lon=mymarkers[,"lon"],cex=0.5,pch=19,col=mymarkers[,"col"])

# what's gone wrong?

# try this instead...
tmp<-PlotOnStaticMap(mymap,lat=mymarkers[,"lat"],lon=mymarkers[,"lon"],cex=0.5,pch=19,col=fieldtemp10col)

# sticking on a legend
legend("topright", fill = attr(temp10cols, "palette"),legend = names(attr(temp10cols, "table")), bty = "y",bg="white")


# moving back to the shapefiles...

# how can we subset a shapefile - in this case a SpatialPolygonsDataFrame, so that we can do a bit better map...
plot(nafo.div.shelf)
plot(field.spdf.trans,col=makeTransparent(temp10cols,50),pch=19,cex=0.5,add=TRUE)
# this plot isn't quite satisfying...


# first figure out what spatial extent we need
summary(field.spdf.trans)
# Coordinates:
#   min      max
# coords.x1 -58.1767 -46.8567
# coords.x2  45.7817  55.3383

# Y is close to right, lets try +/- 1
# X isn't quite there. Lets go +/- 2
# I actually started with a different set of values, but rather than forcing you through the trial and error, I've skipped to my final choice of coordinates

# create our clipping polygon (from https://stackoverflow.com/questions/13982773/crop-for-spatialpolygonsdataframe)
CP<-as(extent(-60.1767, -44.8567, 44.7817, 56.3383),"SpatialPolygons") # for extent - (length=4; order= xmin, xmax, ymin, ymax)
# have to give it a projection
proj4string(CP)<-CRS("+proj=longlat")

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
