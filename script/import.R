###### import.R
### imports data for the Greensboro project

### environment
library(sp)
library(rgeos)
library(rgdal)

setwd("C:/Users/nat/Documents/GitHub/Greensboro")

### Import GIS data
# import guilford county gis file
guilford <- readOGR("data/gis","tl_2010_37081_tabblock10")
# extract greensboro blocks using the Urban Area Code (UACE10)
greensboro <- guilford[guilford$UACE10 %in% "35164",]
# import landfill kml files drawn in Google Earth
landfills <- readOGR("data/gis/whiteStreetLandfill.kml",layer="Polygons")

### Import and append Census data
# TODO: find a better way to exclude second row from import.
census <- read.csv("data/census/DEC_10_SF1_QTP6_with_ann.csv")
header <- names(census)
census <- read.csv("data/census/DEC_10_SF1_QTP6_with_ann.csv",skip=2,header=FALSE)
names(census) <- header
# extract population statistics
pop.total <- as.numeric(census$HD01_S01)  # total population
pop.black <- as.numeric(census$HD01_S06)  # alone/incombination
pct.black <- as.numeric(as.character(census$HD02_S06))  # value from the census
geoid <- as.character(census$GEO.id2)
# build race dataset
race <- data.frame(geoid,pop.total,pop.black,pct.black)
race$geoid <- as.character(race$geoid)  # format
# append data to gis dataset
greensboro$geoid <- as.character(greensboro$GEOID10)  # match format
race <- race[match(guilford$geoid, race$geoid),]  # re-order
greensboro@data <- data.frame(greensboro@data,race)

# export to native R format
save(greensboro,landfills,file="greensboro.RData")







