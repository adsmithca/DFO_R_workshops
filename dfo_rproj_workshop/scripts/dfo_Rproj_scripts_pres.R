## Getting Started
## Project path and name
 root_dir <- "examples"   # path to your project
 proj_name <- "skeleton"  # project name
 
 ## Metadata for the project (NOT the data!!!!!)
 proj_metadata <- list("Title" = "Project title",
                       "Authors@R" = 'person("First", "Last",
                                             email = "first.last@example.com",
                                             role = c("aut", "cre"))',
                       "Description" = "This is a research compendium for...",
                       "License" = "NA")
 
 ## Generate the skeleton for the project
 devtools::create(file.path(root_dir, proj_name),
                  description = proj_metadata)           # generates a minimum R package skeleton
 devtools::use_git(pkg = file.path(root_dir, proj_name)) # Initalize local git repository
 dir.create(file.path(root_dir, proj_name, "data"))      # adds a data folder to the directory
 dir.create(file.path(root_dir, proj_name, "analysis"))  # adds an analysis folder to the directory
 
## Basic Example
## Project path and name
 root_dir <- "examples"                                  # path to your project
 proj_name <- "basic"                                    # project name
 
## Metadata for the project
proj_metadata <- list("Title" = "Trends in mean catch of redfish in the trawl survey",
                       "Authors@R" = 'c(person("Paul", "Regular", email = "Paul.Regular@dfo-mpo.gc.ca",
                                               role = c("aut", "cre")),
                                        person("Keith", "Lewis", email = "Keith.Lewis@dfo-mpo.gc.ca",
                                               role = "aut"))',
                       "Description" = "This is a research compendium for the analysis of trends in
                                        mean catch of redfish in the trawl survey.",
                       "License" = "NA",
                       "Imports" = c("readr", "dplyr", "ggplot2"))
 
## Generate the skeleton for the project
 devtools::create(file.path(root_dir, proj_name),
                  description = proj_metadata)           # generates a minimum R package skeleton
 devtools::use_git(pkg = file.path(root_dir, proj_name)) # Initalize local git repository
  dir.create(file.path(root_dir, proj_name, "data"))      # adds a data folder to the directory
 dir.create(file.path(root_dir, proj_name, "analysis"))  # adds an analysis folder to the directory
 

print(source("examples/basic/analysis/trend_analysis.R"))

## Load packages
library(tidyverse)

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


## Intermediate Example
## Project path and name
root_dir <- "examples"                                  # path to your project
proj_name <- "intermediate"                             # project name
 
## Metadata for the project
 proj_metadata <- list("Title" = "Trends in mean catch of shrimp, cod, halibut and redfish in the trawl survey",
                       "Authors@R" = 'c(person("Paul", "Regular", email = "Paul.Regular@dfo-mpo.gc.ca", role = c("aut", "cre")), person("Keith", "Lewis", email = "Keith.Lewis@dfo-mpo.gc.ca", role = "aut"))',
                       "Description" = "This is a research compendium for the analysis of trends in mean catch of shrimp, cod, halibut and redfish in the trawl survey.",
                       "License" = "NA",
                       "Imports" = c("readr", "dplyr", "ggplot2"))
 
 ## Generate the skeleton for the project
 devtools::create(file.path(root_dir, proj_name),
                  description = proj_metadata)           # generates a minimum R package skeleton
 devtools::use_git(pkg = file.path(root_dir, proj_name)) # Initalize local git repository
 dir.create(file.path(root_dir, proj_name, "data"))      # adds a data folder to the directory
 dir.create(file.path(root_dir, proj_name, "analysis"))  # adds an analysis folder to the directory
 
 

 ## Load packages
 library(tidyverse)
 
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
 
 #' Function for calculating mean catch by year for species in the biomass data
 #'
 #' @param biomass Data frame with trawl catches of shrimp, cod, halibut and redfish from 1995-2010
 #' @param species Species to select for calculations ("shrimp", "cod", "halibut" or "redfish")
 #'
 #' @return Returns a tibble containing mean, sd, n, lwr, and upr values by year.
 #'         Columns lwr and upr represent lower and upper 95 percent confidence intervals.
 #'
 #' @export trends
 #' @import dplyr
 #'
 
 trends <- function(biomass, species = "redfish") {
   
   ## Calculate mean, sd, n, and 95% confidence intervals (lwr, upr)
   biomass %>%
     select_("year", species) %>%
     group_by(year) %>%
     summarize_all(funs(mean, sd, n())) %>%
     mutate(lwr = mean - qnorm(0.975) * sd / sqrt(n),
            upr = mean + qnorm(0.975) * sd / sqrt(n))
   
 }
 
 plot_trends <- function(biomass, species = "redfish") {
   
   ## Calculate means, etc. using the trends function, then plot
   sp_trends <- trends(biomass, species = species)
   ggplot(sp_trends, aes(x = year, y = mean)) +
     geom_line() + geom_point(size = 3) +
     geom_errorbar(aes(min = lwr, max = upr), width = 0) +
     xlab("Year") + ylab("Mean") + theme_bw()
   
 }
 
 ## Load packages
 library(tidyverse)
 
 ## Import trawl data
 biomass <- read_csv("data/trawl_biomass.csv")
 
 ## Visualize trends
 plot_trends(biomass, species = "redfish")