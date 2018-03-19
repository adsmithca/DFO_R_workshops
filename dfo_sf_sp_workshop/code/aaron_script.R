# A script to demonstrate how to map data in R using the sp packages

# load required packages
require(sp)
require(rgdal)
require(classInt)
require(RColorBrewer)
require(RgoogleMaps)
require(raster)
require(plyr)

vignette# load the data
abiotic<-read.csv("e:\\dfo_r_workshops\\dfo.r.workshops\\dfo_sf_sp_workshop\\data\\trawl_abiotic.csv")
biomass<-read.csv("e:\\dfo_r_workshops\\dfo.r.workshops\\dfo_sf_sp_workshop\\data\\trawl_biomass.csv")

# check out the abiotic and biomass data
head(abiotic)
head(biomass)

# probably makes sense to combine the two data.frames...
fielddata<-merge(abiotic,biomass,all.x=TRUE)

# load the map layers
nafo.div.shelf<-readOGR(dsn="e:\\dfo_r_workshops\\dfo.r.workshops\\dfo_sf_sp_workshop\\data\\map_layers",layer="nafo_div_shelf")
divisions<-readOGR(dsn="e:\\dfo_r_workshops\\dfo.r.workshops\\dfo_sf_sp_workshop\\data\\map_layers\\Divisions",layer="Divisions")

# It is quite simple to look at the map layers...
# nafo.div.shelf
plot(nafo.div.shelf)
# divisions
plot(divisions)

# plotting data on these maps is a bit more complicated

# at the most basic level we can create spatial points 
# essentially positions, without any other info...
# first step is to create a matrix of longs and lats (note that longitude has to be first; further note that a matrix is distinct from a dataframe!!!)
trawl_mat<-cbind(fielddata$long, fielddata$lat)

# at some point you have to give the points a projection so that the computer knows how to position the points when plotting them with another layer

# one way to get the points is to use the projection of an underlying layer. In this case, nafo.div.shelf or divisions. We can get that using the "proj4string" function.
proj4string(nafo.div.shelf)
proj4string(divisions)

# there is no difference between the two projections, so we can use either one or alternatively type it in by hand...

# to create a SpatialPoints class object, simply provide a set of points and the projection...

# projection typed in by hand;the CRS function formats the projection for use in SpatialPoints
trawls.sp<-SpatialPoints(trawl_mat, proj4string=CRS("+proj=longlat +datum=NAD83 +no_defs +ellps=GRS80 +towgs84=0,0,0"))

# Projection derived from the nafo.div.shelf object...
# initially just say that the points are unprojected lats and longs
trawls.sp1<-SpatialPoints(trawl_mat, CRS("+proj=longlat")) 
# then transform the unprojected points. You can also do this for data that has already been projected but you want to show it in a different projection
trawls.sp1.trans<-spTransform(trawls.sp1, CRS(proj4string(nafo.div.shelf)))


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
# it is generally a good idea to give the row names of the coordinates and data.frame some names that will be used to link them...
trawl_mat<-cbind(fielddata$long, fielddata$lat) # same command as used on line 33
row.names(trawl_mat)<-fielddata$trawl_id

# clean up the data.frame a bit for use here (e.g. take out the stuff being used elsewhere)
trawl_clean<-fielddata[,which(!colnames(fielddata) %in% c("trawl_id","long","lat"))]
row.names(trawl_clean)<-fielddata$trawl_id

# create the SpatialPointsDataFrame
field.spdf<-SpatialPointsDataFrame(trawl_mat, trawl_clean, proj4string = CRS("+proj=longlat"), match.ID=TRUE)
field.spdf.trans<-spTransform(field.spdf,CRS(proj4string(nafo.div.shelf)))

# to show the values of a variable, we first have to create a colour scale for it
# doing this here using a colour gradient from the package RColorBrewer
pal<-brewer.pal(n=10,name="RdYlBu") # first create a colour palette with 10 intervals with the RdYlBu colour palette. See if you can find a colour palette that you like better...
palinv<-pal[10:1] # because I think red should be "warm" and blue should be cold

# You then have to divide up the observed values into a similar number of intervals
# here I use equal intervals, figure out a different interval scheme to use
temp10<-classIntervals(var=field.spdf.trans$temp_bottom,n=10,style="equal")

# finally, combine the intervals with the colours
temp10cols<-findColours(temp10,palinv)

# and then plot it
plot(nafo.div.shelf)
plot(field.spdf.trans,col=makeTransparent(temp10cols,50),pch=19,cex=0.5,add=TRUE)

# and you can add a scale...
legend("topleft", fill = attr(temp10cols, "palette"),legend = names(attr(temp10cols, "table")), bty = "n")

# Can you redo this for one of the other variable? Come up with a sensible interval scheme and appropriate colours. 


# Sometimes it's better to stick this on a Google Map rather than trying to mess around with shape files...

# first create a data.frame with your markers + we'll give our colours for water temperatures...

