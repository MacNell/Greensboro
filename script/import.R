##### import.R
##### by Nathaniel MacNell
### Script to import data for the Greensboro project

### environment
library(sp)
library(rgeos)
library(rgdal)

setwd("C:/GitHub/Greensboro")

### Import GIS data on landfills and census blocks
# import guilford county gis file
guilford <- readOGR("data/gis","tl_2010_37081_tabblock10")
# extract greensboro blocks using the Urban Area Code field (UACE10)
greensboro <- guilford[guilford$UACE10 %in% "35164",]
# import landfill kml files drawn in Google Earth (z-dimension discarded)
landfills <- readOGR("data/gis/whiteStreetLandfill.kml",layer="Polygons")

### Import Census data and headers
# Must exclude second row from import.
census <- read.csv("data/census/DEC_10_SF1_QTP6_with_ann.csv",skip=2,header=FALSE)
names(census) <- names(read.csv("data/census/DEC_10_SF1_QTP6_with_ann.csv",nrows=1))

### Process Census data
# extract population statistics
race <- data.frame(geoid = as.character(census$GEO.id2),
  total = as.numeric(census$HD01_S01),  # total population
  black = as.numeric(census$HD01_S06),  # alone/incombination
  pct = as.numeric(as.character(census$HD02_S06)))  # pct
# append data to gis dataset
race <- race[match(as.character(greensboro$GEOID10), race$geoid),]  # re-order
greensboro@data <- data.frame(greensboro@data,race)

# export to native R format
save(greensboro,landfills,file="greensboro.RData")







