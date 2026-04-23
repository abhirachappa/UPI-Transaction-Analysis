CREATE DATABASE upi_analysis;
USE upi_analysis;

-- CREATING A USERS TABLE

CREATE TABLE users (
    user_id INT PRIMARY KEY,
    sender_age_group VARCHAR(20),
    sender_state VARCHAR(50),
    sender_bank VARCHAR(50)
);

-- CREATING A RECEIVERS TABLE

CREATE TABLE receivers (
    receiver_id INT PRIMARY KEY,
    receiver_age_group VARCHAR(20),
    receiver_bank VARCHAR(50)
);

-- CREATING TRANSACTIONS TABLE

CREATE TABLE transactions (
    transaction_id VARCHAR(50) PRIMARY KEY,
    timestamp DATETIME,
    amount INT,
    transaction_status VARCHAR(20),
    fraud_flag INT,
    user_id INT,
    receiver_id INT,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (receiver_id) REFERENCES receivers(receiver_id)
);

-- CREATING TRANSACTIONS DETAILS TABLE

CREATE TABLE transaction_details (
    id INT AUTO_INCREMENT PRIMARY KEY,
    transaction_id VARCHAR(50),
    transaction_type VARCHAR(50),
    merchant_category VARCHAR(50),
    device_type VARCHAR(20),
    network_type VARCHAR(20),
    hour_of_day INT,
    day_of_week VARCHAR(20),
    is_weekend INT,
    FOREIGN KEY (transaction_id) REFERENCES transactions(transaction_id)
);

-- ============================================
-- TASK 1: MASTER DATASET (JOIN ALL TABLES)
-- ============================================

-- Insight:
-- This query integrates multiple tables into a unified dataset.
-- It combines transaction, user, receiver, and category information.
-- Serves as the base dataset for further analysis.


SELECT 
    t.transaction_id,
    t.amount,
    t.transaction_status,
    u.sender_state,
    r.receiver_bank,
    d.merchant_category
FROM transactions t
JOIN users u ON t.user_id = u.user_id
JOIN receivers r ON t.receiver_id = r.receiver_id
JOIN transaction_details d ON t.transaction_id = d.transaction_id
LIMIT 10;


-- ============================================
-- TASK 2: TOTAL SPENDING BY CATEGORY
-- ============================================

-- Insight:
-- This query identifies which merchant categories generate the highest spending.
-- It helps understand customer purchase behavior and top revenue-driving segments.
-- Businesses can use this to focus marketing and optimize high-performing categories.

SELECT 
    d.merchant_category,
    SUM(t.amount) AS total_spending
FROM transactions t
JOIN transaction_details d 
ON t.transaction_id = d.transaction_id
GROUP BY d.merchant_category
ORDER BY total_spending DESC;

-- Key findings:
-- Shopping is the highest revenue-generating category, indicating strong consumer preference for retail purchases via UPI. 
-- Grocery and Utilities also contribute significantly, showing that digital payments are widely used for daily essential spending. 
-- Lower spending in categories like Transport and Healthcare suggests either lower transaction frequency or smaller ticket sizes in these segments.


-- ============================================
-- TASK 3: TOP STATES BY TRANSACTION VALUE
-- ============================================

-- Insight:
-- This query identifies which states contribute the most to total transaction value.
-- It helps understand regional spending patterns and high-value markets.
-- Businesses can use this for targeted expansion and marketing strategies.

SELECT 
    u.sender_state,
    SUM(t.amount) AS total_amount
FROM transactions t
JOIN users u 
ON t.user_id = u.user_id
GROUP BY u.sender_state
ORDER BY total_amount DESC;

-- Key findings:
-- Maharashtra, Uttar Pradesh, and Karnataka are the top contributors to total transaction value,indicating strong adoption of digital payments in these regions. 
-- These states represent high-value markets with significant transaction activity. 
-- In contrast, states like Rajasthan and West Bengal show relatively lower contribution, suggesting potential opportunities for growth and targeted expansion strategies.


-- ============================================
-- TASK 4: RANK CATEGORIES BY SPENDING
-- ============================================

-- Insight:
-- This query ranks merchant categories based on total spending using window functions.
-- It helps in identifying top-performing and low-performing categories in a structured manner.
-- Ranking provides better clarity compared to simple aggregation.

