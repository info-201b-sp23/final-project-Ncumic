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

# WE WILL ADD OUR INDIVIDUAL UI STUFF HERE




# MAIN UI TO CONNECT EVERYTHING
ui <- navbarPage(

)