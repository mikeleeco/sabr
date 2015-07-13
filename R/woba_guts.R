#' Retrieves wOBA guts table
#'
#' This function returns the yearly wOBA guts weights
#' from Fangraphs (http://www.fangraphs.com/guts.aspx?type=cn)
#'
#' @return Dataframe of woba weights from Fangraphs
#' (http://www.fangraphs.com/guts.aspx?type=cn)
#' @export
#' @import dplyr
woba_guts <- function() {
  woba_guts <- data.frame()
  url <- "http://www.fangraphs.com/guts.aspx?type=cn"
  guts_table <- '#GutsBoard1_dg1_ctl00'

  rvest::html(url) %>%
    rvest::html_nodes(guts_table) %>%
    rvest::html_table(header = T) %>%
    data.frame() %>%
    dplyr::tbl_df() -> woba_guts

  save(woba_guts, file = "data/woba_guts.Rdata")
  print(woba_guts)
}
