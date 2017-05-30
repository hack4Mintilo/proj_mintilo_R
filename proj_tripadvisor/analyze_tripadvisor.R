
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

## get hotel's rank
source("./scrapTripAdvisor_src.R")

trip_advisor_table <- scrapTripAdvisor(country = "Ethiopia", serv_type = "Hotels", serv_code = "g293790", 
                                       ext_serv_type = "Hotels", is_exp = TRUE)
head(trip_advisor_table)

## get customer's reviews
source("./getReview_tripAdvisor_src.R")


  
