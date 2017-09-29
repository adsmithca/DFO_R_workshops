The Tidyverse: tools for data wrangling
========================================================
author: Eric Pederson and Keith Lewis
date: 2017-09-25
autosize: true
incremental: true
width: 1440
height: 900



What is data wrangling?
========================================================
>- "The process of transforming and mapping data from one "raw" data form into another format with the intent of making it more appropriate and valuable for a variety of downstream purposes such as analytics." 
https://en.wikipedia.org/wiki/Data_wrangling

- or

>- "The art of getting your data into R in a useful form for visualisation and modelling." (http://r4ds.had.co.nz/wrangle-intro.html)

- The tidyverse helps you to data wrangle (http://tidyr.tidyverse.org/)


About tidyr
========================================================
What is tidyr?
  - A package that helps make tidy data (column = variable, row = observation, value = cell)

Why is it useful?
Tidyr changes the fundamental format of the data
- long data (model based format)
- wide data (tabular: easy for humans to read)
- Similar to: 
  - spreadsheets: pivot tables
  - databases: crosstab querries
  

Long to wide: a closer look
========================================================
![Long to Wide](Slide5.png)





Example: gather() and spread() the dune_sp data 
========================================================

```
# A tibble: 20 x 31
      site Achimill Agrostol Airaprae Alopgeni Anthodor Bellpere Bromhord
     <chr>    <int>    <int>    <int>    <int>    <int>    <int>    <int>
 1  site_1        1        0        0        0        0        0        0
 2  site_2        3        0        0        2        0        3        4
 3  site_3        0        4        0        7        0        2        0
 4  site_4        0        8        0        2        0        2        3
 5  site_5        2        0        0        0        4        2        2
 6  site_6        2        0        0        0        3        0        0
 7  site_7        2        0        0        0        2        0        2
 8  site_8        0        4        0        5        0        0        0
 9  site_9        0        3        0        3        0        0        0
10 site_10        4        0        0        0        4        2        4
11 site_11        0        0        0        0        0        0        0
12 site_12        0        4        0        8        0        0        0
13 site_13        0        5        0        5        0        0        0
14 site_14        0        4        0        0        0        0        0
15 site_15        0        4        0        0        0        0        0
16 site_16        0        7        0        4        0        0        0
17 site_17        2        0        2        0        4        0        0
18 site_18        0        0        0        0        0        2        0
19 site_19        0        0        3        0        4        0        0
20 site_20        0        5        0        0        0        0        0
# ... with 23 more variables: Chenalbu <int>, Cirsarve <int>,
#   Comapalu <int>, Eleopalu <int>, Elymrepe <int>, Empenigr <int>,
#   Hyporadi <int>, Juncarti <int>, Juncbufo <int>, Lolipere <int>,
#   Planlanc <int>, Poaprat <int>, Poatriv <int>, Ranuflam <int>,
#   Rumeacet <int>, Sagiproc <int>, Salirepe <int>, Scorautu <int>,
#   Trifprat <int>, Trifrepe <int>, Vicilath <int>, Bracruta <int>,
#   Callcusp <int>
```

"Gather"" the dune_sp data
========================================================




```r
gather(dune_sp, key=species, value = "cover_class", Achimill:Callcusp) 
```

```
# A tibble: 600 x 3
      site  species cover_class
     <chr>    <chr>       <int>
 1  site_1 Achimill           1
 2  site_2 Achimill           3
 3  site_3 Achimill           0
 4  site_4 Achimill           0
 5  site_5 Achimill           2
 6  site_6 Achimill           2
 7  site_7 Achimill           2
 8  site_8 Achimill           0
 9  site_9 Achimill           0
10 site_10 Achimill           4
# ... with 590 more rows
```

"Spread" the dune data
========================================================

```r
dune_sp_gath <- gather(dune_sp, key=species, value = "cover_class", Achimill:Callcusp) 

spread(dune_sp_gath, species, cover_class)
```

```
# A tibble: 20 x 31
      site Achimill Agrostol Airaprae Alopgeni Anthodor Bellpere Bracruta
 *   <chr>    <int>    <int>    <int>    <int>    <int>    <int>    <int>
 1  site_1        1        0        0        0        0        0        0
 2 site_10        4        0        0        0        4        2        2
 3 site_11        0        0        0        0        0        0        4
 4 site_12        0        4        0        8        0        0        4
 5 site_13        0        5        0        5        0        0        0
 6 site_14        0        4        0        0        0        0        0
 7 site_15        0        4        0        0        0        0        4
 8 site_16        0        7        0        4        0        0        4
 9 site_17        2        0        2        0        4        0        0
10 site_18        0        0        0        0        0        2        6
11 site_19        0        0        3        0        4        0        3
12  site_2        3        0        0        2        0        3        0
13 site_20        0        5        0        0        0        0        4
14  site_3        0        4        0        7        0        2        2
15  site_4        0        8        0        2        0        2        2
16  site_5        2        0        0        0        4        2        2
17  site_6        2        0        0        0        3        0        6
18  site_7        2        0        0        0        2        0        2
19  site_8        0        4        0        5        0        0        2
20  site_9        0        3        0        3        0        0        2
# ... with 23 more variables: Bromhord <int>, Callcusp <int>,
#   Chenalbu <int>, Cirsarve <int>, Comapalu <int>, Eleopalu <int>,
#   Elymrepe <int>, Empenigr <int>, Hyporadi <int>, Juncarti <int>,
#   Juncbufo <int>, Lolipere <int>, Planlanc <int>, Poaprat <int>,
#   Poatriv <int>, Ranuflam <int>, Rumeacet <int>, Sagiproc <int>,
#   Salirepe <int>, Scorautu <int>, Trifprat <int>, Trifrepe <int>,
#   Vicilath <int>
```

The dune_env data
========================================================

```r
dune_env = read_csv("data/dune.env.csv")
dune_env
```

```
# A tibble: 20 x 6
      site    A1 Moisture Management      Use Manure
     <chr> <dbl>    <int>      <chr>    <chr>  <int>
 1  site_1   2.8        1         SF Haypastu      4
 2  site_2   3.5        1         BF Haypastu      2
 3  site_3   4.3        2         SF Haypastu      4
 4  site_4   4.2        2         SF Haypastu      4
 5  site_5   6.3        1         HF Hayfield      2
 6  site_6   4.3        1         HF Haypastu      2
 7  site_7   2.8        1         HF  Pasture      3
 8  site_8   4.2        5         HF  Pasture      3
 9  site_9   3.7        4         HF Hayfield      1
10 site_10   3.3        2         BF Hayfield      1
11 site_11   3.5        1         BF  Pasture      1
12 site_12   5.8        4         SF Haypastu      2
13 site_13   6.0        5         SF Haypastu      3
14 site_14   9.3        5         NM  Pasture      0
15 site_15  11.5        5         NM Haypastu      0
16 site_16   5.7        5         SF  Pasture      3
17 site_17   4.0        2         NM Hayfield      0
18 site_18   4.6        1         NM Hayfield      0
19 site_19   3.7        5         NM Hayfield      0
20 site_20   3.5        5         NM Hayfield      0
```

"Spread" the dune_env data
========================================================

```r
spread(dune_env, Use, Moisture)
```

```
# A tibble: 20 x 7
      site    A1 Management Manure Hayfield Haypastu Pasture
 *   <chr> <dbl>      <chr>  <int>    <int>    <int>   <int>
 1  site_1   2.8         SF      4       NA        1      NA
 2 site_10   3.3         BF      1        2       NA      NA
 3 site_11   3.5         BF      1       NA       NA       1
 4 site_12   5.8         SF      2       NA        4      NA
 5 site_13   6.0         SF      3       NA        5      NA
 6 site_14   9.3         NM      0       NA       NA       5
 7 site_15  11.5         NM      0       NA        5      NA
 8 site_16   5.7         SF      3       NA       NA       5
 9 site_17   4.0         NM      0        2       NA      NA
10 site_18   4.6         NM      0        1       NA      NA
11 site_19   3.7         NM      0        5       NA      NA
12  site_2   3.5         BF      2       NA        1      NA
13 site_20   3.5         NM      0        5       NA      NA
14  site_3   4.3         SF      4       NA        2      NA
15  site_4   4.2         SF      4       NA        2      NA
16  site_5   6.3         HF      2        1       NA      NA
17  site_6   4.3         HF      2       NA        1      NA
18  site_7   2.8         HF      3       NA       NA       1
19  site_8   4.2         HF      3       NA       NA       5
20  site_9   3.7         HF      1        4       NA      NA
```

Exercise:
=======================================================
- Try spreading the trawl_abiotic data (may want to subset or filter rows and reduce # of columns) 
- Try gathering the trawl_biomass


Pipes
========================================================
The tidyverse has a number of packages that make programming easier
- purrr() - functional programming
- rlang() - 
- glue() - like paste()

-magrittr() - for "pipes"
http://magrittr.tidyverse.org/

What are pipes?
========================================================
From UNIX

Pipes make it easier to program and easier to read your code!

- data operations become left-to-right
- avoid nested function calls
- make it easy to add steps in sequence of operations

Code: "%>%"

Examples: Pipes in action: spread data after subsetting
========================================================



```r
dune_new <- dune_env %>%
  subset(Management == "HF") %>%
  spread(Use, Moisture)
dune_new
```

```
# A tibble: 5 x 7
    site    A1 Management Manure Hayfield Haypastu Pasture
*  <chr> <dbl>      <chr>  <int>    <int>    <int>   <int>
1 site_5   6.3         HF      2        1       NA      NA
2 site_6   4.3         HF      2       NA        1      NA
3 site_7   2.8         HF      3       NA       NA       1
4 site_8   4.2         HF      3       NA       NA       5
5 site_9   3.7         HF      1        4       NA      NA
```


Exercise:
=======================================================
- Try using pipes to first subset the trawl_abiotic data and then spread
- Try using pipes to first subset the trawl_biomass before gathering

dplyr
========================================================
- summarize data
- mutate new variables
- group data by a variable
- join data sets

summarize()
========================================================
- Turns multiple rows into a single

![Long to Wide](Slide6.png)




Exampe: summarise()
========================================================

```r
dune_long <- gather(dune_sp, key=species, value = "cover_class", Achimill:Callcusp) 

dune_summary <- dune_long %>%
  group_by(species) %>%
  summarise(mean = mean(cover_class))

dune_summary
```

```
# A tibble: 30 x 2
    species  mean
      <chr> <dbl>
 1 Achimill  0.80
 2 Agrostol  2.40
 3 Airaprae  0.25
 4 Alopgeni  1.80
 5 Anthodor  1.05
 6 Bellpere  0.65
 7 Bracruta  2.45
 8 Bromhord  0.75
 9 Callcusp  0.50
10 Chenalbu  0.05
# ... with 20 more rows
```

Exampe: summarise() continued
========================================================


```r
dune_summary <- dune_env %>%
  group_by(Management, Use) %>%
  summarise(count = n())
dune_summary
```

```
# A tibble: 11 x 3
# Groups:   Management [?]
   Management      Use count
        <chr>    <chr> <int>
 1         BF Hayfield     1
 2         BF Haypastu     1
 3         BF  Pasture     1
 4         HF Hayfield     2
 5         HF Haypastu     1
 6         HF  Pasture     2
 7         NM Hayfield     4
 8         NM Haypastu     1
 9         NM  Pasture     1
10         SF Haypastu     5
11         SF  Pasture     1
```

mutate()
========================================================
- creates new column from existing columns

![Long to Wide](Slide7.png)


Exampe: mutate() - Create a new variable
========================================================

```r
## examples
dune_mutate <- dune_sp %>%
    mutate(sum_sp = Achimill + Agrostol)  

dune_mutate[c("Achimill", "Agrostol", "sum_sp")]
```

```
# A tibble: 20 x 3
   Achimill Agrostol sum_sp
      <int>    <int>  <int>
 1        1        0      1
 2        3        0      3
 3        0        4      4
 4        0        8      8
 5        2        0      2
 6        2        0      2
 7        2        0      2
 8        0        4      4
 9        0        3      3
10        4        0      4
11        0        0      0
12        0        4      4
13        0        5      5
14        0        4      4
15        0        4      4
16        0        7      7
17        2        0      2
18        0        0      0
19        0        0      0
20        0        5      5
```

Exampe: mutate() - Create a new variable continued
========================================================


```r
dune_mutate <- dune_sp %>%
    mutate(test = between(Achimill, 2, 3))
dune_mutate[c("Achimill", "test")]
```

```
# A tibble: 20 x 2
   Achimill  test
      <int> <lgl>
 1        1 FALSE
 2        3  TRUE
 3        0 FALSE
 4        0 FALSE
 5        2  TRUE
 6        2  TRUE
 7        2  TRUE
 8        0 FALSE
 9        0 FALSE
10        4 FALSE
11        0 FALSE
12        0 FALSE
13        0 FALSE
14        0 FALSE
15        0 FALSE
16        0 FALSE
17        2  TRUE
18        0 FALSE
19        0 FALSE
20        0 FALSE
```

Exercise:
=======================================================

Try: 
- counting the number of observations in each year in each nafo division 
- going to the cheat sheet and pick 1-2 functions for summarising or mutating the data in the manner of your choice


Help 
========================================================
For tidyr():
- extract() or unite()
- vignette("tidy-data")
- demo(package = "tidyr")
- cheatsheet (see RStudio -> Help -> Cheatsheets)

Help 
========================================================
For pipes:
- Note: you don't HAVE to use pipes
Tidyverse webiste: http://magrittr.tidyverse.org/

"R for Data Science" http://r4ds.had.co.nz/pipes.html

When not to use pipes (according to Hadley)
- Pipes of more than 10 steps (hard to debug)

- Multiple inputs and outputs

- Complex graphs

Help 
========================================================
For dplyr:
- cheatsheet (see RStudio -> Help -> Cheatsheets)
