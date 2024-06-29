# Cyclistic Data Analysis Case Study
## Methodology : The analysis will follow the standard data analysis process: Ask, Prepare, Process, Analyze, Share, and Act.

## Importing Necessary Library
library(tidyverse)
library(gridExtra)

## Loading Datasets
setwd("C:/Users/Harsh/OneDrive/Desktop/Case Study/case1 _ R")
data_2019 <- read_csv("Divvy_Trips_2019_Q1.csv")
data_2020 <- read_csv("Divvy_Trips_2020_Q1.csv")

## Exploring Datasets 
head(data_2019)
head(data_2020)
 #unique values
unique_counts19 <- sapply(data_2019, function(x) length(unique(x)))
print(unique_counts19)
unique_counts20 <- sapply(data_2020, function(x) length(unique(x)))
print(unique_counts20)
  #Data Types
data_types19 <- sapply(data_2019, class)
print(data_types19)
data_types20 <- sapply(data_2020, class)
print(data_types20)

## Pre-Processing
### Standardizing both the datasets
  # Data_2019
    # Rename , Mutate, Correcting datatype & dropping irrelevant Columns
data_2019 <- data_2019 %>%
  rename(
    ride_id = trip_id,
    started_at = start_time,
    ended_at = end_time,
    start_station_name = from_station_name,
    start_station_id = from_station_id,
    end_station_name = to_station_name,
    end_station_id = to_station_id
  )
data_2019 <- data_2019 %>%
  mutate(
    usertype = ifelse(usertype == "Subscriber", "member",
                      ifelse(usertype == "Customer", "casual", usertype))
  )
data_2019$ride_id <- as.character(data_2019$ride_id)
data_2019 <- data_2019 %>%
  select(-bikeid, -gender, -birthyear)

  # Data_2020
    # Rename, Feature Engineering , Dropping Irrelevant Columns & Reordering Columns
data_2020 <- data_2020 %>%
  rename(
    usertype = member_casual
  )
data_2020 <- data_2020 %>%
  mutate(
    tripduration = as.numeric(difftime(ended_at, started_at, units = "secs"))
  )
data_2020 <- data_2020 %>%
  select(-rideable_type, -start_lat, -start_lng, -end_lat, -end_lng)
data_2020<- data_2020 %>% select(ride_id, started_at, ended_at,	tripduration,	start_station_id,	start_station_name,	end_station_id,	end_station_name,	usertype)

## Combining Dataset
data <- bind_rows(data_2019, data_2020)

## Exploring Combined Data 
head(data) #verifying
str(data)
unique_counts <- sapply(data, function(x) length(unique(x)))
print(unique_counts)

## Data Pre-Processing of Combined Data
  # Handling Missing Values
print(colSums(is.na(data)))
data <- na.omit(data)
print(colSums(is.na(data))) #verifying
  
  # Feature Engineering
data <- data %>%
  mutate(tripduration= difftime(ended_at, started_at, units = "secs"))

data <- data %>%
  mutate(day_of_week = wday(started_at, label = TRUE),
         hour = hour(started_at),
         month = month(started_at),
         year = year(started_at))

data <- data %>%
  mutate(month_name = month.name[month])

hour_bins <- c(0, 6, 12, 18, 24)
hour_labelsCat <- c("0-6 hrs", "6-12 hrs", "12-18 hrs", "18-24 hrs")
hour_labels <- c("Night", "Morning", "Afternoon", "Evening")
data <- data %>%
  mutate(time_category = cut(hour, breaks = hour_bins, labels = hour_labels, include.lowest = TRUE),
         hour_category = cut(hour, breaks = hour_bins, labels = hour_labelsCat, right = FALSE))

data <- data %>%
  mutate(day_type = ifelse(wday(started_at) %in% c(1, 7), "Weekend", "Weekday"))

data <- data %>%
  mutate(tripduration_minutes = as.numeric(tripduration) / 60)

  # Droping Unnecessary Columns
data <- data %>%
  select(-hour, -month)

# Checking Datatypes
str(data)

## Exploratory Data Analysis (EDA)
  # User Type Analysis
    # Count Plot for Casual and Member Users
ggplot(data, aes(x = usertype, fill = usertype)) +
  geom_bar() +
  geom_text(
    stat = "count",
    aes(label = after_stat(count)),
    position = position_stack(vjust = 0.5),
    size = 3
  ) +
  labs(x = "User Type", y = "Count", title = "Count of User Types") +
  theme_minimal()

  # Station Analysis
    # Top 10 Start Stations
top_10_start <- data %>%
  group_by(start_station_name) %>%
  summarize(ride_count = n()) %>%
  top_n(10, ride_count) %>%
  arrange(desc(ride_count))

plot_start <- ggplot(top_10_start, aes(x = reorder(start_station_name, ride_count), y = ride_count, fill = start_station_name)) +
  geom_bar(stat = "identity") +
  labs(x = "Start Station", y = "Number of Rides", title = "Top 10 Start Stations by Ride Count") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  scale_fill_viridis_d(option = "plasma") +
  coord_flip()

