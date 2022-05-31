#' Save d3 diagram as png
#' 
#' Saves d3 diagram as a png image using webshot.
#' 
#' @param d3 A d3 object.
#' @param file Location to save image. Must have extension ".png" or ".html".
#' @param width Width of image.
#' @param height Height of image.
#' @param delay Time to wait before taking screenshot, in seconds. Sometimes a longer delay is needed for all assets to display properly.
#' @param zoom Zoom before screenshot.
#' @param background Background color of diagram.
#' @param title Title for HTML diagram.
#' 
#' @examples
#' \dontrun{
#' data(energy)
#' 
#' d3 = sankey(energy)
#' f = paste0(tempfile(), ".html")
#' save.d3(d3, f)
#' }
#' 
#' @export

save.d3 <-
  function(d3, file, width = 1000, height = 750, delay = 0.2, zoom = 1, background = "white", title = "D3 Visualization"){
    # Check that file extension is valid
    if (!grepl("(\\.png|\\.html)$", file)) stop("file must have extension \".png\" or \".html\".")
    
    # Extract file extension
    file.extension = utils::tail(strsplit(file, "\\.")[[1]], 1)
    
    if (file.extension == "png"){
      temp.file = tempfile(fileext = ".html")
      r2d3::save_d3_html(d3, temp.file, background = background, title = title)
      webshot::webshot(temp.file, file = file, vwidth = width, vheight = height, delay = delay, zoom = zoom)
    } else{
      r2d3::save_d3_html(d3, file, background = background, title = title)
    }
  }
