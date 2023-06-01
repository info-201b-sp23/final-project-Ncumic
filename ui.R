library(shiny)
library(ggplot2)
library(plotly)
library(dplyr)
library(bslib)
library(rsconnect)
library(maps)

earthquake_data <- read.csv('https://raw.githubusercontent.com/info-201b-sp23/exploratory-analysis-Ncumic/main/earthquake_data.csv')
earthquake_data_modified <- select(earthquake_data, -c("title","net", "nst", "dmin", "gap", "magType", "depth"))
source("Summary.R")
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

INTRO_Tab <- tabPanel("INTRODUCTION",
                      h2("Overview"),
                      p("This app explores the fascinating realm of worldwide earthquakes, aiming to uncover patterns, extract insights, and gain a deeper understanding of these seismic events that shape our planet. By analyzing a dataset spanning multiple regions and time periods, we embark on a journey to explore the nature of earthquakes and their impact on our world."),
                      
                      h2("Main Questions"),
                      p("In the project, our main purpose is to determine the countries with the highest accuracy of estimating intensities of earthquakes, the continents or areas with the highest probabilities of getting tsunamis due to earthquakes, and the continents with the most intense magnitudes. These questions are crucial because understanding these patterns is crucial for disaster preparedness and risk assessment. To make the results more intuitive, we’ve built 3 interactive visualizations. "),
                      
                      h2("Data"),
                      p("The dataset employed in this project consists of a comprehensive collection of worldwide earthquakes. The data was published by Chirag Chauhan, an interventional cardiologist at Denver Heart and Rose Medical Center. The data was collected through seismic sensors near/at the locations of earthquakes from all around the world. The data is a massive collaboration between seismic stations around the world by having their data gathered and shared in one location.
                        It provides an extensive record of seismic events across different regions and time periods. The dataset's appropriateness stems from its relevance to the study of earthquakes, enabling us to gain valuable insights into their characteristics, patterns, and impact on a global scale."),
                      
                      h4("Data Link"),
                      p("https://www.kaggle.com/datasets/warcoder/earthquake-dataset"),
                      
                      h2("Ethical Questions and Limitations"),
                      p("The earthquake dataset from Kaggle has the following problems and limitations such as limited coverage, incomplete data, and potential data quality issues. There are some features missing in the dataset, and the dataset only includes the earthquakes that happened from 2001 to 2023. This implies the data can not represent the earthquakes that happen in all regions. Furthermore, this dataset is collected from multiple sources, which may be collected through different methods and standards. Thus, the data may lead to inconsistencies and issues. "),
                      p("One another main limitation is that the accuracy of earthquake data can be affected by the changes of monitoring technology and techniques over time. As the newest methods for detecting and measuring earthquakes are developed, the historical data may become less accurate and reliable compared to the more recent data."),
                      p("To minimize the impact of these restrictions, we cleaned up the dataset before doing the visualizations. All the NA values are removed to ensure the accuracy of the results to the utmost extent. "),
)

# BONIE_SECTION

Bonie_TAB <- tabPanel(
  "Accuracy VIZ",
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "country1", 
                  label = "Select the first country:", 
                  choices = unique(CountryAccuracy$country)),
      selectInput(inputId = "country2", 
                  label = "Select the second country:", 
                  choices = unique(CountryAccuracy$country))
    ),
    mainPanel(
      plotlyOutput("BonieChart"),
      br(),
      HTML("<h5><strong>Chart Description: </strong></h5>"),
      p("This interactive chart displays the accuracy of the estimation made by different countries on the earthquake magnitude from 2001 to 2020"),
      p("It shows patterns including variations in accuracy among countries, shifts in accuracy over time, and individual country trends. Specific 
        details of the chart would provide more insights into these patterns.")
    )
  )
)

# BRIAN SECTION
eq_df <- read.csv("https://raw.githubusercontent.com/info-201b-sp23/exploratory-analysis-Ncumic/main/earthquake_data.csv", 
                  stringsAsFactors = FALSE)

# Define UI
ui <- fluidPage(
  titlePanel("Earthquakes and Tsunamis"),
  sidebarLayout(
    sidebarPanel(
      selectInput("country", "Select a Country:", choices = unique(eq_df$country))
    ),
    mainPanel(
      plotOutput("plot")
    )
  )
)

# Define server
server <- function(input, output) {
  output$plot <- renderPlot({
    world_shape <- map_data("world")
    
    filtered_eq_df <- filter(eq_df, country == input$country)
    
    eq_mapping_df <- left_join(world_shape, filtered_eq_df, by = c("long" = "longitude", "lat" = "latitude"))
    
    world_plot <- ggplot(data = world_shape) +
      geom_polygon(aes(x = long, y = lat, group = group)) +
      geom_point(data = filter(filtered_eq_df, tsunami == 0), aes(x = longitude, y = latitude, color = "Non-Tsunami"), size = 2) +
      geom_point(data = filter(filtered_eq_df, tsunami == 1), aes(x = longitude, y = latitude, color = "Tsunami"), size = 2) +
      labs(title = paste("Earthquakes That Caused Tsunamis in", input$country), x = "Longitude", y = "Latitude") +
      scale_color_manual(values = c("Non-Tsunami" = "blue", "Tsunami" = "red"), 
                         labels = c("Non-Tsunami", "Tsunami"),
                         name = "Tsunami")
    
    print(world_plot)
  })
}

# MAIN UI TO CONNECT EVERYTHING
ui <- navbarPage(
  theme = Viz_theme,
  titlePanel(Title),
  INTRO_Tab,
  NIKOLA_TAB,
  Bonie_TAB,
  SUMMARY_Tab
)