setwd("~/git/d3po-scripts")
devtools::check("../d3po")

# setwd("~/git/d3po")
# usethis::use_travis()

setwd("~/git/d3po-scripts")
system("R CMD check --as-cran d3po_0.0.1.tar.gz")
