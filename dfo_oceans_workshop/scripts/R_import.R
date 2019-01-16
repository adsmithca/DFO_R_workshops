
library(readxl) # first step is to load the readxl package
?read_excel     # access help file of key function

## Use the read_excel function to import the data

duck <- read_excel("data/Duck Islands Movement.xlsx")
duck

round <- read_excel("data/Round Island Movement.xlsx")
round

View(duck)
View(round)

## Are these data tidy?

library(dplyr) # load the dplyr package
library(tidyr) # load the tidyr package

## Use functions from dplyr and tidyr to tidy up the data

tags <- bind_rows(duck, round)
tags

tidy_tags <- drop_na(tags)
tidy_tags # what happened?

tidy_tags <- select(tags, SIDE:NOTCH) %>% # step 1: select columns between SIDE and NOTCH
    drop_na() # step 2: take the data from step 1 and drop rows with NA's
tidy_tags

select(tags, SIDE, YEAR, TAG, LENGTH, RECAP)
select(tidy_tags, SIDE, YEAR, TAG, LENGTH, RECAP) # there's still a problem

## Select specific columns and drop rows with missing values from specific columns
tidy_tags <- select(tags, SIDE:NOTCH) %>% 
    drop_na(SIDE, ISLAND, YEAR, TAG)
select(tidy_tags, SIDE, YEAR, TAG, LENGTH, RECAP)



