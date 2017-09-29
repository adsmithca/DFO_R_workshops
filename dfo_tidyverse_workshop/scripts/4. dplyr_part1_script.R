
#Loading the packages and getting data ready
library(readr)
library(tidyr)
library(dplyr)


dune_env = read_csv("data/dune.env.csv")

dune_cover = read_csv("data/dune.csv") %>%
  gather(key = species,value = cover_class, Achimill:Callcusp)

head(dune_cover,n = 3)

trawl_abiotic = read_csv("data/trawl_abiotic.csv",col_types = cols(depth="d"))

trawl_biomass = read_csv("data/trawl_biomass.csv")%>%
  gather(key = species, value = biomass, shrimp:redfish)

head(trawl_biomass, n=3)

#Trying joins and select on the dune data
dune_moisture = dune_cover %>%
  left_join(dune_env) %>%
  select(site, species, cover_class, Moisture)

head(dune_moisture)

#Exercise: 

# using the trawl survey data:
# 1. join the environmental data to biomass data set
# 2. create a new tibble that only includes the year, species name, and bottom temperature
# 3. create a second tibble that excludes longitude, latitude, and depth

#Trying grouping and filtering on the dune data
dune_high_moisture = dune_moisture %>%
  filter(Moisture > 3)

head(dune_moisture) 
dune_moisture_tolerant = dune_moisture %>%
  filter(Moisture>3) %>%
  group_by(species) %>%
  filter(mean(count)>2)

head(dune_moisture_tolerant) 
