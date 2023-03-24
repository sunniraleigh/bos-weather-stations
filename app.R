# Load libraries
library(shiny)
library(tidyverse)
library(leaflet)

# Load data
stations_data <- read.csv(here::here("station-data.csv")) %>%
  mutate(
    NAME = str_extract(str_to_title(NAME), "^[^,]*"),
    DATE = as.Date(DATE, format = "%Y-%m-%d")
    )

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  selectInput("station_name", "Station Name", c("All", unique(stations_data$NAME))),
  sliderInput("date", "Date", 
              min = min(stations_data$DATE),
              max = max(stations_data$DATE),
              value = c(median(unique(stations_data$DATE)), median(unique(stations_data$DATE)))
              ),
  
  tableOutput("stations")
  # verbatimTextOutput("range")
  # tableOutput("slider_stations")
  
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  # Filtering data by station name
  # Changes the data being displayed but also changes the slider range
  new_data <- reactive({
    stations_data %>%
      filter(if(input$station_name != "All") (NAME == input$station_name) else TRUE)
  })
  
  observeEvent(new_data(),{
    min_val <- min(unique(new_data()$DATE))
    max_val <- max(unique(new_data()$DATE))
    mid_val <- median(unique(new_data()$DATE))
    
    if(input$station_name != "All"){
      updateSliderInput(inputId = "date",
                        min = min_val,
                        max = max_val,
                        value = c(min_val, max_val)
      )
    }else{
      updateSliderInput(inputId = "date",
                        min = min_val,
                        max = max_val,
                        value = c(mid_val, mid_val)
                        )
    }
    
  })

  # Filtering data by a date range (range value is influenced by the station name)
  # slider_data <- reactive(
  #   stations_data[
  #     stations_data$DATE >= input$date[1] &
  #       stations_data$DATE <= input$date[2],
  #   ] %>%
  #     mutate(DATE = as.character(DATE))
  # )
  
  # output$range <- renderPrint({ typeof(input$date[2]) })
  
  
  
  
  # 
  # observeEvent(new_data(), {
  #   updateSliderInput(inputId = "date", 
  #                     min = min(unique(new_data()$DATE)), 
  #                     max = max(unique(new_data()$DATE))
  #                     )
  # })
  # 
  output$stations <- renderTable(head(new_data()))
  
  # output$slider_stations <- renderTable(head(slider_data()))
}

# Run the application 
shinyApp(ui = ui, server = server)
