# readr

#In the data folder there are two data files:
#  * trawl_abiotic.csv
#  * trawl_biomass.csv


### For these two data files:

#1. Load the data as `trawl_abiotic` and `trawl_sp_biomass` using `readr`
#2. Identify the column types
#3. Identify any issues loading with loading this data

library(readr)
trawl_abiotic = read_csv("data/trawl_abiotic.csv")

trawl_biomass = read_csv("data/trawl_biomass.csv")


#  Try loading the trawl abiotic dataset again by:
  
#1. Increasing the number of columns read in
#2. Specifying depth as a "double" instead of an integer

trawl_abiotic = read_csv("data/trawl_abiotic.csv",col_types = cols(depth="d"))

# tidyr
  #Try spreading the trawl_abiotic data (may want to subset or filter rows and reduce # of columns) 
 #Try gathering the trawl_biomass
                  
# pipes
# Try using pipes to first subset the trawl_abiotic data and then spread
# Try using pipes to first subset the trawl_biomass before gathering


# dplyr
### using the trawl survey data:
# 1. join the environmental data to biomass data set
# 2. create a new tibble that only includes the year, species name, and bottom temperature
# 3. create a second tibble that excludes longitude, latitude, and depth

# dplyr
### using the joined the data set you created above:
# 1. Create a new tibble that only includes trawls collected in NAFO division # 2J,  and are deeper than 400 meters
# 2. Create a new tibble, grouped by species and strata, that only includes observations taken after 2000 and have a maximum biomass greater than 1 kg.


#Try: 
# - counting the number of observations in each year in each nafo division 
# - going to the cheat sheet and pick 1-2 functions for summarising or mutating the data in the manner of your choice