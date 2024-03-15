/*
Travel Agency Dataset
*/

--1. Revenue Analysis:

/*1. Revenue Trends Analysis (Evaluate the overall revenue trends over time)*/

WITH CTE_Monthly_Revenue AS (
SELECT EXTRACT(YEAR FROM booking_date) AS Sale_Year,EXTRACT(MONTH FROM booking_date) AS Sale_Month,
TO_CHAR(booking_date, 'Month') AS Month_Name, SUM(Total_Package_USD) AS Total_Revenue,
ROW_NUMBER() OVER (PARTITION BY EXTRACT(YEAR FROM booking_date), 
EXTRACT(MONTH FROM booking_date) ORDER BY SUM(Total_Package_USD) DESC) AS Month_Rank
FROM Booking_Details
GROUP BY EXTRACT(YEAR FROM booking_date), EXTRACT(MONTH FROM booking_date),
TO_CHAR(booking_date, 'Month')
)

SELECT Sale_Year,Month_Name,Total_Revenue,
COALESCE(ROUND(((Total_Revenue - LAG(Total_Revenue, 1) OVER (ORDER BY Sale_Year, Sale_Month)) / LAG(Total_Revenue, 1) OVER (ORDER BY Sale_Year, Sale_Month)) * 100, 2), 0) AS Percent_Change
FROM CTE_Monthly_Revenue
ORDER BY Sale_Year, Sale_Month;

--Summary
/* Utilizing window function and organizing data by year and month to calculate total revenue per month and determining the percentage change in revenue from previous month, 
and finally sorting by year and month. */



/*2. Geographical Revenue Distribution Analysis*/

SELECT RG.country AS Country, RG.region_name AS Region,SUM(BD.Total_Package_USD) AS Total_Revenue,
ROUND(AVG_Region.Avg_Revenue_Per_Region, 2) AS Avg_Revenue_Per_Region
FROM Booking_Details BD
LEFT JOIN Region RG ON BD.region_id = RG.region_id
LEFT JOIN (SELECT region_name AS Region_Name,
AVG(Total_Package_USD) AS Avg_Revenue_Per_Region
FROM Booking_Details BD
JOIN Region ON BD.region_id = Region.region_id
GROUP BY region_name
) AS AVG_Region ON RG.region_name = AVG_Region.Region_Name
GROUP BY RG.country, RG.region_name, AVG_Region.Avg_Revenue_Per_Region
ORDER BY Total_Revenue DESC;



--Summary
/* Using aggregation functions and grouping the data by country and region to derive the total and average revenue per region and country, showcasing revenue distribution.*/



/*3. Seasonal Revenue Fluctuations (Identify revenue fluctuations based on seasons)*/

WITH CTE_Seasonal_Revenue AS (SELECT 
EXTRACT(YEAR FROM booking_date) AS Sale_Year,
    CASE 
        WHEN EXTRACT(MONTH FROM booking_date) IN (3, 4, 5) THEN 'Spring'
        WHEN EXTRACT(MONTH FROM booking_date) IN (6, 7, 8) THEN 'Summer'
        WHEN EXTRACT(MONTH FROM booking_date) IN (9, 10, 11) THEN 'Fall'
        ELSE 'Winter'
 END AS Season,
 SUM(Total_Package_USD) AS Total_Revenue
 FROM Booking_Details
 GROUP BY Sale_Year, Season
)
SELECT Sale_Year,Season,Total_Revenue
FROM CTE_Seasonal_Revenue
ORDER BY Sale_Year, Season;



--Summary
/* Applying conditional functions and aggregation based on season categorization (Spring, Summer, Fall, Winter), to illustrate revenue fluctuations across different seasons
and grouping it by year and season to highlight seasonal revenue patterns.*/


/*4. Monthly Revenue Forecasting and Deviation Analysis.*/
WITH CTE_Monthly_Revenue_Forecasting AS (SELECT 
EXTRACT(YEAR FROM booking_date) AS Sale_Year, EXTRACT(MONTH FROM booking_date) AS Sale_Month,
SUM(total_package_usd) AS Total_Revenue
FROM Booking_Details
GROUP BY EXTRACT(YEAR FROM booking_date), EXTRACT(MONTH FROM booking_date)
)

