pkgname <- "d3po"
source(file.path(R.home("share"), "R", "examples-header.R"))
options(warn = 1)
options(pager = "console")
base::assign(".ExTimings", "d3po-Ex.timings", pos = 'CheckExEnv')
base::cat("name\tuser\tsystem\telapsed\n", file=base::get(".ExTimings", pos = 'CheckExEnv'))
base::assign(".format_ptime",
function(x) {
  if(!is.na(x[4L])) x[1L] <- x[1L] + x[4L]
  if(!is.na(x[5L])) x[2L] <- x[2L] + x[5L]
  options(OutDec = '.')
  format(x[1L:3L], digits = 7L)
},
pos = 'CheckExEnv')

### * </HEADER>
library('d3po')

base::assign(".oldSearch", base::search(), pos = 'CheckExEnv')
base::assign(".old_wd", base::getwd(), pos = 'CheckExEnv')
cleanEx()
nameEx("chord")
### * chord

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: chord
### Title: Chord diagram
### Aliases: chord

### ** Examples

labels = c("spam", "eggs", "foo", "bar")

df = data.frame(source = rep(labels, each = 4),
                target = rep(labels, times = 4),
                value = c(11975, 5871, 8916, 2868,
                          1951, 10048, 2060, 6171,
                          8010, 16145, 8090, 8045,
                          1013, 990, 940, 6907))

chord(df)




base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("chord", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("choropleth.county")
### * choropleth.county

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: choropleth.county
### Title: County level choropleth
### Aliases: choropleth.county

### ** Examples

## Not run: 
##D data(unemployment.county)
##D 
##D choropleth.county(unemployment.county,
##D                  id.column = "id",
##D                  value.column = "rate",
##D                  legend.title = "Unemployment rate (%)")
## End(Not run)




base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("choropleth.county", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("choropleth.state")
### * choropleth.state

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: choropleth.state
### Title: State level choropleth
### Aliases: choropleth.state

### ** Examples

data(unemployment.state)

choropleth.state(unemployment.state,
                 state.column = "name",
                 value.column = "rate",
                 legend.title = "Unemployment rate (%)")




base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("choropleth.state", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("cloud")
### * cloud

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: cloud
### Title: Word cloud diagram
### Aliases: cloud

### ** Examples

df = data.frame(text = c("foo", "bar", "spam", "eggs"),
                value = 2 * c(0.5, 10, 1, 10),
                group = c("Not Python", "Not Python", "Python", "Python"))

cloud(df)




base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("cloud", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("df.to.adjacency")
### * df.to.adjacency

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: df.to.adjacency
### Title: Conversion from data.frame to adjacency matrix
### Aliases: df.to.adjacency

### ** Examples

labels = c("spam", "eggs", "foo", "bar")

df = data.frame(source = rep(labels, each = 4),
                target = rep(labels, times = 4),
                value = c(11975, 5871, 8916, 2868,
                          1951, 10048, 2060, 6171,
                          8010, 16145, 8090, 8045,
                          1013, 990, 940, 6907))

df.to.adjacency(df)




base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("df.to.adjacency", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("df.to.hierarchy")
### * df.to.hierarchy

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: df.to.hierarchy
### Title: Conversion from data.frame to hierarchy
### Aliases: df.to.hierarchy

### ** Examples

data(flare)

df.to.hierarchy(flare$ancestry.df, flare$leaf.df)




base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("df.to.hierarchy", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("marimekko")
### * marimekko

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: marimekko
### Title: Marimekko diagram
### Aliases: marimekko

### ** Examples

data(sales)

marimekko(sales, x.column = "market", y.column = "segment")




base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("marimekko", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("sankey")
### * sankey

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: sankey
### Title: Sankey diagram
### Aliases: sankey

### ** Examples

data(energy)

sankey(energy)




base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("sankey", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("save.d3")
### * save.d3

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: save.d3
### Title: Save d3 diagram as png
### Aliases: save.d3

### ** Examples

## Not run: 
##D data(energy)
##D 
##D d3 = sankey(energy)
##D f = paste0(tempfile(), ".html")
##D save.d3(d3, f)
## End(Not run)




base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("save.d3", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("sunburst")
### * sunburst

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: sunburst
### Title: Sunburst diagram
### Aliases: sunburst

### ** Examples

data(flare)

sunburst(flare$ancestry.df, flare$leaf.df)




base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("sunburst", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
### * <FOOTER>
###
cleanEx()
options(digits = 7L)
base::cat("Time elapsed: ", proc.time() - base::get("ptime", pos = 'CheckExEnv'),"\n")
grDevices::dev.off()
###
### Local variables: ***
### mode: outline-minor ***
### outline-regexp: "\\(> \\)?### [*]+" ***
### End: ***
quit('no')
