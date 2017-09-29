library(vegan)
library(dplyr)
library(readr)
library(stringr)
library(sf)

data("dune")
data("dune.env")

switch_na = function(x, new_val = 0) ifelse(is.na(x),new_val,x)


#configuring dune data from vegan ####
dune = dune %>%
  mutate(site = paste("site", 1:n(), sep="_"))%>%
  select(site, everything())

dune.env = dune.env %>%
  mutate(site = paste("site", 1:n(), sep="_"))%>%
  select(site, everything())

write_csv(dune,path = "data/dune.csv")
write_csv(dune.env,path = "data/dune.env.csv")


# Loading and cleaning multispecies trawl data ####
strata_locations = st_read("data/strata_boundaries/all_strata.shp") %>%
  mutate(strata = as.character(strata)) 

trawl_data = read_csv("data/dfo_SURVEYS_text.csv",
                      col_types = cols(Depth="d"))  %>%
  st_as_sf(coords = c("LONG_DEC", "LAT_DEC"),
           crs = st_crs(strata_locations),
           remove=F) %>%
  st_join(strata_locations) %>%
  filter(!is.na(strata), 
         DIV %in% c("2J","3K", "3L"),
         Season=="Fall", Strata_Type =="Core",
         YEAR>1994)%>%
  as_data_frame()%>%
  select(-geometry)%>%
  select(strata, everything()) %>%
  mutate(trawl_id = 1:n())

  
  

trawl_biomass = trawl_data %>%
  mutate_at(.vars=vars(`AGONUS DECAGONUS`:`UROPHYCIS TENUIS`), 
            .funs = funs(switch_na),
            new_val =0)%>%
  transmute(year = YEAR, 
            trawl_id = trawl_id, 
            shrimp = as.numeric(`PANDALUS BOREALIS`),
            cod = `GADUS MORHUA`, 
            halibut = `REINHARDTIUS HIPPOGLOSSOIDES`,
            redfish = `SEBASTES MENTELLA`)
            

trawl_abiotic  = trawl_data %>%
  transmute(year = YEAR, 
            trawl_id = trawl_id, 
            nafo_div = DIV,
            long = LONG_DEC,
            lat = LAT_DEC,
            depth = Depth, 
            temp_bottom = Temp_at_fishing,
            strata = strata)

write_csv(trawl_biomass, "data/trawl_biomass.csv")
write_csv(trawl_abiotic, "data/trawl_abiotic.csv")
