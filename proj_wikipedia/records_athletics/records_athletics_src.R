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
  write.xlsx(x = records_athletics_table, file = "./records_athletics_table_raw.xlsx", sheetName = "records_athletics_table_raw", 
             row.names = FALSE, col.names = TRUE)
  
  
  ## ------------------------------------------------- ##
  ## <!-- Step-3: Pre-process the messy web data.  --> ##
  ## ------------------------------------------------- ##
  library(stringr)
  
  # records_athletics_table$Event <- as.numeric(records_athletics_table$Event)    ## first, keep only numeric values...
  
  ## drop records with no record time available
  records_athletics_table <- records_athletics_table[!(is.na(records_athletics_table$Record) | records_athletics_table$Record==""), ]
  
  ## drop competition which has strange values under Date column
  # records_athletics_table$Date <- ifelse(str_detect(records_athletics_table$Date, "thlon\\>"), "", records_athletics_table$Date)   ## not working
  
  ## -- split the data
  # records_athletics_table$category <- ifelse(str_detect(records_athletics_table$Event, "\\d+[ m|km]"), "main", "others")
#   if (str_detect(records_athletics_table$Event, "\\d+\\s{1}[m|km]")) {     
#     records_athletics_table$category <- "main"
#   } 
#   else if (str_detect(records_athletics_table$Event, "Marathon")) {
#     records_athletics_table$category <- "Marathon"
#   }
  
  ## get category of the competition
  records_athletics_table$category <- ifelse(str_detect(records_athletics_table$Event, "\\d+\\s{1}[m|km]"), "main", "others")
  records_athletics_table$category <- ifelse(str_detect(records_athletics_table$Event, "mara|Mara"), "Marathon", records_athletics_table$category)
  records_athletics_table$category <- ifelse(str_detect(records_athletics_table$Event, "hurdles|steeplechase|walk|relay"), "others", records_athletics_table$category)
  
  ## split dataset by main vs others
  records_athletics_table_main <- records_athletics_table[records_athletics_table$category %in% c("main", "Marathon"), ]
  
  
  ## ----------------------------------------------------------- ##
  ## <!-- Step-4: Further pre-process of the main web data.  --> ##
  ## ----------------------------------------------------------- ##
  ## get additional info about the competition, e.g., kind of units (m, km, etc) and category
  records_athletics_table_main$units <- unlist(str_extract_all(records_athletics_table_main$Event, "[[:alpha:] ()]{2,}"))      ## E.g., 100 m -> unit=m; mile -> mile; 5 km (road) -> km (road)
  records_athletics_table_main$units <- str_trim(records_athletics_table_main$units)
  
  if (substr(records_athletics_table_main$units, 1, 1) == "m") {
#     records_athletics_table_main$distance <- ifelse(str_detect(records_athletics_table_main$Event, "\\d+"), 
#                                                     as.numeric(unlist(str_extract(records_athletics_table_main$Event, "\\d+"))), 
#                                                     NA)
    records_athletics_table_main$distance <- as.numeric(unlist(str_extract(records_athletics_table_main$Event, "\\d+")))
  }
  
  ## export raw combined datasets
  write.xlsx(x = records_athletics_table, file = "./records_athletics_table.xlsx", sheetName = "records_athletics_table", 
             row.names = FALSE, col.names = TRUE)
  write.xlsx(x = records_athletics_table_main, file = "./records_athletics_table_main.xlsx", sheetName = "records_athletics_table_main", 
             row.names = FALSE, col.names = TRUE)
  
  
}
  
  
  