
## -- set current working directory
user <- "workuhm"
cwd <- paste("/Users/", user, "/Desktop/Data Science/Data Mining with R/proj_mintilo_R/proj_alexa", 
             sep = "")
setwd(cwd)

## --------------------------------------------------- ##
## <!-- Obtain country information using REST api  --> ##
## --------------------------------------------------- ##

# install.packages("mapdata")
# library(mapdata)

## SOURCE: http://www.internetworldstats.com/list1.htm
# url_world_region <- "http://www.internetworldstats.com/list1.htm#geo"
# world_region <- read_html(url_world_region)
# continent <- world_region%>%html_nodes("td blockquote ul")%>%html_text()
# continent <- gsub("\n", " ", continent)

# install.packages("jsonlite")
library(jsonlite)
url_country_json <- "https://restcountries.eu/rest/v2/all"
# country_json <- read_json(url_country_json)    ## not needed anymore because of 'fromJSON' function
country_all <- fromJSON(url_country_json)

## filter data for export
country_all_filter <- country_all[ , c("name", "alpha2Code", "alpha3Code", "capital", 
                                       "region", "subregion", "borders")]
# sapply(country_all_filter, class)   ## check class type
# country_all_filter$borders <- unlist(country_all_filter$borders)   ## not working...

## using tidyr package to unlist borders variable
library(tidyr)
country_all_filter <- unnest(data = country_all_filter, borders)

## export all country
library(xlsx)
write.xlsx(x = country_all_filter, file = "./country_all_filter.xlsx", sheetName = "countryAll_filter", 
           row.names = FALSE, col.names = TRUE)


##

## --------------------------------------------------- ##
## <!-- Scraping Alexa for top websites by country --> ##
## --------------------------------------------------- ##
library(rvest)

## url
url <- paste("http://www.alexa.com/topsites/countries/", country, sep = "")

## load the page
top_sites <- read_html(url)

## get attributes
rank <- top_sites%>%html_nodes("div div .number")%>%html_text()
site <- top_sites%>%html_nodes(".DescriptionCell p a")%>%html_text()
site_desc <- top_sites%>%html_nodes(".DescriptionCell .description")%>%html_text()
daily_time_on_site <- top_sites%>%html_nodes(".DescriptionCell+ .right p")%>%html_text()
daily_pageviews_per_visitor <- top_sites%>%html_nodes(".right:nth-child(4) p")%>%html_text()
percent_of_traffic_from_search <- top_sites%>%html_nodes(".right:nth-child(5) p")%>%html_text()
total_sites_linking_in <- top_sites%>%html_nodes(".right:nth-child(6) p")%>%html_text()

top_sites_table <- data.frame(rank=rank, site=site, site_desc, 
                              daily_time_on_site, daily_pageviews_per_visitor, 
                              percent_of_traffic_from_search, total_sites_linking_in)

## -- pre-processing data
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

## export data 
library(xlsx)
# write.csv(x = top_sites_table, file = "./top_sites_by_country.csv", 
#           row.names = FALSE, header = TRUE, na = "")
write.xlsx(x = top_sites_table, file = "./top_sites_by_country.xlsx", sheetName = "TopSitesByCountry", 
           row.names = FALSE, col.names = TRUE)


