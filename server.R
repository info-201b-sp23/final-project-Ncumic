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
  world_earthquake_table <- left_join(world_data_shape, earthquake_data_modified, by = c("long" = "longitude", "lat" = "latitude"))

  output$Nikola_Plot <- renderPlotly({

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



}