
### UI ###

ui <- fluidPage(title = "Animal Movement, Offshore Wind Development, and SST",
                
                leafletOutput("mymap", width = "100%", height = "850px"),
                
                absolutePanel(class = "panel panel-default",
                              top = 300,
                              left = 25,
                              width = 250,
                              fixed = TRUE,
                              draggable = TRUE,
                              height = "auto",
                              
                              h3("Choose which layers to map"),
                              pickerInput(inputId = "tracks",
                                          label = "Select tracks",
                                          choices = unique(tracks$id),
                                          selected = unique(tracks$id),
                                          multiple = TRUE),
                              pickerInput(inputId = "polygons",
                                          label = "Select polygons by state",
                                          choices = unique(wind$State),
                                          selected = unique(wind$State),
                                          multiple = TRUE),
                              selectInput(inputId = "raster",
                                          label = "Select month of SST",
                                          choices = month.name,
                                          selected = month.name[1]),
                              # actionButton(inputId = 'btn',
                              #              label = "Update map",
                              #              icon = icon("arrows-rotate"),
                              #              class = "btn-primary btn-lg")
                              input_task_button("btn", "Update map")
                              
                )  #close absolutePanel
                
)  #close fluidPage

