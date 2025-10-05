-- SQL Retail Sales Analysis
CREATE DATABASE Sql_Project_P1;

-- Create TABLE
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
            (
                transaction_id INT PRIMARY KEY,	
                sale_date DATE,	 
                sale_time TIME,	
                customer_id	INT,
                gender	VARCHAR(15),
                age	INT,
                category VARCHAR(15),	
                quantity	INT,
                price_per_unit FLOAT,	
                cogs	FLOAT,
                total_sale FLOAT
            );

SELECT * FROM retail_sales
LIMIT 10

SELECT COUNT(*) FROM RETAIL_SALES

-- Data Cleaning
SELECT * FROM retail_sales
WHERE transactions_id IS NULL

SELECT * FROM retail_sales
WHERE sale_date IS NULL

SELECT * FROM retail_sales
WHERE sale_time IS NULL

SELECT * FROM retail_sales
WHERE 
    transactions_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantiy IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;
-- 
	
DELETE FROM RETAIL_SALES
WHERE 
    transactions_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantiy IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;

-- Data Exploration

-- How Many Sales we have?
SELECT COUNT(*) AS TOTAL_SALES FROM RETAIL_SALES

-- How Many Unique customer we have?
SELECT COUNT(DISTINCT CUSTOMER_ID) AS TOTAL_WE_HAVE_CUSTOMER FROM RETAIL_SALES

-- How Many Category we have?
SELECT COUNT(DISTINCT CATEGORY) FROM RETAIL_SALES


-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)


-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

SELECT * 
FROM RETAIL_SALES
WHERE SALE_DATE = '2022-11-05'

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 3 in the month of Nov-2022

SELECT *
FROM RETAIL_SALES
WHERE 
	category = 'Clothing'
	AND
	TO_CHAR(SALE_DATE, 'YYYY-MM') = '2022-11'
	AND
	quantiy > 3;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT 
	CATEGORY, 
	SUM(TOTAL_SALE) AS TOTAL_SOLD, 
	COUNT(*) AS TOTAL_ORDER
FROM RETAIL_SALES
GROUP BY 1

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT 
	CATEGORY, 
	ROUND(AVG(AGE), 2) AS AVERAGE_AGE
FROM RETAIL_SALES
WHERE CATEGORY = 'Beauty'
GROUP BY 1

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT *
FROM RETAIL_SALES
WHERE total_sale > 1000

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT 
	GENDER,
	CATEGORY,
	COUNT(*) AS SUM_CATEGORY_BY_GENDER
FROM RETAIL_SALES
GROUP BY 
	GENDER,
	CATEGORY
ORDER BY 1

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT 
	YEAR,
	MONTH,
	AVG_SALES
	FROM
(
SELECT 
	EXTRACT(YEAR FROM SALE_DATE) AS YEAR,
	EXTRACT(MONTH FROM SALE_DATE) AS MONTH,
	AVG(TOTAL_SALE) AS AVG_SALES,
	RANK() OVER(PARTITION BY EXTRACT(YEAR FROM SALE_DATE) ORDER BY AVG(TOTAL_SALE) DESC) AS RANK
FROM RETAIL_SALES
GROUP BY 1,2
) AS T1
WHERE RANK = 1

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

SELECT 
	CUSTOMER_ID,
	SUM(TOTAL_SALE) AS SUM_SALE_EACH_CUSTOMER
FROM RETAIL_SALES
GROUP BY 1 
ORDER BY SUM_SALE_EACH_CUSTOMER DESC
LIMIT 5

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT 
	CATEGORY,
	COUNT(DISTINCT CUSTOMER_ID) AS CON_UNIQUE_CUS
FROM RETAIL_SALES
GROUP BY 1

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

WITH HOURLY_SALE 
AS
(
SELECT 
	*,
	CASE
		WHEN EXTRACT(HOUR FROM SALE_TIME) < 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM SALE_TIME) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END AS SHIFT
FROM RETAIL_SALES
)
SELECT
	SHIFT,
	COUNT(*) AS TOTAL_ORDERS
FROM HOURLY_SALE
GROUP BY 1

-- END OF PROJECT