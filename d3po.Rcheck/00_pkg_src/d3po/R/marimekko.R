#' Marimekko diagram
#' 
#' Creates Marimekko diagram from data.frame.
#' 
#' @param df data.frame containing horizontal category, vertical category, and value data.
#' @param x.column Name of column containing horizontal category data. Defaults to "x".
#' @param y.column Name of column containing vertical category data. Defaults to "y".
#' @param value.column Name of column containing value data. Defaults to "value".
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
           width = NULL, height = NULL, viewer = c("internal", "external", "browser")){
    
    # Parsing arguments
    viewer = match.arg(viewer)
    
    # JS file locations
    package.dir = system.file(package = "d3po")
    marimekko.script.file = paste0(package.dir, "/js/marimekko.js")
    
    # Selecting columns and renaming
    df = df[,c(x.column, y.column, value.column)]
    names(df) = c("x", "y", "value")
    
    # Creating d3 diagram
    d3 = r2d3::r2d3(
      data = df,
      script = marimekko.script.file,
      width = width,
      height = height,
      viewer = viewer
    )
    
    # Return diagram
    return(d3)
  }
