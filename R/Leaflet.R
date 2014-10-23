
Leaflet = setRefClass('Leaflet', contains = 'rMapskr', methods = list(
  initialize = function(krmap = c("daum", "naver", "vworld")){
    callSuper(krmap=krmap[1])
    krmap <<- krmap[1]
    #.self$tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png')
    params$addons <<- list(enablePopover = FALSE)
    params$center <<- c(37.566429, 126.977997)
    if(krmap[1] == "vworld"){
    	params$zoom <<- 12
    } else {
    	params$zoom <<- 9
    }
    
  },
  enablePopover = function(e = TRUE){
    params$addons$enablePopover <<- e
  },
  mapOpts = function(worldCopyJump = FALSE, ...){
    if(krmap == "naver"){
    	params$mapOpts <<- list(..., 
			    crs = "L.Proj.CRS.TMS.Naver",
			    worldCopyJump = worldCopyJump, 
                            continuousWorld = TRUE,
                            zoomControl = TRUE)
    } else if(krmap == "vworld") {
    	params$mapOpts <<- list(..., 
			    #crs = "L.Proj.CRS.TMS.VWorld",
			    worldCopyJump = worldCopyJump, 
                            continuousWorld = TRUE,
                            zoomControl = TRUE)
    } else {
    	params$mapOpts <<- list(..., 
			    crs = "L.Proj.CRS.TMS.Daum",
			    worldCopyJump = worldCopyJump, 
                            continuousWorld = TRUE,
                            zoomControl = TRUE)
    }
    
  },
  fullScreen = function(e = TRUE){
    params$addons$fullscreen <<- e
  },
  setView = function(center=c(37.566429, 126.977997), zoom = 9, ...){
    #params <<- c(params, list(center = center, zoom = zoom))
    params$center <<- center
    params$zoom <<- zoom
  },
  tileLayer = function(urlTemplate, provider = NULL, ...){
    if (!is.null(provider)){
      params$provider <<- provider
    } else {
      params$urlTemplate <<- urlTemplate
      params$layerOpts <<- list(..., 
        attribution =  'Map data<a href="http://openstreetmap.org">OpenStreetMap</a>
         contributors, Imagery<a href="http://mapbox.com">MapBox</a>'
      )
    }
  },
  marker = function(LatLng, ...){
    m = list(
      marker = as.list(LatLng),
      addTo = '#! map !#',
      ...
    )
    params$marker <<- c(params$marker, list(m))
  },
  circle = function(LatLng, radius = 500, ...){
    circle_ = list(
      circle = LatLng,
      setRadius = radius,
      ...,
      addTo = '#! map !#'
    )
    params$circle <<- c(params$circle, list(circle_))
  },
  circle2 = function(circleData){
    require(plyr)
    dat = alply(circleData, 1, function(c){
      list(
        center = list(c$lat, c$lng), 
        radius = c$radius, 
        opts = c[!(names(c) %in% c('lat', 'lng', 'radius'))])
    })
    params$circle2 <<- setNames(dat, nm = NULL)
  },
  geocsv = function(data){
    paste2 = function(...) {paste(..., sep = ';')}
    params$addons$geocsv <<- TRUE
    params$geocsv <<- list(
      titles = names(data),
      data = paste(do.call('paste2', data), collapse = '\n')
    )
  },
  geoJson = function(list_, ...){
    params$addons$geoJson <<- TRUE
    params$features <<- list_
    dotlist = list(...)
    if (length(dotlist) > 0){
      params$geoJson <<- list(...)
    } else {
      params$geoJson <<- FALSE
    }
  },
  addKML = function(kmlFile){
    params$addons$kml <<- TRUE
    params$kml <<- kmlFile
  },
  legend = function(position, colors, labels){
    params$addons$legend <<- TRUE
    params$legend <<- list(position = position, colors = colors, labels = labels)
  },
  getPayload = function(chartId){
    skip = c('marker', 'circle', 'addons', 'geoJson', 'kml')
    geoJson = toJSON2(params$geoJson)
    kml = toJSON2(params$kml)
    #params2 <<- params 
    params$marker <<- lapply(params$marker, function(n) c(list(marker=lapply(n$marker, function(m) formatC(m, format = "fg", digits = 10))), 
                                                           n[which(names(n) !="marker")] ))
    #params3 <<- params
    marker = paste(lapply(params$marker, toChain, obj =  'L'), collapse = '\n')
    # circle = paste(lapply(params$circle, toChain, obj =  'L'), collapse = '\n')
    circle = toChain(params$circle, obj = 'L')

    toJSONcrs <- function(params, ...){
      #print(params$center)
      #print(params$zoom)
      if(is.null(params$center)){
      	params$center <<- c(37.566429, 126.977997)
      }
      if(is.null(params$zoom)){
      	params$zoom <<- 10
      }
      x <- RJSONIO:::toJSON(params, ...)
      ind <- regexpr("\"crs\":", x)
      if(ind[1] >= 0){
        ind2 <- gregexpr("\"", x)[[1]]
        ind2 <- ind2[ind2 > (ind+4)][1:2]
        x <- gsub(substring(x, ind2[1], ind2[2]), 
                 substring(x, ind2[1]+1, ind2[2]-1),
                 x)
      }
      return(x)
    }

    chartParams = toJSONcrs(params[!(names(params) %in% skip)], digits = 13)
    list(
      chartParams = chartParams, 
      chartId = chartId, 
      lib = basename(lib),
      marker = marker,
      circle = circle,
      addons = params$addons,
      geoJson = geoJson,
      kml = kml
    )
  }
))

