library(readr)
library(dplyr)

trawl_abiotic = read_csv("data/trawl_abiotic.csv",col_types = cols(depth="d"))
trawl_biomass = read_csv("data/trawl_biomass.csv")
trawl_merged  = trawl_biomass %>%
  left_join(trawl_abiotic)