SELECT 
    merchant_category,
    total_spending,
    RANK() OVER (ORDER BY total_spending DESC) AS rank_position
FROM (
    SELECT 
        d.merchant_category,
        SUM(t.amount) AS total_spending
    FROM transactions t
    JOIN transaction_details d 
    ON t.transaction_id = d.transaction_id
    GROUP BY d.merchant_category
) AS sub;


-- Key findings:
-- Shopping ranks as the top category in terms of total spending, followed by Grocery and Utilities.
-- The ranking highlights clear differences in consumer spending behavior across categories.
-- Lower-ranked categories such as Transport and Healthcare indicate comparatively lower transaction values, suggesting smaller ticket sizes or lower frequency of transactions.
-- Using window functions like RANK() provides a structured way to compare performance across categories.


-- ============================================
-- TASK 5: FRAUD ANALYSIS BY CATEGORY
-- ============================================

-- Insight:
-- This query identifies which merchant categories have the highest number of fraudulent transactions.
-- It helps detect high-risk segments and supports fraud prevention strategies.
-- Businesses can use this to strengthen security measures in vulnerable categories.

SELECT 
    d.merchant_category,
    COUNT(*) AS fraud_cases
FROM transactions t
JOIN transaction_details d 
ON t.transaction_id = d.transaction_id
WHERE t.fraud_flag = 1
GROUP BY d.merchant_category
ORDER BY fraud_cases DESC;


-- Key findings:
-- Fraud cases are very low and evenly distributed across categories such as Other, Utilities, and Entertainment, each having only one case.
-- This indicates that fraud occurrence is rare in the dataset and does not show a strong pattern toward any specific category.
-- Due to the small dataset size, no definitive high-risk category can be identified,but the analysis demonstrates the ability to detect and evaluate fraud patterns.


-- ============================================
-- TASK 6: CTE - ABOVE AVERAGE SPENDING CATEGORIES
-- ============================================

-- Insight:
-- This query identifies categories with spending above the overall average.
-- It helps focus on high-performing segments while filtering out lower-performing ones.
-- CTE improves readability and makes complex queries easier to manage.

WITH category_spending AS (
    SELECT 
        d.merchant_category,
        SUM(t.amount) AS total_spending
    FROM transactions t
    JOIN transaction_details d 
    ON t.transaction_id = d.transaction_id
    GROUP BY d.merchant_category
)

SELECT *
FROM category_spending
WHERE total_spending > (
    SELECT AVG(total_spending) FROM category_spending
);

-- Key findings:
-- Categories such as Shopping, Grocery, Utilities, Education, and Fuel have spending above the overall average, making them high-performing segments.
-- These categories contribute significantly to total transaction value and represent key areas of consumer spending.
-- Businesses can prioritize these segments for marketing, offers, and strategic growth.
-- The use of CTE improves query readability and simplifies complex aggregations.


-- ============================================
-- TASK 7: HOURLY TRANSACTION ANALYSIS
-- ============================================

-- Insight:
-- This query analyzes transaction value across different hours of the day.
-- It helps identify peak transaction periods and user activity patterns.
-- Businesses can use this information for optimizing system performance and 
-- scheduling promotions during high-activity hours.

SELECT 
    d.hour_of_day,
    SUM(t.amount) AS total_spending
FROM transactions t
JOIN transaction_details d 
ON t.transaction_id = d.transaction_id
GROUP BY d.hour_of_day
ORDER BY d.hour_of_day;

-- Key findings:
-- Peak transaction activity occurs in the evening hours, with the highest spending observed at 17:00 (5 PM), followed by 19:00 and 13:00. 
-- This indicates that users are most active during post-work and afternoon periods. 
-- Early morning hours show significantly lower activity, suggesting limited transaction usage during that time.
-- This pattern can help businesses optimize server load and schedule promotions during peak hours.


-- ============================================
-- TASK 8: CREATE ANALYTICAL VIEW
-- ============================================

-- Insight:
-- This view combines all relevant tables into a single dataset for easy analysis.
-- It simplifies querying and can be reused for dashboards and reporting.
-- Views improve efficiency and maintainability in real-world database systems.

