
## ------------------------------------------------------------------------
X <- matrix(1:9, nrow = 3, ncol = 3)
X
X[2, 3]

## ------------------------------------------------------------------------
for (i in 1:3) {
  # do stuff
}

## ------------------------------------------------------------------------
for (i in 1:3) {
  print(i)
}

## ------------------------------------------------------------------------
for (a in c("age1", "age2", "age3")) {
  print(a)
}

## ------------------------------------------------------------------------
N <- c(10000, rep(NA, 10)) # create an object to fill inside the loop          
N
for (j in 2:11) {
  N[j] <- N[j - 1] * exp(-0.5)
}
N

## ------------------------------------------------------------------------

## Step 1: Define ages and years
ages <- 1:10
years <- 2005:2016

## Step 2: Create an empty matrix
N <- matrix(NA, nrow = length(ages), ncol = length(years),
            dimnames = list(age = ages, year = years))
N


## ------------------------------------------------------------------------

## Step 3: Make up some numbers for N at age 1, N at year 1 and Z
N[1, ] <- c(10000, 2000, 3500, 1000, 15000, 1500, 700, 300, 500, 200, 400, 5800)
N[, 1] <- c(10000, 6000, 3600, 2200, 1300, 800, 500, 300, 200, 100)
N
Z <- 0.5


## ------------------------------------------------------------------------

## Step 4: Use a loop to fill the matrix
for (j in seq_along(years)[-1]) {
  for (i in seq_along(ages)[-1]) {
    N[i, j] <- N[i - 1, j - 1] * exp(-Z)
  }
}
round(N)


## ------------------------------------------------------------------------
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
for (j in seq_along(years)[-1]) {
  for (i in seq_along(ages)[-1]) {
    N[i, j] <- N[i - 1, j - 1] * exp(-Z)
  }
}

## Here is where you calculate the proportion of individuals of age 1 in each year

## ------------------------------------------------------------------------
##    if (test) {
##      # do this if yes
##    } else {
##      # do this if no
##    }

## ------------------------------------------------------------------------
for (j in 2:8) {
  if (years[j] == 2009) {                 # evalues to TRUE or FALSE, depending on the itteration
    Z <- 0.9                              # Z is set to 0.9 if TRUE
  } else {
    Z <- 0.5                              # Z is set to 0.5 if FALSE
  }
  cat(paste0('year: ', years[j], ' - Z: ', Z, '\n'))
}

## ------------------------------------------------------------------------
for (j in seq_along(years)[-1]) {
  for (i in seq_along(ages)[-1]) {
    if (years[j] == 2009) {                 # evalues to TRUE or FALSE, depending on the itteration
      Z <- 0.9                              # Z is set to 0.9 if TRUE
    } else {
      Z <- 0.5                              # Z is set to 0.5 if FALSE
    }
    N[i, j] <- N[i - 1, j - 1] * exp(-Z)    # Z supplied here changes, depending on the itteration
  }
}

## ------------------------------------------------------------------------
## ifelse(test, yes, no)

## ------------------------------------------------------------------------
Ndf <- N %>%
  as.data.frame(.) %>%
  dplyr::mutate(., age = rownames(.)) %>% 
  tidyr::gather(., year, n, -age)
head(Ndf)

## ------------------------------------------------------------------------
Ndf$n <- ifelse(Ndf$age == 1 & Ndf$year >= 2012, 0, Ndf$n)
filter(Ndf, age == 1)


## ------------------------------------------------------------------------
library(FSAdata)
data(WhitefishMB)

## ------------------------------------------------------------------------
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
## step 5: This is where you modify the loops


## ------------------------------------------------------------------------
## my_fun <- function(formal_arguments) {
##   # body; do stuff with the formal_arguments
## }

## ------------------------------------------------------------------------
#' Function for substracting two values
#' @param x,y Numeric values to substract (x = 1 and y = 1 are default values)  
minus <- function(x = 1, y = 1) {
  x - y
}   

## ------------------------------------------------------------------------
minus()                       # defaults are run when values are not supplied
c(minus(3, 10), minus(10, 3)) # you can supply values without names, but remember that order matters!!
minus(y = 10, x = 3)          # order does not matter if you supply argument names

## ------------------------------------------------------------------------
`-`
`-`(3, 10)
3 - 10

## ------------------------------------------------------------------------

#' Simulate age-structured population model
#' @param ages  Ages to include in the simulation
#' @param years Years to include in the simulation
#' @param Z     Total mortality
#' @param R     Recruitment (N at age 1)
#' @param N0    Starting abundance (N at year 1)
sim_pop <- function(ages = 1:10, years = 2005:2016, Z = 0.5,
                    R = c(10000, 2000, 3500, 1000, 15000, 1500, 700, 300, 500, 200, 400, 5800),
                    N0 = c(10000, 6000, 3600, 2200, 1300, 800, 500, 300, 200, 100)) {
  N <- matrix(NA, nrow = length(ages), ncol = length(years),
              dimnames = list(age = ages, year = years))      # start the N matrix
  N[1, ] <- R                                                 # add age 1 vector
  N[, 1] <- N0                                                # add year 1 vector
  for (i in seq_along(ages)[-1]) {
    for (j in seq_along(years)[-1]) {
      N[i, j] <- N[i - 1, j - 1] * exp(-Z)                    # use equation to fill in the rest
    }
  }
  N                                                           # return N matrix
}


## ------------------------------------------------------------------------
N <- sim_pop()
round(N)

## ------------------------------------------------------------------------
N <- sim_pop(Z = 1.3)
round(N)

## ------------------------------------------------------------------------
meanbiomass <- read.csv('data/trawl_biomass.csv', header = T) %>%
  gather(key = species, value = biomass, 3:6) %>%
  group_by(year, species) %>%
  summarise(meanb = mean(biomass))
p <- ggplot(meanbiomass, aes(x = year, y = meanb, colour = species))
p <- p + geom_line()
print(p)

## ------------------------------------------------------------------------
print('b' + 1)

## ------------------------------------------------------------------------
x <- 1
pryr::where('x')

