#' Compatible D3 Color Schemes
#' 
#' Vector of color schemes available. Most/all d3po functions use d3.interpolate<scheme>.
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

#' Synthetic Sales Data
#' 
#' Fictitious dataset describing sales of various products in various locales.
#' Taken from \url{https://observablehq.com/@d3/marimekko-chart}.
#' 
"sales"

#' County Unemployment
#' 
#' Unemployment rate by county, August 2016. Data: Bureau of Labor Statistics.
#'
"unemployment.county"

#' State Unemployment
#' 
#' Unemployment rate by state, July 2019. Data: Bureau of Labor Statistics.
#'
"unemployment.state"

#' Counties in the U.S.
#' 
#' Contains a data.frame of all counties, their respective states, and an identifier
#' that can be used with d3po::choropleth.county.
#'
"us.counties"