# need to redo the process we did above for plotting on shapefiles as the observation order got altered when we made a SpatialPointsDataFrame and Google Maps doesn't deal the way I want it to with missing data...
fieldtemps<-fielddata[which(!is.na(fielddata$temp_bottom)),]
fieldtemp10<-classIntervals(var=fieldtemps$temp_bottom,n=10,style="equal")
fieldtemp10col<-findColours(fieldtemp10,palinv)

mymarkers=cbind.data.frame(lat=fieldtemps$lat,lon=fieldtemps$lon,col=fieldtemp10col)
# First step is to find your basemap. To do this, you need to know the extent of your data points e.g. make a bounding box...
bb<-qbbox(lat=mymarkers[,"lat"],lon=mymarkers[,"lon"])
# download the map
mymap<-GetMap.bbox(bb$lonR,bb$latR,destfile="firstmap.png",maptype="satellite")
tmp<-PlotOnStaticMap(mymap,lat=mymarkers[,"lat"],lon=mymarkers[,"lon"],cex=0.5,pch=19,col=mymarkers[,"col"])

# what's gone wrong?

# try this instead...
tmp<-PlotOnStaticMap(mymap,lat=mymarkers[,"lat"],lon=mymarkers[,"lon"],cex=0.5,pch=19,col=fieldtemp10col)
legend("topright", fill = attr(temp10cols, "palette"),legend = names(attr(temp10cols, "table")), bty = "y",bg="white")



# moving back to the shapefiles...

# how can we subset a shapefile - in this case a SpatialPolygonsDataFrame, so that we can do a bit better map...

# first figure out what spatial extent we need
summary(field.spdf.trans)
# Coordinates:
#   min      max
# coords.x1 -58.1767 -46.8567
# coords.x2  45.7817  55.3383

# Y is close to right, lets try +/- 1
# X isn't quite there. Lets go +/- 2

# create our clipping polygon (from https://stackoverflow.com/questions/13982773/crop-for-spatialpolygonsdataframe)
CP<-as(extent(-60.1767, -44.8567, 44.7817, 56.3383),"SpatialPolygons") # for extent - (length=4; order= xmin, xmax, ymin, ymax)
# have to give it a projection
proj4string(CP)<-CRS("+proj=longlat")

# take a look at the original SpatialPolygon and the clipping polygon
plot(divisions)
plot(CP,add=TRUE)

# transform the clipping polygon so it matches the projection of the original
CP.trans<-spTransform(CP, CRS(proj4string(divisions)))

# gIntersection is used to clip the polygon - you could also do this for points or lines 
out <- gIntersection(divisions, CP.trans, byid=TRUE)

# plotting everything up and throwing on a legend
plot(CP.trans)
plot(out,add=TRUE)
plot(field.spdf.trans,col=makeTransparent(temp10cols,50),pch=19,cex=0.5,add=TRUE)
legend("topright", fill = attr(temp10cols, "palette"),legend = names(attr(temp10cols, "table")), bty = "y",bg="white")

# final thing is to find the median water temperature by region (polygon)

# use over to figure out which polygon each observation is resting in
pt.assign<-over(field.spdf.trans,out) # first term is the values you want to query and the second term is the data you're querying against
# pt.assign contains the assigned polygon for each point

# you can get the data.frame behind the field.spdf.trans SpatialPointsDataFrame using as.data.frame
retrievepts<-as.data.frame(field.spdf.trans)

# connect the point assignments
retrievepts<-cbind(retrievepts,pt.assign)

# get the median water temp by polygon
median.temp<-ddply(retrievepts,.(pt.assign),summarise,med.temp=median(temp_bottom,na.rm=TRUE))
# need to divide these up into intervals for a figure we're going to make
tempbrks<-classIntervals(median.temp$med.temp,n=6,style="fixed",fixedBreaks=seq(-2,4,1))

median.temp$colint<-findColours(tempbrks,palinv)

# now the hard part... need to have a data.frame with the same number of rows and order as the original spatial polygon...
# first get the polygon ID slots in order
polygonidvec<-getSpPPolygonsIDSlots(out) 

# next create the dataframe we are going to end up adding to the polygon
newdf<-data.frame(id=polygonidvec)

# also need a smaller data.frame with our median water temps. For this one, it's the median.temp data.frame from the ddply. The pt.assign column contains the index of the row.names that we want. We are going to use this to create a common column for merging the two...

# creating the shared column
median.temp$id<-polygonidvec[median.temp$pt.assign]
# merging
newdf<-merge(newdf,median.temp,all.x=TRUE)
# need to create a variable for the colour interval

# create the row.names
row.names(newdf)<-newdf$id
# clean-up data.frame
newdf<-newdf[,c("pt.assign","med.temp","colint")]

test<-SpatialPolygonsDataFrame(out,newdf)
plot(test,col=test$colint)
plot(field.spdf.trans,col=makeTransparent(temp10cols,50),pch=19,cex=0.5,add=TRUE)