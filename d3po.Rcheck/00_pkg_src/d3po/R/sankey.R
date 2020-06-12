#' Sankey diagram
#' 
#' Creates Sankey diagram from edge data.frame.
#' 
#' @param df data.frame containing edge data
#' @param source.column Name of column containing source nodes. Defaults to "source".
#' @param target.column Name of column containing target nodes. Defaults to "target".
#' @param value.column Name of column containing edge values. Defaults to "value".
#' @param align Alignment of node labels. Defaults to "justify".
#' @param edge.color Method of coloring edges. The value "path" will create a gradient between two nodes. Defaults to "path".
#' @param width Desired width for output widget.
#' @param height Desired height for output widget.
#' @param viewer "internal" to use the RStudio internal viewer pane for output; "external" to display in an external RStudio window; "browser" to display in an external browser.
#' 
#' @return A d3 object as returned by r2d3::r2d3.
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
           align = c("justify", "left", "right", "center"), edge.color = c("path", "input", "output", "none"),
           width = NULL, height = NULL, viewer = c("internal", "external", "browser")){
    
    # Parsing arguments
    align = match.arg(align)
    edge.color = match.arg(edge.color)
    viewer = match.arg(viewer)
    
    # JS file locations
    package.dir = system.file(package = "d3po")
    d3.sankey.file = paste0(package.dir, "/js/d3-sankey/d3-sankey.js")
    sankey.script.file = paste0(package.dir, "/js/sankey.js")
    
    # Copying sankey.js and adding variables in preamble
    sankey.script = readLines(sankey.script.file)
    
    preamble = c(sprintf("const align = \"%s\";", align),
                 sprintf("const edgeColor = \"%s\";", edge.color))
    
    temp.script.file = tempfile()
    writeLines(c(preamble, sankey.script), temp.script.file)
    
    # Selecting source, target, and value columns from df and renaming
    df = df[,c(source.column, target.column, value.column)]
    names(df) = c("source", "target", "value")
    
    # Creating d3 diagram
    d3 = r2d3::r2d3(
      data = df,
      script = temp.script.file,
      dependencies = d3.sankey.file,
      width = width,
      height = height,
      viewer = viewer
    )
    
    # Remove temporary script file
    file.remove(temp.script.file)
    
    # Return diagram
    return(d3)
  }
