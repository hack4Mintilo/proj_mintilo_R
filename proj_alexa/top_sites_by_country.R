
## -- set current working directory
user <- "<user>"
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


## Get info for a specific country, ET
country_ET <- country_all_filter[country_all_filter$alpha2Code == "ET", ]

## --------------------------------------------------- ##
## <!-- Scraping Alexa for top websites by country --> ##
## --------------------------------------------------- ##
library(rvest)

## load talk2Alexa source file
source("./scrapAlexa_src.R")

## country = Ethiopia (ET)
# scrapAlexa(country = "Ethiopia", is_region = TRUE, region = "Africa", is_exp = TRUE)

# borders <- c("ET", "DJ", "KE", "SO", "SD")     ## no info for Eritrea (ER)
borders <- substr(country_all_filter[country_all_filter$alpha3Code == "ETH", ]$borders, 
                  start = 1, stop = 2)

for (border in borders) {
  
  scrapAlexa(country = border, is_regional = FALSE, is_exp = TRUE)
}
