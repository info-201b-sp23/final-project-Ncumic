library(shiny)
library(ggplot2)
library(plotly)
library(dplyr)
library(bslib)
library(rsconnect)

earthquake_data <- read.csv('https://raw.githubusercontent.com/info-201b-sp23/exploratory-analysis-Ncumic/main/earthquake_data.csv')
earthquake_data_modified <- select(earthquake_data, -c("title","net", "nst", "dmin", "gap", "magType", "depth"))

earthquake_data_modified$Year <- as.integer(format(as.POSIXct(earthquake_data_modified$date, format = "%d-%m-%Y %H:%M"), "%Y"))
# DEFAULT THEME WE CAN USE
Viz_theme <- bs_theme(
  bg = "#0b3d91", # background color
  fg = "white", # foreground color
  primary = "#FCC780", # primary color
)
# Update BootSwatch Theme
Viz_theme <- bs_theme_update(Viz_theme, bootswatch = "journal")

Title <- h1("Earthquake Data Work", align = "center")
# WE WILL ADD OUR INDIVIDUAL UI STUFF HERE

# NIKOLA_SECTION
Nikola_Plot_Description <- p("WORLD MAP OF MAGINTUDES AROUND THE EARTH")

Nikola_Plot <- mainPanel(
  # Make plot interactive
  plotlyOutput(outputId = "Nikola_Plot")
)

NIKOLA_TAB <- tabPanel("Data Viz",
                       sidebarLayout(
                         sidebarPanel(
                           # ADD WIDGET HERE

                           Nikola_Plot_Description
                           # can add more
                         ),
                         Nikola_Plot
                       )
)

summary_Tab <- tabPanel("Data Summary",
                        p("hello")


)














# BONIE_SECTION

Bonie_TAB <- tabPanel(
  "Bonie's Visual",
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "country1", 
                  label = "Select the first country:", 
                  choices = unique(earthquake_data_modified$country)),
      selectInput(inputId = "country2", 
                  label = "Select the second country:", 
                  choices = unique(earthquake_data_modified$country)),
      sliderInput(inputId = "year_range", 
                  label = "Select a year range:", 
                  min = 2000, 
                  max = 2020, 
                  value = c(2000, 2020))
    ),
    mainPanel(
      
    )
  )
  
  
  
  
  
  
  
)
# MAIN UI TO CONNECT EVERYTHING
ui <- navbarPage(
  theme = Viz_theme,
  titlePanel(Title),
  summary_Tab,
  NIKOLA_TAB,
  Bonie_TAB
)