# SQL Data Analytics Project

## Project Overview

This project demonstrates a comprehensive SQL-based data analytics solution built on a star schema data warehouse architecture. The project focuses on sales analytics, providing insights into customer behavior, product performance, and business trends through systematic data exploration and analysis.

## 🏗️ Architecture

The project implements a **star schema** data warehouse with:
- **Fact Table**: `gold.fact_sales` - Contains transactional sales data
- **Dimension Tables**: 
  - `gold.dim_customers` - Customer master data
  - `gold.dim_products` - Product catalog information

## 📊 Database Schema

### Fact Table: `gold.fact_sales`
- `order_number` - Unique order identifier
- `product_key` - Foreign key to products dimension
- `customer_key` - Foreign key to customers dimension  
- `order_date`, `shipping_date`, `due_date` - Date tracking
- `sales_amount` - Revenue generated
- `quantity` - Items sold
- `price` - Unit price

### Dimension Tables

#### `gold.dim_customers`
- `customer_key` - Primary key
- `customer_id`, `customer_number` - Business identifiers
- `first_name`, `last_name` - Customer names
- `country`, `marital_status`, `gender` - Demographics
- `birthdate`, `create_date` - Temporal information

#### `gold.dim_products`
- `product_key` - Primary key
- `product_id`, `product_number`, `product_name` - Product identifiers
- `category_id`, `category`, `subcategory` - Product hierarchy
- `maintenance`, `cost`, `product_line` - Product attributes
- `start_date` - Product lifecycle tracking

## 📁 Project Structure

```
sql-data-analytics-project/
├── 00_init_database.sql          # Database setup and data loading
├── 01_database_exploration.sql   # Schema exploration
├── 02_dimensions_exploration.sql # Dimension analysis
├── 03_date_range_exploration.sql # Temporal boundaries analysis
├── 04_measures_exploration.sql   # Key metrics calculation
├── 05_magnitude_analysis.sql     # Data distribution analysis
├── 06_ranking_analysis.sql       # Performance ranking
├── 07_change_over_time_analysis.sql # Time series analysis
├── 08_cumulative_analysis.sql    # Running totals and trends
├── 09_performance_analysis.sql   # Year-over-year comparisons
├── 10_data_segmentation.sql      # Customer/product segmentation
├── 11_part_to_whole_analysis.sql # Contribution analysis
├── 12_report_customers.sql       # Customer analytics view
└── 13_report_products.sql        # Product analytics view
```

## 🔧 Setup Instructions

### Prerequisites
- SQL Server (any recent version)
- CSV data files in the specified directory structure

### Installation Steps

1. **Initialize Database**
   ```sql
   -- Run 00_init_database.sql
   -- This will create the DataWarehouseAnalytics database
   -- and load data from CSV files
   ```

2. **Execute Analysis Scripts**
   Run the numbered SQL files in sequence to perform different types of analysis.

3. **Create Reporting Views**
   Execute the report scripts (12 and 13) to create analytical views.

## 📈 Analysis Categories

### 1. **Database Exploration** (`01_database_exploration.sql`)
- Schema discovery using `INFORMATION_SCHEMA`
- Table structure analysis
- Column metadata inspection

### 2. **Dimensional Analysis** (`02_dimensions_exploration.sql`)
- Unique value identification across dimensions
- Data quality assessment
- Category hierarchy exploration

### 3. **Temporal Analysis** (`03_date_range_exploration.sql`)
- Date range identification
- Data freshness assessment
- Customer age demographics

### 4. **Key Metrics** (`04_measures_exploration.sql`)
- **Total Sales**: Revenue aggregation
- **Total Quantity**: Volume analysis  
- **Average Price**: Pricing insights
- **Order Counts**: Transaction frequency
- **Customer/Product Counts**: Entity counting

### 5. **Magnitude Analysis** (`05_magnitude_analysis.sql`)
- Customer distribution by geography and demographics
- Product portfolio analysis by category
- Revenue contribution by dimension
- Cross-dimensional analysis

### 6. **Ranking Analysis** (`06_ranking_analysis.sql`)
- Top/bottom performing products
- High-value customer identification
- Performance benchmarking using window functions

