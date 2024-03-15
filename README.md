# Random Travel Agency Project

# Project Overview

Embarking on the Travel Agency Dataset Analysis, this project seeks to delve into the intricacies of Terrific Travel Agency's data landscape. As the travel industry navigates through dynamic shifts, leveraging data becomes paramount for strategic decision-making. This initiative aims to unravel key patterns within the dataset, offering valuable insights that will refine operational strategies, elevate customer experiences, and amplify revenue streams. Outcomes include actionable insights empowering Terrific Travel Agency to refine strategies, enhance customer experiences, and optimize revenue streams. Python-based graph visualizations will visually represent the findings, ensuring effective communication of insights derived from the dataset.


# Showing the Relational schema Based on Plan of Project

Creating the schema marked the initial phase of the project, requiring the establishment of a structured framework to illustrate the logical representation of the database. This involved defining relationships among entities and mapping attributes to ensure a coherent foundation for the subsequent stages of the project.

![image](https://github.com/TobiAyinde/TERRIFIC-TRAVEL-AGENCY/assets/149031697/03aa7bf2-0fbd-43de-ad17-84551fd1496b)

# Creation of the Tables

Data sets used can be found below:

 - **Booking Details:** Contains comprehensive booking information, including customer details, flight and hotel IDs, booking and travel dates, travel class, and financial details.

 - **Customer Table:** Provides customer-specific data such as customer ID, name, contact information, address, and premium membership status, crucial for understanding customer behavior.

 - **Flight Table:** Includes details about flights, such as flight ID, flight number, airline, departure, and arrival airport codes, essential for analyzing flight-related patterns.

 - **Hotel Table:** Encompasses hotel-related information, including hotel ID, name, location, rating, and type, facilitating analysis of hotel-specific trends and preferences.

 - **Region Table:** Offers regional data, including region ID, name, city, country, and airport code, supporting insights into geographical revenue distribution and regional trends.


Two types of tables were created, and these include below:

 - **Dimension tables:** These are tables that contain descriptive, textual, or categorical information, which is typically the entry points to data.

 - **Facts tables:** These are tables that contain the performance metrics of specific business processes.
   
Created tables are:

 - **Booking Details:**

 - **Customer Table:**

 - **Flight Table:**

 - **Hotel Table:**


# Analysis and Visualization

## **Revenue Analysis:**

### **Summary**

Utilizing the window function and organizing data by year and month to calculate total revenue per month and determine the percentage change in revenue from previous month, and finally sorting by year and month.

![image](https://github.com/TobiAyinde/TERRIFIC-TRAVEL-AGENCY/assets/149031697/a4b9b878-0b62-4a82-86b7-6eeb96dda370)

![image](https://github.com/TobiAyinde/TERRIFIC-TRAVEL-AGENCY/assets/149031697/8c2d6f1b-cb82-43a9-b1f5-4f74d8857419)

### **Insight**

The revenue trends observed during 2023 demonstrate varying patterns in monthly revenues. Months such as July and March have significant increases in revenue, maybe suggesting peak travel seasons or promotional activities. In contrast, notable decreases in May, August, and October indicate a reduction in travel demand or less profitable seasons. The variations in client behavior might be attributed to seasonal travel preferences, as well as exogenous variables like economic swings or marketing tactics.

## **Geographical Revenue Distribution Analysis:**

### **Summary**

Using aggregation functions and grouping the data by country and region to derive the total and average revenue per region and country, showcasing revenue distribution.

![image](https://github.com/TobiAyinde/TERRIFIC-TRAVEL-AGENCY/assets/149031697/f77d198c-0c69-494e-91e6-7ab0da8cbb4d)

![image](https://github.com/TobiAyinde/TERRIFIC-TRAVEL-AGENCY/assets/149031697/5cbef42d-de8c-48e6-967a-82b4dc4180fc)

### **Insight**

The Geographical Revenue Distribution demonstrates the allocation of revenue across several nations and their corresponding regions. The data reveals significant disparities in revenue across different regions, highlighting locations such as Antibes in France and London in the United Kingdom as major contributors to high revenue. This suggests that there are varying average revenue levels within regions of the same nation. Possible factors contributing to these variances include regional demand drivers, unique attractions, cultural events, or marketing strategies.

## **Seasonal Revenue Fluctuations (Identify revenue fluctuations based on seasons):**

### **Summary**

Applying conditional functions and aggregation based on season categorization (Spring, Summer, Fall, Winter), to illustrate revenue fluctuations across different seasons and grouping it by year and season to highlight seasonal revenue patterns.

![image](https://github.com/TobiAyinde/TERRIFIC-TRAVEL-AGENCY/assets/149031697/55165d77-d0e5-45f1-9d1d-99f2d3f472b6)

![image](https://github.com/TobiAyinde/TERRIFIC-TRAVEL-AGENCY/assets/149031697/b9b18ffe-a3e5-42c5-867c-ceb8f4026cc4)

### **Insight**

The Seasonal Revenue Fluctuations Analysis illustrates the variations in revenue throughout different seasons, highlighting significant increases in revenue during the Summer and Spring seasons in comparison to the Fall and Winter seasons. This implies a seasonal pattern in which the months with higher temperatures tend to generate greater revenue, maybe due to an increase in travel during holiday times.

## **Monthly Revenue Forecasting and Deviation Analysis:**

### **Summary**

Created CTE and used window function to calculate monthly revenue, moving average revenue, percentage difference between the monthly revenue and forecasted revenue, and ordering it by Sale year and month.

![image](https://github.com/TobiAyinde/TERRIFIC-TRAVEL-AGENCY/assets/149031697/5e60cefd-6ce0-481d-86fb-8ae1d023ca21)

![image](https://github.com/TobiAyinde/TERRIFIC-TRAVEL-AGENCY/assets/149031697/0843aa3d-7041-441a-b667-57c5a937d4d3)

### **Insight**

Monthly Revenue Forecasting and Deviation Analysis predicts how much revenue will be made each month in 2023 and figures out what percentage of that revenue will be different from what was predicted. There are changes, especially in May and June, when real sales are very different from what was expected. This could lead to questions about how accurate the forecasting models were during those times, possibly because of outside factors or changes in the way the market works that affected the revenue forecasts.

## **Customer Spending Analysis:**

### **Summary**

Retrieving details of the top 20 customers by their total spending and ranking based on their spending by using left join and ranking function.

![image](https://github.com/TobiAyinde/TERRIFIC-TRAVEL-AGENCY/assets/149031697/7495a734-575a-4381-92bf-b98395c14893)

![image](https://github.com/TobiAyinde/TERRIFIC-TRAVEL-AGENCY/assets/149031697/95c251a6-013c-4c78-aab8-2f1b8a91678c)

### **Insight**

Based on the overall package values of their clients, the Customer Spending study ranks the highest-spending consumers. The two highest-spending clients on the list, James Charlse and Patrick Baldwin, are noteworthy for their equal expenditure. Many consumers in the same spending range point to a group of consumers with comparable spending capacities, pointing to possible markets for focused advertising campaigns or service offers to keep or grow these consumers' spending and engagement levels.



# Goals and Objectives of the project
