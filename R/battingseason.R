#' Offensive performance by player season
#'
#' This function returns a MLB player's offensive performance
#' statistics from the Lahman baseball database
#'
#' @param playerID Unique Lahman reference ID
#' @param yearID Season
#' @return Dataframe of batting statistics of \code{playerID} during
#' \code{yearID}
#' @export
battingseason <- function(playerID = "parrage01", yearID = "2014") {

  query <- paste("SELECT playerID, yearID, MAX(stint) as stints, GROUP_CONCAT(DISTINCT teamID) as teamID, SUM(AB) as AB, SUM(R) as R, SUM(H) as H, SUM([2B]) as DB, SUM([3B]) as TR,SUM(HR) as HR, SUM(RBI) as RBI, SUM(SB) as SB, SUM(CS) as CS, SUM(BB) as BB,  SUM(SO) as SO, SUM(IBB) as IBB, SUM(SF) as SF, SUM(SH) as SH, SUM(GIDP) as GIDP, SUM(HBP) as HBP FROM Batting WHERE playerID = '", playerID, "' AND yearID = '", yearID, "' GROUP BY yearID", sep="")

  lahman <- DBI::dbConnect(RSQLite::SQLite(), "inst/db/lahman2014.sqlite")
  query <- RSQLite::dbGetQuery(lahman, query)
  query <- as.data.frame(query)

  print(query)
}
