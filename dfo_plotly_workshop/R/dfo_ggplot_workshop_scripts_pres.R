library(readr)
library(tidyr)
library(dplyr)
library(ggplot2)


# 1. Setup
# setwd("c:/where_the_folder_is/")

library(readr)
library(tidyr)
library(dplyr)
library(ggplot2)
 
file.exists("data/trawl_abiotic.csv")
file.exists("data/trawl_biomass.csv")
file.exists("data/wdata.Rdata")
file.exists("data/strata_boundaries/all_strata.shp")
file.exists("data/NL_shapefile/NL.shp")

abiotic <- read_csv("data/trawl_abiotic.csv", guess_max = 5000)
head(abiotic)


# basic scatterplot
ggplot(data = abiotic, aes(x = temp_bottom, y = depth)) + geom_point()

# basic boxplot
ggplot(data = abiotic, aes(x = nafo_div, y = temp_bottom)) + geom_boxplot()

# basic barplot
ggplot(data = abiotic, aes(x = year, fill = nafo_div)) +
  geom_bar(stat = "count") # statistics modifies geom

# save plot
ggplot(data = abiotic, aes(x = year, fill = nafo_div)) +
  geom_bar(stat = "count")     # statistics modifies geom
ggsave("plot.pdf")             # saves to working directory
ggsave("plot.png", dpi = 600)


# intermediate plots - add grammar
p <- ggplot(data = abiotic)
p + geom_point(aes(x = temp_bottom, y = depth))

#add colour
p + geom_point(aes(x = temp_bottom, y = depth, colour = nafo_div))

# change axes/legend labels
p <- ggplot(data = abiotic, aes(x = temp_bottom, y = depth, colour = nafo_div))
p + geom_point(shape = 16, size = 1, alpha = 0.5) +  # change the geom
  ylab("Depth (m)") +                                # change label of y-axis
  xlab("Temperature (°C)") +                         # change label of x-axis
  labs(colour = "NAFO")                              # change label of legend

# change background etc.
p <- ggplot(data = abiotic, aes(x = temp_bottom, y = depth, colour = nafo_div))
p + geom_point(shape = 16, size = 1, alpha = 0.5) +                      # change the geom
  ylab("Depth (m)") + xlab("Temperature (°C)") + labs(colour = "NAFO") + # change labels
  scale_y_reverse(limits = c(750, 0)) +                                  # reverse y-axis and impose limits
  scale_x_continuous(position = "top") +                                 # place x-axis on top of plot
  scale_colour_brewer(palette = "Set1") +                                # change the colour palette
  theme_bw()                                                             # change the theme

# advanced - link ggplot to the tidyverse
abiotic %>%                        # Start with the 'abiotic' dataset
  filter(nafo_div == "2J") %>%     # Then, filter down to rows where nafo_div == 2J
  ggplot(aes(temp_bottom)) +       # Then, determine aes
    geom_histogram()               # plot histograms

# advanced - link ggplot to the tidyverse
abiotic %>%                        # Start with the 'abiotic' dataset
  filter(nafo_div == "2J") %>%     # Then, filter down to rows where nafo_div == 2J
  ggplot(aes(temp_bottom)) +       # Then, determine aes
    geom_histogram() +             # plot histograms
    facet_wrap(~ year)             # facet by year

## layers
# no layers
ggplot(data = abiotic, aes(x = temp_bottom, y = depth, colour = nafo_div)) # run this line - what happens?

# one layer
ggplot(data = abiotic, aes(x = temp_bottom, y = depth, colour = nafo_div)) + # the data and aes
  geom_point()                                                               # the point layer

# one layer but with data specific to layer
ggplot() +
  geom_point(data = abiotic, aes(x = temp_bottom, y = depth, colour = nafo_div))  # geom, data, aes 

# two layers
ggplot() +
  geom_point(data = abiotic, aes(x = temp_bottom, y = depth, colour = nafo_div)) +
  geom_vline(aes(xintercept = 0), linetype = 2)

# two layers with two seperate data sets
load("data/wdata.Rdata")
w <- ggplot(adf, aes(length, weight, colour = as.factor(month)))
w <- w + geom_point(alpha = 0.5)
w <- w + geom_line(data = pdata, aes(length, predw, colour = as.factor(month)), size = 1.5)
w <- w + labs(x = 'Length (cm)', y = 'Weight (kg)')
w <- w + scale_colour_discrete(name = "",
                               breaks = c("12", "1", "2"),
                               labels = c("December", "January", "February"))
w

# two plots on a page
p1 <- ggplot(data = abiotic, aes(x = temp_bottom, y = depth)) + geom_point()
p2 <- ggplot(data = abiotic, aes(x = nafo_div, y = temp_bottom)) + geom_boxplot()
cowplot::plot_grid(p1, p2, labels = c("A", "B"))

# interactive plots
p <- abiotic %>% 
  left_join(biomass, by = c("year", "trawl_id")) %>%       # merge abiotic and biomass data
  ggplot(aes(x = depth, y = cod, colour = temp_bottom)) +  # set-up aes
  geom_point(alpha = 0.5) + scale_y_sqrt() +               # sqrt scale to help see the data
  scale_colour_viridis_c() + theme_minimal()               # set colour and theme
p                                                          # print static plot

library(plotly)
ggplotly(p)       # print interactive plot

# maps
library(sf)
strata <- read_sf("data/strata_boundaries/all_strata.shp", # import shapefiles
                  layer = "all_strata")                     
nl <- read_sf("data/NL_shapefile/NL.shp", layer = "NL")
p <- abiotic %>% 
  left_join(biomass, by = c("year", "trawl_id")) %>%       # merge abiotic and biomass data                           
  filter(year == 2010) %>%                                 # filter to 2010 data
  group_by(nafo_div, strata) %>%                           # set-up groups
  summarise(mean_shrimp = mean(shrimp)) %>%                # calculate mean biomass of shrimp by strat
  left_join(strata, by = "strata") %>%                     # merge with sf object
  ggplot(aes(fill = mean_shrimp)) + geom_sf() +            # strata map
  geom_sf(data = nl, fill = "grey") +                      # NL map
  ggtitle("Mean biomass of shrimp by strata in 2010") +    # plot labels
  labs(fill = "Mean\nbiomass") +
  scale_fill_viridis_c() + theme_bw()                      # colour and theme

p # print map