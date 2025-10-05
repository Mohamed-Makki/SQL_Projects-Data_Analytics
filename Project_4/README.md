# Music Database Analysis Project

This project aims to analyze a digital music store database using SQL, containing comprehensive information about artists, albums, tracks, customers, and invoices. The project demonstrates various SQL techniques from basic queries to advanced analytics.

## 📊 Database Schema

The database consists of the following interconnected tables:

### Core Tables:
- **artist** - Artist information
- **album** - Album details
- **track** - Individual music tracks
- **genre** - Music genres
- **media_type** - Media format types
- **playlist** - User-created playlists
- **playlist_track** - Junction table linking tracks to playlists
- **customer** - Customer information
- **employee** - Employee records
- **invoice** - Purchase invoices
- **invoice_line** - Detailed invoice line items

## 🔗 Setting up Relationships (Foreign Keys)

The first step in this project is establishing proper relationships between tables using foreign key constraints:

```sql
-- Link albums to artists
ALTER TABLE album
ADD CONSTRAINT FK_album
FOREIGN KEY(artist_id)
REFERENCES artist(artist_id);

-- Link tracks to albums
ALTER TABLE track
ADD CONSTRAINT FK_track_album
FOREIGN KEY(album_id)
REFERENCES album(album_id);

-- Link tracks to media types
ALTER TABLE track
ADD CONSTRAINT FK_track_medi_type
FOREIGN KEY(media_type_id)
REFERENCES media_type(media_type_id);

-- Link tracks to genres
ALTER TABLE track
ADD CONSTRAINT FK_track_genre
FOREIGN KEY(genre_id)
REFERENCES genre(genre_id);

-- Link playlist tracks to tracks
ALTER TABLE playlist_track
ADD CONSTRAINT FK_playlist_track_track
FOREIGN KEY(track_id)
REFERENCES track(track_id);

-- Link playlist tracks to playlists
ALTER TABLE playlist_track
ADD CONSTRAINT FK_playlist_track_playlist
FOREIGN KEY(playlist_id)
REFERENCES playlist(playlist_id);

-- Link invoice lines to tracks
ALTER TABLE invoice_line
ADD CONSTRAINT FK_invoiceline_track
FOREIGN KEY(track_id)
REFERENCES track(track_id);

-- Link invoice lines to invoices
ALTER TABLE invoice_line
ADD CONSTRAINT FK_invoiceline_invoice
FOREIGN KEY(invoice_id)
REFERENCES invoice(invoice_id);

-- Link invoices to customers
ALTER TABLE invoice
ADD CONSTRAINT FK_invoice_customer
FOREIGN KEY(customer_id)
REFERENCES customer(customer_id);
```

### Initial Data Exploration

After setting up the relationships, we explore all tables to understand the data structure:

```sql
SELECT * FROM album;
SELECT * FROM artist;
SELECT * FROM track;
SELECT * FROM invoice;
SELECT * FROM customer;
SELECT * FROM genre;
SELECT * FROM invoice_line;
SELECT * FROM employee;
SELECT * FROM media_type;
SELECT * FROM playlist;
SELECT * FROM playlist_track;
```

## 📝 Questions and Analysis

### 🟢 Easy Questions

#### 1. Who is the senior most employee based on job title?
**Objective:** Find the highest-ranking employee in the company
```sql
SELECT * FROM employee
ORDER BY levels DESC
LIMIT 1
```
**Explanation:** Sort employees by job level in descending order and select the top result

#### 2. Which country has the most invoices?
**Objective:** Identify the most active purchasing country
```sql
SELECT COUNT(*) AS C, billing_country
FROM invoice
GROUP BY billing_country
ORDER BY C DESC
LIMIT 1
```
**Explanation:** Count invoices per country and sort to find the highest

#### 3. What are the top 3 values of total invoices?
**Objective:** Find the highest-value purchases
```sql
SELECT * FROM invoice
ORDER BY total DESC
LIMIT 3
```

