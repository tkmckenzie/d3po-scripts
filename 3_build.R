setwd("~/git/d3po-scripts")

devtools::build("../d3po", ".")
system("R CMD Rd2pdf ../d3po --force --output=d3po.pdf --no-preview .")
