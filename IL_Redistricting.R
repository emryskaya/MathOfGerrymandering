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

IL_block_adjacency_list <- st_intersects(sf_IL_blocks,sf_IL_blocks)
IL_block_adjacency_list
IL_block_adjacency_df <- as.data.frame(IL_block_adjacency_list)
IL_block_adjacency_df
IL_block_adjacency_matrix <- sparseMatrix(i = IL_block_adjacency_df$row.id, j = IL_block_adjacency_df$col.id)
image(IL_block_adjacency_matrix[100:150,100:150])
save(IL_block_adjacency_matrix, file = "IL_block_adjacency_matrix.Rdata")

sf_IL_blocks[IL_block_adjacency_df[1,1],]$Population



border_blocks_list <- st_touches(sf_IL_cong_dist[2,], sf_IL_blocks)
border_blocks_df <- as.data.frame(border_blocks_list)
abc <- as.integer(border_blocks_df[,"col.id"])
single_sf_touches <- st_union(sf_IL_blocks[abc,])

within_blocks_list <- st_within(sf_IL_blocks, sf_IL_cong_dist[2,])
within_blocks_df <- as.data.frame(within_blocks_list)
def <- as.integer(within_blocks_df[,"row.id"])

inner_border_list <- st_touches(sf_IL_blocks, single_sf_touches)
inner_border_df <- as.data.frame(inner_border_list)
ghi <- as.integer(inner_border_df[,"row.id"])
jkl <- intersect(ghi,def)
ghi

z <- sf_IL_blocks[def,]
t <- sf_IL_blocks[jkl,]


x
y

z$Districtno <- 2
z

x$Districtno <- 1
x

par(mfrow = c(1,1))
plot(st_geometry(sf_IL_cong_dist[1:2,]))

plot(st_geometry(t))
plot(st_geometry(y), add = TRUE)

listt <- st_touches(y,t)
dff <- as.data.frame(listt)

xxt <- as.integer(dff[,"col.id"])
xxt <- unique(xxt)
tborder <- t[xxt,]
xxy <- as.integer(dff[,"row.id"])
xxy <- unique(xxy)
yborder <- y[xxy,]

plot(st_geometry(tborder))
plot(add = TRUE, st_geometry(yborder))

newyborder <- rbind(yborder, tborder[423,])

plot(st_geometry(newyborder), col = "red")
plot(st_geometry(yborder), col = "blue", add = TRUE)



dff
r <- 
plot(r)
