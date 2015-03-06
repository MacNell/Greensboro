# ej_bayes.R
# Estimates ej quantities using bayesian approach

# load louisiana algorithms
# make sure to load the data from ej_frequentist.R first

source("D:/Louisiana/script/lib/restrict.R")
source("D:/Louisiana/script/lib/polygons_experimental.R")

# model can only handle points at the moment
lf.cents <- gCentroid(lf)
gb.blocks <- spTransform(gb,CRS(proj))
gb.bayes <- DescribeShapefile(gb.blocks,lf.cents,d=3*5280)

# gb.bayes contains mean and standard deviation
# of number of facilities within 3 miles
save(gb.bayes,file="D:/Greensboro/Analysis/bayes.RData")

DescribePolygon(


# append race data
gb.bayes$white <- gb.ej$pop.white
gb.bayes$black <- gb.ej$pop.black

# use mean formulas
white <- gb.bayes$white *






