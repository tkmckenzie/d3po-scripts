#' Marimekko diagram
#' 
#' Creates Marimekko diagram from data.frame.
#' 
#' @param df data.frame containing horizontal category, vertical category, and value data.
#' @param x.column Name of column containing horizontal category data. Defaults to "x".
#' @param y.column Name of column containing vertical category data. Defaults to "y".
#' @param value.column Name of column containing value data. Defaults to "value".
#' @param min.opacity Minimum opacity value for area colors, between 0 and 1. Defaults to 0.25.
#' @param max.opacity Maximum opacity value for area colors, between 0 and 1. Defaults to 0.9.
#' @param width Desired width for output widget.
#' @param height Desired height for output widget.
#' @param viewer "internal" to use the RStudio internal viewer pane for output; "external" to display in an external RStudio window; "browser" to display in an external browser.
#' 
#' @return A d3 object as returned by r2d3::r2d3.
#' 
#' @details
#' Utilizes a script similar to \url{https://observablehq.com/@d3/marimekko-chart} adapted to work with r2d3.
#' 
#' @examples
#' data(sales)
#' 
#' marimekko(sales, x.column = "market", y.column = "segment")
#' 
#' @export

marimekko <-
  function(df, x.column = "x", y.column = "y", value.column = "value",
           min.opacity = 0.25, max.opacity = 0.9,
           width = NULL, height = NULL, viewer = c("internal", "external", "browser")){
    
    # Parsing arguments
    viewer = match.arg(viewer)
    
    if (min.opacity < 0 | min.opacity > 1) stop("min.opacity must be between 0 and 1.")
    if (max.opacity < 0 | max.opacity > 1) stop("max.opacity must be between 0 and 1.")
    if (min.opacity >= max.opacity) stop("min.opacity must be less than max.opacity")
    
    # JS file locations
    package.dir = system.file(package = "d3po")
    marimekko.script.file = paste0(package.dir, "/js/marimekko.js")
    
    # Copying marimekko.js and adding variables in preamble
    marimekko.script = readLines(marimekko.script.file)
    
    preamble = c(sprintf("const minOpacity = %f;", min.opacity),
                 sprintf("const maxOpacity = %f;", max.opacity))
    
    temp.script.file = tempfile()
    writeLines(c(preamble, marimekko.script), temp.script.file)
    
    # Selecting columns and renaming
    df = df[,c(x.column, y.column, value.column)]
    names(df) = c("x", "y", "value")
    
    df$x = as.character(df$x)
    df$y = as.character(df$y)
    
    # Creating d3 diagram
    d3 = r2d3::r2d3(
      data = df,
      script = temp.script.file,
      width = width,
      height = height,
      viewer = viewer
    )
    
    file.remove(temp.script.file)
    
    # Return diagram
    return(d3)
  }
