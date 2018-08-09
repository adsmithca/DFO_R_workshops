#  Script written by Keith Lewis (Keith.Lewis@dfo-mpo.gc.ca)  #
#  Created 2018-08-07, R version 3.5.1 (2017-07-02)
#   Purpose: to conduct Exploratory Data Analysis as part of R-seminar series

# libraries
library(readr)
library(tidyr)
library(dplyr)
library(ggplot2)
library(tidyselect)
library(magrittr)
library(car)
library(rmarkdown)
library(psych)


# read in abiotic data set using readr
abiotic <- read_csv("data/trawl_abiotic.csv", guess_max = 5000)
View(abiotic)

biomass <- read_csv("data/trawl_biomass.csv") %>%
  gather(key = species, value = biomass, shrimp:redfish)
View(biomass)

trawl <- biomass %>% 
  left_join(abiotic, by = c("year", "trawl_id"))
View(trawl)

# Step 1 Are there outliers in X and Y?
filter(trawl, year > 2008) %>% 
  ggplot(aes(x = as.numeric(biomass))) + geom_dotplot() + facet_wrap(~species)

filter(trawl, species == "shrimp") %>% 
  ggplot(aes(x = as.factor(year), y = biomass)) + geom_boxplot()

#Cleveland dotplot
trawl$id <- row.names(trawl)
filter(trawl, year > 2008 & species == "shrimp") %>% 
  ggplot(aes(y = id, x = biomass)) + geom_point()

# Step 2: Is the variance homogeneous?
filter(trawl, species == "shrimp" & year > 2000) %>% 
  ggplot(aes(x = as.factor(year), y = biomass)) + geom_boxplot()

# Step 3: Are the data normally distributed?
filter(trawl, year > 2005 & species == "shrimp") %>% 
  ggplot(aes(x = biomass)) + geom_histogram() + facet_wrap(~year)

# Step 4: Are there lots of zeros in the data?
p <- ggplot(trawl, aes(x=biomass))
p + geom_histogram() 


filter(trawl, biomass == 0)

filter(trawl, species == "shrimp" & biomass == 0)

# Step 5: Is there collinearity among the covariates (pairs plots)?

pairs.panels(trawl[c("biomass", "depth", "temp_bottom")], 
             method = "pearson", # correlation method
             hist.col = "#00AFBB",
             density = F,  # show density plots
             ellipses = F, # show correlation ellipses,
             cex.labels = 1,
             cex.cor = 1
)



# Step 6: What are the relationships betwen Y and X variables? 
ggplot(data = trawl) + geom_point(aes(x=depth, y = biomass))

## Step 6: What are the relationships betwen Y and X variables?
ggplot(data=trawl) + geom_point(aes(x=depth, y = biomass, colour=nafo_div)) +  facet_wrap(~nafo_div)

# Step 7: Should we consider interactions?  Think hard about this - they can seriously complicate the analysis!!!!!

ggplot(data = trawl, aes(x = depth, y = biomass)) + geom_point() + geom_smooth(method = lm, se = F) + facet_wrap(~ cut_number(temp_bottom, 3))


## Step 8: Are observations of the response variable independent?
