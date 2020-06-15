#' Chord diagram
#' 
#' Creates chord diagram from edge data.frame.
#' 
#' @param df data.frame containing edge data.
#' @param source.column Name of column containing source nodes. Defaults to "source".
#' @param target.column Name of column containing target nodes. Defaults to "target".
#' @param value.column Name of column containing edge values. Defaults to "value".
#' @param adjacency.matrix Adjancency matrix of edge weights, as an alternative to edge list.
#' @param labels Node names corresponding to rows/columns of adjacency.matrix.
#' @param edge.color Method of coloring edges. The value "path" will create a gradient between two nodes. Defaults to "path".
#' @param width Desired width for output widget.
#' @param height Desired height for output widget.
#' @param viewer "internal" to use the RStudio internal viewer pane for output; "external" to display in an external RStudio window; "browser" to display in an external browser.
#' 
#' @return A d3 object as returned by r2d3::r2d3.
#' 
#' @details
#' Utilizes a script similar to \url{https://observablehq.com/@d3/chord-diagram} adapted to work with r2d3.
#' 
#' @examples
#' labels = c("spam", "eggs", "foo", "bar")
#' 
#' df = data.frame(source = rep(labels, each = 4),
#'                 target = rep(labels, times = 4),
#'                 value = c(11975, 5871, 8916, 2868,
#'                           1951, 10048, 2060, 6171,
#'                           8010, 16145, 8090, 8045,
#'                           1013, 990, 940, 6907))
#' 
#' chord(df)
#' 
#' @export

chord <-
  function(df, source.column = "source", target.column = "target", value.column = "value",
           adjacency.matrix = NULL, labels = NULL,
           edge.color = c("path", "input", "output", "none"),
           width = NULL, height = NULL, viewer = c("internal", "external", "browser")){
    
    # Parsing arguments
    edge.color = match.arg(edge.color)
    viewer = match.arg(viewer)
    
    if (missing(df)){
      if ((is.null(adjacency.matrix) | is.null(labels))) stop("Either argument df or arguments adjacency.matrix + labels should be used.")
      if ((is.null(adjacency.matrix) & is.null(labels))) stop("Both adjacency.matrix and labels must be specified.")
      if ((nrow(adjacency.matrix) != ncol(adjacency.matrix)) | (nrow(adjacency.matrix) != length(labels))) stop("adjacency.matrix must be square with the same number of rows/columns as number of labels.")
    }
    
    # Creating data object to pass to chord.js
    if (missing(df)){
      matrix.labels = list(matrix = adjacency.matrix, labels = labels)
    } else{
      matrix.labels = df.to.adjacency(df, source.column, target.column, value.column)
    }
    
    # JS file locations
    package.dir = system.file(package = "d3po")
    chord.script.file = paste0(package.dir, "/js/chord.js")
    
    # Copying sankey.js and adding variables in preamble
    chord.script = readLines(chord.script.file)
    
    preamble = c(sprintf("const edgeColor = \"%s\";", edge.color))
    
    temp.script.file = tempfile()
    writeLines(c(preamble, chord.script), temp.script.file)
    
    # Creating d3 diagram
    d3 = r2d3::r2d3(
      data = matrix.labels,
      script = temp.script.file,
      width = width,
      height = height,
      viewer = viewer
    )
    
    file.remove(temp.script.file)
    
    # Return diagram
    return(d3)
  }