rqMap <- function(location = "montreal", ...){
  myMap = Leaflet$new()
  myMap$setView(c(LngLat$lat, LngLat$lon), ...)
  return(myMap)
}

Datamaps = setRefClass('Datamaps', contains = 'rMapskr', methods = list(
  getPayload = function(chartId){
    params_ = params[!(names(params) %in% "popup_template")]
    list(
      chartParams = toJSON(params_), 
      chartId = chartId, lib = basename(lib),
      popup_template = params$popup_template
    )
  }  
))

choropleth <- function(x, data, pal, map = 'usa', ...){
  fml = lattice::latticeParseFormula(x, data = data)
  data = transform(data, fillKey = fml$left)
  mypal = RColorBrewer::brewer.pal(length(unique(fml$left)), pal)
  d <- Datamaps$new()
  d$set(
    scope = map,
    fills = as.list(setNames(mypal, unique(fml$left))),
    data = dlply(data, fml$right.name),
    ...
  )
  return(d)
}

makeChoroData <- function(x, data, pal, map = 'usa'){
  fml = lattice::latticeParseFormula(x, data = data)
  if (!is.null(fml$condition)){
    data = dlply(data, names(fml$condition))
  }
  return(data)
}

processChoroData <- function(x, data, pal, map = 'usa', ...){
  fml = lattice::latticeParseFormula(x, data = data)
  data = transform(data, fillKey = fml$left)
  mypal = RColorBrewer::brewer.pal(length(unique(fml$left)), pal)
  list(
   scope = map,
   fills = as.list(setNames(mypal, unique(fml$left))),
   data = dlply(data, fml$right.name),
   ...
  )
}

choropleth2 <- function(x, data, pal, map = 'usa', ...){
  data1 = makeChoroData(x, data, pal, map, ...)
  data2 = llply(data1, processChoroData, x = x, pal, map, ...)
  d <- Datamaps$new()
  d$setTemplate(
    script =  system.file('libraries', 'datamaps', 'layouts', 
      'chart2.html', package = 'rMapskr')  
  )
  d$set(map = data2)
  return(d)
}


# data1 = makeChoroData(
#   cut(Adult_Obesity_Rate, 5, labels = F) ~ state | Mandates_BMI_Screening,
#   data = obesity,
#   pal = 'PuRd'
# )
# 
# data2 = llply(data1, processChoroData, 
#   x =cut(Adult_Obesity_Rate, 5, labels = F) ~ state | Mandates_BMI_Screening,
#   pal = 'PuRd', map = 'usa'
# )

