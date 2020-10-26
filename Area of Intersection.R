library(sf)
library(rgeos)
library(lwgeom)

load("sf_IL_cong_dist.Rdata")
load("sf_IL_blocks.Rdata")

xy <- st_intersection(sf_IL_blocks[5109,], sf_IL_cong_dist)
str(xy,1)
plot(xy)
st_area(xy) st_area(xy)[2]
st_area(xy)[1]/sum(st_area(xy))
