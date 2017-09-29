dplyr basics: filtering, selecting, grouping, and connecting tibbles
========================================================
author: 
date: 
autosize: true
width: 1440
height: 900
<div align="center">
<img src="dplyr_hex.png" width=500 height=500>
</div>




Starting up:
========================================================
To make sure everyone's on the same page, run this block of code:





```r
library(readr)
library(tidyr)
library(dplyr)


dune_env = read_csv("data/dune.env.csv")

dune_cover = read_csv("data/dune.csv") %>%
  gather(key = species,value = cover_class, Achimill:Callcusp)

head(dune_cover,n = 3)
```

```
# A tibble: 3 x 3
    site  species cover_class
   <chr>    <chr>       <int>
1 site_1 Achimill           1
2 site_2 Achimill           3
3 site_3 Achimill           0
```



Starting up:
========================================================
To make sure everyone's on the same page, run this block of code:



```r
trawl_abiotic = read_csv("data/trawl_abiotic.csv",col_types = cols(depth="d"))

trawl_biomass = read_csv("data/trawl_biomass.csv")%>%
  gather(key = species, value = biomass, shrimp:redfish)

head(trawl_biomass, n=3)
```

```
# A tibble: 3 x 4
   year trawl_id species biomass
  <int>    <int>   <chr>   <dbl>
1  1995        1  shrimp   62.39
2  1995        2  shrimp   29.86
3  1995        3  shrimp   46.04
```



What is dplyr?
==============
incremental: true
Manipulates data within a data frame

Basic verbs: 
* select
* join
* group_by
* filter
* mutate
* summarize


What is dplyr?
==============
Manipulates data within a data frame

Basic verbs: 
* **select**
* **join**
* **group_by**
* **filter**
* mutate
* summarize




select(): Removing columns
========================================================
incremental: true

<div align="center">
<img src="select.png" width=550>
</div>

* Removes columns
* Can use just column names to keep, column names to remove
* Can also use ranges of either (`select(data, A:C)`, `select(data, -(C:D)`)


left_join(): Adds columns from one data frame to another
========================================================


<div align="center">
<img src="left_join.png" width=550>
</div>


Using this on the dune data set
=================================
incremental: true







```r
dune_moisture = dune_cover %>%
  left_join(dune_env) %>%
  select(site, species, cover_class, Moisture)

head(dune_moisture)
```

```
# A tibble: 6 x 4
    site  species cover_class Moisture
   <chr>    <chr>       <int>    <int>
1 site_1 Achimill           1        1
2 site_2 Achimill           3        1
3 site_3 Achimill           0        2
4 site_4 Achimill           0        2
5 site_5 Achimill           2        1
6 site_6 Achimill           2        1
```

Exercise:
=================================


### using the trawl survey data:
1. join the environmental data to biomass data set
2. create a new tibble that only includes the year, species name, and bottom temperature
3. create a second tibble that excludes longitude, latitude, and depth






group_by(): grouping related observations
============================
incremental:true


<div align="center">
<img src="group_by.png" width=600>
</div>

* Does not change data
* Grouping passes on to other verbs
* undo it with ungroup(data)

filter(): Filtering out observations based on values
========================================================
incremental:true

<div align="center">
<img src="filter.png" width=550>
</div>

* removes rows
* keeps the number of columns and their values the same






Using this on the dune data set
=================================
incremental: true



Without grouping:


```r
dune_high_moisture = dune_moisture %>%
  filter(Moisture > 3)

head(dune_moisture) 
```

```
# A tibble: 6 x 4
    site  species cover_class Moisture
   <chr>    <chr>       <int>    <int>
1 site_1 Achimill           1        1
2 site_2 Achimill           3        1
3 site_3 Achimill           0        2
4 site_4 Achimill           0        2
5 site_5 Achimill           2        1
6 site_6 Achimill           2        1
```

Using this on the dune data set
=================================
incremental: true


With grouping:


```r
dune_moisture_tolerant = dune_moisture %>%
  filter(Moisture>3) %>%
  group_by(species) %>%
  filter(mean(count)>2)

head(dune_moisture_tolerant) 
```

```
# A tibble: 0 x 4
# Groups:   species [0]
# ... with 4 variables: site <chr>, species <chr>, cover_class <int>,
#   Moisture <int>
```



Exercise:
=================================


### using the joined the data set you created above:
1. Create a new tibble that only includes trawls collected in NAFO division 2J,  and are deeper than 400 meters
2. Create a new tibble, grouped by species and strata, that only includes observations taken after 2000 and have a maximum biomass greater than 1 kg.



