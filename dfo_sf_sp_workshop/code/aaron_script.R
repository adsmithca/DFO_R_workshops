# A script to demonstrate how to map data in R using the sp packages

# load required packages
require(sp)
require(rgdal)

# load the data
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

field.spdf<-SpatialPointsDataFrame(trawl_mat, trawl_clean, proj4string = CRS("+proj=longlat"), match.ID=TRUE)
field.spdf.trans<-spTransform(field.spdf,CRS(proj4string(nafo.div.shelf)))

plot(nafo.div.shelf)
plot(field.spdf.trans,col=)