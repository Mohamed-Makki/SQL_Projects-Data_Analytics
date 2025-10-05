# 📊 SQL Data Analysis Projects Portfolio

Welcome to my comprehensive collection of SQL data analysis projects showcasing advanced analytical approaches across diverse industries and business scenarios.

## 📋 Table of Contents

- [Projects Overview](#projects-overview)
- [Technologies Used](#technologies-used)
- [Key Skills Demonstrated](#key-skills-demonstrated)
- [Featured Projects](#featured-projects)
- [Advanced SQL Techniques](#advanced-sql-techniques)
- [Business Impact](#business-impact)
- [Installation & Setup](#installation--setup)
- [Contact](#contact)

---

## 🚀 Projects Overview

This repository contains **6 comprehensive SQL projects** across multiple industries:

| Project | Industry | Complexity | Key Focus | Tables |
|---------|----------|------------|-----------|---------|
| **Sales Analytics** | E-commerce | Advanced | Customer Analytics & Star Schema | 3 |
| **Library Management** | Education | Intermediate | CRUD Operations & Automation | 6 |
| **Spotify Music Analysis** | Entertainment | Progressive | Multi-Platform Analytics | 1 |
| **Music Store Analysis** | Digital Retail | Advanced | Complex Joins & Customer Insights | 11 |
| **Retail Sales Analysis** | Retail | Beginner | EDA & Transaction Analysis | 1 |
| **Zepto Grocery Analytics** | E-commerce | Intermediate | Pricing & Inventory Strategy | 1 |

---

## 🛠️ Technologies Used

- **Database Systems**: MySQL, PostgreSQL, SQL Server
- **Advanced SQL**: Window Functions, CTEs, Stored Procedures, Triggers
- **Analytics**: Time Series Analysis, Customer Segmentation, Cohort Analysis
- **Design**: Star Schema, Data Warehousing, Relational Modeling
- **Business Intelligence**: KPI Development, Automated Reporting, Trend Analysis

---

## 🎯 Key Skills Demonstrated

### **Database Design & Architecture**
- Star schema implementation with fact and dimension tables
- Relational database design with proper normalization
- Foreign key constraints and referential integrity
- Performance optimization through strategic indexing

### **Advanced SQL Techniques**
- Window functions (RANK, DENSE_RANK, LAG/LEAD, ROW_NUMBER)
- Complex multi-table JOINs (up to 11 tables)
- Common Table Expressions (CTEs) for complex data processing
- Stored procedures for automated business logic
- Conditional aggregation and dynamic reporting

### **Business Analytics**
- Customer Lifetime Value (CLV) and RFM analysis
- Year-over-Year (YoY) growth calculations
- Customer segmentation (VIP/Regular/New categories)
- Revenue trend analysis and forecasting
- Performance metrics and KPI tracking

---

## 📁 Featured Projects

### 1. 🛒 **Sales Analytics - E-commerce Data Warehouse**
**Complexity**: Advanced | **Architecture**: Star Schema

**Overview**: Comprehensive sales analytics solution built on star schema architecture with fact table (`fact_sales`) and dimension tables (`dim_customers`, `dim_products`).

**Key Features**:
- 13 specialized analysis scripts covering exploration, metrics, trends, and segmentation
- Customer segmentation logic (VIP/Regular/New) based on spending patterns
- YoY comparisons and cumulative analysis
- Pre-built analytical views for automated reporting

**Technical Highlights**:
```sql
-- Customer Lifetime Value Analysis
WITH customer_metrics AS (
    SELECT customer_id,
           SUM(total_amount) as total_spent,
           COUNT(DISTINCT order_id) as order_count,
           AVG(total_amount) as avg_order_value
    FROM fact_sales
    GROUP BY customer_id
)
SELECT customer_id,
       CASE 
           WHEN total_spent >= 10000 THEN 'VIP'
           WHEN total_spent >= 5000 THEN 'Regular'
           ELSE 'New'
       END as customer_segment
FROM customer_metrics;
```

### 2. 📚 **Library Management System**
**Complexity**: Intermediate | **Focus**: Complete CRUD Operations

**Overview**: Functional library database system with 6 interconnected tables, automated processes, and performance analytics.

**Key Features**:
- 20 practical tasks covering CRUD, CTAS, and stored procedures
- Automated overdue book tracking with fine calculations
- Branch performance reporting across multiple locations
- Stored procedures for automated return processing

### 3. 🎵 **Spotify Music Analytics**
**Complexity**: Progressive (Easy → Advanced)

**Overview**: Multi-platform music analytics comparing Spotify and YouTube performance metrics.

**Key Features**:
- Progressive analysis structure across three difficulty levels
- Track metadata analysis (streams, likes, comments, audio features)
- Artist ranking using DENSE_RANK() for top-N analysis
- Custom metrics like energy-to-liveness ratio calculations

### 4. 🎼 **Music Store Analysis**
**Complexity**: Advanced | **Schema**: 11 Tables

**Overview**: Digital music store analytics with complex relationships and customer behavior insights.

**Key Features**:
- Multi-table JOINs involving up to 5 tables simultaneously
- Genre popularity analysis by geographic region
- Customer spending patterns and loyalty metrics
- Senior employee identification and best customer analysis

### 5. 🛍️ **Retail Sales Analysis**
**Complexity**: Beginner | **Focus**: Exploratory Data Analysis

**Overview**: Beginner-friendly retail analytics with comprehensive EDA and business insights.

**Key Features**:
- Sales transaction analysis by time, category, and customer
- Data quality checks and cleaning procedures
- Time-shift analysis (Morning/Afternoon/Evening patterns)
- Monthly trend identification using RANK() functions

### 6. 🥬 **Zepto Grocery Analytics**
**Complexity**: Intermediate | **Focus**: E-commerce Optimization

**Overview**: Grocery e-commerce analytics focusing on pricing strategies and inventory optimization.

**Key Features**:
- Price-per-gram value analysis for competitive positioning
- Out-of-stock impact assessment on revenue
- Category-level revenue estimation and forecasting
- Weight-based product segmentation (bulk vs regular)

---

## ⚡ Advanced SQL Techniques

### **Window Functions & Analytics**
```sql
-- Revenue Ranking with Growth Analysis
SELECT product_id,
       SUM(revenue) as total_revenue,
       RANK() OVER (ORDER BY SUM(revenue) DESC) as revenue_rank,
       LAG(SUM(revenue)) OVER (ORDER BY order_date) as prev_revenue
FROM sales_data
GROUP BY product_id, order_date;
```

### **Complex Query Patterns**
- Recursive CTEs for hierarchical data processing
- Pivot operations for dynamic cross-tabulation
- Cohort analysis for customer retention tracking
- Time series analysis with seasonal pattern detection

---

## 💼 Business Impact

### **Quantifiable Results**
- **Customer Segmentation**: Improved targeting efficiency by identifying high-value segments
- **Revenue Analysis**: Discovered top 10% customers contributing 60% of total revenue
- **Inventory Optimization**: Reduced stockouts through predictive trend analysis
- **Performance Metrics**: Automated KPI tracking and dashboard development

### **Strategic Insights**
- Customer lifetime value modeling for retention strategies
- Product performance analysis enabling data-driven inventory decisions
- Geographic sales patterns supporting market expansion planning
- Seasonal trends identification for optimal resource allocation

---

## 🚀 Installation & Setup

### Prerequisites
- MySQL 8.0+ / PostgreSQL 12+ / SQL Server 2019+
- Database management tools (MySQL Workbench, pgAdmin, SSMS)
- Git for version control

### Quick Start
```bash
# Clone the repository
git clone https://github.com/Mohamed-Makki/SQL_Projects-Data_Analytics.git

# Navigate to project directory
cd sql-projects

# Import sample databases
mysql -u username -p < database_setup.sql
```

### Project Structure
```
SQL_Projects-Data_Analytics/
├── 01-sales-analytics/        # Star schema e-commerce analysis
├── 02-library-management/     # CRUD operations and automation  
├── 03-spotify-analysis/       # Progressive music analytics
├── 04-music-store/           # Complex multi-table analysis
├── 05-retail-sales/          # Beginner-friendly EDA
└── 06-zepto-grocery/         # E-commerce optimization
```

---

## 📞 Contact

* **LinkedIn**: [Mohamed Makki](https://www.linkedin.com/in/mohamed-makki-ab5a10302/)
* **Email**: makki0749@gmail.com
* **Kaggle**: [Mohamed Makki](https://www.kaggle.com/mohamedmakkiabdelaal)