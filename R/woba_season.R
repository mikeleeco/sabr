#' wOBA performance by player season
#'
#' This function returns a MLB player's weight On-Base Average
#' statistic using the Lahman baseball database and Fangraphs weights
#'
#' @param playerID Unique Lahman reference ID
#' @param yearID Season
#' @return Print wOBA of \code{playerID} during \code{yearID}
#' @export
#' @import DBI
#' @import RSQLite
#' @import dplyr
woba_season <- function(playerID = "parrage01", yearID = "2014") {

  load("data/woba_guts.Rdata")
  wobayear <- dplyr::filter(woba_guts,Season == yearID)
  wobayear <- as.data.frame(wobayear)

  query <- paste("SELECT SUM(H) as H, SUM([2B]) as DB, SUM([3B]) as TR,SUM(HR) as HR, SUM(AB) as AB, SUM(BB) as BB, SUM(IBB) as IBB, SUM(SF) as SF, SUM(HBP) as HBP FROM Batting WHERE playerID = '", playerID, "' AND yearID = '", yearID, "'", sep="")

  lahman <- DBI::dbConnect(RSQLite::SQLite(), "data/lahman2014.sqlite")
  query <- DBI::dbGetQuery(lahman, query)
  query <- as.data.frame(query)

  uBB <- wobayear$wBB*(query$BB-query$IBB)
  HBP <- wobayear$wHBP*(query$HBP)
  DB <- wobayear$w2B*(query$DB)
  TR <- wobayear$w3B*(query$TR)
  HR <- wobayear$wHR*(query$HR)
  H <- wobayear$w1B*(query$H - query$DB - query$TR - query$HR)
  AB <- query$AB
  BB <- query$BB
  IBB <- query$IBB
  SF <- query$SF

  woba <- (uBB + HBP + H + DB + TR + HR) / (AB + BB - IBB + SF + HBP)
  print(woba)
}
