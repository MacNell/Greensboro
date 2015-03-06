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
setwd("C:/Users/nat/Desktop/Greensboro/Analysis")
load("whitestreet.RData")

# bw: black and white color scheme
# grey0 is black, grey 100 is white
bw <- rep("gray90",length(gb$pct.black))
bw[gb$pct.black >= 75] <- "grey60"

# Plot map
pdf("bw.pdf")
  b <- bbox(gb)  # bounding box
  width <- b[1,2] - b[1,1]
  par(mar=c(1,1,1,1))
  plot(gb,col=bw,border=NA)
  plot(landfills,col="black",border=NA,add=TRUE)
  maps::map.scale(x=b[1,2]-width/2, y=b[2,1], ratio=FALSE, relwidth=0.2,metric=FALSE)
  legend(x="bottomleft",
       legend=c("Landfills","Black","White","Outside City"),
       fill=c("black","grey60","grey90","white"),bg="white",
       title="")
dev.off()


b

