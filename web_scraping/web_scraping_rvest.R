
## Web scraping IMDB website
install.packages("rvest")
library(rvest)

## read in HTML page
imdb <- read_html("http://www.imdb.com/movies-in-theaters/?ref_=nv_tp_inth_1")

## get attributes of the page
title <- imdb%>%html_nodes("h4 a")%>%html_text()
time <- imdb%>%html_nodes("p time")%>%html_text()
genere <- imdb%>%html_nodes("time+span")%>%html_text()

imdb_table <- data.frame(title=title, time=time, genere=genere)

## --------------------------------- ##
## <!-- Pre-processing Data      --> ##
## --------------------------------- ##
imdb_table$time <- gsub(pattern = "min", replacement = "", x = imdb_table$time)
imdb_table$time <- as.numeric(imdb_table$time)

## distribution movie time
imdb_table2 <- imdb_table[imdb_table$genere != "Documentary", ]
hist(imdb_table2$time, prob=TRUE, breaks = 7)
curve(dnorm(x, mean=mean(imdb_table2$time), sd=sd(imdb_table2$time)), add=TRUE)

