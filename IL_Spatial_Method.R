library(Matrix)
library(tigris)
library(sp)
library(sf)
library(dplyr)
library(tidyverse)
library(rgeos)

load("sf_IL_tracts.Rdata")
load("sf_IL_blocks.Rdata")
load("sf_IL_cong_dist.Rdata")
load("sf_IL_state_sen.Rdata")
load("sf_IL_state_cong.Rdata")

class(sf_IL_cong_dist)
class(sf_IL_blocks)

#Trying to develop a gerrymandering score for districts
#All the congressional districts
plot(st_geometry(sf_IL_state_cong[3,]))
plot(st_geometry(sf_IL_blocks), add = TRUE,border = rgb(0,1,1,0.25), lwd = 2)

bbl <- st_touches(sf_IL_state_cong[3,], sf_IL_blocks)
bbdf <- as.data.frame(bbl)
no1 <- as.integer(bbdf[,"col.id"])
onesftouch <- st_union(sf_IL_blocks[no1,])

wbl <- st_within(sf_IL_blocks, sf_IL_state_cong[3,])
wbdf <- as.data.frame(wbl)
no2 <- as.integer(wbdf[,"row.id"])

ibl <- st_touches(sf_IL_blocks, onesftouch)
ibdf <- as.data.frame(ibl)
no3 <- as.integer(ibdf[,"row.id"])
no4 <- intersect(no3,no2)


# Plots
plot(st_geometry(sf_IL_state_cong[3,]),)
# plot(st_geometry(sf_IL_blocks[no1,]), add = TRUE,border = rgb(1,0,0,0.3), lwd = 4)
# plot(st_geometry(sf_IL_blocks[no2,]), add = TRUE,border = rgb(1,0,0,0.3), lwd = 4)
# plot(st_geometry(sf_IL_blocks[no3,]), add = TRUE,border = rgb(0,1,1,0.3), lwd = 4)
plot(st_geometry(sf_IL_blocks[no4,]), add = TRUE,border = rgb(1,0,0,0.3), lwd = 4)



sf_IL_cong_dist$GEOID

# Scoring function 

g_score <- function(district_no, electoral_region) {
  
  border_blocks_list <- st_touches(electoral_region[district_no,], sf_IL_blocks)
  border_blocks_df <- as.data.frame(border_blocks_list)
  abc <- as.integer(border_blocks_df[,"col.id"])
  single_sf_touches <- st_union(sf_IL_blocks[abc,])

  within_blocks_list <- st_within(sf_IL_blocks, electoral_region[district_no,])
  within_blocks_df <- as.data.frame(within_blocks_list)
  def <- as.integer(within_blocks_df[,"row.id"])

  inner_border_list <- st_touches(sf_IL_blocks, single_sf_touches)
  inner_border_df <- as.data.frame(inner_border_list)
  ghi <- as.integer(inner_border_df[,"row.id"])
  jkl <- intersect(ghi,def)
  
  x <- sf_IL_blocks[def,]
  y <- sf_IL_blocks[jkl,]
  
  score = sum(sf_IL_blocks[def,]$Population)/(sum(sf_IL_blocks[jkl,]$Population)^2)
  
  return(list(score,x,y))
  
  }

start <- Sys.time()
g_score(1, sf_IL_cong_dist)
end <- Sys.time()
start - end

library(parallel)
IL_congress_gscores <- mclapply(as.list(1:6), g_score, electoral_region = sf_IL_cong_dist)
IL_congress_gscores2 <- mclapply(as.list(7:12), g_score, electoral_region = sf_IL_cong_dist)
IL_congress_gscores3 <- mclapply(as.list(13:18), g_score, electoral_region = sf_IL_cong_dist)
save(IL_congress_gscores, file = "IL_congress_gscores.Rdata")
save(IL_congress_gscores2, file = "IL_congress_gscores2.Rdata")
save(IL_congress_gscores3, file = "IL_congress_gscores3.Rdata")

IL_total_congress_scores <- c(IL_congress_gscores, IL_congress_gscores2, IL_congress_gscores3)
save(IL_total_congress_scores, file = "IL_total_congress_scores.Rdata")

for (i in length(IL_total_congress_scores)) {
  
}

values <- function (x) {
  pop_within <- sum(IL_total_congress_scores[[x]][[2]]$Population)
  pop_inner_border <- sum(IL_total_congress_scores[[x]][[3]]$Population)
  no_blocks <- nrow(IL_total_congress_scores[[x]][[2]])
  avrg_pop_per_block <- (pop_within/no_blocks)
  
  return(list(pop_within,pop_inner_border,no_blocks,avrg_pop_per_block))
}

total_values <- lapply(as.list(1:18), values)

IL_final_congress_scores <- list()
for(i in 1:18) {
  IL_final_congress_scores[[i]] <- c(IL_total_congress_scores[[i]],total_values[[i]])
}

str(IL_final_congress_scores,1)
save(IL_final_congress_scores, file = "IL_final_congress_scores.Rdata")


cvb <- lapply(IL_final_congress_scores, function(x){return (x[[1]])})
unlist(cvb)
which.min(unlist(cvb))
which.max(unlist(cvb))
