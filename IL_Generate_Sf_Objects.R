library(tigris)
library(sf)
library(sp)
library(rgeos)

IL_tracts <- tracts(state = 'IL')
IL_tracts <- IL_tracts[order(IL_tracts$TRACTCE),]
rownames(IL_blocks@data) <- NULL
IL_tracts@data <- cbind(IL_tracts@data, orderno = 1:length(IL_tracts$GEOID10))
sf_IL_tracts <- st_as_sf(IL_tracts)
save(sf_IL_tracts, file = "sf_IL_tracts.Rdata")

# IL_tract_adjacency_list <- st_intersects(sf_IL_tracts, sf_IL_tracts)
# IL_tract_adjacency_df <- as.data.frame(IL_tract_adajcency_list)
# IL_tract_adjacency_matrix <- sparseMatrix(i = abcddf$row.id, j = abcddf$col.id)
# image(IL_tract_adjacency_matrix)

IL_blocks <- tigris::blocks(state = 'IL')
IL_blocks@data
IL_blocks <- IL_blocks[order(IL_blocks$COUNTYFP10, IL_blocks$TRACTCE10, IL_blocks$BLOCKCE10),]
rownames(IL_blocks@data) <- NULL
IL_blocks@data <- cbind(IL_blocks@data, Orderno = 1:length(IL_blocks$GEOID10))
sf_IL_blocks <- st_as_sf(IL_blocks)

#Checking to see if the two sources of data are identical so we can combine them
load("IL_pop_total.Rdata")
library(tidyr)
popGEOID <- unite(IL_pop_total, GEOID, state, county, tract, block, sep = "" )
popGEOID <- popGEOID[,"GEOID"]
identical(sf_IL_blocks$GEOID10,popGEOID)

cbind(sf_IL_blocks, "Population" = IL_pop_total$P001001)
sf_IL_blocks <- cbind(sf_IL_blocks, "Population" = IL_pop_total$P001001)


# IL_block_adjacency_list <- st_intersects(sf_IL_blocks,sf_IL_blocks)
# IL_block_adjacency_list
# IL_block_adjacency_df <- as.data.frame(IL_block_adjacency_list)
# IL_block_adjacency_df
# IL_block_adjacency_matrix <- sparseMatrix(i = IL_block_adjacency_df$row.id, j = IL_block_adjacency_df$col.id)
# image(IL_block_adjacency_matrix[100:150,100:150])


cong_dist <- congressional_districts()
names(cong_dist)
Il_cong_dist <- cong_dist[cong_dist$STATEFP == "17",]
Il_cong_dist <- Il_cong_dist[order(Il_cong_dist$CD115FP),]
sf_IL_cong_dist <-  st_as_sf(Il_cong_dist)
save(sf_IL_cong_dist, file = "sf_IL_cong_dist.Rdata")

IL_state_sen <- state_legislative_districts("IL")
IL_state_cong <- state_legislative_districts("IL", house = "lower")

sf_IL_state_sen <- st_as_sf(IL_state_sen)
sf_IL_state_cong <- st_as_sf(IL_state_cong)
save(sf_IL_state_sen, file = "sf_IL_state_sen.Rdata")
save(sf_IL_state_cong, file = "sf_IL_state_cong.Rdata")

sf_IL_blocks$Districtno <- 0

for(x in 19:19) {
  print(x)
  within_blocks_list <- st_within(sf_IL_blocks, sf_IL_cong_dist[x,])
  within_blocks_df <- as.data.frame(within_blocks_list)
  def <- as.integer(within_blocks_df[,"row.id"])
  
  sf_IL_blocks[def,]$Districtno <- x
}


which(sf_IL_blocks$Districtno == 0)

ints <- st_intersection(sf_IL_blocks[5109,], sf_IL_cong_dist)

str(ints)

par(mfrow = c(1,1))
plot(st_geometry(sf_IL_cong_dist[c(13),]))
plot(st_geometry(sf_IL_blocks[5109,]), add = TRUE, col = "red")

sf_IL_blocks[5105:5115,]
save(sf_IL_blocks, file = "sf_IL_blocks.Rdata")

plot(Il_cong_dist[13,], xlim = c(-89.28, -89.24), ylim = c(38.99, 39.012))
plot(IL_blocks[5109,], add = TRUE)

summary(IL_blocks[5109,]@polygons[[1]]@Polygons[[1]]@coords)


