install.packages('RSocrata')
install.packages('sf')
install.packages('tidyverse')
install.packages('RANN')
install.packages('mapproj')
install.packages('hexbin')



## create maps in R according to MUSA class

library(RSocrata)
library(ggplot2)
library(sf)
library(tidyverse)
library(RANN)
library(hexbin)
library(mapproj)

setwd('C:/Users/151268/Documents/R_work/myrepo/masterclass')

accident_url<- "https://data.cityofchicago.org/Transportation/Traffic-Crashes-Crashes/85ca-t3if"

accident_in <- read.socrata(accident_url)

### view head
head(accident_in)

unique(accident_in$prim_contributory_cause)

### examine data related to poor driving skills
bad_drive <- accident_in[accident_in$prim_contributory_cause == "DRIVING SKILLS/KNOWLEDGE/EXPERIENCE",]

# Only want to use complete rows
bad_drive <- bad_drive[complete.cases(bad_drive),]


# convert bad_drive from a dataframe into a spatial object. The coordinates are in wgs84.
# R has a lot of spatial packages, we will switch to tidyverse with the 'sf' package

# convert dataframe into sf (simple feature) object
bad_drive_sf <- st_as_sf(bad_drive, coords = c('longitude', 'latitude'))

# specify CFS to EPSG code of 4326 which is WGS84
bad_drive_sf <- st_set_crs(bad_drive_sf, 4326)

# See how this turned out by plotting the geometry element of bad_drive_sf
plot(bad_drive_sf$geometry, col='grey')

### Manually import major streets feature as RSocrata can't read zip files
roads <- read_sf("Major_Streets.shp")

# simplify roads to 1km
roads <- st_simplify(roads, 1000)

# plot roads
plot(roads$geometry)
#overlay accident data
plot(bad_drive_sf$geometry, col='yellow', add=T, pch=16) #this actually didn't work

## Need to set CRS of accidents to match roads
st_crs(roads) #this finds the CRS of roads currently
bad_drive_sf<- st_transform(bad_drive_sf,st_crs(roads)$proj4string)

st_crs(bad_drive_sf)


## Now use ggplot2 to explore different approaches to plotting the data using ggplot2

# create a simple point map using ggplot2 #at 1hr 20min
bad_drive_sf %>%
  st_coordinates %>%
  











































