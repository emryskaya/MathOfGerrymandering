library(rmarkdown)

render_one <- function(district_no){
  rmarkdown::render('GM_Report_Template.Rmd', 
  output_file = paste0("GM_Report_Dist_", district_no, '.html'), 
  params = list(dist_no = district_no), envir = parent.frame())
}

for(i in 1:18) {
  render_one(i)
}
