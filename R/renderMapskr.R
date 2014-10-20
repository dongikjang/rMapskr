#' renderMapskr (use with Shiny)
#' 
#' Use rMapskr as Shiny output. First, use \code{renderMapskr} in \code{server.R}
#' to assign the chart object to an Shiny output. Then create an chartOutput
#' with the same name in #' \code{ui.R}. \code{chartOutput} is currently just an
#' alias for \code{htmlOutput}.
#' 
#' @author Thomas Reinholdsson, Ramnath Vaidyanathan
#' @param expr An expression that returns a chart object
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is expr a quoted expression (with \code{quote()})? This is
#'  useful if you want to save an expression in a variable.
#'   
#' @export
renderMapskr <- function(expr, env = parent.frame(), quoted = FALSE) {
  func <- shiny::exprToFunction(expr, env, quoted)
  function() {
    rMapskr_ <- func()
    cht_style <- sprintf("<style>.rMapskr {width: %spx; height: %spx} </style>",
      rMapskr_$params$width, rMapskr_$params$height)
    HTML(paste(c(cht_style, rMapskr_$html()), collapse = '\n'))
  }
}

renderMap = function(expr, env = parent.frame(), quoted = FALSE, html_sub = NULL){
  func <- shiny::exprToFunction(expr, env, quoted)
  function() {
    rMapskr_ <- func()
    map_style <- sprintf("<style>.leaflet {width: %spx; height: %spx} </style>",
      rMapskr_$params$width, rMapskr_$params$height)
    map_div = sprintf('<div id="%s" class="rMapskr leaflet"></div>', rMapskr_$params$dom)    
    rMapskr_html = rMapskr_$html()
    if (length(html_sub) > 0){
      for (i in 1:length(html_sub)){
        rMapskr_html = gsub(names(html_sub)[i], as.character(html_sub[i]), rMapskr_html)
      }
    }
    # bbest DEBUG    
    #cat(HTML(paste(c(map_style, map_div, rMapskr_html), collapse = '\n')), file='~/Code/rMapskr/inst/apps/leaflet_chloropleth/debug_renderMap.html')
    HTML(paste(c(map_style, map_div, rMapskr_html), collapse = '\n'))    
  }
}

#' renderMapskr2 (use with Shiny)
#' 
#' renderMapskr2 is a modified version of renderMapskr. While renderMapskr 
#' creates the chart directly on a shiny input div, renderMapskr2 uses the
#' shiny input div as a wrapper and appends a new chart div to it. This
#' has advantages in being able to keep chart creation workflow the same
#' across shiny and non-shiny applications
renderMapskr2 <- function(expr, env = parent.frame(), quoted = FALSE) {
  func <- shiny::exprToFunction(expr, env, quoted)
  function() {
    rMapskr_ <- func()
    cht_style <- sprintf("<style>.rMapskr {width: %spx; height: %spx} </style>",
      rMapskr_$params$width, rMapskr_$params$height)
    cht <- paste(capture.output(rMapskr_$print()), collapse = '\n')
    HTML(paste(c(cht_style, cht), collapse = '\n'))
  }
}