SELECT Sale_Year,Sale_Month,Total_Revenue,
ROUND(AVG(Total_Revenue) OVER (ORDER BY Sale_Year, 
Sale_Month ROWS BETWEEN 3 PRECEDING AND 1 FOLLOWING), 2) AS Forecasted_Revenue,
ROUND((Total_Revenue - AVG(Total_Revenue) OVER (ORDER BY Sale_Year, 
Sale_Month ROWS BETWEEN 3 PRECEDING AND 1 FOLLOWING)) / AVG(Total_Revenue) 
OVER (ORDER BY Sale_Year, Sale_Month ROWS BETWEEN 3 PRECEDING AND 1 FOLLOWING) * 100, 2) AS Deviation_Percentage
FROM CTE_Monthly_Revenue_Forecasting
ORDER BY Sale_Year, Sale_Month;

--Summary
/*Created CTE and used window function to calculate monthly revenue, moving average revenue,percentage difference between the monthly revenue and forecasted revenue, and 
ordering it by Sale year and month.*/

---2. Customer Behaviour Analysis:

/*5. Customer Spending Analysis.*/

SELECT Customer_ID, customer_name, email AS Email,Total_Package_Value,
RANK() OVER (ORDER BY Total_Package_Value DESC) AS Spending_Rank
FROM (SELECT CS.customer_id AS Customer_ID, CS.customer_name, CS.email,
SUM(BD.Total_Package_Usd) AS Total_Package_Value
FROM Booking_Details BD
LEFT JOIN Customer CS ON BD.customer_id = CS.customer_id
GROUP BY CS.customer_id, CS.customer_name, CS.email
) AS CustomerSpending
ORDER BY  Total_Package_Value DESC
LIMIT 20;


/* Retrieving details of the top 20 customers by their total spending and ranking based on their spending by using left join and ranking function.*/

--6 Feedback-based Preference Analysis

SELECT HT.hotel_id AS Hotel_ID,HT.hotel_name AS Hotel_Name,ROUND(AVG(HT.rating), 1) AS Average_hotel_rating,
COUNT(BD.booking_id) AS Total_Bookings,
CASE 
    WHEN AVG(HT.rating) >= 4.5 THEN 'Highly Preferred'
    WHEN AVG(HT.rating) >= 3.8 THEN 'Moderately Preferred'
    ELSE 'Low Preferred'
END AS Preference_Category
FROM Hotel HT
join Booking_Details BD ON HT.hotel_id = BD.hotel_id
GROUP BY HT.hotel_id, HT.hotel_name
ORDER BY Average_Hotel_Rating DESC, Total_Bookings DESC;

/* Calculating the average hotel rating and total bookings for each hotel,categorizing them into Highly Preferred/Moderately Preferred/Low Preferred
 based on their average ratings to estimate most popular and preferred  hotels among customers.*/
 
 --7.Travel Class Preference Analysis by Expenditure
WITH CTE_Class_Spending AS ( 
SELECT travel_class,
COUNT(*) AS Total_Bookings,
ROUND(AVG(total_package_usd), 2) AS Avg_Spending,
SUM(total_package_usd) AS Total_Spending
FROM Booking_Details
GROUP BY travel_class
)

SELECT travel_class, Total_Bookings, Avg_Spending,
ROUND((Total_Spending / (SELECT SUM(Total_Spending) FROM CTE_Class_Spending)) * 100, 2) AS Spending_Percentage
FROM CTE_Class_Spending
ORDER BY Total_Bookings DESC;

/* Utilizing aggregation function to calculate total spending and average expenditure per travel class and grouping it by the travel class to analyse the number of bookings and respective spending for each class.*/

--8. Booking preference Analysis
SELECT booking_channel AS Booking_Channel, ROUND(COUNT(booking_id)) AS Total_Bookings,
ROUND(SUM(total_package_usd)) AS Total_Revenue, ROUND(AVG(total_package_usd)) AS Avg_Revenue_Per_Booking,
ROUND((SUM(total_package_usd) / (SELECT SUM(total_package_usd) FROM Booking_Details)) * 100, 2) AS Revenue_Contribution_Percentage
FROM Booking_Details
GROUP BY booking_channel
ORDER BY Total_Revenue DESC;

