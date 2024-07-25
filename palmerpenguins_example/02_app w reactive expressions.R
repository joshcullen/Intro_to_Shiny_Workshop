

## Shiny app with multiple components (i.e., plot, table, text)
## Created 2024-07-08 by Josh Cullen (josh.cullen@noaa.gov)

library(palmerpenguins)
library(ggplot2)
library(dplyr)
library(DT)
library(shiny)
library(bslib)


# Define UI
ui <- page_sidebar(
  title = "Penguins dashboard",
  
  # Define sidebar inputs
  sidebar = sidebar(
    title = "Inputs",
    
    # Filter data by species
    selectInput(
      inputId = "species",
      label = "Filter by species",
      choices = unique(penguins$species)
    ),
    
    #create dropdown selection for numeric columns
    varSelectInput(
      inputId = "var",
      label = "Select variable",
      data = dplyr::select_if(penguins, is.numeric)
    ),
  ),  #close sidebar
  
  # Main panel content
  layout_columns(
    col_widths = c(12, 8, 4),
    row_heights = c(1, 1.5),
    
    # Density plot
    card(
      card_header("Density Plot"),
      plotOutput("dens"),
      full_screen = TRUE
    ),
    
    # Table
    card(
      card_header("Data Table"),
      DT::dataTableOutput("tbl"),
      full_screen = TRUE
    ),
    
    # Text
    card(
      card_header("Summary"),
      verbatimTextOutput("txt"),
      full_screen = TRUE
    )
  )
)



# Define server
server <- function(input, output, session) {
  
  penguins_react <- reactive({
    penguins |> 
      filter(species == input$species)
  })
  
  # Create density plot based on selection from inputs
  output$dens <- renderPlot({
    ggplot(penguins_react()) +
      geom_density(aes(!!input$var, fill = island), alpha = 0.6) +
      scale_fill_brewer("Island", palette = "Set1") +
      theme_bw(base_size = 20)
  })
  
  
  # Create interactive table via {reactable}
  output$tbl <- DT::renderDataTable({
    datatable(
      data = penguins_react()
    )
  })
  
  
  # Summarize penguins dataset for text
  output$txt <- renderPrint({
    penguins |> 
      group_by(species, island) |> 
      count()
  })
  
  
  
}


# Run app
shinyApp(ui, server)
