
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

## <!-- option 1: accessing algae dataset from UCI ML webpage  -->
#install.packages("RCurl")
#install.packages("XML")
library(RCurl)
# library(XML)

# url_data_analysis <- "https://archive.ics.uci.edu/ml/machine-learning-databases/coil-mld/analysis.data"
# algae_url <- getURL(url = url_data_analysis, ssl.verifypeer=FALSE)
# algae_connection <- textConnection(algae_url)
# algae <- read.csv(algae_connection, header = FALSE)

## <!-- option 2: accessing algae dataset from DMwR package (see pp. 41, Luis Torgo)  -->
install.packages("DMwR")
library(DMwR)
head(algae)
?algae

## step-2: data visualization and summarization
## FINDINGS:
## -- [pp 44]. There are more water samples collected in winter (n_win=62) than in other seasons (n_aut=40; n_spr=53; n_summ=45)
summary(algae)

hist(algae$mxPH, probability = F)

boxplot(algae$oPO4, ylab="Orthophosphate (oPo4)")
abline(h = mean(algae$oPO4, na.rm = T), lty=2)

## ------------------------------------ ##
## <!-- falcon_mission 1            --> ##
## ------------------------------------ ##
## [pp 49] understanding the distribution of the values of, say, algal a1.
library(lattice)

## FINDINGS:
## -- [pp 49]. Higher frequencies of algae A1 in smaller rivers 
bwplot(size ~ a1, data = algae, ylab = "River size", xlab = "Algae A1")

## -- [pp 50]. Box-percentile plots
## FINDINGS:
## -- we can confirm our previous observation that smaller rivers have 
##    higher frequencies of this alga, but we can also observe that the 
##    value of the observed frequencies for these small rivers is much 
##    more widespread across the domain of frequencies than for other types of rivers.
library(Hmisc)
bwplot(size ~ a1, data = algae, 
       panel = panel.bpplot, probs=seq(0.01,0.49,by=0.01), datadensity=TRUE,
       ylab = "River size", xlab = "Algae A1")


## -- condition plot for contineous variables
min02 <- equal.count(na.omit(algae$mnO2),
                     number=4, overlap=1/5)





