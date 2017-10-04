# Introduction to the tidyverse
# answers to exercises

### For these two data files:

#1. Load the data as `trawl_abiotic` and `trawl_sp_biomass` using `readr`
#2. Identify the column types
#3. Identify any issues loading with loading this data

library(readr)
library(tidyr)
library(dplyr)
trawl_abiotic = read_csv("data/trawl_abiotic.csv") # note the column names, the types, and any issues
trawl_abiotic # shows the tibble
View(trawl_abiotic) # shows the whole data set in tabs above the editor
trawl_biomass = read_csv("data/trawl_biomass.csv")
View(trawl_biomass)

#  Try loading the trawl abiotic dataset again by:
  
#1. Increasing the number of columns read in
#2. Specifying depth as a "double" instead of an integer

trawl_abiotic = read_csv("data/trawl_abiotic.csv",guess_max=5000, col_types = cols(depth="d"))

# tidyr

#Try spreading the trawl_abiotic data 
spread(data = trawl_abiotic, key = nafo_div, value = depth) 
spread(trawl_abiotic, nafo_div, depth) # note that this line of code is equivalent to the one above.  It takes more effort to write code like above but it can be easier to read the one above when you haven't looked at the code in a while.


#Try gathering the trawl_biomass
gather(trawl_biomass, key = species, value = biomass, shrimp:redfish)


# pipes
# Try using pipes to first subset the trawl_abiotic data and then spread it as aboe
# Note that we've snuck a little bit of dplyr in here, i.e., the filter() and select() functions
trawl_abiotic %>%
  filter(temp_bottom >3) %>% # removes all observations where temp_bottom >3
    spread(nafo_div, depth)

# Try using pipes to first subset the trawl_biomass before gathering
trawl_biomass %>%
  select(-shrimp, - redfish) %>% # here, the shrimp and redfish columns are removed
  gather(species, biomass, cod:halibut)

# dplyr
### using the trawl survey data:
# 1. join the environmental data to biomass data set
trawl_all <- left_join(trawl_abiotic, trawl_biomass, by = c("trawl_id", "year")) # data sets are joined by trawl_id and year

# 2. create a new tibble that only includes the year, species name, and bottom temperature
subset1 <- select(trawl_all, year, shrimp:redfish, temp_bottom) 
View(subset1)

# 3. create a second tibble that excludes longitude, latitude, and depth
subset2 <- select(trawl_all, - long, -lat, -depth) # again, sometimes its easier to remove a few columns than select a bunch

# dplyr
### using the joined the data set you created above:
# 1. Create a new tibble that only includes trawls collected in NAFO division # 2J,  and are deeper than 400 meters

trawl_all %>% 
  filter(nafo_div == "2J" & depth > 400)

# 2. Create a new tibble, grouped by species and strata, that only includes observations taken after 2000 and have a maximum biomass greater than 1 kg.

trawl_all %>%
  gather(key = species, value = biomass, shrimp:redfish) %>%
  group_by(species, strata) %>%
  filter(year > 2000 & biomass > 1)

#Try: 
# - counting the number of observations in each year in each nafo division 

trawl_abiotic %>%
  group_by(nafo_div, year) %>%
  summarise(count = n())

# - going to the cheat sheet and pick 1-2 functions for summarising or mutating the data in the manner of your choice.  Best to do this on your own and confirm your work on a subset of the data.  Here's an example.

trawl_all %>%
  gather(key = species, value = biomass, shrimp:redfish) %>%
  mutate(logbiomass = log(biomass))
