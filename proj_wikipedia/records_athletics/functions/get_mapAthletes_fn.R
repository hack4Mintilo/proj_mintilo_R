get_mapAthelets = function (dsin = NULL, varin = NULL, country_baseline = NULL, 
                            db_sel = NULL, lon_in = NULL, lat_in = NULL) {
  ## ----------------------------------------------------------------------------- ##
  ## <!--   INSPIRED BY: Munzert, S., Rubba, C. and Meibner, P. (2015), R book --> ##
  ## ----------------------------------------------------------------------------- ##
  
  ## select variable
  var_sel <- dsin[ , varin]
  
  ## define map attributes
  pch1 <- ifelse(var_sel == country_baseline, 19, 2)
  col1 <- ifelse(var_sel == country_baseline, "green", "red")
  
  ## create the map
  file_name <- paste("./outputs/plots/", "map_", varin, "_", db_sel, ".png", sep = "")
  png(file_name)
  
  map(database = db_sel, col = "darkgrey", lwd = 0.5, mar = c(0.1, 0.1, 0.1, 0.1))
  points(x = round(dsin[, lon_in], 2), 
         y = round(dsin[, lat_in], 2), 
         pch = pch1,
         col = col1)
  box()
  
  dev.off()
}









