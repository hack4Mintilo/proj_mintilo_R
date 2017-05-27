
## -- set current working directory
user <- "<user>"
project <- "proj_tripadvisor"
cwd <- paste("/Users/", user, "/Desktop/Data Science/Data Mining with R/proj_mintilo_R/", project, 
             sep = "")
setwd(cwd)


## --------------------------------------------------- ##
## <!-- Scraping TripAdvisor for customer reviews  --> ##
## --------------------------------------------------- ##
library(rvest)

## load talk2Alexa source file
source("./scrapTripAdvisor_src.R")
  
