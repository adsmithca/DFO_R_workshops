
library(readxl)
library(dplyr)
library(tidyr)
library(ggplot2)

## Import and tidy data
duck <- read_excel("data/Duck Islands Movement.xlsx")
round <- read_excel("data/Round Island Movement.xlsx")
tags <- bind_rows(duck, round) %>%   # stack both data sets
    select(SIDE:NOTCH) %>%           # select main columns
    drop_na(SIDE, ISLAND, YEAR, TAG) # drop empty rows

## Scatterplot
ggplot(tags, aes(x = YEAR, y = LENGTH)) + 
    geom_point()

## Line-plot
ggplot(tags, aes(x = YEAR, y = LENGTH, group = TAG)) + 
    geom_line()

## Boxplot
ggplot(tags, aes(x = SEX, y = LENGTH)) + 
    geom_boxplot()

## Barplot
ggplot(tags, aes(x = YEAR, fill = ISLAND)) +
  geom_bar(color = "black") 

## Exercise - modify this code to color the lines by sex
ggplot(tags, aes(x = YEAR, y = LENGTH, group = TAG)) +
     geom_line()

## Object + geom
p <- ggplot(tags)
p + geom_line(aes(x = YEAR, y = LENGTH, group = TAG, colour = SEX))

## Object + alternate aes
p + geom_line(aes(x = YEAR, y = LENGTH, group = TAG, color = ISLAND))

## Object + alternate aes
p + geom_line(aes(x = YEAR, y = LENGTH, group = TAG, color = SIDE))

## Object + alternate geom
p + geom_bar(aes(x = YEAR, fill = ISLAND), stat = "count")

## Object + geom + facet
p + geom_bar(aes(x = YEAR)) +
    facet_grid(~ ISLAND) # split plots by island

## Object + geom + facet
p + geom_bar(aes(x = YEAR)) +
    facet_grid(SEX ~ ISLAND) # split plots by sex and island

## Object + geom + facet
p + geom_bar(aes(x = YEAR, fill = factor(MONTH), group = MONTH)) +
    facet_grid(SEX ~ ISLAND)

## Save the first step into an object called p1
p1 <- ggplot(tags) + 
    geom_bar(aes(x = YEAR, fill = factor(MONTH))) +
    facet_grid(SEX ~ ISLAND)

## Here's what the defaults look like
p1

## Iterative changes to the defaults
p2 <- p1 + xlab("Year") + ylab("Number of records") # change x and y labels
p2

p3 <- p2 + scale_fill_brewer(palette = "RdBu", name = "Month")  # name legend and use greyscale
p3

p4 <- p3 + coord_cartesian(ylim = c(0, 700), expand = FALSE) # set y limits and remove buffer
p4

p5 <- p4 + theme_bw() # use the black and white theme
p5

p6 <- p5 + theme(panel.grid.major = element_blank()) # remove major grid lines
p6

p7 <- p6 + theme(panel.grid.minor = element_blank()) # remove minor grid lines
p7

p8 <- p7 + theme(strip.background = element_blank()) # remove facet strip background
p8

## All changes plus an option for changing the facet labels

### Set-up nice island and sex labels
island_names <- c("duck" = "Duck",
                  "round" = "Round")
sex_names <- c("F" = "Female",
               "M" = "Male")

### Add all the above changes to one object
p <- ggplot(tags) +                                                 # set-up base layer
    geom_bar(aes(x = YEAR, fill = factor(MONTH)), stat = "count") + # add bars by year and filled by month
    facet_grid(SEX ~ ISLAND,                                        # facet by sex and island
               labeller = labeller(SEX = sex_names,                 # edit facet labels
                                   ISLAND = island_names)) +        
    xlab("Year") + ylab("Number of records") +                      # change x and y labels
    scale_fill_brewer(palette = "RdBu", name = "Month") +           # name legend and use greyscale
    coord_cartesian(ylim = c(0, 700), expand = FALSE) +             # set y limits and remove buffer
    theme_bw() +                                                    # use the black and white theme
    theme(panel.grid.major = element_blank(),                       # remove major grid lines
          panel.grid.minor = element_blank(),                       # remove minor grid lines
          strip.background = element_blank())                       # remove facet strip background
p
