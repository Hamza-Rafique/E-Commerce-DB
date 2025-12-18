![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)
![Neon](https://img.shields.io/badge/Neon-000000?style=for-the-badge&logo=neon&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-CC2927?style=for-the-badge&logo=postgresql&logoColor=white)
![GitHub](https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white)

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](http://makeapullrequest.com)
# 🛍️ E-Commerce Database Project

A complete PostgreSQL database for an e-commerce platform with realistic data and 20+ analytical queries.

## 🚀 Features

- **5 Normalized Tables**: Users, Products, Categories, Orders, Order Items
- **Realistic Sample Data**: 100+ records across all tables
- **20+ Analytical Queries**: From basic to advanced business intelligence
- **Performance Optimized**: Proper indexes and constraints
- **Abandoned Cart Analysis**: Specialized e-commerce analytics
- **Customer Segmentation**: RFM analysis and behavior tracking

## 📊 Database Schema

![ER Diagram](docs/ER_Diagram.md)

### Tables:
1. **users** - Customer information
2. **products** - Product catalog with inventory
3. **categories** - Hierarchical product categories
4. **orders** - Customer orders with status tracking
5. **order_items** - Line items for each order
6. **cart_items** - Shopping cart data (for abandoned cart analysis)

## 🛠️ Setup Instructions

### Using Neon PostgreSQL:

1. **Create a Neon account** at [neon.tech](https://neon.tech)
2. **Create a new project** called `ecommerce-db`
3. **Copy your connection string**
4. **Run the setup script**:

```bash
# Make the setup script executable
chmod +x scripts/setup_database.sh

# Run the setup (update with your Neon connection string)
./scripts/setup_database.sh "your_neon_connection_string"

#Manual Setup:
```bash
-- 1. Create tables
\i database/schema/01_create_tables.sql

-- 2. Create indexes
\i database/schema/02_create_indexes.sql

-- 3. Insert sample data
\i database/data/01_insert_categories.sql
\i database/data/02_insert_users.sql
\i database/data/03_insert_products.sql
\i database/data/04_insert_orders.sql
\i database/data/05_insert_cart_items.sql
```
## 📈 Analytical Queries
The project includes 4 categories of queries:

### 1. Basic Queries (queries/01_basic_queries.sql)
 - Simple SELECT statements
 - Basic JOIN operations
 - Filtering and sorting

### 2. Analytical Queries (queries/02_analytical_queries.sql)
 - Revenue analysis by category
 - Customer segmentation
 - Product performance
 - Sales trends

### 3. Advanced Queries (queries/03_advanced_queries.sql)
 - Customer Lifetime Value (CLV)
 - Product affinity analysis
 - Inventory turnover
 - Cohort analysis

### 4. Business Reports (queries/04_business_reports.sql)
    - Executive dashboard
    - Monthly performance reports
    - Abandoned cart analysis
    - Inventory restock alerts

## 📊 Sample Business Insights
### Top 5 Customers by Lifetime Value:
    - VIP customers (> $2000 spent)
    - Regular customers ($500-$2000)
    -Occasional customers (< $500)

### Revenue by Category:

   - Electronics leads with 45% of revenue
   - Furniture has highest average order value
  -  Clothing has highest unit sales

### Abandoned Cart Analysis:

   - 12% cart abandonment rate
  -  $2,500+ in potential lost revenue
   - Most abandoned items: Electronics

## 🧪 Testing
Run test queries to verify setup:
``bash
-- Test data integrity
\i tests/test_queries.sql

-- Compare with expected results
cat tests/expected_results.md
```