CREATE VIEW upi_analysis_view AS
SELECT 
    t.transaction_id,
    t.amount,
    t.transaction_status,
    t.fraud_flag,
    u.sender_state,
    u.sender_age_group,
    r.receiver_bank,
    d.merchant_category,
    d.transaction_type,
    d.device_type,
    d.network_type,
    d.hour_of_day,
    d.day_of_week,
    d.is_weekend
FROM transactions t
JOIN users u ON t.user_id = u.user_id
JOIN receivers r ON t.receiver_id = r.receiver_id
JOIN transaction_details d ON t.transaction_id = d.transaction_id;

SELECT * FROM upi_analysis_view LIMIT 10;


-- ============================================
-- STORED PROCEDURE 1: TOP CATEGORIES
-- ============================================

-- Insight:
-- This procedure returns categories ranked by total spending.
-- It helps quickly identify top-performing segments without rewriting queries.

DELIMITER //

CREATE PROCEDURE get_top_categories()
BEGIN
    SELECT 
        d.merchant_category,
        SUM(t.amount) AS total_spending
    FROM transactions t
    JOIN transaction_details d 
    ON t.transaction_id = d.transaction_id
    GROUP BY d.merchant_category
    ORDER BY total_spending DESC;
END //

DELIMITER ;

CALL get_top_categories();


-- ============================================
-- STORED PROCEDURE 2: FILTER BY STATE
-- ============================================

-- Insight:
-- This procedure allows dynamic filtering of transaction data by state.
-- It enables flexible analysis based on user input.

DELIMITER //

CREATE PROCEDURE get_state_spending(IN state_name VARCHAR(50))
BEGIN
    SELECT 
        u.sender_state,
        SUM(t.amount) AS total_spending
    FROM transactions t
    JOIN users u 
    ON t.user_id = u.user_id
    WHERE u.sender_state = state_name
    GROUP BY u.sender_state;
END //

DELIMITER ;

CALL get_state_spending('Maharashtra');


-- ============================================
-- STORED PROCEDURE 3: CATEGORY LEVEL
-- ============================================

-- Insight:
-- This procedure classifies categories into high or low spending based on threshold.
-- Demonstrates use of control flow logic in SQL.

DELIMITER //

CREATE PROCEDURE category_level()
BEGIN
    SELECT 
        d.merchant_category,
        SUM(t.amount) AS total_spending,
        CASE 
            WHEN SUM(t.amount) > 200000 THEN 'High'
            ELSE 'Low'
        END AS category_level
    FROM transactions t
    JOIN transaction_details d 
    ON t.transaction_id = d.transaction_id
    GROUP BY d.merchant_category;
END //

DELIMITER ;

CALL category_level();


-- ============================================
-- FINAL INSIGHTS: UPI TRANSACTION ANALYSIS
-- ============================================

-- Insight 1: Consumer Spending Behavior
-- Shopping emerged as the highest spending category, followed by Grocery and Utilities,
-- indicating strong consumer preference for retail and essential services through UPI.

-- Insight 2: High-Value Categories
-- Categories such as Shopping, Grocery, Utilities, Education, and Fuel consistently
-- performed above average, making them key revenue-driving segments.

-- Insight 3: Regional Trends
-- Maharashtra, Uttar Pradesh, and Karnataka contributed the highest transaction values,
-- reflecting strong digital payment adoption and economic activity in these regions.

-- Insight 4: Time-Based Usage Patterns
-- Peak transaction activity occurs during evening hours, especially around 5 PM,
-- suggesting increased usage after working hours. Early morning hours show minimal activity.

-- Insight 5: Fraud Analysis
-- Fraud cases are minimal and evenly distributed across categories, indicating low
-- overall fraud occurrence in the dataset. No specific category shows significant risk.

-- Insight 6: Transaction Patterns
-- Digital payments are widely used across multiple categories, demonstrating the
-- versatility and widespread adoption of UPI for both essential and non-essential spending.

-- Insight 7: System Design & Optimization
-- The use of normalized tables, joins, CTEs, window functions, and stored procedures
-- ensures efficient data processing and scalable analytical workflows.

-- Insight 8: Business Recommendations
-- - Focus marketing efforts on top-performing categories like Shopping and Grocery
-- - Target high-value states for expansion and partnerships
-- - Optimize system performance during peak hours (evenings)
-- - Continue monitoring fraud patterns despite low occurrence

