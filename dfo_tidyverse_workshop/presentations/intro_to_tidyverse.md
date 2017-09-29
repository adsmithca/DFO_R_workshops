Introduction  to the tidyverse
========================================================
author: Eric Pedersen and Keith Lewis
date: September 28, 2017
autosize: true
width: 1440
height: 900
<div align="center">
<img src="tidyverse_hex.jpeg" width=500 height=500>
</div>


Getting started 
========================================================

Before we go:

1. Have you got R installed? 
2. Were you able to download the scripts and data we sent?
3. Does the following code run without errors? 


```r
# setwd("c:/where_the_folder_is/")

library(readr)
library(tidyr)
library(dplyr)

file.exists("data/dune.csv")
file.exists("data/dune.env.csv")
file.exists("data/trawl_abiotic.csv")
file.exists("data/trawl_biomass.csv")
```

What we'll cover today
========================================================

- What is tidy data, and what is the tidyverse?
- loading data with `readr`
- switching between different ways of representing data with `tidyr`
- manipulating data with `dplyr`

What is tidy data? 
========================================================
incremental: true
Data organized into tables where:


### 1. Every column is a different variable

### 2. Every row is a single observation

### 3. Each type of observation is in its own table


What is tidy data? 
========================================================
incremental: true
### Untidy data

```
  day M_1cm M_5cm F_1cm F_5cm
1   1   0.5   1.2   0.4     2
2   2   0.8   1.5   0.6     3
```


### Tidy data

```
  day sex length weigth
1   1   M      1    0.5
2   2   M      5    0.8
3   1   F      1    1.2
4   2   F      5    1.5
5   1   M      1    0.4
6   2   M      5    0.6
7   1   F      1    2.0
8   2   F      5    3.0
```


Question:
==============================================

What would be needed to make this data set tidy?


```
 year eggs_200m juv_200m eggs_500m juv_500m
 2005        10       20        20        2
 2007        20        4         0        1
 2009         2       12        37        4
```


What is the Tidyverse?
========================================================
incremental: true 

* R packages for working with tidy data
* Workflow based on functions that:
  * Are all simple verbs that do one thing (arrange, mutate, summarize, etc.)
  * Take a data frame as their first argument
  * Let you refer to the columns in that data frame by name
  * Return a data frame
  * **Play well with each other**



What is the Tidyverse?
========================================================
incremental: true



![](hadley.jpg) 

(although Hadley $\ne$ tidyverse)


The basic idea
========================
incremental: true


```r
head(CO2,n=3)
```

```
  Plant   Type  Treatment conc uptake
1   Qn1 Quebec nonchilled   95   16.0
2   Qn1 Quebec nonchilled  175   30.4
3   Qn1 Quebec nonchilled  250   34.8
```



```r
CO2_lowconc = filter(CO2, conc<100)

head(CO2_lowconc,n=3)
```

```
  Plant   Type  Treatment conc uptake
1   Qn1 Quebec nonchilled   95   16.0
2   Qn2 Quebec nonchilled   95   13.6
3   Qn3 Quebec nonchilled   95   16.2
```
