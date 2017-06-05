
## set environment
user <- "workuhm"
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

## load main function(s)
source("./records_athletics_fn.R")

## scrap records hold by Ethiopian athletes
records_athletics_eth <- scrapWikipedia_recordAthletics(country = "Ethiopian")

## country=Kenya
records_athletics_ken <- scrapWikipedia_recordAthletics(country = "Kenyan")

## combine dataframes for analysis purpose
records_athletics_all <- as.data.frame(rbind.fill(records_athletics_eth, records_athletics_ken))
records_athletics_all <- records_athletics_all[, c("Event", "Athlete", "comp_doorInOut", "sex", "Athlete_profile", "category", "year", "distance", "distance_category")]


## ----------------------------------------------- ##
## <!-- Analyze short distance records.        --> ##
## ----------------------------------------------- ##

## records over time by country
# records_athletics_short <- records_athletics_short[order(records_athletics_short$year), ]
records_athletics_all <- records_athletics_all[order(records_athletics_all$year), ]

## -- option-1
# qplot(x = year, y = distance, data = records_athletics_all, geom = "line")
main_plt <- ggplot(data = records_athletics_all, 
                   aes(year, distance, 
                       colour = Athlete_profile,
                       group = Athlete_profile)) + geom_line() + xlab("Year") + ylab("Distance")
main_plt

# Divide by levels of "distance_category", in the horizontal direction
# main_plt + facet_grid(distance_category ~ sex) 
main_plt + facet_wrap(distance_category ~ sex, ncol = 2, scales = "free")

# Divide by levels of "sex", in the horizontal direction
# main_plt + facet_grid(. ~ sex)




