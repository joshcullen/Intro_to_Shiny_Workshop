
### Server ###

server <- function(input, output, session) {
  
  #Create reactive objects based on selected input
  tracks.out <- reactive({
    tracks.sf2 %>%
      filter(id %in% input$tracks)
  })
  
  wind.out <- reactive({
    wind %>%
      filter(State %in% input$polygons)
  })
  
  sst.out <- reactive({
    sst.rast[[which(month.name == input$raster)]]
  })
  
  
  
  
  
  output$mymap <- renderLeaflet({
    
    
    ## Static Leaflet basemap and widgets
    leaflet() %>%
      setView(lng = -73, lat = 41.5, zoom = 6) %>%
      addProviderTiles(provider = providers$Esri.OceanBasemap, group = "Ocean Basemap") %>%
      addProviderTiles(provider = providers$Esri.WorldImagery, group = "World Imagery") %>%
      addProviderTiles(provider = providers$OpenStreetMap, group = "Open Street Map") %>%
      addLayersControl(baseGroups = c("Ocean Basemap", "World Imagery", "Open Street Map"),
                       overlayGroups = c("SST", "Offshore Wind Leases", "Tracks"),
                       options = layersControlOptions(collapsed = TRUE, autoZIndex = TRUE),
                       position = "bottomleft") %>%
      addScaleBar(position = "bottomright") %>%
      addMeasure(position = "topleft",
                 primaryLengthUnit = "kilometers",
                 primaryAreaUnit = "hectares",
                 activeColor = "#3D535D",
                 completedColor = "#7D4479") %>%
      addMouseCoordinates()
    
  })  #close renderLeaflet
  
  
  
  ## Add reactive elements to Leaflet map
  observeEvent(input$btn, {
    
    leafletProxy(mapId = "mymap") %>%
      clearMarkers() %>%
      clearShapes() %>%
      clearImages() %>%
      clearControls() %>%
      addRasterImage(x = sst.out(),
                     colors = rast.pal2,
                     opacity = 1,
                     group = "SST") %>%
      addImageQuery(sst.out(), group = "SST") %>%  #add raster  query
      addLegend_decreasing(pal = rast.pal2,
                           values = as.vector(values(sst.rast)),
                           title = "SST (\u00B0C)",
                           decreasing = TRUE) %>%
      addPolygons(data = wind.out(),
                  color = ~poly.pal(State),
                  fillOpacity = 1,
                  stroke = FALSE,
                  label = ~paste0("State: ", State),
                  group = "Offshore Wind Leases") %>%
      addLegend(pal = poly.pal,
                values = wind.out()$State,
                title = "State",
                opacity = 1) %>%
      addPolylines(data = tracks.out(),
                   color = ~tracks.pal(id),
                   opacity = 0.75,
                   weight = 2,
                   label = ~paste0("ID: ", id),
                   group = "Tracks") %>%
      addLegend(pal = tracks.pal,
                values = tracks.out()$id,
                title = "ID",
                position = "topleft")
    
  })  #close observe
  
}  #close server function
