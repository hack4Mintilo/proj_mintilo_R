scrapReviews_TripAdvisor <- function (hotel_name = NULL, hotel_city = NULL, 
                                      hotelG_code = NULL, hotelD_code = NULL) {
  
  ## -- 
  ## -- prototype: the reviews are located in different pages...
  ## -- E.g., see or255 index, https://www.tripadvisor.com/Hotel_Review-g293791-d7379267-Reviews-or255-Addissinia_Hotel-Addis_Ababa.html#REVIEWS
  
  ## target link: https://www.tripadvisor.com/Hotel_Review-g293791-d7379267-Reviews-Addissinia_Hotel-Addis_Ababa.html#REVIEWS
#   url.main <- "https://www.tripadvisor.com"
#   url.codes <- paste(hotelG_code, "-", hotelD_code)
  
  url <- "https://www.tripadvisor.com/Hotel_Review-g293791-d7379267-Reviews-Addissinia_Hotel-Addis_Ababa.html#REVIEWS"
  
  reviews_page <- read_html(url)
  
  reviewer <- reviews_page%>%html_nodes(".scrname")%>%html_text()
  # selector_rating <- "#taplc_location_detail_overview_hotels_0 > div > div.overviewContent > div.ui_columns.is-mobile.reviewsAndDetails > div.ui_column.is-6.reviews > div.rating > span"
  # xpath_rating <- "//*[@id="taplc_location_detail_overview_hotels_0"]/div/div[2]/div[1]/div[1]/div[1]/span"
  # overall_rating <- reviews_page%>%html_nodes(".rating span.overallRating")%>%html_text()
  # overall_rating <- reviews_page%>%html_nodes(selector_rating)%>%html_text()
  # overall_rating <- reviews_page%>%html_nodes(xpath = //*[@id="taplc_location_detail_overview_hotels_0"]/div/div[2]/div[1]/div[1]/div[1]/span)%>%html_text()
  
  reviewer_subject <- reviews_page%>%html_nodes(".provider0 .is-9 .isNew .noQuotes")%>%html_text()
  
}