/* Analysing booking data across different channels to ascertain booking volumes and revenues per channel, along with the average revenue per booking and computing the 
contribution percentage of each channel to the total revenue*/

--Seasonal Demand Variation Analysis

---9.Seasonal Booking Trends Analysis

SELECT EXTRACT(YEAR FROM booking_date) AS Sale_Year,
    CASE
    WHEN EXTRACT(MONTH FROM booking_date) IN (7, 8, 12) THEN 'Peak Season'
    ELSE 'Non-Peak Season'
END AS season_category,
SUM(total_package_usd) AS total_revenue
FROM Booking_Details
GROUP BY Sale_Year, season_category
ORDER BY Sale_Year, season_category;


/*Utilizing CASE statements to categorize booking dates into Peak Season/Non-Peak Season, to showcase total revenue during these periods
and grouping it by year and season category to show revenue trends.*/

---10./* Seasonal Revenue Analysis by Customer Premium Status */
WITH Seasonal_Booking AS (
SELECT 
CASE 
     WHEN EXTRACT(MONTH FROM booking_date) IN (7, 8, 12) THEN 'Peak Season'
     ELSE 'Non-Peak Season'
END AS season_category, bd.total_package_usd, CT.premium_member
FROM Booking_Details bd
JOIN Customer CT ON bd.customer_id = CT.customer_id
)
SELECT season_category,
CASE 
    WHEN premium_member THEN 'Premium'
    ELSE 'Non-Premium'
END AS customer_status,
SUM(total_package_usd) AS total_revenue
FROM Seasonal_Booking
GROUP BY season_category, customer_status
ORDER BY season_category, total_revenue DESC;

/* Categorizing seasonal revenue based on the premium status of customers. Utilizing CASE statements, joins, aggregators, group by clause to derive total revenue by premium status and season.*/

--11. Regional Revenue Comparison: Peak and Off-Peak Season Analysis

SELECT region_name,
    COALESCE(SUM(CASE WHEN month_number IN (7, 8, 12) THEN total_revenue END), 0) AS peak_season_revenue,
    COALESCE(SUM(CASE WHEN month_number NOT IN (7, 8, 12) THEN total_revenue END), 0) AS off_peak_season_revenue,
    COALESCE(SUM(total_revenue), 0) AS total_combined_revenue
FROM (SELECT r.region_name,EXTRACT(MONTH FROM bd.travel_date) AS month_number,
	  SUM(bd.total_package_usd) AS total_revenue
    FROM Booking_Details bd
    JOIN Region r ON bd.region_id = r.region_id
    GROUP BY r.region_name, EXTRACT(MONTH FROM bd.travel_date)
) AS MonthlyRegionRevenue
GROUP BY region_name
ORDER BY total_combined_revenue DESC, region_name;

/* Categorizing seasons and analysing total revenue for each region across both seasonal categories,using Coalesce, aggregation, case and join function*/

--12. Revenue Breakdown of Top 10 Hotels by Ratings in Peak and Non-Peak Seasons

SELECT Rating.hotel_id, Rating.rating,Rating.hotel_name,Rating.location,
    SUM(CASE WHEN EXTRACT(MONTH FROM bd.travel_date) IN (7, 8, 12) THEN bd.total_package_usd ELSE 0 END) AS Peak_Season_Revenue,
    SUM(CASE WHEN EXTRACT(MONTH FROM bd.travel_date) NOT IN (7, 8, 12) THEN bd.total_package_usd ELSE 0 END) AS "Non-Peak_Season_Revenue",
    SUM(bd.total_package_usd) AS Total_Revenue
FROM (SELECT HT.hotel_id,HT.rating,HT.hotel_name,HT.location,
ROW_NUMBER() OVER (ORDER BY HT.rating DESC) AS rating_rank
FROM Hotel HT
) AS Rating
JOIN Booking_Details bd ON Rating.hotel_id = bd.hotel_id
WHERE Rating.rating_rank <= 10
GROUP BY Rating.hotel_id, Rating.rating, Rating.hotel_name, Rating.location
ORDER BY Total_Revenue DESC;

