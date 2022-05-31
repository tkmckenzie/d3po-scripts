#' Sankey diagram
#' 
#' Creates Sankey diagram from edgelist data.frame.
#' 
#' @param df data.frame containing edgelist data.
#' @param source.column Name of column containing source nodes. Defaults to "source".
#' @param target.column Name of column containing target nodes. Defaults to "target".
#' @param value.column Name of column containing edge values. Defaults to "value".
#' @param sort.nodes Boolean indicating whether to let sankey.js to sort nodes. Defaults to TRUE. If FALSE, nodes will be ordered as they appear in df.
#' @param text.align Alignment of node labels. Defaults to "outside".
#' @param margin.proportion Proportion of image to devote to margins on both left and right side. Only effective when text.align is "outside". Defaults to 0.2, must be between 0 and 0.5.
#' @param edge.color Method of coloring edges. The value "path" will create a gradient between two nodes. Defaults to "path".
#' @param color.scheme Color scheme to use in visualization. See \link[d3po]{color.schemes} for more details.
#' @param width Desired width for output widget.
#' @param height Desired height for output widget.
#' @param viewer "internal" to use the RStudio internal viewer pane for output; "external" to display in an external RStudio window; "browser" to display in an external browser.
#' 
#' @return A d3 object as returned by \link[r2d3]{r2d3}.
#' 
#' @details
#' Utilizes a script similar to \url{https://observablehq.com/@d3/sankey-diagram} adapted to work with r2d3.
#' 
#' @examples
#' data(energy)
#' 
#' sankey(energy)
#' 
#' @export

sankey <-
  function(df, source.column = "source", target.column = "target", value.column = "value",
           sort.nodes = c(TRUE, FALSE), text.align = c("outside", "inside"), margin.proportion = 0.2,
           edge.color = c("path", "input", "output", "none"),
           color.scheme = c("Spectral", names(d3po::color.schemes)),
           width = NULL, height = NULL, viewer = c("internal", "external", "browser")){
    
    # Parsing arguments
    sort.nodes = match.arg(as.character(sort.nodes[1]), choices = c(TRUE, FALSE))
    text.align = match.arg(text.align)
    edge.color = match.arg(edge.color)
    color.scheme = match.arg(color.scheme)
    viewer = match.arg(viewer)
    
    if (margin.proportion < 0 | margin.proportion > 0.5) stop("margin.proportion must be between 0 and 0.5.")
    
    # JS file locations
    package.dir = system.file(package = "d3po")
    d3.sankey.file = paste0(package.dir, "/js/d3-sankey/d3-sankey.js")
    d3.scale.chromatic.file = paste0(package.dir, "/js/d3-scale-chromatic/d3-scale-chromatic.js")
    sankey.script.file = paste0(package.dir, "/js/sankey.js")
    
    # Copying sankey.js and adding variables in preamble
    sankey.script = readLines(sankey.script.file)
    
    preamble = c(sprintf("const sortNodes = %s;", tolower(as.character(sort.nodes))),
                 sprintf("const textAlign = \"%s\";", text.align),
                 sprintf("const edgeColor = \"%s\";", edge.color),
                 sprintf("const marginProportion = %f;", margin.proportion),
                 sprintf("const colorScheme = d3.interpolate%s;", color.scheme),
                 sprintf("const divergentColorScheme = %s;", tolower(d3po::color.schemes[[color.scheme]])))
    
    temp.script.file = tempfile()
    writeLines(c(preamble, sankey.script), temp.script.file)
    
    # Selecting source, target, and value columns from df and renaming
    df = df[,c(source.column, target.column, value.column)]
    names(df) = c("source", "target", "value")
    
    df$source = as.character(df$source)
    df$target = as.character(df$target)
    
    # Creating d3 diagram
    d3 = r2d3::r2d3(
      data = df,
      script = temp.script.file,
      dependencies = c(d3.sankey.file, d3.scale.chromatic.file),
      width = width,
      height = height,
      viewer = viewer
    )
    
    # Remove temporary script file
    file.remove(temp.script.file)
    
    # Return diagram
    return(d3)
  }
