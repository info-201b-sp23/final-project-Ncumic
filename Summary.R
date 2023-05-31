##SUMMARY VALUES TO CALCULATE:

##1) Which Continent with most earthquakes?
continent_counts <- earthquake_data_modified %>%
  count(continent)

continent_counts

##2) What year had the most earthquakes?
earthquake_data_modified$Year <- as.integer(format(as.POSIXct(earthquake_data_modified$date, format = "%d-%m-%Y %H:%M"), "%Y"))

earthquakes_by_year <- earthquake_data_modified %>%
  group_by(Year) %>%
  summarise(Count = n()) %>%
  arrange(Count)

most_earthquakes_year <- earthquakes_by_year %>%
  filter(Count == max(Count)) %>%
  pull(Year)

##3) Number of earthquakes over the years(trend)
earthquake_data_modified$date <- as.Date(earthquake_data_modified$date, format = "%d-%m-%Y")
earthquake_data_modified$Year <- as.integer(format(earthquake_data_modified$date, "%Y"))

trend_data <- earthquake_data_modified %>%
  group_by(Year) %>%
  summarise(earthquakes = n())

ggplot(data = trend_data, aes(x = Year, y = earthquakes)) +
  geom_line() +
  geom_point() +
  labs(x = "Year", y = "Number of Earthquakes", title = "Trend of Earthquakes over the Years")

View(trend_data)

##4) Country with the most intense magnitudes of earthquakes

country_max_magnitude <- earthquake_data_modified %>%
  group_by(country) %>%
  summarise(max_magnitude = max(magnitude, na.rm = TRUE)) %>%
  arrange(max_magnitude) %>%
  last()

country_max_magnitude

#5) Which Country had the most accurate estimated of intensities?

earthquake_data_Accuracy <- select(earthquake_data, c("magnitude", "mmi", "country"))
earthquake_data_Accuracy <- earthquake_data_Accuracy[earthquake_data_Accuracy$country != "", , drop = FALSE]
earthquake_data_Accuracy$accuracy <- (1 - abs(earthquake_data_Accuracy$mmi - earthquake_data_Accuracy$magnitude) / earthquake_data_Accuracy$magnitude) * 100

CountryAccuracy <- earthquake_data_Accuracy %>%
  group_by(country) %>%
  summarize(avg_accuracy = mean(accuracy)) %>%
  arrange(desc(avg_accuracy))

CountryMostAccurate <- CountryAccuracy %>% head(1) %>% pull(country)

# TURN INTO A LIST OF VALUES
summary_info <- list()
summary_info$continent_counts <- earthquake_data_modified %>%
  count(continent)

summary_info$most_earthquakes_year <- earthquakes_by_year %>%
  filter(Count == max(Count)) %>%
  pull(Year)

summary_info$trend_data <- earthquake_data_modified %>%
  group_by(Year) %>%
  summarise(earthquakes = n())

summary_info$country_max_magnitude <- earthquake_data_modified %>%
  group_by(country) %>%
  summarise(max_magnitude = max(magnitude, na.rm = TRUE)) %>%
  arrange(max_magnitude) %>%
  last()

summary_info$CountryMostAccurate <- CountryAccuracy %>% head(1) %>% pull(country)