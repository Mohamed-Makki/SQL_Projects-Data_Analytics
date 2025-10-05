
DROP TABLE IF EXISTS zepto;
CREATE TABLE zepto(
	sku_id SERIAL PRIMARY KEY,
	category VARCHAR(120),
	name VARCHAR(150) NOT NULL,
	mrp NUMERIC(8,2),
	discountPercent NUMERIC(5,2),
	availableQyantity INTEGER,
	discountedSellingPrice NUMERIC(8,2),
	weightInGms INT,
	outOFStock BOOLEAN,
	quantity INT 
);

--data exploration

--count of rows
SELECT
	COUNT(*)
FROM zepto;

--sample data
SELECT
	*
FROM zepto
LIMIT 10;

--null values
SELECT
	*
FROM zepto
WHERE name IS NULL
	OR
	category IS NULL
	OR
	mrp IS NULL
	OR
	discountPercent IS NULL
	OR
	availableQyantity IS NULL
	OR
	discountedSellingPrice IS NULL
	OR
	weightInGms IS NULL
	OR
	outOFStock IS NULL
	OR
	quantity IS NULL

-- different product categories
SELECT
	DISTINCT category
FROM zepto
ORDER BY category;

--products in stock vs out of stock
SELECT
	outOFStock,
	COUNT(sku_id)
FROM zepto
GROUP BY 1

--product name present multiple times
SELECT
	name,
	COUNT(sku_id) AS "Number of SKUs"
FROM zepto
GROUP BY 1
HAVING COUNT(sku_id) > 1
ORDER BY 2 DESC

--data cleaing

--products with price = 0
SELECT
	*
FROM zepto
WHERE
	mrp = 0 OR discountedSellingPrice = 0;

DELETE
FROM zepto
WHERE 
	mrp = 0;

--convert paise to rupees
UPDATE zepto
SET mrp = mrp/100.0,
discountedSellingPrice = discountedSellingPrice/100.0;

SELECT 
	mrp, 
	discountedSellingPrice 
FROM zepto

-- Q1.Find the top 10 best-vale product based on the discount percentage.
SELECT
	DISTINCT name,
	mrp,
	discountedSellingPrice
FROM zepto
ORDER BY 3 DESC
LIMIT 10

--Q2.What are the products with high mrp but out of stock.
SELECT
	DISTINCT name,
	mrp
FROM zepto
WHERE 
	outofstock = TRUE AND mrp > 300
ORDER BY 2 DESC

--Q3.Calculate estimated revenue for each category.
SELECT
	category,
	SUM(discountedSellingPrice * availableQyantity) AS total_revenue
FROM zepto
GROUP BY 1
ORDER BY 2

--Q4.Find all products where mrp is grater than 500 and discount is less than 10.
SELECT
	name,
	mrp,
	discountPercent
FROM zepto
WHERE
	mrp > 500
	AND
	discountPercent < 10
ORDER BY 2 DESC, 3 DESC

--Q5.Identify the top 5 categries offering the highest average discount percentage.
SELECT
	category,
	ROUND(AVG(discountPercent), 2) AS avg_discount
FROM zepto
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

--Q6.Find the price per gram for productd above 100g and sort by best value.
SELECT
	DISTINCT name,
	discountedSellingPrice,
	ROUND(discountedSellingPrice / weightingms, 2) AS price_per_gram
FROM zepto
WHERE
	weightingms >= 100
ORDER BY 3 DESC

--Q7.Group the products into categoties like low. medium, bulk.

SELECT
	name,
	weightingms,
	CASE
		WHEN weightingms < 1000 THEN 'low'
		WHEN weightingms < 5000 THEN 'medium'
		ELSE 'bulk'
	END category_by_weight
FROM zepto

--Q8.What is the total inventory weight per category.
SELECT
	category,
	SUM(weightingms * availableQyantity) AS total_weight
FROM zepto
GROUP BY 1
ORDER BY 2 DESC