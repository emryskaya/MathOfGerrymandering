library(rmarkdown)

for (i in nrow(sf_IL_cong_dist)){
  render("GM_Report_Template.rmd", output_file = paste0('report.', id, '.html'))
}
