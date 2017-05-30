scrapTripAdvisor <- function(country = NULL, serv_type = NULL, serv_code, 
                             ext_serv_type = NULL, is_exp = FALSE) {
  
  ## Param:
  ##      - serv_type: type of service (e.g., Hotels, Restaurants, Attractions, 
  ##                      Flights, etc)
  ## -----------------------------------------------------------------------------
  
  require(rvest)
  
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
  trip_advisor <- read_html(url)
  
  ## get attributes
  # name <- character()
  name <- trip_advisor%>%html_nodes(".listing_title .property_title")%>%html_text(); print(name[1:5])
  rank <- trip_advisor%>%html_nodes(".recRanking .slim_ranking")%>%html_text(); print(rank[1:5])
#   name_rank <- character()
#   name_rank <- paste(name, c(1:length(name)), sep = "-")
  
  # price <- trip_advisor%>%html_nodes(".fullPrice span .xthrough_good")%>%html_text()    ## not working
  
#   reviews_urls <- trip_advisor%>%html_nodes(".ratingReview a")%>%html_attr("href")    ## not working
#   reviews_links <- trip_advisor%>%html_nodes(".ratingReview a")%>%html_text() 
  # reviews_urls <- trip_advisor%>%html_nodes(xpath = '//*[@id="HOTELDEAL7379267"]/div/div/div[4]/div[1]/div[1]/span')%>%html_attr("href")
  
#   reviews_urls <- trip_advisor%>%html_nodes(".rtofimg .statsLine.easyClear .ratingReview span a")%>%html_attr("href")
#   reviews_links <- trip_advisor%>%html_nodes(".rtofimg .statsLine.easyClear .ratingReview span a")%>%html_text()
  
#   reviews_urls <- trip_advisor%>%html_nodes("#HOTELDEAL .rtofimg .statsLine.easyClear .ratingReview span a")%>%html_attr("href")
#   reviews_links <- trip_advisor%>%html_nodes(".rtofimg .statsLine.easyClear .ratingReview span")%>%html_text()
  
#   url <- "http://www.tripadvisor.com/Hotel_Review-g37209-d1762915-Reviews-JW_Marriott_Indianapolis-Indianapolis_Indiana.html"
#   
#   reviews <- url %>%
#     read_html() %>%
#     html_nodes("#REVIEWS .innerBubble")
  
  ## ------------------------------ ##
  ## <!-- Pre-processing data.  --> ##
  ## ------------------------------ ##
  require(stringr)
  # rank <- as.numeric(str_match(rank, "#([0-9]{1}|[0-9]{2}) ")[,2])
  # rank <- str_match(rank, "#([0-9]{1}|[0-9]{2}) ")[,2]
  
  ## -- create dataframe of top site rankings
  trip_advisor_table <- data.frame(name=name, rank=rank, name_reviews=gsub("\\s", "_", gsub(",|-", "", name), perl = T))
  # trip_advisor_table <- as.data.frame(cbind(name=name, name_reviews=gsub("\\s", "_", gsub(",|-", "", name), perl = T), rank=c(1:length(name))))
  
  ## export data, if requested
  if (is_exp) {
    require(xlsx)
    
    xls.fname <- paste("./tripadvisor", "_", country, "_", serv_type,".xlsx", sep = "")
    write.xlsx(x = trip_advisor_table, file = xls.fname, sheetName = "tripadvisor", 
               row.names = FALSE, col.names = TRUE)
  }
  
  return(trip_advisor_table)
}