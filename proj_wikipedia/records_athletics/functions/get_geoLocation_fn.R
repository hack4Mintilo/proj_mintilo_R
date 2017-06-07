get_geoLocation <- function (dsin = NULL, place_type = NULL) {
  
  ## get unique location (e.g., country/city) names
  locations_all <- dsin[, place_type]
  locations_uniq <- unique(locations_all)
  
  # get geo-location value from Google
  geo_res <- data.frame(a = character(), b = numeric(), c = numeric())
  
  for (place in locations_uniq) {
    geo_val <- geocode(location = place)
    geo_val <- cbind(place, geo_val)
    
    geo_res <- rbind(geo_res, geo_val)
  }

  geo_res <- as.data.frame(geo_res)
  colnames(geo_res) <- c(place_type, 
                         paste("lon", "_", place_type, sep = ""), 
                         paste("lat", "_", place_type, sep = ""))
  
  ## export geo-location data to external drive
  file_name <- paste("./outputs/tables/geoLocation", "_", place_type, ".xlsx", sep = "")
  sheet_name <- paste("geolocation_", place_type, sep = "")
  
  write.xlsx(x = geo_res, file = file_name, sheetName = sheet_name,
             row.names = FALSE, col.names = TRUE)
  
  return(geo_res)
}
