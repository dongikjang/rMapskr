..p. <- function() invisible(readline("\nPress <return> to continue: "))
require(rMapsKR)

library(rMapskr)

map3 <- Leaflet$new(krmap="daum")
#map3$setView(c(37.56641861115186, 126.97787362769193), zoom = 11)
map3$marker(c(37.5545355, 126.9706773), bindPopup = "<p> Seoul Station </p>")
map3$marker(c(37.5666208, 126.9783823), bindPopup = "<p> City Hall of Seoul </p>")
map3
