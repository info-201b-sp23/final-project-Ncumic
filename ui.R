library(shiny)
library(ggplot2)
library(plotly)
library(dplyr)
library(bslib)
library(rsconnect)

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




# MAIN UI TO CONNECT EVERYTHING
ui <- navbarPage(
  theme = Viz_theme,
  titlePanel(Title),
  NIKOLA_TAB

)