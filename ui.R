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
Nikola_Plot_Description <- p("This is a world map of all magnitudes of earthquakes and their location. It helps people understand
                              where a majority of earthquakes take place and where certain magnitudes are more commen then others. This can help dispel
                              fear related to earthquakes while keeping people informed of the dangers.")

Nikola_Widget <- sliderInput(inputId = "Variables",
                             label = h3("Magnitude Range"),
                             min = 6,
                             max = 9.5,
                             step = 0.1,
                             value = c(6,6.5)
)

Nikola_Plot <- mainPanel(
  # Make plot interactive
  plotlyOutput(outputId = "Nikola_Plot")
)

NIKOLA_TAB <- tabPanel("Magnitude VIZ",
                       sidebarLayout(
                         sidebarPanel(
                           # ADD WIDGET HERE
                           Nikola_Widget,
                           Nikola_Plot_Description
                         ),
                         Nikola_Plot
                       )
)

SUMMARY_Tab <- tabPanel("Data Summary",
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
  NIKOLA_TAB,
  Bonie_TAB,
  SUMMARY_Tab
)