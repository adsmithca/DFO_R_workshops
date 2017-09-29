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
