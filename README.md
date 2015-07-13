---
title: "sabr - A package to query and calculate MLB offensive performance statistics"
author: "Michael Lee"
date: "July 13, 2015"
output: rmarkdown::html_vignette
vignette: >
  %\VignetteIndexEntry{Vignette Title}
  %\VignetteEngine{knitr::rmarkdown}
  %\VignetteEncoding{UTF-8}
---
#sabr

The sabr package connects the Lahman SQL Database with functions used in calculating offensive performance in the MLB, namely wOBA. wOBA, created by Tom Tango and popularized in [The Book: Playing the Percentages in Baseball](http://www.insidethebook.com/woba.shtml). This statistic uses yearly MLB performance to weigh offensive measures relative to league value. This package offers the following capabilities:

- Retrieves the most up-to-date wOBA measures from 1871-2015
- Queries yearly and career offensive performance from the Lahman SQL database
- Calculates a player's seasonal wOBA performance

Installation:

* the latest development version from github with

    ```R
    if (packageVersion("devtools") < 1.6) {
      install.packages("devtools")
    }
    devtools::install_github("mdlee12/sabr")
    ```

## Key Functions

*battingseason : Offensive seasonal performance by playerID and yearID
```{r, message = FALSE}
battingseason("parrage01","2014")
```

*woba_guts : Retrieves current wOBA guts table from [Fangraphs]((http://www.fangraphs.com/guts.aspx?type=cn))
```{r, message = FALSE}
library(sabr)
woba_guts()
```

*battingcareer : Offensive career performance by playerID by organized by season
```{r, message = FALSE}
battingcareer("fieldpr01")
```

*woba_season : Returns a MLB player's weighted On-Base Average by yearID
```{r, message = FALSE}
woba_season("fieldpr01","2014")
```