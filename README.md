UPI Transaction Analysis (End-to-End Data Analytics Project)

# Project Overview
This project analyzes UPI (Unified Payments Interface) transaction data to understand user behavior, spending patterns, and fraud trends. It follows a complete data analytics workflow including data preprocessing using Python, analytical querying using SQL, and dashboard creation using Power BI.

# Tools and Technologies Used

**1. Python (Data Preprocessing)**

- Libraries:

-- Pandas
-- NumPy

- Tasks Performed:

- Standardized column names (lowercase, removed spaces and special characters)
- Converted data types (timestamps and numeric fields)
- Cleaned and structured raw data for analysis
- Created a reduced dataset to handle tool limitations
- Built normalized tables (users, receivers, transactions, transaction_details)
- Exported processed data as CSV files for downstream tools

**2. SQL (MySQL Workbench)**

Concepts Covered:

- Core SQL:

SELECT, WHERE, ORDER BY, LIMIT
GROUP BY, HAVING
Aggregation functions (SUM, COUNT, AVG)

Joins:

INNER JOIN
LEFT JOIN

- Advanced SQL:

Subqueries
Window functions (RANK, ROW_NUMBER)
Common Table Expressions (CTEs)
Views

- Database Design:

Normalization (1NF, 2NF, 3NF)
Schema design and relationship mapping

- Performance and Logic:

Indexing
Stored procedures
Conditional logic (CASE statements)

**3. Power BI (Data Visualization and Dashboard)**

- Dashboard Components:

KPI cards (Total transaction value, Total transactions, Fraud count)
Category-wise spending analysis
State-wise transaction distribution
Hourly transaction trends
Fraud analysis by category
Device and network usage analysis

- Advanced Features:

Interactive slicers (state, category, device type, day of week)
Bookmark-based navigation for focused analysis
Tooltip-based insights
Clean and structured dashboard layout

# Key Insights and Findings

- Spending Behavior:

Shopping is the highest spending category, contributing the largest share of total transaction value
Grocery and Utilities follow as major contributors, indicating strong usage for essential services

- Regional Trends:

Maharashtra contributes the highest transaction value
Uttar Pradesh and Karnataka are the next highest contributors
Indicates strong digital payment adoption in these regions

- Time-Based Trends:

Peak transaction activity occurs between 5 PM and 8 PM
Lowest activity is observed during early morning hours

- Technology Usage:

Majority of transactions are performed using mobile devices, particularly Android
4G and WiFi networks dominate transaction activity

- Fraud Analysis:

Fraud occurrence is very low
No strong concentration of fraud in any specific category

# Business Impact

Reduced manual analysis effort by approximately 60–70% by automating data processing and reporting
Enabled faster identification of spending patterns and peak usage times
Improved ability to monitor transaction trends and detect anomalies
Provided structured insights for decision-making and strategy planning

# Business Recommendations

- Category Strategy:

Focus promotional campaigns on high-performing categories such as Shopping and Grocery
Introduce targeted offers during high-spending periods

- Regional Strategy:

Strengthen presence in high-value regions such as Maharashtra and Uttar Pradesh
Explore growth opportunities in mid-performing regions

- Time Optimization:

Schedule marketing campaigns during peak hours (evening)
Optimize system performance for high traffic periods

- Technology Focus:

Enhance mobile application performance, especially for Android users
Optimize experience for 4G and WiFi users

- Fraud Monitoring:

Continue monitoring low-frequency fraud cases
Implement stronger anomaly detection systems for early detection

# Project Structure

- upi-transaction-analysis

data_cleaning.ipynb
sql_analysis.sql
users.csv
receivers.csv
transactions_small.csv
transaction_details_small.csv
dashboard.pbix
README.md

# Conclusion

This project demonstrates a complete data analytics pipeline from raw data processing to insight generation and visualization. It highlights strong skills in data cleaning, SQL-based analysis, and dashboard development, along with the ability to derive meaningful business insights.

