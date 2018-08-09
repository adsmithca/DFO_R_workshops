# A script to demonstrate how to map data in R using the sp packages

# load required packages
library(sf)
library(sp)
require(rgdal)
library(dplyr)
library(classInt)
library(RColorBrewer)
library(ggplot2)

# load the data
abiotic<-read.csv("data\\trawl_abiotic.csv")
biomass<-read.csv("data\\trawl_biomass.csv")

# probably makes sense to combine the two data.frames...
trawl_data<- biomass %>%
  left_join(abiotic)

#This is how you'd set the data up for using in sp:
trawl_mat<-cbind(trawl_data$long, trawl_data$lat) # same command as used on line 33
row.names(trawl_mat)<-trawl_data$trawl_id
trawl_clean<-trawl_data[,which(!colnames(trawl_data) %in% c("trawl_id","long","lat"))]
row.names(trawl_clean)<-trawl_data$trawl_id

trawl_sp = SpatialPointsDataFrame(coords=trawl_mat, 
                                   data=trawl_clean, 
                                   proj4string = CRS("+proj=longlat +datum=NAD83 +no_defs +ellps=GRS80 +towgs84=0,0,0"), 
                                   match.ID=TRUE)

newfoundland_sp<-readOGR(dsn = "data/map_layers/atlantic_map.shp")

#This is the sf version of the data
trawl_sf = st_as_sf(trawl_data, coords= c("long","lat")) %>%
  st_set_crs("+proj=longlat +datum=NAD83 +no_defs +ellps=GRS80 +towgs84=0,0,0")
newfoundland_sf <- st_read(dsn = "data/map_layers/atlantic_map.shp")



#Now how you'd create a ggplot2 plot for an sp SpatialPointsDataFrame: ####

#Mercator projection:
sp_cod_mercator = ggplot(data= data.frame(trawl_sp), 
                     aes(x = coords.x1 , y=coords.x2))+
  geom_point(aes(color=log10(shrimp+0.1)))+
  geom_polygon(data=fortify(newfoundland_sp),aes(x=long,y=lat, group=piece))+
  coord_map(projection = "mercator")+
  scale_color_viridis_c()+
  theme_bw()

#Lambert conformal conic projection
sp_cod_lambert = ggplot(data= data.frame(trawl_sp), 
                     aes(x = coords.x1 , y=coords.x2))+
  geom_point(aes(color=log10(shrimp+0.1)))+
  geom_polygon(data=fortify(newfoundland_sp),aes(x=long,y=lat, group=piece))+
  coord_map(projection = "lambert",parameters = c(49, 77))+
  scale_color_viridis_c()+
  theme_bw()


#And how to do this type of plot with sf data: #### 
#(note: this requires the development version of ggplot2; you have to have Rtools
# installed to install this. If you have Rtools installed, you can run:
# devtools::install_github("tidyverse/ggplot2")

#Mercator projection:
sf_cod_mercator = ggplot(data= trawl_sf)+
  geom_sf(aes(color= log10(shrimp+0.1)))+
  geom_sf(data=newfoundland_sf)+
  scale_color_viridis_c()+
  theme_bw()

#Lambert conformal conic projection
sp_cod_lambert = ggplot(data= trawl_sf)+
  geom_sf(aes(color= log10(shrimp+0.1)))+
  geom_sf(data=newfoundland_sf)+
  scale_color_viridis_c()+
  coord_sf(crs = 3979)+
  theme_bw()
  


