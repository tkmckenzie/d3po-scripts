#' Word cloud diagram
#' 
#' Creates word cloud diagram text and value data.frame.
#' 
#' @param df data.frame containing text, value, and group data.
#' @param text.column Name of column containing text. Defaults to "text".
#' @param value.column Name of column containing edge values. Defaults to "value".
#' @param group.column Name of column containing group data. Defaults to "group". If group.column is not found in df, a new column with a single group will be created.
#' @param text.color How to color text; "group" (default) colors by group, "word" colors by word, and "none" colors all words black.
#' @param color.scheme Color scheme to use in visualization. See \link[d3po]{color.schemes} for more details.
#' @param legend.font.size Size of font in legend in points. Defaults to 20.
#' @param width Desired width for output widget.
#' @param height Desired height for output widget.
#' @param viewer "internal" to use the RStudio internal viewer pane for output; "external" to display in an external RStudio window; "browser" to display in an external browser.
#' 
#' @return A d3 object as returned by \link[r2d3]{r2d3}.
#' 
#' @details
#' Utilizes a script similar to \url{https://observablehq.com/@d3/word-cloud} adapted to work with r2d3.
#' 
#' @examples
#' df = data.frame(text = c("foo", "bar", "spam", "eggs"),
#'                 value = 2 * c(0.5, 10, 1, 10),
#'                 group = c("Not Python", "Not Python", "Python", "Python"))
#' 
#' cloud(df)
#' 
#' @export

cloud <-
  function(df, text.column = "text", value.column = "value", group.column = "group",
           text.color = c("group", "word", "none"),
           color.scheme = c("Rainbow", names(d3po::color.schemes)),
           legend.font.size = 20,
           width = NULL, height = NULL, viewer = c("internal", "external", "browser")){
    
    # Parsing arguments
    text.color = match.arg(text.color)
    color.scheme = match.arg(color.scheme)
    viewer = match.arg(viewer)
    
    # JS file locations
    package.dir = system.file(package = "d3po")
    d3.cloud.file = paste0(package.dir, "/js/d3-cloud/build/d3.layout.cloud.js")
    d3.dispatch.file = paste0(package.dir, "/js/d3-cloud/node_modules/d3-dispatch/dist/d3-dispatch.js")
    d3.scale.chromatic.file = paste0(package.dir, "/js/d3-scale-chromatic/d3-scale-chromatic.js")
    cloud.script.file = paste0(package.dir, "/js/cloud.js")
    
    # Checking for group column
    if (!(group.column %in% names(df))){
      df[,group.column] = 1
    }
    
    # Copying sankey.js and adding variables in preamble
    cloud.script = readLines(cloud.script.file)
    
    preamble = c(sprintf("const textColor = \"%s\";", text.color),
                 sprintf("const colorScheme = d3.interpolate%s;", color.scheme),
                 sprintf("const legendFontSize = %i;", legend.font.size),
                 sprintf("const divergentColorScheme = %s;", tolower(d3po::color.schemes[[color.scheme]])))
    
    temp.script.file = tempfile()
    writeLines(c(preamble, cloud.script), temp.script.file)
    
    # Selecting columns and renaming
    df = df[,c(text.column, value.column, group.column)]
    names(df) = c("text", "value", "group")
    
    df$text = as.character(df$text)
    df$group = as.character(df$group)
    
    # Creating d3 diagram
    d3 = r2d3::r2d3(
      data = df,
      script = temp.script.file,
      dependencies = c(d3.cloud.file, d3.dispatch.file, d3.scale.chromatic.file),
      width = width,
      height = height,
      viewer = viewer
    )
    
    rm(temp.script.file)
    
    # Return diagram
    return(d3)
  }
