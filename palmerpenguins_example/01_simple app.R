

## Simple Shiny app example (taken from https://rstudio.github.io/bslib/articles/dashboards/index.html#hello-dashboards)
## Created 2024-07-08 by Josh Cullen (josh.cullen@noaa.gov)

library(palmerpenguins)
library(ggplot2)
library(shiny)
library(bslib)


# Define UI
ui <- page_sidebar(
  title = "Penguins dashboard",
  
  # Define sidebar inputs
  sidebar = sidebar(
    title = "Histogram controls",
    
    #create dropdown selection for numeric columns
    varSelectInput(
      inputId = "var",
      label = "Select variable",
      data = dplyr::select_if(penguins, is.numeric)
    ),
    
    #create slider input for histogram
    sliderInput("bins", "Number of bins", min = 3, max = 100, value = 30, step = 1)
  ),  #close sidebar
  
  # Main panel content
  card(
    card_header("Histogram"),
    plotOutput("hist")
  )
)



# Define server
server <- function(input, output, session) {
  
  # Create histogram based on selection from inputs
  output$hist <- renderPlot({
    ggplot(penguins) +
      geom_histogram(aes(!!input$var), bins = input$bins) +
      theme_bw(base_size = 20)
  })
  
}


# Run app
shinyApp(ui, server)
