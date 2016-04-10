sabr
====

The sabr package connects the Lahman SQL Database with functions used in calculating offensive performance in the MLB, namely wOBA. Created by Tom Tango and popularized in [The Book: Playing the Percentages in Baseball](http://www.insidethebook.com/woba.shtml), wOBA uses yearly MLB performance to weigh offensive measures relative to league value. This package offers the following capabilities:

-   Retrieves the most up-to-date wOBA measures from 1871-2015
-   Queries yearly and career offensive performance from the Lahman SQL database
-   Calculates a player's seasonal wOBA performance

Installation:
-------------

-   the latest development version from github with

    ``` r
    if (packageVersion("devtools") < 1.6) {
      install.packages("devtools")
    }
    devtools::install_github("mdlee12/sabr")
    ```

Motivation:
-----------

wOBA is one of the best catch-all offensive performance statistics, but it's formula is a bit convoluted since it requires 1) ten distinct rate stats and 2) weighted values based on a season's run environment.

For example, the wOBA formula for the 2013 season was:

wOBA = (0.690×uBB + 0.722×HBP + 0.888×1B + 1.271×2B + 1.616×3B + 2.101×HR) / (AB + BB – IBB + SF + HBP)

Check out [Fangraphs](http://www.fangraphs.com/library/offense/woba/)' library for additional details.

New Functions with 0.2:
-----------------------

-   wRAA\_season : Returns a MLB player's weighted Runs Above Average by yearID

``` r
library(sabr)
wRAA_season("braunry02","2015")
```

    ## [1] 23.89798

-   wRC\_season : Returns a MLB player's weighted Runs Created by yearID

``` r
wRC_season("molitpa01","1991")
```

    ## [1] 127.0164

-   wRCp\_season : Returns a MLB player's weighted Runs Created Plus by yearID

``` r
wRCp_season("yountro01","1989")
```

    ## [1] 152.5421

**Full calculation details are in the [wOBA and wRC+ calculation.Rmd file](https://github.com/mdlee12/sabr/blob/master/vignettes/wOBA%20and%20wRC%2B%20calculation.Rmd)**

*wRCp\_season makes a couple assumptions:* 1. Park Factors are pulled from the Lahman Database - these are different from other sources 2. A player's primary position is used to remove pitchers from the League Runs/Plate Appearance calculation

------------------------------------------------------------------------

Key Functions from 0.1:
-----------------------

-   battingseason : Offensive seasonal performance by playerID and yearID

``` r
battingseason("parrage01","2014")
```

    ##    playerID yearID stints  teamID  AB  R   H DB TR HR RBI SB CS BB  SO IBB
    ## 1 parrage01   2014      2 ARI,MIL 529 64 138 22  4  9  40  9  7 32 100   5
    ##   SF SH GIDP HBP
    ## 1  2  6   10   5

-   battingcareer : Offensive career performance by playerID by organized by season

``` r
battingcareer("fieldpr01")
```

    ##     playerID yearID stints teamID  AB   R   H DB TR HR RBI SB CS  BB  SO
    ## 1  fieldpr01   2005      1    MIL  59   2  17  4  0  2  10  0  0   2  17
    ## 2  fieldpr01   2006      1    MIL 569  82 154 35  1 28  81  7  2  59 125
    ## 3  fieldpr01   2007      1    MIL 573 109 165 35  2 50 119  2  2  90 121
    ## 4  fieldpr01   2008      1    MIL 588  86 162 30  2 34 102  3  2  84 134
    ## 5  fieldpr01   2009      1    MIL 591 103 177 35  3 46 141  2  3 110 138
    ## 6  fieldpr01   2010      1    MIL 578  94 151 25  0 32  83  1  0 114 138
    ## 7  fieldpr01   2011      1    MIL 569  95 170 36  1 38 120  1  1 107 106
    ## 8  fieldpr01   2012      1    DET 581  83 182 33  1 30 108  1  0  85  84
    ## 9  fieldpr01   2013      1    DET 624  82 174 36  0 25 106  1  1  75 117
    ## 10 fieldpr01   2014      1    TEX 150  19  37  8  0  3  16  0  0  25  24
    ## 11 fieldpr01   2015      1    TEX 613  78 187 28  0 23  98  0  0  64  88
    ##    IBB SF SH GIDP HBP
    ## 1    0  1  0    0   0
    ## 2    5  8  0   17  12
    ## 3   21  4  0    9  14
    ## 4   19 10  0   12  12
    ## 5   21  9  0   14   9
    ## 6   17  1  0   12  21
    ## 7   32  6  0   17  10
    ## 8   18  7  0   19  17
    ## 9    5  4  0   20   9
    ## 10  11  1  0    5   2
    ## 11  14  5  0   21  11

-   woba\_season : Returns a MLB player's weighted On-Base Average by yearID

``` r
woba_season("fieldpr01","2014")
```

    ## [1] 0.3049516

-   lahman\_search : Returns a player's Lahman playerID using either:
-   nameFirst (Player First Name)
-   nameLast (Player Last Name)
-   nameGiven (Player Given Name)
-   retroID ([Retrosheet](http://www.retrosheet.org/retroID.htm) ID)
-   bbrefID ([Baseball Reference](http://www.baseball-reference.com/players/) ID)

``` r
lahman_search(nameFirst = "Robin")
```

    ##    playerID nameFirst nameLast         nameGiven  retroID   bbrefID
    ## 1 jenniro01     Robin Jennings Robin Christopher jennr001 jenniro01
    ## 2 roberro01     Robin  Roberts        Robin Evan rober102 roberro01
    ## 3 venturo01     Robin  Ventura        Robin Mark ventr001 venturo01
    ## 4 yountro01     Robin    Yount          Robin R. younr001 yountro01

``` r
lahman_search(nameLast = "Fielder")
```

    ##    playerID nameFirst nameLast     nameGiven  retroID   bbrefID
    ## 1 fieldce01     Cecil  Fielder   Cecil Grant fielc001 fieldce01
    ## 2 fieldpr01    Prince  Fielder Prince Semien fielp001 fieldpr01

``` r
lahman_search(nameGiven = "Russell Oles")
```

    ##    playerID nameFirst nameLast    nameGiven  retroID   bbrefID
    ## 1 branyru01   Russell  Branyan Russell Oles branr001 branyru01

``` r
lahman_search(retroID = "molip001")
```

    ##    playerID nameFirst nameLast nameGiven  retroID   bbrefID
    ## 1 molitpa01      Paul  Molitor  Paul Leo molip001 molitpa01

``` r
lahman_search(bbrefID = "yostne01")
```

    ##   playerID nameFirst nameLast       nameGiven  retroID  bbrefID
    ## 1 yostne01       Ned     Yost Edgar Frederick yoste001 yostne01

Have a question, issue or suggestion? Create a pull request, file an issue, or feel free to contact me on [Twitter](https://twitter.com/mikeleeco) or [my website](http://mikelee.co/)!
=======================================================================================================================================================================================

Have a question, issue or suggestion? Create a pull request or feel free to contact me on [Twitter](https://twitter.com/mikeleeco)!
