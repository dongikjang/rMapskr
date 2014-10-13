# `rMapskr`

`rMapskr`r is an R package to create, customize and publish interactive South Korea maps(Daum Map, Naver Map and VWorld Map) visualizations from R using a familiar lattice style plotting interface. `rMapskr` is modification version  of package rCharts.  
This package is under developement. 

## Installation

You can install `rMapskr` from `github` using the `devtools` package

```coffee
require(devtools)
install_github('dongikjang/rMapskr')
```


### Create

`rMapskr` uses a formula interface to specify plots, just like the `lattice` package. Here are a few examples you can try out in your R console.

```coffee
require(rMapskr)

map3 <- Leaflet$new()
map3$setView(c(51.505, -0.09), zoom = 13)
map3$marker(c(51.5, -0.09), bindPopup = "<p> Hi. I am a popup </p>")
map3$marker(c(51.495, -0.083), bindPopup = "<p> Hi. I am another popup </p>")
map3
```

![leaflet](screenshots/leaflet.png)

