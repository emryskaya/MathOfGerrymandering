library(Matrix)
library(tigris)
library(sp)
library(sf)
library(dplyr)
library(tidyverse)
library(rgeos)
library(parallel)
library(leaflet)

##Tract Level
IL_tracts <- tracts(state = 'IL')
IL_tracts <- IL_tracts[order(IL_tracts$TRACTCE),]
sf_IL_tracts <- st_as_sf(IL_tracts)
IL_tract_adjacency_list <- st_intersects(sf_IL_tracts, sf_IL_tracts)
IL_tract_adjacency_df <- as.data.frame(IL_tract_adajcency_list)
IL_tract_adjacency_matrix <- sparseMatrix(i = abcddf$row.id, j = abcddf$col.id)
IL_tract_adjacency_matrix

##Block Level
IL_blocks <- tigris::blocks(state = 'IL')
IL_blocks <- IL_blocks[order(IL_blocks$TRACTCE10, IL_blocks$BLOCKCE10),]
IL_blocks@data <- cbind(IL_blocks@data, orderno = 1:length(IL_blocks$GEOID10))
sf_IL_blocks <- st_as_sf(IL_blocks)
IL_block_adjacency_list <- st_intersects(sf_IL_blocks,sf_IL_blocks)
IL_block_adjacency_df <- as.data.frame(block_adjacency_list)
IL_block_adjacency_matrix <- sparseMatrix(i = block_adjacency_df$row.id, j = block_adjacency_df$col.id)

##Congressional Districts
congress <- congressional_districts()
IL_congress <- congress[congress$STATEFP == 17, ]
IL_congress@data
sf_IL_congress <- st_as_sf(IL_congress)
plot(st_geometry(sf_IL_congress))

##State Legislatures
IL_state_sen <- state_legislative_districts("IL")
IL_state_cong <- state_legislative_districts("IL", house = "lower")
sf_IL_state_sen <- st_as_sf(IL_state_sen)
sf_IL_state_cong <- st_as_sf(IL_state_cong)

##Scoring Function
gscore <- function(x,y) {
  border_blocks_list <- st_touches(y[x,], sf_IL_blocks)
  border_blocks_df <- as.data.frame(border_blocks_list)
  abc <- as.integer(border_blocks_df[,"col.id"])
  
  within_blocks_list <- st_within(sf_IL_blocks, y[x,])
  within_blocks_df <- as.data.frame(within_blocks_list)
  def <- as.integer(within_blocks_df[,"row.id"])
  
  sgbpl <- st_intersects(sf_IL_blocks[abc,], sf_IL_blocks[def,])
  no_cuts <- length(unlist(sgbpl))
  return(no_cuts)
}

##Get IL state house of representatives score
start <- Sys.time()
scorelist <- mclapply(as.list(1:nrow(sf_IL_state_cong)), gscore, y = sf_IL_state_cong)
end <- Sys.time()
end - start
scorelistcolumn <- as.integer(scorelist)
scorelistcolumn
sf_IL_state_cong <- cbind(sf_IL_state_cong, gmscore = scorelistcolumn)

ilstcng <- as.data.frame(sf_IL_state_cong)
names(ilstcng)
fcdf = subset(ilstcng, select = -c(geometry))
write.csv(fcdf, "Il_state_cong_w_gmscore.csv")

## Get US Congress scores for IL
start <- Sys.time()
scorelist2 <- mclapply(as.list(1:nrow(sf_IL_congress)), gscore, y = sf_IL_congress)
end <- Sys.time()
end - start
scorelistcolumn2 <- as.integer(scorelist2)
scorelistcolumn2
sf_IL_congress <- cbind(sf_IL_congress, gmscore = scorelistcolumn2)
ilcng <- as.data.frame(sf_IL_congress)
names(ilcng)
abcd = subset(ilcng, select = -c(geometry))
write.csv(abcd, "Il_cong_w_gmscore.csv")


