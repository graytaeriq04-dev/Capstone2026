--Calculate the total number of transactions in the cc_data table

SELECT 
COUNT(cd.trans_num) as Total_Transactions
FROM cc_data cd; 

--Identify the top 10 most frequent merchants in the cc_data table

UPDATE cc_data
SET merchant = REPLACE(merchant, 'fraud_', '');

SELECT 
cd.merchant as Merchant
,COUNT(cd.merchant) as Total_Transactions
FROM cc_data cd 
GROUP BY cd.merchant 
ORDER BY COUNT(cd.merchant) DESC
LIMIT 10;

--Find the average transaction amount for each category of transactions in the cc_data table

SELECT 
cd.category as Category
,Round(AVG(cd.amt), 2) as Average_Trans_Amount
FROM cc_data cd 
GROUP BY cd.category 
ORDER BY AVG(cd.amt) DESC;

--Determine the number of fraudulent transactions and the percentage of total transactions that they represent

SELECT 
    COUNT(trans_num) AS Total_Transactions
    ,COUNT(CASE WHEN is_fraud = 1 THEN 1 END) AS Total_Fraud
    ,ROUND(COUNT(CASE WHEN is_fraud = 1 THEN 1 END) * 100.0 / COUNT(trans_num), 2) || '%' AS Fraud_Percentage
FROM cc_data;

--Join the cc_data and location_data tables to identify the latitude and longitude of each transaction

SELECT
cd.trans_num as Transcation_Number
,cd.city as City
,ld.lat as Latitude_ld
,ld.long as Longitude_ld
FROM cc_data cd 
INNER JOIN location_data ld on cd.cc_num = ld.cc_num;

--Identify the city with the highest population in the location_data table

SELECT
cd.city as City
,cd.city_pop as Population
,ld.lat as Latitude
,ld.long as Longitude
FROM location_data ld 
INNER JOIN cc_data cd on ld.cc_num = cd.cc_num 
ORDER BY cd.city_pop DESC  
LIMIT 1;

--Find the earliest and latest transaction dates in the cc_data table

SELECT 
MIN(cd.trans_date_trans_time) as Earliest_Trans_Date
,MAX(cd.trans_date_trans_time) as Latest_Trans_Date
FROM cc_data cd; 

--Fraud by Month

SELECT
STRFTIME('%m', 
SUBSTR(trans_date_trans_time, 7, 4) || '-' || 
SUBSTR(trans_date_trans_time, 4, 2) || '-' || 
SUBSTR(trans_date_trans_time, 1, 2)) AS Month
,COUNT(trans_num) AS Total_Fraud
FROM cc_data
WHERE is_fraud = 1
GROUP BY Month
ORDER BY Total_Fraud DESC;

--What is the total amount spent across all transactions in the cc_data table?

SELECT 
ROUND(SUM(cd.amt), 2) as Total_Amount
FROM cc_data cd; 

--Fraud vs Legitimate

SELECT
CASE WHEN is_fraud = 1 THEN 'Fraud' ELSE 'Legitimate' END AS Transaction_Type
,ROUND(SUM(amt), 2) AS Total_Amount
FROM cc_data
GROUP BY is_fraud;

--How many transactions occurred in each category in the cc_data table?

SELECT
cd.category as Category 
,COUNT(cd.trans_num) as Total_Transactions
FROM cc_data cd
GROUP BY Category 
ORDER BY Total_Transactions DESC;

--How many transactions occurred in each category in the cc_data table, where it was fraud

SELECT
cd.category as Category 
,COUNT(cd.trans_num) as Total_Transactions
FROM cc_data cd
WHERE is_fraud = 1
GROUP BY Category 
ORDER BY Total_Transactions DESC;

--Fraud rate percentages per Category

SELECT
cd.category as Category
,COUNT(cd.trans_num) as Total_Transactions
,COUNT(CASE WHEN is_fraud = 1 THEN 1 END) as Total_Fraud
,ROUND(COUNT(CASE WHEN is_fraud = 1 THEN 1 END) * 100.0 / COUNT(trans_num), 2) || '%' AS Fraud_Percentage
FROM cc_data cd 
GROUP BY Category 
ORDER BY ROUND(COUNT(CASE WHEN is_fraud = 1 THEN 1 END) * 100.0 / COUNT(trans_num), 2) DESC; 

--What is the average transaction amount for each gender in the cc_data table?

SELECT
cd.gender as Gender
,ROUND(AVG(cd.amt), 2) as Average_Transaction_Amount
FROM cc_data cd  
GROUP BY cd.gender;

--Which day of the week has the highest average transaction amount in the cc_data tab

SELECT
CASE STRFTIME('%w', 
    SUBSTR(trans_date_trans_time, 7, 4) || '-' || 
    SUBSTR(trans_date_trans_time, 4, 2) || '-' || 
    SUBSTR(trans_date_trans_time, 1, 2))
    WHEN '0' THEN 'Sunday'
    WHEN '1' THEN 'Monday'
    WHEN '2' THEN 'Tuesday'
    WHEN '3' THEN 'Wednesday'
    WHEN '4' THEN 'Thursday'
    WHEN '5' THEN 'Friday'
    WHEN '6' THEN 'Saturday'
END AS Day
,ROUND(AVG(amt), 2) AS Average_Amount
FROM cc_data cd
GROUP BY Day
ORDER BY ROUND(AVG(amt), 2) DESC;









