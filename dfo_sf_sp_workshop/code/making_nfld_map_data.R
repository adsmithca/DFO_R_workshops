library(rnaturalearth)
library(rnaturalearthdata)
library(sp)
library(sf)
library(dplyr)

canada_map = ne_countries(country="canada",scale = "medium")
canada_map = st_as_sf(canada_map) %>% 
  select(pop_est)
atlantic_bounds = data_frame(geometry= st_polygon(list(cbind(c(-62,-62,-52,-52,-62),
                             lat  = c(46, 60,60, 46,46)))))%>%
  mutate(geometry=st_sfc(geometry))%>%
  st_as_sf()%>%
  st_set_crs(4326)

atlantic_map = canada_map %>%
  st_intersection(atlantic_bounds)

st_write(atlantic_map,dsn = "data/map_layers/atlantic_map.shp")
