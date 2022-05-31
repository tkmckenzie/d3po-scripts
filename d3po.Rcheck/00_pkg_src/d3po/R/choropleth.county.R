#' County level choropleth
#' 
#' Creates choropleth at the U.S. county level.
#' 
#' @param df data.frame containing value data by county.
#' @param id.column Name of column containing identifiers for states/counties. Defaults to "id". All values in this column must match \code{d3po::us.counties$id}.
#' @param value.column Name of column containing values by county. Defaults to "value".
#' @param legend.title Title of legend, e.g., units. Defaults to "".
#' @param legend.text.size Size of text (in points) for legend title. Defaults to 20.
#' @param scale.text.size Size of text (in points) for the scale values. Defaults to 16.
#' @param color.domain Range of values for the color scale. Defaults to \code{c(min(df[,value.column]), max(df[,value.column]))}. Length greater than two results in a multi-point gradient.
#' @param num.legend.ticks Number of breaks in legend scale. Defaults to 5.
#' @param color.scheme Color scheme to use in visualization. See \link[d3po]{color.schemes} for more details.
#' @param width Desired width for output widget.
#' @param height Desired height for output widget.
#' @param viewer "internal" to use the RStudio internal viewer pane for output; "external" to display in an external RStudio window; "browser" to display in an external browser.
#' 
#' @return A d3 object as returned by \link[r2d3]{r2d3}.
#' 
#' @details
#' Utilizes a script similar to \url{https://observablehq.com/@d3/choropleth} adapted to work with r2d3.
#' 
#' @examples
#' \dontrun{
#' data(unemployment.county)
#' 
#' choropleth.county(unemployment.county,
#'                  id.column = "id",
#'                  value.column = "rate",
#'                  legend.title = "Unemployment rate (%)")
#' }
#' 
#' @export

choropleth.county <-
  function(df,
           id.column = "id", value.column = "value",
           legend.title = "", legend.text.size = 20, scale.text.size = 16,
           color.domain = NULL, num.legend.ticks = 5,
           color.scheme = c("Blues", names(d3po::color.schemes)),
           width = NULL, height = NULL, viewer = c("internal", "external", "browser")){
    # TODO: Deal with NA values in df[,value.column]
    
    # Parsing arguments
    color.scheme = match.arg(color.scheme)
    viewer = match.arg(viewer)
    
    legend.text.size = as.integer(legend.text.size)
    scale.text.size = as.integer(scale.text.size)
    num.legend.ticks = as.integer(num.legend.ticks)
    
    if (is.null(color.domain)) color.domain = c(min(df[,value.column], na.rm = TRUE), max(df[,value.column], na.rm = TRUE))
    
    if (!is.character(legend.title)) stop("legend.title must be a string.")
    if (legend.text.size <= 0) stop("legend.text.size must be greater than 0.")
    if (scale.text.size <= 0) stop("scale.text.size must be greater than 0.")
    if (num.legend.ticks <= 0) stop("num.legend.ticks must be greater than 0.")
    if (!is.numeric(color.domain) | length(color.domain) < 2) stop("color.domain must be a numeric vector of length at least 2.")
    
    # JS file locations
    package.dir = system.file(package = "d3po")
    topojson.file = paste0(package.dir, "/js/topojson-client/dist/topojson-client.js")
    shape.file = paste0(package.dir, "/js/map_data/county.json")
    d3.scale.chromatic.file = paste0(package.dir, "/js/d3-scale-chromatic/d3-scale-chromatic.js")
    choropleth.script.file = paste0(package.dir, "/js/choropleth.county.js")
    
    # Copying sankey.js and adding variables in preamble
    choropleth.script = readLines(choropleth.script.file)
    
    preamble = c(sprintf("const title = \"%s\";", legend.title),
                 sprintf("const legendTextSize = %i;", legend.text.size),
                 sprintf("const scaleTextSize = %i;", scale.text.size),
                 paste0("const colorDomain = [", paste0(color.domain, collapse = ", "), "];"),
                 sprintf("const numLegendTicks = %i;", num.legend.ticks),
                 sprintf("const colorScheme = d3.interpolate%s;", color.scheme),
                 sprintf("const divergentColorScheme = %s;", tolower(d3po::color.schemes[[color.scheme]])))
    
    temp.script.file = tempfile()
    writeLines(c(preamble, choropleth.script), temp.script.file)
    
    # Selecting source, target, and value columns from df and renaming
    # df = df[,c(state.column, county.column, id.column, value.column)]
    # names(df) = c("state", "county", "id", "value")
    df = df[,c(id.column, value.column)]
    names(df) = c("id", "value")
    
    df$value = as.numeric(df$value)
    
    df = df[stats::complete.cases(df),]
    
    # Creating d3 diagram
    d3 = r2d3::r2d3(
      data = list(values = df, shape = jsonlite::read_json(shape.file)),
      script = temp.script.file,
      dependencies = c(topojson.file, d3.scale.chromatic.file),
      width = width,
      height = height,
      viewer = viewer
    )
    
    # Remove temporary script file
    file.remove(temp.script.file)
    
    # Return diagram
    return(d3)
  }
