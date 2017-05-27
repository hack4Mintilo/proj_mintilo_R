scrapTripAdvisor <- function(country = NULL, serv_type = NULL, serv_code, 
                             ext_serv_type = , is_exp = FALSE) {
  
  ## Param:
  ##      - serv_type: type of service (e.g., Hotels, Restaurants, Attractions, 
  ##                      Flights, etc)
  ## -----------------------------------------------------------------------------
  
  
  ## --------------------------------- ##
  ## <!-- Calling to TripAdvisor   --> ##
  ## --------------------------------- ##
  # e.g., https://www.tripadvisor.com/Hotels-g293790-Ethiopia-Hotels.html
  if (!is.null(ext_serv_type)) {
    ext_serv_type <- paste("-", ext_serv_type, 
                           sep = "")
  }
  
  url_main <- "https://www.tripadvisor.com/"
  url <- paste(url_main, serv_type, "-", serv_code, "-", country, 
               ext_serv_type, sep = "")
  
  ## load the page
  trip.advisor <- read_html(url)
  
  ## get attributes
  name <- trip.advisor%>%html_nodes(".listing_title .property_title")%>%html_text()
  rank <- trip.advisor%>%html_nodes(".recRanking .slim_ranking")%>%html_text()
  # price <- trip.advisor%>%html_nodes(".fullPrice span .xthrough_good")%>%html_text()    ## not working
  rating <- trip.advisor%>%html_nodes("")%>%html_text()    ## not working
  
  
  ## -- pre-processing data
  library(stringr)
  qwe <- as.numeric(str_match(rank, "#([0-9]{1}|[0-9]{2}) ")[,2])
  
  ## -- create dataframe of top site rankings
  trip.advisor.table <- data.frame()
  
  ## ------------------------------ ##
  ## <!-- Pre-processing data.  --> ##
  ## ------------------------------ ##
  
  
  trip.advisor.table <- trip.advisor.table[order(ttrip.advisor.table$rank), ]
  
  ## export data, if requested
  if (is_exp) {
    require(xlsx)
    
    xls_fname <- paste("./tripadvisor", "_", country, "_", serv_type,".xlsx", sep = "")
    write.xlsx(x = trip.advisor.table, file = xls_fname, sheetName = "tripadvisor", 
               row.names = FALSE, col.names = TRUE)
  }
}