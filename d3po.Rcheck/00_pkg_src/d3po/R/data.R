#' Compatible D3 Color Schemes
#' 
#' List of color schemes available and indicators of whether schemes are divergent.
#' All d3po functions use d3.interpolate<scheme>.
#' See \url{https://github.com/d3/d3-scale-chromatic} for more details on scales.
"color.schemes"

#' Energy Sources and Sinks
#' 
#' Dataset describing energy generation and consumption
#' as a directed network. Data come from the Department
#' of Energy & Climate Change via Tom Counsell. See
#' \url{http://www.decc.gov.uk/en/content/cms/tackling/2050/calculator_on/calculator_on.aspx}.
#' 
"energy"

#' Flare Class Hierarchy
#' 
#' Dataset describing the hierarchy of the Flare Javascript class. The data object is a list
#' of two data.frames. The first (ancestry.df) describes the hierarchy as a list of parent
#' and child nodes. The second (leaf.df) gives values for leaves of the hierarchy that can
#' be used for sizing. Taken from \url{https://observablehq.com/@d3/sunburst}.
"flare"

#' Synthetic Sales Data
#' 
#' Fictitious dataset describing sales of various products in various locales.
#' Taken from \url{https://observablehq.com/@d3/marimekko-chart}.
#' 
"sales"

#' County Unemployment
#' 
#' Unemployment rate by county, August 2016. Source: Bureau of Labor Statistics.
#'
"unemployment.county"

#' State Unemployment
#' 
#' Unemployment rate by state, July 2019. Source: Bureau of Labor Statistics.
#'
"unemployment.state"

#' Counties in the U.S.
#' 
#' Contains a data.frame of all counties, their respective states, and an identifier
#' that can be used with d3po::choropleth.county.
#'
"us.counties"
