# Load libraries
library(shiny)
library(tidyverse)
library(leaflet)
library(shinydashboard)

# Load data
stations <- read.csv(here::here("station-data.csv"))

# Define UI for application that draws a histogram
ui <- dashboardPage(
    leafletOutput("stations")
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    output$stations <- renderLeaflet({
            leaflet() %>%
            addTiles()
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
