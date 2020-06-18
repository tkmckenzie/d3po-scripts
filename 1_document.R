setwd("~/git/d3po-scripts")

library(roxygen2)
library(devtools)
library(knitr)

knit("../d3po/README.Rmd", "../d3po/README.md")
document("../d3po")