#### 4. Which city has the best customers?
**Objective:** Determine the best city for a promotional music festival
```sql
SELECT billing_country, SUM(total) AS sum_all_invoices
FROM invoice
GROUP BY billing_country
ORDER BY sum_all_invoices DESC
LIMIT 1
```
**Explanation:** Sum total invoice amounts by country to identify the most profitable market

#### 5. Who is the best customer?
**Objective:** Find the customer who has spent the most money
```sql
SELECT 
    customer.customer_id, 
    customer.first_name, 
    customer.last_name,
    SUM(invoice.total) AS money
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
GROUP BY customer.customer_id
ORDER BY money DESC
LIMIT 1
```

### 🟡 Moderate Questions

#### 6. Rock Music Listeners
**Objective:** Get email, first name, last name of all Rock music listeners, ordered alphabetically by email
```sql
SELECT 
    DISTINCT(cs.email),
    cs.first_name,
    cs.last_name
FROM customer AS cs
JOIN invoice AS inv ON cs.customer_id = inv.customer_id
JOIN invoice_line AS inl ON inl.invoice_id = inv.invoice_id
JOIN track AS tk ON inl.track_id = tk.track_id
JOIN genre AS gen ON tk.genre_id = gen.genre_id
WHERE gen.name LIKE 'Rock'
ORDER BY email
```
**Explanation:** Use multiple JOINs to connect customers to their music genre preferences

#### 7. Top 10 Rock Artists
**Objective:** Invite artists who have written the most rock music
```sql
SELECT 
    art.artist_id, 
    art.name,
    COUNT(art.artist_id) AS number_of_songs
FROM artist AS art
JOIN album AS al ON al.artist_id = art.artist_id
JOIN track AS tk ON tk.album_id = al.album_id
JOIN genre AS gen ON gen.genre_id = tk.genre_id
WHERE gen.name LIKE 'Rock'
GROUP BY art.artist_id, art.name
ORDER BY number_of_songs DESC
LIMIT 10
```

#### 8. Tracks Longer Than Average
**Objective:** Return track names and milliseconds for tracks longer than average length
```sql
SELECT name, milliseconds
FROM track
WHERE milliseconds > (
    SELECT AVG(milliseconds) FROM track
)
ORDER BY milliseconds DESC
```
**Explanation:** Use a subquery to calculate average track length and compare each track against it

### 🔴 Advanced Questions

#### 9. Customer Spending by Artist
**Objective:** Find how much each customer has spent on each artist
```sql
SELECT
    cs.customer_id,
    cs.first_name,
    cs.last_name,
    art.name,
    SUM(inl.unit_price * inl.quantity) AS total_spent
FROM customer AS cs
JOIN invoice AS inv ON inv.customer_id = cs.customer_id
JOIN invoice_line AS inl ON inl.invoice_id = inv.invoice_id
JOIN track AS tk ON inl.track_id = tk.track_id
JOIN album AS al ON al.album_id = tk.album_id
JOIN artist AS art ON al.artist_id = art.artist_id
GROUP BY cs.customer_id, cs.first_name, cs.last_name, art.name
ORDER BY total_spent DESC
```

#### 10. Most Popular Music Genre by Country
**Objective:** Find the most popular music genre for each country based on purchase quantity
```sql
WITH popular_genre AS (
    SELECT 
        COUNT(inl.quantity) AS purchases,
        cs.country,
        gen.name,
        gen.genre_id,
        ROW_NUMBER() OVER(PARTITION BY cs.country ORDER BY COUNT(inl.quantity) DESC) AS RowNum
    FROM customer AS cs
    JOIN invoice AS inv ON inv.customer_id = cs.customer_id
    JOIN invoice_line AS inl ON inl.invoice_id = inv.invoice_id
    JOIN track AS tk ON inl.track_id = tk.track_id
    JOIN genre AS gen ON gen.genre_id = tk.genre_id
    GROUP BY cs.country, gen.name, gen.genre_id
    ORDER BY cs.country, purchases DESC
)
SELECT * FROM popular_genre WHERE RowNum = 1
```
**Advanced Techniques Used:**
- **CTE (Common Table Expression)** for query organization
- **ROW_NUMBER() OVER PARTITION BY** for ranking within groups

