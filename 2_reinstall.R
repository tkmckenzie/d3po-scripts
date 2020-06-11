setwd("~/git/r2d3.common-scripts")

remove.packages("r2d3.common")

devtools::install_local("../r2d3.common")
# install.packages("snfa_0.0.1.tar.gz", repos = NULL, type = "source")
# devtools::install_github("tkmckenzie/snfa")
