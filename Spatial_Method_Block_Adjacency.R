library(Matrix)
library(tigris)
library(sp)
library(sf)
library(dplyr)
library(tidyverse)
library(rgeos)

load("sf_VT_tracts.Rdata")
load("sf_VT_blocks.Rdata")
load("sf_VT_state_sen.Rdata")
load("sf_VT_state_cong.Rdata")
load("VT_pop_total.Rdata")

cbind(sf_VT_blocks, "Population" = VT_pop_total$P001001)
sf_VT_blocks <- cbind(sf_VT_blocks, "Population" = VT_pop_total$P001001)


#Trying to develop a gerrymandering score for districts
#All the congressional districts
plot(st_geometry(sf_VT_state_cong[3,]))
plot(st_geometry(sf_VT_blocks), add = TRUE,border = rgb(0,1,1,0.25), lwd = 2)
  
bbl <- st_touches(sf_VT_state_cong[3,], sf_VT_blocks)
bbdf <- as.data.frame(bbl)
no1 <- as.integer(bbdf[,"col.id"])
onesftouch <- st_union(sf_VT_blocks[no1,])

wbl <- st_within(sf_VT_blocks, sf_VT_state_cong[3,])
wbdf <- as.data.frame(wbl)
no2 <- as.integer(wbdf[,"row.id"])

ibl <- st_touches(sf_VT_blocks, onesftouch)
ibdf <- as.data.frame(ibl)
no3 <- as.integer(ibdf[,"row.id"])
no4 <- intersect(no3,no2)
  

# Plots
plot(st_geometry(sf_VT_state_cong[3,]),)
# plot(st_geometry(sf_VT_blocks[no1,]), add = TRUE,border = rgb(1,0,0,0.3), lwd = 4)
# plot(st_geometry(sf_VT_blocks[no2,]), add = TRUE,border = rgb(1,0,0,0.3), lwd = 4)
# plot(st_geometry(sf_VT_blocks[no3,]), add = TRUE,border = rgb(0,1,1,0.3), lwd = 4)
plot(st_geometry(sf_VT_blocks[no4,]), add = TRUE,border = rgb(1,0,0,0.3), lwd = 4)


# Scoring function 

g_score <- function(x) {
  
  border_blocks_list <- st_touches(sf_VT_state_cong[x,], sf_VT_blocks)
  border_blocks_df <- as.data.frame(border_blocks_list)
  abc <- as.integer(border_blocks_df[,"col.id"])
  single_sf_touches <- st_union(sf_VT_blocks[abc,])
  plot(single_sf_touches)
  
  within_blocks_list <- st_within(sf_VT_blocks, sf_VT_state_cong[x,])
  within_blocks_df <- as.data.frame(within_blocks_list)
  def <- as.integer(within_blocks_df[,"row.id"])
  length(def)
  
  inner_border_list <- st_touches(sf_VT_blocks, single_sf_touches)
  inner_border_df <- as.data.frame(inner_border_list)
  ghi <- as.integer(inner_border_df[,"row.id"])
  jkl <- intersect(ghi,def)
  
  plot(st_geometry(sf_VT_blocks[def,]))
  plot(st_geometry(sf_VT_blocks[jkl,]), border = rgb(1,0,0,0.25), add =TRUE, lwd = 4)
  
  score = sum(sf_VT_blocks[def,]$Population)/(sum(sf_VT_blocks[jkl,]$Population)^2)
  return(score)
  
}

g_score(3)
g_score(6)
g_score(14)
g_score(20)

VT_congress_gscores <- mclapply(as.list(1:20), g_score)
unlist(VT_congress_gscores)

