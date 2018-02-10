## ----setup, echo=FALSE, results="hide", message=FALSE, warning=FALSE-----
library(readr)
library(tidyr)
library(dplyr)
library(ggplot2)
knitr::opts_knit$set(root.dir = '../')
knitr::opts_chunk$set(cache = TRUE, 
                      fig.align = "center", 
                      fig.height = 4.5, 
                      fig.width = 7.5,
                      dev = "svg")

## ----startup, eval=FALSE, message=FALSE, warning=FALSE-------------------
## # setwd("c:/where_the_folder_is/")
## 
## library(readr)
## library(tidyr)
## library(dplyr)
## library(ggplot2)
## 
## file.exists("data/trawl_abiotic.csv")
## file.exists("data/trawl_biomass.csv")
## file.exists("data/wdata.Rdata")
## file.exists("data/strata_boundaries/all_strata.shp")
## file.exists("data/NL_shapefile/NL.shp")
## 

## ---- message=FALSE------------------------------------------------------

library(readr)
abiotic <- read_csv("data/trawl_abiotic.csv", guess_max = 5000)
head(abiotic)


## ---- warning=FALSE, fig.width=4.5---------------------------------------
ggplot(data = abiotic, aes(x = temp_bottom, y = depth)) + geom_point()

## ---- warning = FALSE----------------------------------------------------
ggplot(data = abiotic, aes(x = nafo_div, y = temp_bottom)) + geom_boxplot()

## ------------------------------------------------------------------------
ggplot(data = abiotic, aes(x = year, fill = nafo_div)) +
  geom_bar(stat = "count") # statistics modifies geom

## ---- eval=FALSE---------------------------------------------------------
## ggplot(data = abiotic, aes(x = year, fill = nafo_div)) +
##   geom_bar(stat = "count")     # statistics modifies geom
## ggsave("plot.pdf")             # saves to working directory
## ggsave("plot.png", dpi = 600)

## ---- message=FALSE, echo=FALSE------------------------------------------
biomass <- read_csv("data/trawl_biomass.csv")
ggplot(data = biomass, aes(x = factor(year), y = shrimp)) + geom_boxplot()

## ---- fig.height=4.5, fig.width = 4, warning=FALSE-----------------------
p <- ggplot(data = abiotic)
p + geom_point(aes(x = temp_bottom, y = depth))

## ---- fig.height=4.5, fig.width = 4, warning=FALSE-----------------------
p + geom_point(aes(x = temp_bottom, y = depth, colour = nafo_div))

## ---- fig.height=3.5, fig.width = 4, warning=FALSE-----------------------
p <- ggplot(data = abiotic, aes(x = temp_bottom, y = depth, colour = nafo_div))
p + geom_point(shape = 16, size = 1, alpha = 0.5) +  # change the geom
  ylab("Depth (m)") +                                # change label of y-axis
  xlab("Temperature (°C)") +                         # change label of x-axis
  labs(colour = "NAFO")                              # change label of legend

## ---- fig.height=3.5, fig.width = 4, warning=FALSE-----------------------
p <- ggplot(data = abiotic, aes(x = temp_bottom, y = depth, colour = nafo_div))
p + geom_point(shape = 16, size = 1, alpha = 0.5) +                      # change the geom
  ylab("Depth (m)") + xlab("Temperature (°C)") + labs(colour = "NAFO") + # change labels
  scale_y_reverse(limits = c(750, 0)) +                                  # reverse y-axis and impose limits
  scale_x_continuous(position = "top") +                                 # place x-axis on top of plot
  scale_colour_brewer(palette = "Set1") +                                # change the colour palette
  theme_bw()                                                             # change the theme

## ---- fig.height=4, fig.width = 6.5, warning=FALSE, message=FALSE--------
abiotic %>%                        # Start with the 'abiotic' dataset
  filter(nafo_div == "2J") %>%     # Then, filter down to rows where nafo_div == 2J
  ggplot(aes(temp_bottom)) +       # Then, determine aes
    geom_histogram()               # plot histograms

## ---- fig.height=4, fig.width = 6.5, warning=FALSE, message=FALSE--------
abiotic %>%                        # Start with the 'abiotic' dataset
  filter(nafo_div == "2J") %>%     # Then, filter down to rows where nafo_div == 2J
  ggplot(aes(temp_bottom)) +       # Then, determine aes
    geom_histogram() +             # plot histograms
    facet_wrap(~ year)             # facet by year

## ---- fig.height=4, fig.width = 4, warning=FALSE-------------------------
# no layers
ggplot(data = abiotic, aes(x = temp_bottom, y = depth, colour = nafo_div)) # run this line - what happens?

## ---- fig.height=4, fig.width = 4, warning=FALSE-------------------------
# one layer
ggplot(data = abiotic, aes(x = temp_bottom, y = depth, colour = nafo_div)) + # the data and aes
  geom_point()                                                               # the point layer

## ---- fig.height=4, fig.width = 4, warning=FALSE-------------------------
# one layer but with data specific to layer
ggplot() +
  geom_point(data = abiotic, aes(x = temp_bottom, y = depth, colour = nafo_div))  # geom, data, aes 


## ---- fig.height=4, fig.width = 4, warning=FALSE-------------------------
# two layers
ggplot() +
  geom_point(data = abiotic, aes(x = temp_bottom, y = depth, colour = nafo_div)) +
  geom_vline(aes(xintercept = 0), linetype = 2)

## ------------------------------------------------------------------------
load("data/wdata.Rdata")
w <- ggplot(adf, aes(length, weight, colour = as.factor(month)))
w <- w + geom_point(alpha = 0.5)
w <- w + geom_line(data = pdata, aes(length, predw, colour = as.factor(month)), size = 1.5)
w <- w + labs(x = 'Length (cm)', y = 'Weight (kg)')
w <- w + scale_colour_discrete(name = "",
                               breaks = c("12", "1", "2"),
                               labels = c("December", "January", "February"))

## ------------------------------------------------------------------------
w

## ---- warning=FALSE, message=FALSE---------------------------------------
p1 <- ggplot(data = abiotic, aes(x = temp_bottom, y = depth)) + geom_point()
p2 <- ggplot(data = abiotic, aes(x = nafo_div, y = temp_bottom)) + geom_boxplot()
cowplot::plot_grid(p1, p2, labels = c("A", "B"))

## ---- warning=FALSE, message = FALSE, fig.height=3.5---------------------
p <- abiotic %>% 
  left_join(biomass, by = c("year", "trawl_id")) %>%       # merge abiotic and biomass data
  ggplot(aes(x = depth, y = cod, colour = temp_bottom)) +  # set-up aes
  geom_point(alpha = 0.5) + scale_y_sqrt() +               # sqrt scale to help see the data
  scale_colour_viridis_c() + theme_minimal()               # set colour and theme
p                                                          # print static plot


## ---- warning=FALSE, message=FALSE, fig.width=10-------------------------
library(plotly)
ggplotly(p)       # print interactive plot

## ---- warning=FALSE, message=FALSE---------------------------------------
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

## ---- warning=FALSE, message=FALSE, fig.width=10, fig.height = 4.5-------
p # print map

