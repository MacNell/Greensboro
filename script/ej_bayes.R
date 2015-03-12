# ej_bayes.R
# Estimates ej quantities using bayesian approach

# load louisiana algorithms
# make sure to load the data from ej_frequentist.R first

source("C:/GitHub/Louisiana/script/lib/restrict.R")
source("C:/GitHub/Louisiana/script/lib/polygons.R")
load("C:/GitHub/Greensboro/greensboro.RData")

### Set up analysis objects
# model can only handle points at the moment
feet.projection <- "+proj=lcc +lat_1=34.33333333333334 +lat_2=36.16666666666666 +lat_0=33.75 +lon_0=-79 +x_0=609601.2199999999 +y_0=0 +ellps=GRS80 +datum=NAD83 +to_meter=0.3048006096012192 +no_defs"
blocks  <- spTransform(greensboro,CRS(feet.projection))
hazards <- spTransform(gCentroid(landfills,byid=TRUE),CRS(feet.projection))
gb.bayes <- PolygonsProximity(blocks,hazards,d=3*5280)

# gb.bayes contains mean and standard deviation
# of number of facilities within 3 miles
save(gb.bayes,file="C:/GitHub/Greensboro/bayes.RData")

### analysis prep
# remove blocks without population
# TODO: do this before the spatial characterization!
populated <- greensboro$total > 0
greensboro <- greensboro[populated,]
greensboro$white <- greensboro$total - greensboro$black
gb.bayes <- gb.bayes[populated]

### Analysis functions
resample.block <- function(n0,n1,df) {
  race <- c(rep(0,n0),rep(1,n1)) 
  mat <- matrix(apply(df,2,function(i) sample(i,length(race),replace=TRUE)),ncol=2)
  cbind(race,mat) 
}

resample <- function(n0,n1,bayes) {
  do.call(rbind,lapply(1:length(bayes), function(i) resample.block(n0[i],n1[i],bayes[[i]])))
}

calculate <- function(n0,n1,bayes) {
  result <- resample(n0,n1,bayes)
  tab <- apply(result[,-1],2, function(i) aggregate(i,by=list(result[,1]),mean))
  tab <- do.call(cbind,tab)
  tab <- tab[c(1,seq(from=2,to=dim(tab)[2],by=2))] # remove redeundant columns
  colnames(tab) <- c("Group",colnames(bayes[[1]]))
  tab
}

calculate(n0=greensboro$white,n1=greensboro$black,bayes=gb.bayes)




