# ejmap.R
# Creates an EJ map based on the greensboro race data

# install packages (run once)
install.packages("maptools")
install.packages("maps")
install.packages("GISTools")
install.packages("RColorBrewer")

# load packages
require(maptools)
library(maps)
library(GISTools)
library(RColorBrewer)
setwd("D:/Greensboro/Analysis")
load("whitestreet.RData")

# constants
# color palette, left is white, right is black
pal <- brewer.pal(5,"YlGn")
col.race <- c("yellow","brown")
col.miss <- "grey"   # missing population
col.gb   <- "blue"	# greensboro color
col.land <- "purple"		# landfill color

# set up rescale function for colors
rescale <- function(x,start=0,stop=1) {
	xmin <- min(x,na.rm=TRUE)
	xmax <- max(x,na.rm=TRUE)
	range <- xmax-xmin
	new.range <- stop-start
	x <- x-xmin # start 0
	x <- x/range  # stop 1
	x <- x*new.range # scale to new range
	x <- x+start		# scale to new stop
	return(x)
}

# create map colors
color.scale <- function(x,start=0,stop=1) {
	# define color interpolation ramp
	ramp <- colorRamp(colors=col.race)
	# define missing color
	colors <- rep(col.miss,length(x))
	colors[!is.na(x)] <- rgb(ramp(
		rescale(x[!is.na(x)],start=start,stop=stop))/255)
	return(colors)
}

# create the outline of greensboro
b <- bbox(guilford)

# cut up the race levels for colors
pct <- guilford$pct.black
race <- cut(pct,c(-1,20,40,60,80,101))
colors <- rep("grey",length(pct))
for(i in 1:5) {
	colors[race==levels(race)[i]] <- pal[i]
}

# plot a map of guilford's race
pdf("GuilfordRace.pdf")
	par(mar=c(1,1,1,1))
	plot(guilford,col=colors,border=NA)
	plot(landfills,col=col.land,border=NA,add=TRUE)
	plot(greensboro.border,border=col.gb,add=TRUE)
	# annotate
	maps::map.scale(x=b[1,1], y=b[2,1], ratio=FALSE, relwidth=0.2,metric=FALSE)
	legend(x="bottomright",
		legend=c("Unpopulated","<20%","20-40%","40-60%","60-80%","80-100%"),
		fill=c("grey",pal),bg="white",
		title="Percent Black")
	dev.off()






