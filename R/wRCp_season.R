#' wRCp performance by player season
#'
#' This function returns a MLB player's weighted Runs Created Plus
#' statistic using the Lahman baseball database statistics/park factors
#' and Tangotiger's formula for calculating wOBA weights/scales
#'
#' @param playerID - Unique Lahman reference ID
#' @param yearID - Season
#' @return Print wRC+ of \code{playerID} during \code{yearID}
#' @references Andrew Dolphin, Mitchel Lichtman, and Tom Tango (2007)
#'             The Book: Playing the Percentages in Baseball
#' @export
#' @import DBI
#' @import RSQLite
wRCp_season <- function(playerID = NULL, yearID = NULL, ...) {
  
  db <- lahman()
  woba_guts <- RSQLite::dbGetQuery(db, "SELECT * FROM wOBA_Table")
  wobayear <- woba_guts[woba_guts$yearID == yearID, ]
  wobayear <- data.frame(wobayear)

  nlalrpa <- RSQLite::dbGetQuery(db, "SELECT * FROM League_RPA_Table")
  nlalrpa <- nlalrpa[nlalrpa$yearID == yearID, ]
  nlalrpa <- data.frame(nlalrpa)

  query <- paste("SELECT *, b.AB + b.BB + b.HBP + b.SH + b.SF as PA FROM Batting AS b left join Teams AS t using (yearID, teamID, lgID) WHERE playerID = '", playerID, "' AND yearID = '", yearID, "'", sep="")

  db <- lahman()
  query <- RSQLite::dbGetQuery(db, query)
  query <- as.data.frame(query)
  query$PF <- 

  uBB <- wobayear$wobaBB*(query$BB-query$IBB)
  HBP <- wobayear$wobaHB*(query$HBP)
  DB <- wobayear$woba2B*(query$'2B')
  TR <- wobayear$woba3B*(query$'3B')
  HR <- wobayear$wobaHR*(query$HR)
  H <- wobayear$woba1B*(query$H - query$'2B' - query$'3B' - query$HR)
  AB <- query$AB
  BB <- query$BB
  IBB <- query$IBB
  SF <- query$SF
  SH <- query$SH
  PA <- query$PA

  woba <- (uBB + HBP + H + DB + TR + HR) / (AB + BB - IBB + SF + HBP)
  # woba <- woba_season(playerID,yearID)
  wRAA <-((woba-wobayear$wOBA)/wobayear$wOBAscale)*PA
  query$wRAA <- wRAA

  if(all(c("NL","AL") %in% query$lgID)) {
    querynl <- subset(query, lgID=="NL")
    nlalrpa_nl <- subset(nlalrpa,lgID=="NL")
    wRCp_stints_nl <- ((((querynl$wRAA/querynl$PA) + wobayear$R.PA) + (wobayear$R.PA - (querynl$PPF/100)*wobayear$R.PA))/nlalrpa_nl$R.PA)*100
    # wRCp_stints_nlm <- sum((wRCp_stints_nl*querynl$PA)/sum(querynl$PA))
    queryal <- subset(query,lgID=="AL")
    nlalrpa_al <- subset(nlalrpa,lgID=="AL")
    wRCp_stints_al <- ((((queryal$wRAA/queryal$PA) + wobayear$R.PA) + (wobayear$R.PA - (queryal$PPF/100)*wobayear$R.PA))/nlalrpa_al$R.PA)*100
    # wRCp_stints_alm <- sum((wRCp_stints_al*queryal$PA)/sum(queryal$PA))
    #sum((wRCp_stints*query$PA)/sum(query$PA))
    wRCp <- sum(((wRCp_stints_nl*querynl$PA)/sum(querynl$PA,queryal$PA)),((wRCp_stints_al*queryal$PA)/sum(querynl$PA,queryal$PA)))
  } else {
    if(isTRUE(unique(query$lgID) == "AL")) {
      nlalrpa <- subset(nlalrpa, lgID=="AL")
      wRCp_stints <- ((((query$wRAA/query$PA) + wobayear$R.PA) + (wobayear$R.PA - (query$PPF/100)*wobayear$R.PA))/nlalrpa$R.PA)*100
      wRCp <- sum((wRCp_stints*query$PA)/sum(query$PA))
    } else {
    if(isTRUE(unique(query$lgID) == "NL")) {
      nlalrpa <- subset(nlalrpa, lgID=="NL")
      wRCp_stints <- ((((query$wRAA/query$PA) + wobayear$R.PA) + (wobayear$R.PA - (query$PPF/100)*wobayear$R.PA))/nlalrpa$R.PA)*100
      wRCp <- sum((wRCp_stints*query$PA)/sum(query$PA))
    }
   }
  }
  wRCp
}