print(plot_start)

    # Top 10 End Stations
top_10_end <- data %>%
  group_by(end_station_name) %>%
  summarize(ride_count = n()) %>%
  top_n(10, ride_count) %>%
  arrange(desc(ride_count))

plot_end <- ggplot(top_10_end, aes(x = reorder(end_station_name, ride_count), y = ride_count, fill = end_station_name)) +
  geom_bar(stat = "identity") +
  labs(x = "End Station", y = "Number of Rides", title = "Top 10 End Stations by Ride Count") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  scale_fill_viridis_d(option = "plasma") +
  coord_flip()

print(plot_end)

  # Behavioural Analysis
    # Day of the Week Ride Couts by User Type
day_counts <- data %>%
  group_by(day_of_week, usertype) %>%
  summarise(count = n(), .groups = "drop") %>%
  arrange(match(day_of_week, c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday")), usertype)

ggplot(day_counts, aes(x = day_of_week, y = count, fill = usertype)) +
  geom_bar(stat = 'identity', position = 'dodge') +
  geom_text(aes(label = count), position = position_dodge(width = 0.9), vjust = -0.5, size = 3, color = "black") +  # Add this geom_text layer
  labs(x = 'Day of the Week', y = 'Count', title = 'Ride Counts by User Type and Day of the Week') +
  scale_x_discrete(labels = c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday")) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

  # Temporal Analysis
    # Monthly Ride Counts by User Type
monthly_counts <- data %>%
  group_by(month_name, usertype) %>%
  summarise(count = n(), .groups = "drop") %>%
  arrange(match(month_name, month.name), usertype)

ggplot(monthly_counts, aes(x = month_name, y = count, fill = usertype)) +
  geom_bar(stat = 'identity', position = 'dodge') +
  geom_text(aes(label = count), position = position_dodge(width = 0.9), vjust = -0.5) +  # Add this geom_text layer
  labs(x = 'Month', y = 'Count', title = 'Monthly Ride Counts by User Type') +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

    # Time of Day Counts by User Type
hourly_counts <- data %>%
  group_by(time_category, usertype) %>%
  summarise(count = n(), .groups = "drop") %>%
  arrange(match(time_category, c("Night", "Morning", "Afternoon", "Evening")), usertype)

ggplot(hourly_counts, aes(x = time_category, y = count, fill = usertype)) +
  geom_bar(stat = 'identity', position = 'dodge') +
  geom_text(aes(label = count), position = position_dodge(width = 0.9), vjust = -0.5, size = 3, color = "black") +  # Add this geom_text layer
  labs(x = 'Time of Day', y = 'Count', title = 'Ride Counts by User Type and Time of Day') +
  scale_x_discrete(labels = c("Night", "Morning", "Afternoon", "Evening")) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
    
    # Ride Count by Hour and Day for Casual Users
casual_data <- data %>%
  filter(usertype == "casual")

hourly_counts <- casual_data %>%
  group_by(hour_category, day_of_week) %>%
  summarise(count = n(), .groups = "drop") %>%
  arrange(hour_category)

ggplot(hourly_counts, aes(x = hour_category, y = day_of_week, fill = count)) +
  geom_tile() +
  labs(x = "Hour of the Day", y = "Day of the Week",
       title = "Heatmap of Ride Counts by Hour and Day for Casual Users") +
  scale_fill_gradient(low = "lightblue", high = "darkblue") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

    # Ride Counts by Hour and Day for Member Users
member_data <- data %>%
  filter(usertype == "member")

hourly_counts_members <- member_data %>%
  group_by(hour_category, day_of_week) %>%
  summarise(count = n(), .groups = "drop") %>%
  arrange(hour_category)

ggplot(hourly_counts_members, aes(x = hour_category, y = day_of_week, fill = count)) +
  geom_tile() +
  labs(x = "Hour of the Day", y = "Day of the Week",
       title = "Heatmap of Ride Counts by Hour and Day for Member Users") +
  scale_fill_gradient(low = "lightblue", high = "darkblue") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

  # Usage Patterns Analysis
    # Trip Duration Comparison
trip_duration_comparison <- data %>%
  group_by(usertype) %>%
  summarize(avg_trip_duration = mean(as.numeric(tripduration), na.rm = TRUE))

plot1 <- ggplot(trip_duration_comparison, aes(x = usertype, y = avg_trip_duration, fill = usertype)) +
  geom_bar(stat = "identity") +
  geom_text(aes(label = round(avg_trip_duration, 2)), position = position_stack(vjust = 0.5), size = 3, color = "black") +
  labs(x = "User Type", y = "Average Trip Duration (seconds)", title = "Average Trip Duration Comparison") +
  theme_minimal()
print(plot1)

plot2 <- ggplot(data, aes(x = usertype, y = tripduration_minutes, color = usertype)) +
  geom_dotplot(binaxis = "y", stackdir = "center", fill = "white") +
  labs(x = "User Type", y = "Trip Duration (seconds)", title = "Trip Duration Comparison by User Type") +
  theme_minimal()
print(plot2)
