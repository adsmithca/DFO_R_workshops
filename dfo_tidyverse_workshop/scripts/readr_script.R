
#This loads the package
library(readr)

#Loading the dune data
dune_sp_data = read_csv("data/dune.csv")
dune_env_data = read_csv("data/dune.env.csv")

#Viewing the dune data set
head(dune_sp_data) 
head(dune_env_data)

#### Exercise 1: 
# In the data folder there are two data files:
# * trawl_abiotic.csv
# * trawl_biomass.csv
# 
# For these two data files:
# 1. Load the data as `trawl_abiotic` and `trawl_sp_biomass` using `readr`
# 2. Identify the column types 

# Increasing the number of rows used to guess:
dune_env_data = read_csv("data/dune.env.csv",
                         guess_max=5000)

# Specifying column types:
dune_env_data = read_csv("data/dune.env.csv",
                         col_types = cols(Moisture = "d"))

#### Exercise 2: 
# Try loading the trawl abiotic dataset again, specifying depth as a "double" instead of an integer


# other useful options:
dune_env_data = read_csv("data/dune.env.csv",
                         na = c("NA","."))
