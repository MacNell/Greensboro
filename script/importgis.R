# importgis.R
# import spatial data files for greensboro EJ analysis

debug <- FALSE

library(sp)
library(rgeos)
library(rgdal)

setwd("D:/Greensboro")

# import guilford county
guilford <- readOGR("gis","tl_2010_37081_tabblock10")

# extract greensboro blocks using the Urban Area Code (UACE10)
in.greensboro <- guilford$UACE10=="35164"
in.greensboro[is.na(in.gb)] <- FALSE  # exclude blocks with no code
greensboro <- guilford[in.gb,]

# import landfill kml files drawn in Google Earth
# ogrInfo("gis/whiteStreetLandfill.kml","Polygons")  # find layer
landfills <- readOGR("gis/whiteStreetLandfill.kml",layer="Polygons")
 
# debug section (plotting)
if(debug) {
	pdf("Guilford.pdf")
	par(mar=c(0,0,0,0))
	plot(guilford)
	plot(greensboro,col="green",add=TRUE)
	plot(landfills,col="red",add=TRUE)
	dev.off()
}

# export to native R format
save(guilford,greensboro,landfills,file="whitestreet.RData")