/*Fetching top 10 hotels based on their ratings, providing revenue breakdown for each hotel across both peak and non-peak seasons.*/

--4.  Geographical Revenue Analysis:

-- 13. Top Regions by Revenue for Each Quarter

SELECT travel_quarter,region_id,region_name,total_revenue
FROM (SELECT Reg.region_id,Reg.region_name,EXTRACT(QUARTER FROM BD.travel_date) AS travel_quarter,
SUM(BD.total_package_usd) AS total_revenue,
ROW_NUMBER() OVER(PARTITION BY EXTRACT(QUARTER FROM BD.travel_date) ORDER BY SUM(BD.total_package_usd) DESC) AS revenue_rank
FROM Region Reg
JOIN Booking_Details BD ON Reg.region_id = BD.region_id
WHERE EXTRACT(YEAR FROM BD.travel_date) = 2023 
GROUP BY Reg.region_id, Reg.region_name, EXTRACT(QUARTER FROM BD.travel_date)
) AS Ranked_Regions
WHERE revenue_rank <= 3 
ORDER BY travel_quarter, revenue_rank;

/*Using ranking functions to categorize and identify the top revenue-generating regions for each quarter and grouping data by quarter and region to determine the regions contributing the most revenue in different quarters*/



--14. Top Airlines Contribution towards Regional Revenue 

SELECT reg.region_id AS reg_id, reg.region_name AS reg_name,FL.airline AS airline,
SUM(BD.total_package_usd) AS total_revenue
FROM Region Reg
left join Booking_Details BD ON reg.region_id = BD.region_id
left join Flight FL ON BD.flight_id = FL.flight_id
WHERE BD.flight_id IS NOT NULL AND FL.airline IS NOT NULL
GROUP BY reg.region_id, reg.region_name, FL.airline
HAVING SUM(BD.total_package_usd) = (SELECT SUM(BD.total_package_usd)
FROM Booking_Details bd_inner
WHERE BD_inner.flight_id IS NOT NULl AND BD_inner.region_id = reg.region_id
GROUP BY BD_inner.flight_id
ORDER BY SUM(BD_inner.total_package_usd) DESC
LIMIT 1)
ORDER BY reg.region_id, total_revenue DESC;

/*Evaluating revenue contribution of various airlines in each region and identifying the top three airlines, based on total booking values, 
using joins and aggregations and group by clause.*/

--5. Revenue impact based on flight service
--15. Flight Meal Inclusion Revenue Analysis

SELECT FL.meal_inclusion, COUNT(BD.booking_id) AS Total_Bookings,
ROUND(SUM(BD.total_package_usd), 2) AS Total_Revenue,
ROUND(AVG(BD.total_package_usd), 2) AS Avg_Revenue_Per_Booking,
ROUND((SUM(BD.total_package_usd) / (SELECT SUM(total_package_usd) FROM Booking_Details)) * 100, 2) AS Revenue_Contribution_Percentage
FROM Booking_Details BD
join Flight FL ON BD.flight_id = FL.flight_id
GROUP BY FL.meal_inclusion
ORDER BY Total_Revenue DESC;

/* Utilizing aggregators to understand the impact of in-flight meal service on bookings by categorizing booking data based on meal options,
 and estimating total bookings, overall revenue, and average revenue per booking for each meal inclusion type*/


--6. Customer Revenue Segmentation
--16. Customer Revenue Segmentation Analysis

SELECT
CASE
     WHEN C.premium_member THEN 'Premium Member'
     ELSE 'Non-Premium Member'
END AS Membership_Type,COUNT(*) AS Total_Customers,
ROUND((COUNT(*) * 100.0) / (SELECT COUNT(*) FROM Customer), 2) AS Percentage_of_Total,
ROUND(SUM(BD.total_package_usd), 2) AS Total_Revenue,
ROUND(AVG(BD.total_package_usd), 2) AS Avg_Revenue_Per_Customer
FROM Customer C
LEFT JOIN Booking_Details BD ON C.customer_id = BD.customer_id
GROUP BY Membership_Type;


/* Categorizing customers into "Premium" and "Non-Premium" groups, calculating the total number of customers in each category,their percentage in relation to the total customer base, total revenue generated by each group, and
the average revenue per customer in both segments*/
--