Plotting in the tidyverse: ggplot2
========================================================
author: Paul Regular and Keith Lewis  
date: 2017-10-01
width: 1540
height: 900
<div align="center">
<img src="ggplot2_hex.png" width=500 height=500>
</div>



Outline
========================================================
- plotting options
- grammar of graphics
- ggplot2: the basics
- ggplot2: publication quality
- ggplot2: advanced stuff


the grammar of graphics
========================================================
- data
- mappings (aesthetics)
- geometry (points, lines, polygons)
- scales (colour, size, shape, axes)
- coordinates (e.g. Cartesian)
- faceting (multiple subsets; lattice)
- layers ()

ggplot2: the basics
========================================================
Some sort of introduction??
ggplot v qplot?

ggplot2: the basics - scatterplot
========================================================

```r
View(mtcars)
library(tidyr)
library(ggplot2)
ggplot(data=mtcars, aes(x = mpg, y = disp)) + geom_point()
```

![plot of chunk unnamed-chunk-1](intro-figure/unnamed-chunk-1-1.png)

ggplot2: the basics - box-whisker plot
========================================================

```r
str(mtcars)
```

```
'data.frame':	32 obs. of  11 variables:
 $ mpg : num  21 21 22.8 21.4 18.7 18.1 14.3 24.4 22.8 19.2 ...
 $ cyl : num  6 6 4 6 8 6 8 4 4 6 ...
 $ disp: num  160 160 108 258 360 ...
 $ hp  : num  110 110 93 110 175 105 245 62 95 123 ...
 $ drat: num  3.9 3.9 3.85 3.08 3.15 2.76 3.21 3.69 3.92 3.92 ...
 $ wt  : num  2.62 2.88 2.32 3.21 3.44 ...
 $ qsec: num  16.5 17 18.6 19.4 17 ...
 $ vs  : num  0 0 1 1 0 1 0 1 1 1 ...
 $ am  : num  1 1 1 0 0 0 0 0 0 0 ...
 $ gear: num  4 4 4 3 3 3 3 4 4 4 ...
 $ carb: num  4 4 1 1 2 1 4 2 2 4 ...
```

```r
mtcars$cyl <- as.factor(mtcars$cyl)
ggplot(data=mtcars, aes(x = cyl, y = mpg)) + geom_boxplot()
```

![plot of chunk unnamed-chunk-2](intro-figure/unnamed-chunk-2-1.png)

ggplot2: the basics - some other graph
========================================================


Basic exercises
========================================================
take the trawl data and make the following?????

ggplot2: publication quality
========================================================

Publication quality exercises
========================================================

ggplot2: advanced stuff
========================================================
 - tidyverse
 - maps
 - working with layers
 
Advanced exercises
========================================================

Help
========================================================
Books:
- R Graphics Cookbook
- ggplot2: elegant graphics for data analysis

Websites:
http://www.cookbook-r.com/   [THIS IS GOLD!!!!!!!!]
