
## set environment
user <- "workuhm"
cwd <- paste("/Users/", user, "/Desktop/Data Science/Data Mining with R/proj_mintilo_R/proj_wikipedia/records_athletics", sep = "")

## set current working directory
setwd(cwd)

## add supportive libraries
library(rvest)     ## for scraping wikipedia page
library(xlsx)      ## for reading/writing xls files
library(plyr)      ## for merging dataframes
library(stringr)   ## for string manipulation

## load main function(s)
source("./records_athletics_fn.R")

## scrap records in Athletics hold by Ethiopians
records_athletics_eth <- scrapWikipedia_recordAthletics(country = "Ethiopian")

## country=Kenya
records_athletics_ken <- scrapWikipedia_recordAthletics(country = "Kenyan")


