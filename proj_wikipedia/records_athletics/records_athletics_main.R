
## set environment
user <- "<username>"
cwd <- paste("/Users/", user, "/Desktop/Data Science/Data Mining with R/proj_mintilo_R/proj_wikipedia/records_athletics", sep = "")

## set current working directory
setwd(cwd)

## add supportive libraries
library(rvest)       ## for scraping wikipedia page
library(xlsx)        ## for reading/writing xls files
library(plyr)        ## for merging dataframes
library(stringr)     ## for string manipulation
library(lubridate)   ## for date manipulation
library(ggplot2)     ## for ploting
library(reshape2)    ## for getting your data in the format ggplot2 would like
library(ggmap)       ## for getting longitude/latitude of a city

library(tm)          ## needed by word-cloud pkg
library(SnowballC)   ## needed by word-cloud pkg
library(wordcloud)   ## for analyzing string using word-cloud

library(countrycode)  ## needed for recoding country name
library(sqldf)        ## needed for merging tables with SQL syntax
library(maps)         ## for worldmap

## load main function(s)
source("./functions/records_athletics_fn.R")
source("./functions/get_geoLocation_fn.R")
source("./functions/get_geoLocation_data_fn.R")
source("./functions/get_wordcloud_fn.R")
source("./functions/get_mapAthletes_fn.R")

## scrap records hold by Ethiopian athletes
records_athletics_eth <- scrapWikipedia_recordAthletics(country = "Ethiopian")

## country=Kenya
records_athletics_ken <- scrapWikipedia_recordAthletics(country = "Kenyan")

## combine dataframes for analysis purpose
records_athletics_all <- as.data.frame(rbind.fill(records_athletics_eth, records_athletics_ken))
records_athletics_all <- records_athletics_all[, c("Event", "Athlete", "comp_doorInOut", "sex", "Athlete_profile", "category", "year", "distance", "distance_category", 
                                                   "country", "city", "fname", "lname", "country_code")]


## ----------------------------------------------- ##
## <!-- Analyze short distance records.        --> ##
## ----------------------------------------------- ##

## records over time by country
# records_athletics_short <- records_athletics_short[order(records_athletics_short$year), ]
records_athletics_all <- records_athletics_all[order(records_athletics_all$year), ]

png("./outputs/plots/distribution_of_records_by_sex_and_distance.png")

## -- option-1
# qplot(x = year, y = distance, data = records_athletics_all, geom = "line")
main_plt <- ggplot(data = records_athletics_all, 
                   aes(year, distance, 
                       colour = Athlete_profile,
                       group = Athlete_profile)) + geom_line() + xlab("Year") + ylab("Distance")
# main_plt

# Divide by levels of "distance_category", in the horizontal direction
# main_plt + facet_grid(distance_category ~ sex) 
final_plt <- main_plt + facet_wrap(distance_category ~ sex, ncol = 2, scales = "free")
final_plt

dev.off()

## -- save the plot
# ggsave("./outputs/plots/plt_distribution_records_by_sex_and_distance-category.png", 
#        final_plt, scale = 2, device = "png")

# ggsave("./outputs/plots/plt_distribution_records_by_sex_and_distance-category_pdf.pdf", 
#        final_plt, scale = 2, device = "pdf")

# ggsave("./outputs/plots/plt_distribution_records_by_sex_and_distance-category.png", 
#        final_plt, width = 30, height = 20, units = "cm")


## ------------------------------------------------------------------------ ##
## <!-- Analyze athlete's first/last names using word-cloud.            --> ##
## ------------------------------------------------------------------------ ##
get_wordcloud(dsin = records_athletics_all, min_freq = 1, varin = "fname")
get_wordcloud(dsin = records_athletics_all, min_freq = 1, varin = "lname")
get_wordcloud(dsin = records_athletics_all, min_freq = 1, varin = "city")
# get_wordcloud(dsin = records_athletics_all, min_freq = 1, varin = "country")
get_wordcloud(dsin = records_athletics_all, min_freq = 1, varin = "country_code")


## ------------------------------------------------------------------------ ##
## <!-- Analyze geographical location of world athletics records.       --> ##
## ------------------------------------------------------------------------ ##
## -- get geo-location data
geoLoc_country <- get_geoLocation_data(dsin = records_athletics_all, loc_type = "country") 
geoLoc_city <- get_geoLocation_data(dsin = records_athletics_all, loc_type = "city") 

## -- add geo-location info to main analysis dataset
records_athletics_all2 <- sqldf("SELECT A.*, B.lon_country, B.lat_country, C.lon_city, C.lat_city 
                                 FROM records_athletics_all AS A 
                                 LEFT JOIN geoLoc_country AS B 
                                 ON A.country = B.country 
                                 LEFT JOIN geoLoc_city AS C 
                                 ON A.city = C.city")

## -- Worldmap with Athletes profile
get_mapAthelets(dsin = records_athletics_all2, varin = "Athlete_profile", country_baseline = "Ethiopian", 
                db_sel = "world", lon_in = "lon_country", lat_in = "lat_country")

## USA map
get_mapAthelets(dsin = records_athletics_all2, varin = "Athlete_profile", country_baseline = "Ethiopian", 
                db_sel = "usa", lon_in = "lon_city", lat_in = "lat_city")

