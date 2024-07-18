

## Example for running multi-file Shiny app
## Created 2024-07-08 by Josh Cullen (josh.cullen@noaa.gov)

library(tidyverse)
library(terra)
library(sf)
library(leaflet)  #v2.2.2 (CRAN)
library(leafem)  #v0.2.3.9006 (GitHub)
library(viridis)
library(shiny)
library(shinyWidgets)
library(bslib)

source("utils.R")  #for function addLegend_decreasing


### Load data ###

# Simulated tracks
tracks <- read.csv("../data/Simulated tracks.csv")
tracks.sf <- tracks %>%
  st_as_sf(., coords = c('x','y'), crs = 4326)
tracks.sf2 <- tracks.sf %>%
  group_by(id) %>%
  summarize(do_union = FALSE) %>%
  st_cast("MULTILINESTRING")

# Monthly SST (2021)
sst <- read.csv("../data/Monthly_SST_2021.csv")
sst.rast <- sst %>%
  split(~month) %>%
  purrr::map(., ~rast(.[,c('x','y','sst')], type = "xyz", crs = "EPSG:4326")) %>%
  rast()

# Offshore wind leases
wind <- st_read("../data/NE_Offshore_Wind.shp")
wind$State <- gsub(pattern = "Massachussets", "Massachusetts", wind$State)  #fix typo


# Define color palettes
tracks.pal <- colorFactor("Dark2", factor(tracks$id))
poly.pal <- colorFactor("Set3", factor(wind$State))

sst.range <- range(as.vector(values(sst.rast)), na.rm = TRUE)
rast.pal2 <- colorNumeric('magma',
                          domain = sst.range,
                          na.color = "transparent")





### Run this in console (or just press "Cmd/Ctrl + Shift + Return")

# runApp("spatial_example")
