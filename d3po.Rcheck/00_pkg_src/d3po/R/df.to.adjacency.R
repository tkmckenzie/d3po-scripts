#' Conversion from data.frame to adjacency matrix
#' 
#' Creates an adjacency matrix from an edge list data.frame.
#' 
#' @param df data.frame containing edge data
#' @param source.column Name of column containing source nodes. Defaults to "source".
#' @param target.column Name of column containing target nodes. Defaults to "target".
#' @param value.column Name of column containing edge values. Defaults to "value".
#' 
#' @return A list with two components:
#' \item{matrix}{Adjacency matrix}
#' \item{labels}{Names of nodes, in same order as rows/columns of adjacency matrix}
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
#' df.to.adjacency(df)
#' 
#' @export

df.to.adjacency <-
  function(df, source.column = "source", target.column = "target", value.column = "value"){
    labels = as.character(unique(c(df[,source.column], df[,target.column])))
    m = matrix(0, nrow = length(labels), ncol = length(labels))
    colnames(m) = labels
    rownames(m) = labels
    
    m[as.matrix(df[,c(source.column, target.column)])] = df[,value.column]
    
    return(list(matrix = m, labels = labels))
  }
