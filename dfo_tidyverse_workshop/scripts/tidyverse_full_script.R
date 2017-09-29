# 1. Introduction to the tidyverse ####


# setwd("c:/where_the_folder_is/")

library(readr)
library(tidyr)
library(dplyr)

file.exists("data/dune.csv")
file.exists("data/dune.env.csv")
file.exists("data/trawl_abiotic.csv")
file.exists("data/trawl_biomass.csv")

untidy_data  = data.frame(day = c(1,2), 
                          M_1cm = c(0.5,0.8), 
                          M_5cm = c(1.2,1.5),
                          F_1cm = c(0.4, 0.6),
                          F_5cm =c(2,3))
untidy_data




tidy_data = data.frame(day = c(1,2,1,2), 
                       sex= c("M","M","F","F"),
                       length = c(1,5,1,5),
                       weigth =c(0.5,0.8,1.2,1.5,0.4,0.6, 2,3))
tidy_data


untidy_data2 = data.frame(year = c(2005,2007,2009),
                          eggs_200m = c(10,20,2),
                          juv_200m = c(20,4,12),
                          eggs_500m = c(20,0,37),
                          juv_500m = c(2,1,4))
print(untidy_data2,row.names=F)

head(CO2,n=3)
CO2_lowconc = filter(CO2, conc<100)

head(CO2_lowconc,n=3)


# 2. Opening data with readr ####



#This loads the package
library(readr)

#Loading the dune data
dune_sp = read_csv("data/dune.csv")
dune_env = read_csv("data/dune.env.csv")

#Viewing the dune data set
head(dune_sp) 
head(dune_env)

#### Exercise 1: 
# In the data folder there are two data files:
# * trawl_abiotic.csv
# * trawl_biomass.csv
# 
# For these two data files:
# 1. Load the data as `trawl_abiotic` and `trawl_sp_biomass` using `readr`
# 2. Identify the column types 

# Increasing the number of rows used to guess:
dune_env = read_csv("data/dune.env.csv",
                         guess_max=5000)

# Specifying column types:
dune_env = read_csv("data/dune.env.csv",
                         col_types = cols(Moisture = "d"))

#### Exercise 2: 
# Try loading the trawl abiotic dataset again, specifying depth as a "double" instead of an integer


# other useful options:
dune_env = read_csv("data/dune.env.csv",
                         na = c("NA","."))


# 3. Changing the shape of data with tidyr ####


#Example #1: 
#Gathering the dune data into long format

#Loading the packages and getting data ready
library(readr)
library(tidyr)
library(dplyr)
library(vegan)
dune_sp = read_csv("data/dune.csv")
dune_sp

#gathering the data up into the long format
gather(dune_sp, key=species, value = "cover_class", Achimill:Callcusp) 
dune_sp_gath <- gather(dune_sp, key=species, value = "cover_class", Achimill:Callcusp) 

spread(dune_sp_gath, species, cover_class)
dune_env = read_csv("data/dune.env.csv")
dune_env
spread(dune_env, Use, Moisture)


# 4. Connecting operations with pipes ####



# Example #3: using pipes
dune_new <- dune_env %>%
  subset(Management == "HF") %>%
  spread(Use, Moisture)
dune_new


#5. dplyr: filtering, selecting, grouping, and connecting tibbles ####


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

# Example #4: using summarise
dune_long <- gather(dune_sp, key=species, value = "cover_class", Achimill:Callcusp) 

dune_summary <- dune_long %>%
  group_by(species) %>%
  summarise(mean = mean(cover_class))

dune_summary
dune_summary <- dune_env %>%
  group_by(Management, Use) %>%
  summarise(count = n())
dune_summary

# Example #5: using mutate
## examples
dune_mutate <- dune_sp %>%
    mutate(sum_sp = Achimill + Agrostol)  

dune_mutate[c("Achimill", "Agrostol", "sum_sp")]
dune_mutate <- dune_sp %>%
    mutate(test = between(Achimill, 2, 3))
dune_mutate[c("Achimill", "test")]
