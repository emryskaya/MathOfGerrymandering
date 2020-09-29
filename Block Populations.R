library(censusapi)

# Add key to .Renviron
Sys.setenv(CENSUS_KEY="73ac79196665398cfd96071d93f4c493dca16b26")
# Reload .Renviron
readRenviron("~/.Renviron")
# Check to see that the expected key is output in your R console
Sys.getenv("CENSUS_KEY")

apis <- listCensusApis()
View(apis)

# data2010 <- getCensus(
#   name = "dec/sf1",
#   vintage = 2010,
#   vars = "P001001", 
#   region = "block:*",
#   regionin = "state:50+county:001")
# data2010


get_county_pop <- function(x,y) {
  county_pop_df <- getCensus(
    name = "dec/sf1",
    vintage = 2010,
    vars = "P001001", 
    region = "block:*",
    regionin = sprintf("state:%02d+county:%03d", x,y, sep = "")
  )
  
  county_pop_df <- county_pop_df[order(county_pop_df$tract, county_pop_df$block),]
  
  return(county_pop_df)
}

library(parallel)
# VT_pop <- mclapply(as.list(seq(1,27,2)), get_county_pop, x = 50)
# VT_pop
# VT_pop_total <- do.call(rbind, VT_pop)
# rownames(VT_pop_total) <- 1:length(VT_pop_total$P001001)
# VT_pop_total
# save(VT_pop_total, file = "VT_pop_total.Rdata")

IL_pop <- mclapply(as.list(seq(1,203,2)), get_county_pop, x = 17)
IL_pop_total <- do.call(rbind, IL_pop)
rownames(IL_pop_total) <- 1:length(IL_pop_total$P001001)
IL_pop_total
save(IL_pop_total, file = "IL_pop_total.Rdata")
nrow(IL_pop_total)



