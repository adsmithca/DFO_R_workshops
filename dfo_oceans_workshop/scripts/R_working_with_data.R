library(readxl)
library(tidyr)
library(dplyr)
library(ggplot2) 


duck <- read_excel("data/Duck Islands Movement.xlsx")
round <- read_excel("data/Round Island Movement.xlsx")

tags <- bind_rows(duck, round)
tags

tidy_tags <- select(tags, SIDE:NOTCH) %>% 
    drop_na(SIDE, ISLAND, YEAR, TAG)%>%
    filter(SIDE!="s")
#Let's say we want to see how catches of legal (82.5 mm+) and non-legal size 
#have changed over time in the tagging data, compared to the average size of all
#lobsters caught:
tidy_tags <- tidy_tags %>%
    mutate(LEGAL_SIZE = LENGTH > 82.5,
           LENGTH_AVERAGE = mean(LENGTH),
           #We can also change an existing variable: 
           SIDE = tolower(SIDE)
           )

tidy_tags
#Now we can plot this:
legal_size_plot <- ggplot(tidy_tags, aes(x=YEAR, y= LENGTH, color = LEGAL_SIZE))+
    facet_grid(ISLAND~SIDE)+
    geom_point()+
    geom_hline(aes(yintercept = LENGTH_AVERAGE))

print(legal_size_plot)


#Exercise 1 ####

#Create a new data frame called `legal_size_tags`, that takes the `tidy_tags`
#data frame, creates the new `LEGAL_SIZE` column, and then use the `filter`
#command to exclude all of the lobsters than are less than legal size.

legal_size_tags = tidy_tags %>%
    mutate(LEGAL_SIZE = LENGTH>82.5)%>%
    filter(LEGAL_SIZE == TRUE)


legal_size_tags = tidy_tags %>%
    mutate(LEGAL_SIZE = LENGTH>82.5)%>%
    filter(LENGTH > 82.5)
#`group_by()`: breaking data into groups ####

tidy_tags <- tidy_tags %>%
    group_by(SEX)

tidy_tags

#Here's how you group with multiple different variables
tidy_tags <- tidy_tags %>%
    group_by(SIDE, ISLAND)

tidy_tags
    

#`group_by() is not that useful alone, but is incredibly powerful when combined with other commands: 
tidy_tags <- tidy_tags %>%
    group_by(SIDE, ISLAND,SEX) %>%
    mutate(LENGTH_AVG = mean(LENGTH))%>%
    #It's always important to use ungroup after doing the grouped action
    ungroup()

#Now we can plot this:
legal_size_plot <- ggplot(tidy_tags, aes(x=YEAR, y= LENGTH, color = SEX))+
    facet_grid(ISLAND~SIDE)+
    geom_point()+
    geom_hline(aes(yintercept = LENGTH_AVG,color=SEX),size=2)

print(legal_size_plot)
    
#Exercise 2####

# Modify the following code so that you are calculating the length of time that 
# each tag value has been observed for each sex and each island (remember to use ungroup at the end!)

legal_tags <- tidy_tags %>%
    mutate(LEGAL_SIZE = LENGTH > 82.5,
           SIDE = tolower(SIDE)) %>%
    filter(LEGAL_SIZE == TRUE) %>%
    mutate(YEARS_OBS = max(YEAR)-min(YEAR))%>%
    filter(YEARS_OBS >0)


# Now we can (almost) create the first plot we saw:
legal_tags <- tidy_tags %>%
    mutate(LEGAL_SIZE = LENGTH > 82.5,
           SIDE = tolower(SIDE)) %>%
    filter(LEGAL_SIZE == TRUE) %>%
    group_by(TAG,SEX, ISLAND)%>%
    mutate(YEARS_OBS = max(YEAR)-min(YEAR))%>%
    filter(YEARS_OBS >0)%>%
    ungroup()

longest_observed_lobsters <- legal_tags %>%
    group_by(SEX,ISLAND)%>%
    filter(YEARS_OBS == max(YEARS_OBS))%>%
    ungroup()

size_plot <- legal_tags %>%
    ggplot(aes(x = YEAR, y = LENGTH, color = SEX))+
    facet_grid(SEX~ISLAND)+
    geom_line(aes(group = TAG),alpha=0.25)+
    geom_line(data= longest_observed_lobsters, 
              aes(group = TAG),
              size=2)

print(size_plot)
    
# Using summerize() ####

average_lengths <- tidy_tags %>%
    group_by(ISLAND,SIDE ,cut(LENGTH,breaks = c(80,90,100))) %>%
    summarize(LENGTH_AVG = mean(LENGTH),
              LENGTH_MIN = min(LENGTH),
              LENGTH_MAX = max(LENGTH))%>%
    #It's always important to use ungroup after doing the grouped action
    ungroup()

average_lengths

lobster_growth_rates = legal_tags %>%
    group_by(TAG, SEX, ISLAND)%>%
    filter(max(YEAR)>min(YEAR))%>%
    summarize(LENGTH_START = min(LENGTH),
              GROWTH_RATE = (max(LENGTH)-min(LENGTH))/(max(YEAR)-min(YEAR)))%>%
    ungroup()

lobster_growth_rates


growth_plot = lobster_growth_rates %>%
    ggplot(aes(x = LENGTH_START, GROWTH_RATE,color = SEX))+
    facet_grid(SEX~ISLAND)+
    geom_point()

growth_plot
    

# This is the full code to generate the clean versions of the figures we showed at the start ####

#This shows how to make the year-versus length plot
legal_tags <- tidy_tags %>%
    mutate(LEGAL_SIZE = LENGTH > 82.5,
           SIDE = tolower(SIDE)) %>%
    filter(LEGAL_SIZE == TRUE) %>%
    group_by(TAG,SEX, ISLAND)%>%
    mutate(YEARS_OBS = max(YEAR)-min(YEAR))%>%
    filter(YEARS_OBS >0)%>%
    ungroup()

longest_observed_lobsters <- legal_tags %>%
    group_by(SEX,ISLAND)%>%
    filter(YEARS_OBS == max(YEARS_OBS))%>%
    ungroup()

size_plot <- legal_tags %>%
    ggplot(aes(x = YEAR, y = LENGTH, color = SEX))+
    facet_grid(SEX~ISLAND)+
    geom_line(aes(group = TAG),alpha=0.25)+
    geom_line(data= longest_observed_lobsters, 
              aes(group = TAG),
              size=2)+
    #This tweaks the colors into something nicer
    scale_color_brewer(palette = "Set1")+
    #These change the elements of the theme
    theme_bw()+
    theme(panel.grid = element_blank())


print(size_plot)

    
#This shows how to make the growth-by-area plot:
lobster_growth_rates = legal_tags %>%
    group_by(TAG, SEX, ISLAND)%>%
    filter(max(YEAR)>min(YEAR))%>%
    summarize(LENGTH_START = min(LENGTH),
              GROWTH_RATE = (max(LENGTH)-min(LENGTH))/(max(YEAR)-min(YEAR)))%>%
    ungroup()

growth_plot = lobster_growth_rates %>%
    ggplot(aes(x = LENGTH_START, GROWTH_RATE,color = SEX))+
    facet_grid(SEX~ISLAND)+
    geom_point()+
    #This tweaks the colors into something nicer
    scale_color_brewer(palette = "Set1")+
    #These change the elements of the theme
    theme_bw()+
    theme(panel.grid = element_blank())

print(growth_plot)
