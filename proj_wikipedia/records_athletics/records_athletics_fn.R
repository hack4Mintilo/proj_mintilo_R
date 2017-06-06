scrapWikipedia_recordAthletics <- function (country = NULL) {
  
  ## ------------------------------------------------------------------------- ##
  ## <!-- Step-1: scrape wikipedia page for list of records in athletics.  --> ##
  ## ------------------------------------------------------------------------- ##
  url_main <- "https://en.wikipedia.org/wiki"
  url <- paste(url_main,"/List_of_", country,"_records_in_athletics", 
               sep = "")
  records_athletics <- read_html(url)
  
  ## -- get references
  # records_athletics_bib <- records_athletics%>%html_nodes(xpath='//*[@id="mw-content-text"]/div[2]')%>%html_text()     ## needs pre-processing
  
  ## -- get records tables 
  records_athletics_outdoorM <- as.data.frame(records_athletics%>%html_nodes(xpath='//*[@id="mw-content-text"]/div/table[1]')%>%html_table(fill = TRUE))
  records_athletics_outdoorF <- as.data.frame(records_athletics%>%html_nodes(xpath='//*[@id="mw-content-text"]/div/table[2]')%>%html_table(fill = TRUE))
  records_athletics_indoorM <- as.data.frame(records_athletics%>%html_nodes(xpath='//*[@id="mw-content-text"]/div/table[3]')%>%html_table(fill = TRUE))
  records_athletics_indoorF <- as.data.frame(records_athletics%>%html_nodes(xpath='//*[@id="mw-content-text"]/div/table[4]')%>%html_table(fill = TRUE))
  
  ## drop Video column, if it exists
  # records_athletics_outdoorM <- records_athletics_outdoorM[, -8]
  records_athletics_outdoorM <- records_athletics_outdoorM[, !names(records_athletics_outdoorM) %in% c("Video")]    ## remove "Video" column if it exists
  records_athletics_outdoorF <- records_athletics_outdoorF[, !names(records_athletics_outdoorF) %in% c("Video")]
  records_athletics_indoorM <- records_athletics_indoorM[, !names(records_athletics_indoorM) %in% c("Video")]
  records_athletics_indoorF <- records_athletics_indoorF[, !names(records_athletics_indoorF) %in% c("Video")]
  
  ## -- export raw datasets 
  write.xlsx(x = records_athletics_outdoorM, file = paste("./records_athletics_outdoorM","_",country,".xlsx", sep = ""), sheetName = "records_athletics_outdoorM", 
             row.names = FALSE, col.names = TRUE)
  write.xlsx(x = records_athletics_outdoorF, file = paste("./records_athletics_outdoorF","_",country,".xlsx", sep = ""), sheetName = "records_athletics_outdoorF", 
             row.names = FALSE, col.names = TRUE)
  write.xlsx(x = records_athletics_indoorM, file = paste("./records_athletics_indoorM","_",country,".xlsx", sep = ""), sheetName = "records_athletics_indoorM", 
             row.names = FALSE, col.names = TRUE)
  write.xlsx(x = records_athletics_indoorF, file = paste("./records_athletics_indoorF","_",country,".xlsx", sep = ""), sheetName = "records_athletics_indoorF", 
             row.names = FALSE, col.names = TRUE)
  
  
  ## -- combine tables
  records_athletics_outdoorM$comp_doorInOut <- "outdoor"; records_athletics_outdoorF$comp_doorInOut <- "outdoor"
  records_athletics_indoorM$comp_doorInOut <- "indoor"; records_athletics_indoorF$comp_doorInOut <- "indoor"
  
  records_athletics_outdoorM$sex <- "m"; records_athletics_outdoorF$sex <- "f"
  records_athletics_indoorM$sex <- "m"; records_athletics_indoorF$sex <- "f"
  
  records_athletics_table_raw <- as.data.frame(rbind.fill(records_athletics_outdoorM, records_athletics_outdoorF, 
                                                          records_athletics_indoorM, records_athletics_indoorF))
  
  ## export raw combined datasets
  records_athletics_table_raw$Athlete_profile <- country
  write.xlsx(x = records_athletics_table_raw, file = "./records_athletics_table_raw.xlsx", sheetName = "records_athletics_table_raw", 
             row.names = FALSE, col.names = TRUE)
  
  
  ## ------------------------------------------------- ##
  ## <!-- Step-3: Pre-process the messy web data.  --> ##
  ## ------------------------------------------------- ##
  # records_athletics_table_raw$Event <- as.numeric(records_athletics_table_raw$Event)    ## first, keep only numeric values...
  
  ## drop records with no record time available
  records_athletics_table <- records_athletics_table_raw[!(is.na(records_athletics_table_raw$Record) | records_athletics_table_raw$Record==""), ]
  
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
  records_athletics_table$category <- ifelse(str_detect(records_athletics_table$Event, "mile|miles|hurdles|steeplechase|walk|relay"), "others", records_athletics_table$category)
  
  ## -- manipulate date value to get year, month and day
  records_athletics_table$Date_recorded <- as.Date(records_athletics_table$Date, "%d %b %Y")
  records_athletics_table$year <- year(records_athletics_table$Date_recorded)                  ## handled by lubridate pkg
  records_athletics_table$month <- month(records_athletics_table$Date_recorded)
  records_athletics_table$day <- day(records_athletics_table$Date_recorded)
  
  ## -- get city and country where the event was.
  records_athletics_table$city <- str_extract(records_athletics_table$Place, "[^,]*")    
  records_athletics_table$city <- str_trim(records_athletics_table$city)
  
  records_athletics_table$country <- str_extract(records_athletics_table$Place, "[^,]*$")
  records_athletics_table$country <- str_trim(records_athletics_table$country)
  
  
  ## export dataframe with all competitions
  write.xlsx(x = records_athletics_table, file = "./records_athletics_table.xlsx", sheetName = "records_athletics_table", 
             row.names = FALSE, col.names = TRUE)
  
  ## get main types of competitions
  records_athletics_table_main <- records_athletics_table[records_athletics_table$category %in% c("main", "Marathon"), ]
  
  
  ## ----------------------------------------------------------- ##
  ## <!-- Step-4: Further pre-process of the main web data.  --> ##
  ## ----------------------------------------------------------- ##
  ## get additional info about the competition, e.g., kind of units (m, km, etc) and category
  records_athletics_table_main$units <- unlist(str_extract_all(records_athletics_table_main$Event, "[[:alpha:] ()]{2,}"))  
  records_athletics_table_main$units <- str_trim(records_athletics_table_main$units)
  
  ## get distance for units="m"
  records_athletics_table_main$distance <- ifelse(records_athletics_table_main$units %in% c("m", "m (track)"), 
                                                  as.numeric(unlist(str_extract(records_athletics_table_main$Event, "\\d+"))), 
                                                  NA)
  
  ## get distance for units="km"
  records_athletics_table_main$distance <- ifelse(records_athletics_table_main$units %in% c("km", "km (road)"), 
                                                  1000 * as.numeric(unlist(str_extract(records_athletics_table_main$Event, "\\d+"))), 
                                                  records_athletics_table_main$distance)
  
  ## get distance for half-marathon
  records_athletics_table_main$distance <- ifelse(records_athletics_table_main$units %in% c("Half marathon"), 
                                                  21*1000, 
                                                  records_athletics_table_main$distance)
  
  ## get distance for full-marathon
  records_athletics_table_main$distance <- ifelse(records_athletics_table_main$units %in% c("Marathon"), 
                                                  42*1000, 
                                                  records_athletics_table_main$distance)
  
  ## derive distance category
  records_athletics_table_main$distance_category <- ifelse(records_athletics_table_main$distance <= 1000, "short", 
                                                    ifelse(((records_athletics_table_main$distance > 1000) & (records_athletics_table_main$distance <= 10000)), "middle", 
                                                    ifelse((records_athletics_table_main$distance > 10000), "long", NA)))
  records_athletics_table_main$distance_category <- factor(records_athletics_table_main$distance_category, 
                                                           levels = c("short", "middle", "long"))
  
  ## export raw combined datasets
  write.xlsx(x = records_athletics_table_main, file = "./records_athletics_table_main.xlsx", sheetName = "records_athletics_table_main", 
             row.names = FALSE, col.names = TRUE)
  
  return(records_athletics_table_main)  
}


  
  