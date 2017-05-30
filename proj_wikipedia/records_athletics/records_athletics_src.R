scrapWikipedia_recordAthletics <- function () {
  
  require(rvest)
  
  ## ------------------------------------------------------------------------- ##
  ## <!-- Step-1: scrape wikipedia page for list of records in athletics.  --> ##
  ## ------------------------------------------------------------------------- ##
  url <- "https://en.wikipedia.org/wiki/List_of_Ethiopian_records_in_athletics"
  records_athletics <- read_html(url)
  
  ## -- get references
  # records_athletics_bib <- records_athletics%>%html_nodes(xpath='//*[@id="mw-content-text"]/div[2]')%>%html_text()     ## needs pre-processing
  
  ## -- get records tables  
  records_athletics_outdoorM <- as.data.frame(records_athletics%>%html_nodes(xpath='//*[@id="mw-content-text"]/table[1]')%>%html_table(fill = TRUE))
  records_athletics_outdoorF <- as.data.frame(records_athletics%>%html_nodes(xpath='//*[@id="mw-content-text"]/table[2]')%>%html_table(fill = TRUE))
  records_athletics_indoorM <- as.data.frame(records_athletics%>%html_nodes(xpath='//*[@id="mw-content-text"]/table[3]')%>%html_table(fill = TRUE))
  records_athletics_indoorF <- as.data.frame(records_athletics%>%html_nodes(xpath='//*[@id="mw-content-text"]/table[4]')%>%html_table(fill = TRUE))
  
  ## -- export raw datasets 
  require(xlsx)
  
  write.xlsx(x = records_athletics_outdoorM, file = "./records_athletics_outdoorM.xlsx", sheetName = "records_athletics_outdoorM", 
             row.names = FALSE, col.names = TRUE)
  write.xlsx(x = records_athletics_outdoorF, file = "./records_athletics_outdoorF.xlsx", sheetName = "records_athletics_outdoorF", 
             row.names = FALSE, col.names = TRUE)
  write.xlsx(x = records_athletics_indoorM, file = "./records_athletics_indoorM.xlsx", sheetName = "records_athletics_indoorM", 
             row.names = FALSE, col.names = TRUE)
  write.xlsx(x = records_athletics_indoorF, file = "./records_athletics_indoorF.xlsx", sheetName = "records_athletics_indoorF", 
             row.names = FALSE, col.names = TRUE)
  
  
  ## -- combine tables
  require(plyr)
  
  records_athletics_outdoorM <- records_athletics_outdoorM[, -8]
  records_athletics_outdoorM$comp_doorInOut <- "outdoor"; records_athletics_outdoorF$comp_doorInOut <- "outdoor"
  records_athletics_indoorM$comp_doorInOut <- "indoor"; records_athletics_indoorF$comp_doorInOut <- "indoor"
  
  records_athletics_outdoorM$sex <- "m"; records_athletics_outdoorF$sex <- "f"
  records_athletics_indoorM$sex <- "m"; records_athletics_indoorF$sex <- "f"
  
  records_athletics_table <- as.data.frame(rbind.fill(records_athletics_outdoorM, records_athletics_outdoorF, 
                                                      records_athletics_indoorM, records_athletics_indoorF))
  
  ## export raw combined datasets
  write.xlsx(x = records_athletics_table, file = "./records_athletics_table.xlsx", sheetName = "records_athletics_table", 
             row.names = FALSE, col.names = TRUE)
  
  ## pre-process the imported data
  # records_athletics_table$Event <- as.numeric(records_athletics_table$Event)    ## first, keep only numeric values...
  
  
}