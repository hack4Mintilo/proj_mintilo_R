scrapAlexa <- function(country = NULL, is_regional = FALSE, region = NULL, is_exp = FALSE) {

  ## ------------------------------ ##
  ## <!-- Calling to Alexa...   --> ##
  ## ------------------------------ ##
  if (is_regional) {
    url <- paste("http://www.alexa.com/topsites/category/Regional/", region, "/", country, sep = "")
  }
  else {
    url <- paste("http://www.alexa.com/topsites/countries/", country, sep = "")
  }
  
  ## load the page
  try(top_sites <- read_html(url))
  
  ## get attributes
  rank <- top_sites%>%html_nodes("div div .number")%>%html_text()
  site <- top_sites%>%html_nodes(".DescriptionCell p a")%>%html_text()
  site_desc <- top_sites%>%html_nodes(".DescriptionCell .description")%>%html_text()
  daily_time_on_site <- top_sites%>%html_nodes(".DescriptionCell+ .right p")%>%html_text()
  daily_pageviews_per_visitor <- top_sites%>%html_nodes(".right:nth-child(4) p")%>%html_text()
  percent_of_traffic_from_search <- top_sites%>%html_nodes(".right:nth-child(5) p")%>%html_text()
  total_sites_linking_in <- top_sites%>%html_nodes(".right:nth-child(6) p")%>%html_text()
  
  ## create dataframe of top site rankings
  top_sites_table <- data.frame(rank=rank, site=site, site_desc, 
                                daily_time_on_site, daily_pageviews_per_visitor, 
                                percent_of_traffic_from_search, total_sites_linking_in)
  
  ## ------------------------------ ##
  ## <!-- Pre-processing data.  --> ##
  ## ------------------------------ ##
  # library(stringr)   ## used for multiple pattern replacement
  
  top_sites_table$rank <- as.numeric(top_sites_table$rank)
  
  top_sites_table$site_desc <- gsub(pattern = "\n", replacement = "", top_sites_table$site_desc)
  top_sites_table$site_desc <- gsub(pattern = "Less", replacement = "", top_sites_table$site_desc)
  
  top_sites_table$site_desc <- as.character(top_sites_table$site_desc)
  # top_sites_table$site_desc <- sub(pattern = "^$", replacement = "NA", top_sites_table$site_desc)
  # top_sites_table$site_desc
  # top_sites_table$site_desc <- str_replace_all(string = top_sites_table$site_desc, pattern = c("\n", "Less"), replacement = "")
  
  top_sites_table$daily_time_on_site <- gsub(pattern = ":", replacement = ".", 
                                             top_sites_table$daily_time_on_site)
  
  top_sites_table$daily_time_on_site <- as.numeric(top_sites_table$daily_time_on_site)
  top_sites_table <- top_sites_table[order(top_sites_table$rank), ]
  
  ## export data, if requested
  if (is_exp) {
    require(xlsx)
    
    ## define file name
    if (is_regional) {
      xls_fname <- paste("./top_sites_by_", region, "_", country, ".xlsx", sep = "")
    }
    else {
      xls_fname <- paste("./top_sites_by_", country, ".xlsx", sep = "")
    }
    
    write.xlsx(x = top_sites_table, file = xls_fname, sheetName = "TopSitesByCountry", 
               row.names = FALSE, col.names = TRUE)
  }
}