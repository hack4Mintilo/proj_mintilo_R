get_geoLocation_data = function (dsin = NULL, loc_type = NULL) {
  
  ## define filename and sheetname
  file_geoLoc <- paste("./outputs/tables/", "geoLocation_", loc_type, ".xlsx", sep = "")
  sheet_geoLoc <- paste("geolocation_", loc_type, sep = "")
  
  ## get geo-location data
  if (!(file.exists(file_geoLoc))) {
    
    ## request Google to get the longitude/latitude of city/country
    geoLoc <- get_geoLocation(dsin = dsin, place = loc_type)
  }
  else {
    
    ## import existing file. Thus, no need to request Google for the same data...
    geoLoc <- read.xlsx(file = file_geoLoc, sheetName = sheet_geoLoc)
  }
  
  ## -- add geo-location info (i.e., long/lat) to the main analysis dataset
#   query <- paste(paste("SELECT A.*", 
#                        paste("B.lon_", loc_type, sep = ""), 
#                        paste("B.lat_", loc_type, sep = ""), 
#                        sep = ","),
#                  paste("FROM", dsName, "AS A", sep = " "), 
#                  "LEFT JOIN geoLoc AS B ",
#                  "USING(", loc_type, ")", sep = " ")
#   
#   combined_geoLoc <- sqldf(query)
  
  return(geoLoc)
}