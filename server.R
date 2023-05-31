library("lubridate")
library(shiny)
library(ggplot2)
library(plotly)
library(dplyr)
library(bslib)
library(rsconnect)

# UPDATED TABLE CODE
earthquake_data <- read.csv('https://raw.githubusercontent.com/info-201b-sp23/exploratory-analysis-Ncumic/main/earthquake_data.csv')
earthquake_data_modified <- select(earthquake_data, -c("title","net", "nst", "dmin", "gap", "magType", "depth"))

# ADD SUMMARY VALUES HERE
source("Summary.R")



server <- function(input, output) {
  # NIKOLA SECTION

  # ADD PART THAT CHANGES DATAFRAME TO ONLY HOLD WANTED MAGNITUDES
  world_data_shape <- map_data("world")


  output$Nikola_Plot <- renderPlotly({


    earthquake_data_modified <- earthquake_data_modified %>% filter(magnitude >= input$Variables[1] & magnitude <= input$Variables[2])


    Earthquake_plot <- ggplot(data = world_data_shape) +
      geom_polygon(aes(x = long,
                       y = lat,
                       group = group)) +
      geom_point(data = earthquake_data_modified,
                 aes(x = longitude, y = latitude,
                     size = magnitude),
                 color = "Red",
                 shape = 21
      ) + labs(title = "Earthquake locations & respective magnitudes",
               x = "Longitude",
               y = "Latitude"
    )
    return(Earthquake_plot)
  })
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  #Bonie SECTION
  
  
  earthquake_data_modified$Year <- as.integer(format(as.POSIXct(earthquake_data_modified$date, format = "%d-%m-%Y %H:%M"), "%Y"))
  


}