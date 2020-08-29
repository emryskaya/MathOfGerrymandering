library(Matrix)
library(tigris)
library(sp)
library(sf)
library(dplyr)
library(tidyverse)
library(rgeos)

VT_tracts <- tracts(state = 'VT')
VT_tracts <- VT_tracts[order(VT_tracts$TRACTCE),]
sf_VT_tracts <- st_as_sf(VT_tracts)
VT_tract_adjacency_list <- st_intersects(sf_VT_tracts, sf_VT_tracts)
VT_tract_adjacency_df <- as.data.frame(VT_tract_adajcency_list)
VT_tract_adjacency_matrix <- sparseMatrix(i = abcddf$row.id, j = abcddf$col.id)
image(VT_tract_adjacency_matrix)

##Block Level
VT_blocks <- tigris::blocks(state = 'VT')
VT_blocks <- VT_blocks[order(VT_blocks$TRACTCE10, VT_blocks$BLOCKCE10),]
VT_blocks@data <- cbind(VT_blocks@data, orderno = 1:length(VT_blocks$GEOID10))
sf_VT_blocks <- st_as_sf(VT_blocks)
VT_block_adjacency_list <- st_intersects(sf_VT_blocks,sf_VT_blocks)
VT_block_adjacency_list
VT_block_adjacency_df <- as.data.frame(VT_block_adjacency_list)
VT_block_adjacency_df
VT_block_adjacency_matrix <- sparseMatrix(i = VT_block_adjacency_df$row.id, j = VT_block_adjacency_df$col.id)
image(VT_block_adjacency_matrix[100:150,100:150])

plot.new()
plot(st_geometry(sf_VT_tracts[90:100,]), reset = FALSE, )
plot(sf_VT_tracts[94,], col = "red", add = TRUE)
plot(sf_VT_tracts[95,], col = "blue", add = TRUE)
plot(sf_VT_tracts[97,], col = "green", add = TRUE)
plot(sf_VT_tracts[98,], col = "orange", add = TRUE)

CA_blocks <- tigris::blocks(state = "CA")
CA_blocks <- CA_blocks[order(CA_blocks$TRACTCE10, CA_blocks$BLOCKCE10),]
CA_blocks@data <- cbind(CA_blocks@data, orderno = 1:length(CA_blocks$GEOID10))
sf_CA_blocks <- st_as_sf(CA_blocks)
start <- Sys.time()
CA_block_adjacency_list <- st_intersects(sf_CA_blocks,sf_CA_blocks)
end <- Sys.time()
(end - start)
CA_block_adjacency_df <- as.data.frame(CA_block_adjacency_list)
CA_block_adjacency_matrix <- sparseMatrix(i = CA_block_adjacency_df$row.id, j = CA_block_adjacency_df$col.id)
CA_block_adjacency_matrix




#Trying to develop a gerrymandering score for districts
#All the congressional districs
VT_state_sen <- state_legislative_districts("VT")
VT_state_cong <- state_legislative_districts("VT", house = "lower")
sf_VT_state_sen <- st_as_sf(VT_state_sen)
sf_VT_state_cong <- st_as_sf(VT_state_cong)

plot(st_geometry(sf_VT_state_cong[21,]))
plot(st_geometry(sf_VT_blocks), add = TRUE,border = rgb(0,1,1,0.25), lwd = 2)

border_blocks_list <- st_touches(sf_VT_state_cong[61,], sf_VT_blocks)
border_blocks_df <- as.data.frame(border_blocks_list)
abc <- as.integer(border_blocks_df[,"col.id"])

within_blocks_list <- st_within(sf_VT_blocks, sf_VT_state_cong[61,])
within_blocks_df <- as.data.frame(within_blocks_list)
def <- as.integer(within_blocks_df[,"row.id"])
length(def)

plot(st_geometry(sf_VT_state_cong[61,]),)
plot(st_geometry(sf_VT_blocks[def,]), add = TRUE,border = rgb(1,0,0,0.3), lwd = 4)
plot(st_geometry(sf_VT_blocks[abc,]), add = TRUE,border = rgb(0,1,1,0.3), lwd = 4)


sgbpl <- st_intersects(sf_VT_blocks[abc,], sf_VT_blocks[def,])
sgbpl

plot(st_geometry(sf_VT_state_cong[c(1:2, 4:5),]),)
plot(st_geometry(sf_VT_blocks[abc[[1]],]), add = TRUE,border = rgb(0,1,1,0.5), lwd = 2)
plot(st_geometry(sf_VT_blocks[def[sgbpl[[1]]],] ), add = TRUE,border = rgb(1,0,0,0.5), lwd = 2)

VT_blocks@data[1:3,]

gscore <- 0

gscore <- function(x) {
  border_blocks_list <- st_touches(sf_VT_state_cong[x,], sf_VT_blocks)
  border_blocks_df <- as.data.frame(border_blocks_list)
  abc <- as.integer(border_blocks_df[,"col.id"])
  
  within_blocks_list <- st_within(sf_VT_blocks, sf_VT_state_cong[x,])
  within_blocks_df <- as.data.frame(within_blocks_list)
  def <- as.integer(within_blocks_df[,"row.id"])
  
  sgbpl <- st_intersects(sf_VT_blocks[abc,], sf_VT_blocks[def,])
  no_cuts <- length(unlist(sgbpl))
  return(no_cuts)
}

min(sf_VT_state_cong$gmscore)
max(sf_VT_state_cong$gmscore)
indexof(sf_VT_state_cong$gmscore, 31)
sf_VT_state_cong[21,]
sf_VT_state_cong[61,]


library(parallel)
scorelist <- mclapply(as.list(1:nrow(sf_VT_state_cong)), gscore)
scorelistcolumn <- as.integer(scorelist)
scorelistcolumn
sf_VT_state_cong <- cbind(sf_VT_state_cong, gmscore = scorelistcolumn)
sf_VT_state_cong

ggplot(data = sf_VT_state_cong) +
  geom_point(mapping = aes(x = INTPTLON, y = INTPTLAT, size = gmscore))
ggplot(add = TRUE, sf_VT_state_cong)
