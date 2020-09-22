library(tigris)
library(sf)
library(sp)
library(rgeos)

VT_tracts <- tracts(state = 'VT')
VT_tracts <- VT_tracts[order(VT_tracts$TRACTCE),]
rownames(VT_blocks@data) <- NULL
VT_tracts@data <- cbind(VT_tracts@data, orderno = 1:length(VT_tracts$GEOID10))
sf_VT_tracts <- st_as_sf(VT_tracts)
save(sf_VT_tracts, file = "sf_VT_tracts.Rdata")

# VT_tract_adjacency_list <- st_intersects(sf_VT_tracts, sf_VT_tracts)
# VT_tract_adjacency_df <- as.data.frame(VT_tract_adajcency_list)
# VT_tract_adjacency_matrix <- sparseMatrix(i = abcddf$row.id, j = abcddf$col.id)
# image(VT_tract_adjacency_matrix)

VT_blocks <- tigris::blocks(state = 'VT')
VT_blocks@data
VT_blocks <- VT_blocks[order(VT_blocks$COUNTYFP10, VT_blocks$TRACTCE10, VT_blocks$BLOCKCE10),]
rownames(VT_blocks@data) <- NULL
VT_blocks@data <- cbind(VT_blocks@data, Orderno = 1:length(VT_blocks$GEOID10))
sf_VT_blocks <- st_as_sf(VT_blocks)
save(sf_VT_blocks, file = "sf_VT_blocks.Rdata")

# VT_block_adjacency_list <- st_intersects(sf_VT_blocks,sf_VT_blocks)
# VT_block_adjacency_list
# VT_block_adjacency_df <- as.data.frame(VT_block_adjacency_list)
# VT_block_adjacency_df
# VT_block_adjacency_matrix <- sparseMatrix(i = VT_block_adjacency_df$row.id, j = VT_block_adjacency_df$col.id)
# image(VT_block_adjacency_matrix[100:150,100:150])

VT_state_sen <- state_legislative_districts("VT")
VT_state_cong <- state_legislative_districts("VT", house = "lower")
sf_VT_state_sen <- st_as_sf(VT_state_sen)
sf_VT_state_cong <- st_as_sf(VT_state_cong)
save(sf_VT_state_sen, file = "sf_VT_state_sen.Rdata")
save(sf_VT_state_cong, file = "sf_VT_state_cong.Rdata")



# CA_blocks <- tigris::blocks(state = "CA")
# CA_blocks <- CA_blocks[order(CA_blocks$TRACTCE10, CA_blocks$BLOCKCE10),]
# CA_blocks@data <- cbind(CA_blocks@data, orderno = 1:length(CA_blocks$GEOID10))
# sf_CA_blocks <- st_as_sf(CA_blocks)
# start <- Sys.time()
# CA_block_adjacency_list <- st_intersects(sf_CA_blocks,sf_CA_blocks)
# end <- Sys.time()
# (end - start)
# CA_block_adjacency_df <- as.data.frame(CA_block_adjacency_list)
# CA_block_adjacency_matrix <- sparseMatrix(i = CA_block_adjacency_df$row.id, j = CA_block_adjacency_df$col.id)
# CA_block_adjacency_matrix

plot.new()
plot(st_geometry(sf_VT_tracts[90:100,]), reset = FALSE, )
plot(sf_VT_tracts[94,], col = "red", add = TRUE)
plot(sf_VT_tracts[95,], col = "blue", add = TRUE)
plot(sf_VT_tracts[97,], col = "green", add = TRUE)
plot(sf_VT_tracts[98,], col = "orange", add = TRUE)

