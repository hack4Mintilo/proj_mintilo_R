
## ---------------------------------------- ##
## Chapter 2: Predicting Algae Blooms       ##
## Book Title: Data Mining with R: ...      ##
## By Luis Torgo (2011)                     ##
## -----------------------------------------##
## Programmer: hack4Mintilo                 ##
## Email: hack4Mintilo@gmail.com            ##
## -----------------------------------------##
## Date: 23-May-2017 (Initial version)      ##
## -----------------------------------------##

## set working directory
#setwd("<user>/Desktop/Data Science/Data Mining with R/src_r/Luis_Torgo/chap2_algae_bloom")

## ------------------------------------------------- ##
## Step-1: load algae bloom dataset from UCI page.   ##
## --------------------------------------------------##

## load library
#install.packages("RCurl")
#install.packages("XML")
library(RCurl)
# library(XML)

url_data_analysis <- "https://archive.ics.uci.edu/ml/machine-learning-databases/coil-mld/analysis.data"
algae_url <- getURL(url = url_data_analysis, ssl.verifypeer=FALSE)
algae_connection <- textConnection(algae_url)
algae <- read.csv(algae_connection, header = FALSE)




