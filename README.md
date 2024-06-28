<h1 align="center"> Cyclistic Bike-Share Analysis </h1>

<div align="center">
  <h4>Aurthor: <a href="https://www.linkedin.com/in/kamakshisharma22">Kamakshi Sharma</a></h4>
</div>

This repository contains an analysis aimed at understanding the usage patterns of Cyclistic bike-share service users, differentiating between annual members and casual riders, with the goal of converting casual riders into annual members. The project utilizes historical bike trip data to derive insights and formulate strategic recommendations.

##Main Objective -
Converting Casual Riders into Annual Members
## Data Description

- **Datasets:** Historical trip data for the years 2019 and 2020, provided by Motivate International Inc.
- **Key Columns:**
  - `trip_duration`: Duration of the bike trip in seconds
  - `start_time` and `end_time`: Start and end times of the bike trip
  - `start_station_id` and `end_station_id`: IDs of the start and end docking stations
  - `user_type`: Indicates whether the user is an annual member or a casual rider

## Approach

### Data Cleaning and Preparation

- **Initial Data Acquisition:** Obtained raw trip data from Cyclistic’s data provider for the years 2019 and 2020.
- **Data Organization:** Structured datasets with key columns essential for analysis.
- **Data Cleaning:** Handled missing values, ensured consistency in data formats, and standardized variables.

### Exploratory Data Analysis (EDA)

- Conducted EDA to understand feature distributions and correlations.
- Visualized data to identify patterns in usage and demographics.
- Addressed data quality issues discovered during EDA.

### Data Processing

- Preprocessed data by addressing missing values and ensuring consistency.
- Standardized datasets by renaming columns and transforming variables where necessary.
- Verified data cleanliness using statistical summaries and visualizations.

### Data Analysis

- Compared trip durations and usage patterns between annual members and casual riders.
- Conducted temporal and spatial analysis to identify peak usage times and popular docking stations.
- Segmented users based on demographic variables to identify distinct user profiles.

### Recommendations

#### Conversion Strategies

- **Promotional Campaigns:** Highlight the benefits of annual memberships, such as cost savings and convenience.
- **Discounts and Incentives:** Offer introductory discounts and referral bonuses to attract new members.
- **Enhanced User Engagement:** Improve personalized communication to encourage casual riders to become annual members.

#### Operational Improvements

- **Dynamic Bike Distribution:** Implement strategies to redistribute bikes based on real-time usage data.
- **Station Management:** Optimize station capacity and layout to accommodate peak usage periods.
- **User Feedback Integration:** Continuously solicit and integrate user feedback to enhance service delivery.

## Files

- **R Scripts:** Contains scripts for data cleaning, EDA, and analysis.
- **Report:** Comprehensive report detailing the analysis, key findings, and recommendations.

## Conclusion

The project successfully analyzed Cyclistic’s bike-share data, uncovering significant insights into user behavior. Recommendations were provided to enhance user engagement, increase annual memberships, and optimize operational efficiency.
