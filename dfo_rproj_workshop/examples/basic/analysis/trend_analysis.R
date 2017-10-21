
## Load packages
library(readr)
library(dplyr)
library(ggplot2)

## Import trawl data
biomass <- read_csv("data/trawl_biomass.csv")

## Calculate mean catch of redfish by year
sbiomass <- biomass %>%
  group_by(year) %>%
  summarise(mean = mean(redfish), sd = sd(redfish), n = n()) %>%
  mutate(lwr = mean - qnorm(0.975) * sd / sqrt(n),
         upr = mean + qnorm(0.975) * sd / sqrt(n))

## Visualize result
ggplot(sbiomass, aes(x = year, y = mean)) +
  geom_line() + geom_point(size = 3) +
  geom_errorbar(aes(min = lwr, max = upr), width = 0) +
  xlab("Year") + ylab("Mean") + theme_bw()

