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
save(sf_IL_blocks, file = "sf_IL_blocks.Rdata")

# IL_block_adjacency_list <- st_intersects(sf_IL_blocks,sf_IL_blocks)
# IL_block_adjacency_list
# IL_block_adjacency_df <- as.data.frame(IL_block_adjacency_list)
# IL_block_adjacency_df
# IL_block_adjacency_matrix <- sparseMatrix(i = IL_block_adjacency_df$row.id, j = IL_block_adjacency_df$col.id)
# image(IL_block_adjacency_matrix[100:150,100:150])

IL_state_sen <- state_legislative_districts("IL")
IL_state_cong <- state_legislative_districts("IL", house = "lower")
sf_IL_state_sen <- st_as_sf(IL_state_sen)
sf_IL_state_cong <- st_as_sf(IL_state_cong)
save(sf_IL_state_sen, file = "sf_IL_state_sen.Rdata")
save(sf_IL_state_cong, file = "sf_IL_state_cong.Rdata")



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
plot(st_geometry(sf_IL_tracts[90:100,]), reset = FALSE, )
plot(sf_IL_tracts[94,], col = "red", add = TRUE)
plot(sf_IL_tracts[95,], col = "blue", add = TRUE)
plot(sf_IL_tracts[97,], col = "green", add = TRUE)
plot(sf_IL_tracts[98,], col = "orange", add = TRUE)

