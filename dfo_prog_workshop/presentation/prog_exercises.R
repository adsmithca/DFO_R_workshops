
## Loops exercise ----
## Step 1: Define ages and years
ages <- 1:10
years <- 2005:2016
## Step 2: Create an empty matrix
N <- matrix(NA, nrow = length(ages), ncol = length(years),
            dimnames = list(age = ages, year = years))
## Step 3: Make up some numbers for N at age 1, N at year 1 and Z
N[1, ] <- c(10000, 2000, 3500, 1000, 15000, 1500, 700, 300, 500, 200, 400, 5800)
N[, 1] <- c(10000, 6000, 3600, 2200, 1300, 800, 500, 300, 200, 100)
Z <- 0.5
## loop
prop_a1 <- (rep(NA, ncol(N)))
for (j in seq_along(years)) {
  prop_a1[j] <- N[1,j] / sum(N[2:10, j])
}


## Conditionals exercises ----
## ifelse
library(FSAdata)
data(WhitefishMB)
wf <- WhitefishMB
wf$flag <- wf$fin == wf$scale
wf$trueage <- ifelse(wf$flag == TRUE, wf$scale,
                     ifelse(wf$lake == 'Huron', wf$fin, wf$scale))

## if ( ) { } else { }
## Step 1: Define ages and years
ages <- 1:10
years <- 2005:2016
## Step 2: Create an empty matrix
N <- matrix(NA, nrow = length(ages), ncol = length(years),
            dimnames = list(age = ages, year = years))
## Step 3: Make up some numbers for N at year 1 and Z
N[, 1] <- c(10000, 6000, 3600, 2200, 1300, 800, 500, 300, 200, 100)
Z <- 0.5
## Step 4: create a vector of fecundities
f <- c(rep(0, 2), 0.1, 0.15, 0.25, 0.6, 0.9, 0.9, 0.85, 0.7)
## step 5: 
for (j in seq_along(years)[-1]) {
  for (i in seq_along(ages)) {
    if (ages[i] == 1) {                 # evalues to TRUE or FALSE, depending on the itteration
      N[1, j] <- sum(N[, j - 1] * f)
    } else {
      N[i, j] <- N[i - 1, j - 1] * exp(-Z)    
    }
  }
}

## functions exercise ----
meanbiomass <- read.csv('data/trawl_biomass.csv', header = T) %>%
  gather(key = species, value = biomass, 3:6) %>%
  group_by(year, species) %>%
  summarise(meanb = mean(biomass))
p <- ggplot(meanbiomass, aes(x = year, y = meanb, colour = species))
p <- p + geom_line()


normalize <- function(x){
  z <- (x - mean(x)) / sd(x)
  z
}

meanbiomass <- meanbiomass %>% 
  group_by(species) %>%
  mutate(meanb_norm = normalize(x = meanb))

p <- ggplot(meanbiomass, aes(x = year, y = meanb_norm, colour = species))
p <- p + geom_line()
p