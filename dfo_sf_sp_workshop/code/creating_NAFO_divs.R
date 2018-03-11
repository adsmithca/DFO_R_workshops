library(sf)
library(dplyr)

nafo_div = st_read("data/map_layers/Divisions/Divisions.shp")
nafo_div_shelf = nafo_div %>%
  filter(ZONE %in% c("2J","3K","3L", "3M", "3Ps","3Pn"))

st_write(nafo_div_shelf,dsn = "data/map_layers/nafo_div_shelf.shp")
