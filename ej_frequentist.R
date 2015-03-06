# ejestimate.R

###  perform ej analysis for greensboro project
# this is an example of a frequentist approach
# that places each person at the center of their block group
# (i.e. the weighted centroid method)

### set up environment
library(sp)
library(rgeos)
library(rgdal)
setwd("C:/Users/nat/Desktop/Greensboro/Analysis")
load("whitestreet.RData")
gb <- greensboro

##### Old Method - Centroids
### Prepare data
# calculate centroids
gb.cents <- gCentroid(greensboro,byid=TRUE)
# transfer both to nc foot projection
proj <- "+proj=lcc +lat_1=34.33333333333334 +lat_2=36.16666666666666 +lat_0=33.75 +lon_0=-79 +x_0=609601.2199999999 +y_0=0 +ellps=GRS80 +datum=NAD83 +to_meter=0.3048006096012192 +no_defs"
gb.cents <- spTransform(gb.cents,CRS(proj))
lf <- spTransform(landfills,CRS(proj))
# find the closest distance
gb.dists <- spDists(gb.cents,lf)
gb.closest <- apply(gb.dists,1,min)
# append the race counts
gb.ej <- data.frame(pop.total = gb$pop.total,
      pop.black = gb$pop.black,
      pop.white = gb$pop.total - gb$pop.black,
      pct.black = gb$pct.black,
      closest = gb.closest)

### Tables to support regression
# blocks
gb.ej$close3 <- gb.ej$closest < 5280*3
gb.ej$bin.black <- gb.ej$pct.black >= 75
tab.block <- table(gb.ej$close3*1,gb.ej$bin.black==FALSE)
colnames(tab.block) <- c("Black","White") 
rownames(tab.block) <- c("Far","Near")
# population-weighted blocks      
tab.black <- aggregate(gb.ej$pop.black,
          by=list(gb.ej$close3),sum)          
tab.white <- aggregate(gb.ej$pop.white,
          by=list(gb.ej$close3),sum)
tab.pop <- cbind(tab.black,tab.white[,2])
names(tab.pop) <- c("Proximity","Black","White")
tab.pop <- tab.pop[,2:3]
rownames(tab.pop) <- c("Far","Near")
tab.pop <- as.table(as.matrix(tab.pop))
# display
tab.block
prop.table(tab.block,2)
tab.pop
prop.table(tab.pop,2)

# Logistic Regression to support tables
log.block <- glm(gb.ej$close3 ~ gb.ej$bin.black,family=binomial("log"))
exp(coef(log.block))
exp(confint(log.block))
log.pop <- glm(gb.ej$close3 ~ gb.ej$bin.black, weights=gb.ej$pop.total, family=binomial("log"))
exp(coef(log.pop))
exp(confint(log.pop))
summary(log.pop)











# what about the average distance
# black distance*population
distblack <- ej.greensboro$black*ej.greensboro$d
distance <- sum(distblack) / sum(ej.greensboro$black)
distance

# white distance
white <- ej.greensboro$pop-ej.greensboro$black
distwhite <- white*ej.greensboro$d
distance <- sum(distwhite) / sum(white)
distance

# function to calculate average distance of race group
ej.summary <- function(d,n) {
	xbar <- sum(d*n) / sum(n)
	dev2 <- (d-xbar)^2
	s2 <- sum(dev2*n) / sum(n)
	c(xbar,sqrt(s2))
}

# define ej density function
ej.density <- function(d,n) {
	tot <- sum(n)
	wt <- n/tot
	density(d, weights=wt)
}

# make plots of distance distribution
d.total <- ej.density(ej.greensboro$d/5280,ej.greensboro$pop)
d.black <- ej.density(ej.greensboro$d/5280,ej.greensboro$black)
d.white <- ej.density(ej.greensboro$d/5280,white)

# total population
plot(d.total,col="blue",xlab="Distance to Closest Landfill(mi)",
	main="Distribution of Distance to Landfill")

plot(d.white,col="red",xlab="Distance to Closest Landfill (mi)",
	main="Distribution of Distance to Landfill")
lines(d.black)



dist(ej.greensboro$d,ej.greensboro$black)	
dist(ej.greensboro$d/5280,ej.greensboro$pop)	


