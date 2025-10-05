# Zepto Grocery Analytics Project

## Project Overview

This project analyzes grocery product data from Zepto, focusing on pricing strategies, inventory management, and product performance. The analysis includes data exploration, cleaning, and business intelligence queries to derive actionable insights for e-commerce grocery operations.

## 📊 Dataset Schema

### Table: `zepto`

| Column | Data Type | Description |
|--------|-----------|-------------|
| `sku_id` | SERIAL (Primary Key) | Unique product identifier |
| `category` | VARCHAR(120) | Product category |
| `name` | VARCHAR(150) | Product name |
| `mrp` | NUMERIC(8,2) | Maximum Retail Price |
| `discountPercent` | NUMERIC(5,2) | Discount percentage |
| `availableQuantity` | INTEGER | Stock quantity |
| `discountedSellingPrice` | NUMERIC(8,2) | Final selling price |
| `weightInGms` | INT | Product weight in grams |
| `outOfStock` | BOOLEAN | Stock status |
| `quantity` | INT | Unit quantity |

- ### Sample Data

  ```
  Category: Fruits & Vegetables
  Products: Onion, Tomato, Coconut, Coriander, etc.
  Price Range: ₹9.00 - ₹100.00 (after conversion)
  Weight Range: 58g - 3000g
  Discount Range: 13% - 18%
  ```

  ## 🔧 Data Processing Pipeline

  ### 1. Data Exploration

  - **Row Count Analysis**: Total dataset size assessment
  - **Sample Data Review**: Initial data structure examination
  - **Null Value Detection**: Data quality assessment
  - **Category Analysis**: Product category distribution
  - **Stock Status Review**: In-stock vs out-of-stock analysis
  - **Duplicate Detection**: Multiple SKUs for same products

  ### 2. Data Cleaning

  - **Zero Price Removal**: Eliminated products with zero MRP
  - **Currency Conversion**: Converted prices from paise to rupees (÷100)
  - **Data Validation**: Ensured data consistency and accuracy

  ### 3. Business Analysis Queries

## 📈 Business Analysis Queries

### Q1: Top 10 Best Value Products
```sql
SELECT DISTINCT name, mrp, discountedSellingPrice
FROM zepto
ORDER BY discountedSellingPrice DESC
LIMIT 10;
```
**Purpose**: Identify premium products with highest absolute savings

### Q2: High-Value Out-of-Stock Products
```sql
SELECT DISTINCT name, mrp
FROM zepto
WHERE outofstock = TRUE AND mrp > 300
ORDER BY mrp DESC;
```
**Purpose**: Highlight revenue loss from expensive unavailable items

### Q3: Revenue Estimation by Category
```sql
SELECT category, 
       SUM(discountedSellingPrice * availableQuantity) AS total_revenue
FROM zepto
GROUP BY category
ORDER BY total_revenue;
```
**Purpose**: Category-wise revenue potential analysis

### Q4: Premium Low-Discount Products
```sql
SELECT name, mrp, discountPercent
FROM zepto
WHERE mrp > 500 AND discountPercent < 10
ORDER BY mrp DESC, discountPercent DESC;
```
**Purpose**: Identify high-margin premium products

### Q5: Categories with Highest Average Discounts
```sql
SELECT category, 
       ROUND(AVG(discountPercent), 2) AS avg_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;
```
**Purpose**: Discount strategy analysis by category

### Q6: Price Per Gram Analysis
```sql
SELECT DISTINCT name, discountedSellingPrice,
       ROUND(discountedSellingPrice / weightInGms, 2) AS price_per_gram
FROM zepto
WHERE weightInGms >= 100
ORDER BY price_per_gram DESC;
```
**Purpose**: Value-based pricing comparison for bulk items

### Q7: Product Weight Segmentation
```sql
SELECT name, weightInGms,
       CASE 
           WHEN weightInGms < 1000 THEN 'Low'
           WHEN weightInGms < 5000 THEN 'Medium'
           ELSE 'Bulk'
       END AS category_by_weight
FROM zepto;
```
**Purpose**: Product classification for logistics planning

### Q8: Total Inventory Weight by Category
```sql
SELECT category,
       SUM(weightInGms * availableQuantity) AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight DESC;
```
**Purpose**: Warehouse optimization and logistics planning

## 🎯 Key Insights

- **Pricing**: 13-18% discount range across products
- **Inventory**: Systematic stock tracking and weight-based categorization  
- **Revenue**: Category-wise performance analysis for optimization
- **Value Analysis**: Price-per-gram metrics for bulk products

## 💡 Technical Features

- **Data Quality**: Null detection, duplicate analysis, price validation
- **SQL Techniques**: Aggregations, CASE statements, window functions
- **Business Logic**: Revenue calculations, segmentation, ranking

## 🚀 Usage

### Prerequisites
- PostgreSQL database
- Grocery product CSV data

### Quick Start
```sql
-- Check data
SELECT COUNT(*) FROM zepto;

-- View categories  
SELECT DISTINCT category FROM zepto;

-- Stock analysis
SELECT outOfStock, COUNT(*) FROM zepto GROUP BY outOfStock;
```

## 📋 Applications

- **E-commerce**: Pricing optimization and inventory planning
- **Supply Chain**: Stockout analysis and warehouse management
- **Marketing**: Value proposition and promotional strategies

This project demonstrates practical SQL analytics for grocery retail, providing actionable insights for pricing, inventory, and business intelligence.