### 7. **Time Series Analysis** (`07_change_over_time_analysis.sql`)
- Monthly/yearly trend analysis
- Seasonality identification
- Growth pattern recognition

### 8. **Cumulative Analysis** (`08_cumulative_analysis.sql`)
- Running totals calculation
- Moving averages
- Growth trajectory analysis

### 9. **Performance Comparison** (`09_performance_analysis.sql`)
- Year-over-year analysis
- Product performance benchmarking
- Trend classification (increase/decrease/stable)

### 10. **Customer Segmentation** (`10_data_segmentation.sql`)
- **Product Segmentation**: Cost-based categorization
- **Customer Segmentation**: 
  - **VIP**: 12+ months history, >€5,000 spending
  - **Regular**: 12+ months history, ≤€5,000 spending  
  - **New**: <12 months history

### 11. **Contribution Analysis** (`11_part_to_whole_analysis.sql`)
- Category contribution to total sales
- Percentage-based performance metrics
- Part-to-whole relationship analysis

## 📊 Analytical Views

### Customer Report (`gold.report_customers`)
Comprehensive customer analytics including:
- **Demographics**: Age, age groups
- **Behavior Metrics**: Total orders, sales, quantity
- **Segmentation**: VIP/Regular/New classification
- **KPIs**: 
  - Average Order Value (AOV)
  - Average Monthly Spend
  - Recency (months since last order)
  - Customer Lifespan

### Product Report (`gold.report_products`)
Complete product performance analysis including:
- **Product Attributes**: Category, subcategory, cost
- **Performance Metrics**: Sales, quantity, customer reach
- **Segmentation**: High-Performer/Mid-Range/Low-Performer
- **KPIs**:
  - Average Order Revenue (AOR)
  - Average Monthly Revenue
  - Average Selling Price
  - Recency Analysis

## 🎯 Key Business Insights

The project enables analysis of:
- **Customer Lifetime Value** and segmentation
- **Product Performance** and profitability
- **Sales Trends** and seasonality
- **Geographic Performance** across markets
- **Inventory Management** through product analysis
- **Revenue Optimization** opportunities

## 💡 Technical Highlights

### SQL Techniques Demonstrated
- **Star Schema Design** for analytical workloads
- **Window Functions** for ranking and running calculations
- **CTEs (Common Table Expressions)** for complex query organization
- **Data Segmentation** using CASE statements
- **Time Series Analysis** with date functions
- **View Creation** for reusable analytical models

### Advanced Analytics Features
- **Cumulative Analysis** with running totals
- **Year-over-Year Comparisons** using LAG functions
- **Customer Cohort Analysis** through segmentation
- **Product Portfolio Analysis** with contribution metrics
- **Trend Classification** using conditional logic

## 🚀 Usage Examples

```sql
-- Get top 5 customers by revenue
SELECT TOP 5 customer_name, total_sales 
FROM gold.report_customers 
ORDER BY total_sales DESC;

-- Analyze product performance by category
SELECT category, COUNT(*) as product_count, AVG(total_sales) as avg_revenue
FROM gold.report_products 
GROUP BY category 
ORDER BY avg_revenue DESC;

-- Customer segmentation distribution
SELECT customer_segment, COUNT(*) as customer_count
FROM gold.report_customers 
GROUP BY customer_segment;
```

## 📋 Requirements

- **SQL Server** (2016 or later recommended)
- **CSV Data Files** in the specified format
- **File System Access** for BULK INSERT operations
- **Database Permissions** for schema creation and data loading

## 🔄 Data Refresh Process

The project includes a complete rebuild process:
1. **Database Drop/Create** (if exists)
2. **Schema Creation** with proper data types
3. **Data Loading** via BULK INSERT from CSV files
4. **View Creation** for analytical reporting

## 📝 Notes

- All monetary values appear to be in integer format (consider scaling for currency precision)
- Date ranges and customer age calculations use `GETDATE()` for current date references
- The schema supports extensibility for additional dimensions and metrics

## 🤝 Contributing

This project serves as a template for SQL-based analytics solutions. Feel free to extend with additional analysis types, metrics, or visualization components.