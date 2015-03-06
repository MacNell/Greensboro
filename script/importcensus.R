# importcensus.R
# import the census data into R

setwd("D:/Greensboro")

# load census data
# fix this section
# variable names can be found in the metadata file
# have to do the following to exclude 2nd row
census <- read.csv("census/DEC_10_SF1_QTP6_with_ann.csv")
header <- names(census)
census <- read.csv("census/DEC_10_SF1_QTP6_with_ann.csv",skip=2,header=FALSE)
names(census) <- header

pop.total <- as.numeric(census$HD01_S01)	# total population
pop.black <- as.numeric(census$HD01_S06)  # alone/incombination
pct.black <- as.numeric(as.character(census$HD02_S06))  # value from the census
geoid <- as.character(census$GEO.id2)

# build race dataset
race <- data.frame(geoid,pop.total,pop.black,pct.black)
race$geoid <- as.character(race$geoid)  # format

# load gis data
load("whitestreet.RData")
guilford$geoid <- as.character(guilford$GEOID10)  # format

# order race dataset for appending
keys <- match(guilford$geoid, race$geoid)
race <- race[keys,] # reorder dataset

# merge the data
guilford@data <- data.frame(guilford@data,race)

# re-extract greensboro blocks using the Urban Area Code (UACE10)
in.greensboro <- guilford$UACE10=="35164"
in.greensboro[is.na(in.gb)] <- FALSE  # exclude blocks with no code
greensboro <- guilford[in.gb,]

# save data again
greensboro.border <- unionSpatialPolygons(greensboro,IDs=rep(1,length(greensboro)))

save(guilford,greensboro,landfills,greensboro.border,file="whitestreet.RData")





 