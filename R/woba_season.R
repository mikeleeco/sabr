#' wOBA performance by player season
#'
#' This function returns a MLB player's weight On-Base Average
#' statistic using the Lahman baseball database and Fangraphs weights
#'
#' @param playerID - Unique Lahman reference ID
#' @param yearID - Season
#' @return Print wOBA of \code{playerID} during \code{yearID}
#' @references Andrew Dolphin, Mitchel Lichtman, and Tom Tango (2007)
#'             The Book: Playing the Percentages in Baseball
#' @export
#' @import DBI
#' @import RSQLite
woba_season <- function(playerID = NULL, yearID = NULL, ...) {

  db <- lahman()
  woba_guts <- RSQLite::dbGetQuery(db, "SELECT * FROM wOBA_Table")
  wobayear <- woba_guts[woba_guts$yearID == yearID, ]
  wobayear <- data.frame(wobayear)

  query <- paste("SELECT GROUP_CONCAT(DISTINCT teamID) as teamID, SUM(H) as H, SUM([2B]) as DB, SUM([3B]) as TR,SUM(HR) as HR, SUM(AB) as AB, SUM(BB) as BB, SUM(IBB) as IBB, SUM(SF) as SF, SUM(SH) as SH, SUM(HBP) as HBP FROM Batting WHERE playerID = '", playerID, "' AND yearID = '", yearID, "'", sep="")

  db <- lahman()
  query <- RSQLite::dbGetQuery(db, query)
  query <- as.data.frame(query)

  uBB <- wobayear$wobaBB*(query$BB-query$IBB)
  HBP <- wobayear$wobaHB*(query$HBP)
  DB <- wobayear$woba2B*(query$DB)
  TR <- wobayear$woba3B*(query$TR)
  HR <- wobayear$wobaHR*(query$HR)
  H <- wobayear$woba1B*(query$H - query$DB - query$TR - query$HR)
  AB <- query$AB
  BB <- query$BB
  IBB <- query$IBB
  SF <- query$SF
  SH <- query$SH
  PA <- query$PA

  woba <- (uBB + HBP + H + DB + TR + HR) / (AB + BB - IBB + SF + HBP)
  woba
}