#### 11. Top Customer by Country
**Objective:** Find the customer who has spent the most in each country
```sql
WITH customer_with_country AS (
    SELECT
        cs.customer_id,
        cs.first_name,
        cs.last_name,
        inv.billing_country,
        SUM(inv.total) AS total_spending,
        ROW_NUMBER() OVER(PARTITION BY inv.billing_country ORDER BY SUM(inv.total) DESC) AS RowNum
    FROM customer AS cs
    JOIN invoice AS inv ON inv.customer_id = cs.customer_id
    GROUP BY cs.customer_id, cs.first_name, cs.last_name, inv.billing_country
    ORDER BY inv.billing_country, total_spending DESC
)
SELECT * FROM customer_with_country WHERE RowNum = 1
```

## 🛠️ SQL Techniques and Concepts Used

### Basic SQL Operations:
- **SELECT, FROM, WHERE** - Fundamental query structure
- **ORDER BY, GROUP BY** - Sorting and grouping data
- **LIMIT** - Restricting result count
- **COUNT(), SUM(), AVG()** - Aggregate functions
- **DISTINCT** - Removing duplicates

### Intermediate Techniques:
- **JOIN Operations** - Connecting related tables
- **INNER JOIN** - Standard table relationships
- **Aliases** - Table and column naming for clarity
- **Conditional Filtering** - WHERE clauses with LIKE operator

### Advanced Concepts:
- **Subqueries** - Nested queries for complex logic
- **CTE (Common Table Expressions)** - Temporary named result sets
- **Window Functions** - ROW_NUMBER(), PARTITION BY
- **Complex JOINs** - Multi-table relationships
- **Aggregate Analysis** - Statistical calculations across groups

## 💡 Key Learning Outcomes

1. **Database Design:** Understanding the importance of foreign key relationships for data integrity
2. **Business Analysis:** Converting business questions into actionable SQL queries
3. **Performance Optimization:** Writing efficient queries for large datasets
4. **Reporting:** Creating meaningful business intelligence reports
5. **Data Relationships:** Navigating complex multi-table relationships

## 🎯 Business Value Achieved

### Customer Insights:
- Identification of high-value customers and markets
- Understanding of customer music preferences by geography
- Customer segmentation for targeted marketing

### Revenue Analysis:
- Financial performance tracking by region
- Artist popularity and revenue contribution analysis
- Purchase pattern identification

### Strategic Decision Support:
- Market prioritization for promotional events
- Artist partnership opportunities
- Geographic expansion insights

## 📈 Technical Accomplishments

- **Data Integrity:** Proper foreign key implementation
- **Query Complexity:** Progressive skill demonstration from basic to advanced
- **Window Functions:** Advanced analytical capabilities
- **Performance:** Efficient query design for business reporting
- **Scalability:** Queries designed to handle growing datasets

## 🚀 Future Enhancement Possibilities

### Advanced Analytics:
- **Time Series Analysis:** Seasonal trends and growth patterns
- **Customer Lifetime Value:** Predictive customer worth calculations
- **Cohort Analysis:** Customer behavior over time
- **Recommendation Engine:** Music suggestion algorithms

### Technical Improvements:
- **Indexing Strategy:** Performance optimization
- **Data Warehouse Design:** OLAP cube implementation
- **Real-time Dashboards:** Business intelligence visualization
- **Machine Learning Integration:** Predictive analytics

### Business Applications:
- **Dynamic Pricing Models:** Revenue optimization
- **Inventory Management:** Track popularity forecasting
- **Customer Retention:** Churn prediction and prevention
- **Market Expansion:** New territory analysis

## 📊 Project Impact

This project demonstrates the power of SQL in transforming raw business data into actionable insights. The progressive complexity of queries showcases comprehensive database analysis skills, from basic reporting to advanced business intelligence.

The analysis provides concrete value for business decision-making, including customer targeting, market expansion strategies, and revenue optimization opportunities.

---

*This project exemplifies how structured data analysis using SQL can drive informed business decisions and create competitive advantages in the digital music industry.*