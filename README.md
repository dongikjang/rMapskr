# rMapskr

`rMapskr`r is an R package to create, customize and publish interactive South Korea maps (Daum Map, Naver Map and VWorld Map) visualizations from R using a familiar lattice style plotting interface. `rMapskr` is modification version  of package rCharts.  
This package is under developement. 

## Installation

You can install `rMapskr` from `github` using the `devtools` package

```coffee
require(devtools)
install_github('dongikjang/rMapskr')
```


## Create

`rMapskr` uses a formula interface to specify plots, just like the `lattice` package. Here are a few examples you can try out in your R console.

### Daum Map

```coffee
require(rMapskr)

map3 <- Leaflet$new("daum")
#map3$setView(c(37.56641861115186, 126.97787362769193), zoom = 11)
map3$marker(c(37.5545355, 126.9706773), bindPopup = "<p> Seoul Station </p>")
map3$marker(c(37.5666208, 126.9783823), bindPopup = "<p> City Hall of Seoul </p>")
map3
```

### Naver Map

```coffee
require(rMapskr)

map3 <- Leaflet$new("naver")
#map3$setView(c(37.56641861115186, 126.97787362769193), zoom = 11)
map3$marker(c(37.5545355, 126.9706773), bindPopup = "<p> Seoul Station </p>")
map3$marker(c(37.5666208, 126.9783823), bindPopup = "<p> City Hall of Seoul </p>")
map3
```


### Vworld Map

```coffee
require(rMapskr)

map3 <- Leaflet$new("vworld")
#map3$setView(c(37.56641861115186, 126.97787362769193), zoom = 11)
map3$marker(c(37.5545355, 126.9706773), bindPopup = "<p> Seoul Station </p>")
map3$marker(c(37.5666208, 126.9783823), bindPopup = "<p> City Hall of Seoul </p>")
map3
```


![leaflet](screenshots/leaflet.png)

#### Demo
See <https://github.com/dongikjang/rMapskr>


This work was inspired from <http://ramnathv.github.io/rCharts/>, <https://github.com/tontita/Leaflet.KoreanTmsProviders>, <http://plugins.qgis.org/plugins/tmsforkorea>, <https://github.com/leaflet-extras/leaflet-providers>, and <https://github.com/kartena/Proj4Leaflet>.
