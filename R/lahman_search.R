#' Lahman SQLite database search
#'
#' This function returns a queries from the Master table from
#' the 2015 Lahman baseball database to assist in further queries.
#'
#' @param playerID - Unique Lahman reference ID
#' @param nameFirst - Player First Name
#' @param nameLast - Player Last Name
#' @param nameGiven - Player Given Name
#' @param retroID - Unique Retrosheet reference ID
#' @param bbrefID - Unique Baseball-Reference reference ID
#' @return Dataframe of career batting statistics for \code{playerID}
#' @export
#' @import DBI
#' @import RSQLite
#' @example man/examples/lahman_search.R
lahman_search <- function(playerID = NULL, nameFirst = NULL, nameLast = NULL, nameGiven = NULL, retroID = NULL, bbrefID = NULL) {

  query <- paste("SELECT playerID, nameFirst, nameLast, nameGiven, retroID, bbrefID FROM Master WHERE playerID = '", playerID, "' OR nameFirst = '", nameFirst, "' OR nameLast = '", nameLast, "' OR nameGiven = '", nameGiven, "' OR retroID = '", retroID, "' OR bbrefID = '", bbrefID, "'", sep="")
  db <- lahman()
  query <- RSQLite::dbGetQuery(db, query)
  query <- as.data.frame(query)

  print(query)
}
