#' Sunburst diagram
#' 
#' Creates sunburst diagram from hierarchy and value data.
#' 
#' @param ancestry.df data.frame containing edge data for all parents/children.
#' @param leaf.df data.frame containing values for nodes without children.
#' @param parent.column Name of column in ancestry.df containing parent nodes. Defaults to "parent".
#' @param child.column Name of column in ancestry.df containing child nodes. Defaults to "child".
#' @param id.column Name of column in leaf.df containing node names. Defaults to "id".
#' @param value.column Name of column in leaf.df containing leaf values. Defaults to "value".
#' @param color.scheme Color scheme to use in visualization. See \link[d3po]{color.schemes} for more details.
#' @param width Desired width for output widget.
#' @param height Desired height for output widget.
#' @param viewer "internal" to use the RStudio internal viewer pane for output; "external" to display in an external RStudio window; "browser" to display in an external browser.
#' 
#' @return A d3 object as returned by \link[r2d3]{r2d3}.
#' 
#' @details
#' Utilizes a script similar to \url{https://observablehq.com/@d3/sunburst} adapted to work with r2d3.
#' 
#' @examples
#' data(flare)
#' 
#' sunburst(flare$ancestry.df, flare$leaf.df)
#' 
#' @export

sunburst <-
  function(ancestry.df, leaf.df,
           parent.column = "parent", child.column = "child", id.column = "id", value.column = "value",
           color.scheme = c("Spectral", names(d3po::color.schemes)),
           width = NULL, height = NULL, viewer = c("internal", "external", "browser")){
    
    # Parsing arguments
    # print(color.scheme)
    color.scheme = match.arg(color.scheme)
    viewer = match.arg(viewer)
    
    # JS file locations
    package.dir = system.file(package = "d3po")
    d3.scale.chromatic.file = paste0(package.dir, "/js/d3-scale-chromatic/d3-scale-chromatic.js")
    sunburst.script.file = paste0(package.dir, "/js/sunburst.js")
    
    # Copying sankey.js and adding variables in preamble
    sunburst.script = readLines(sunburst.script.file)
    
    preamble = c(sprintf("const colorScheme = d3.interpolate%s;", color.scheme),
                 sprintf("const divergentColorScheme = %s;", tolower(d3po::color.schemes[[color.scheme]])))
    
    temp.script.file = tempfile()
    writeLines(c(preamble, sunburst.script), temp.script.file)
    
    # Creating d3 diagram
    d3 = r2d3::r2d3(
      data = df.to.hierarchy(ancestry.df, leaf.df, parent.column, child.column, id.column, value.column),
      script = temp.script.file,
      dependencies = d3.scale.chromatic.file,
      width = width,
      height = height,
      viewer = viewer
    )
    
    file.remove(temp.script.file)
    
    # Return diagram
    return(d3)
  }
