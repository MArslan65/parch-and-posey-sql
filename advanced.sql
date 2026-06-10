-- =============================================
-- PARCH AND POSEY - ADVANCED SQL QUERIES
-- =============================================
-- Author: Muhammad Arslan
-- Database: PostgreSQL - Parch and Posey
-- Level: Advanced

-- =============================================
-- LESSON 1: CASE STATEMENTS
-- =============================================

-- categorize orders by size using CASE
SELECT account_id,
       total_amt_usd,
       CASE WHEN total_amt_usd > 10000 THEN 'Large Order'
            WHEN total_amt_usd > 5000 THEN 'Medium Order'
            WHEN total_amt_usd > 1000 THEN 'Small Order'
            ELSE 'Tiny Order'
       END AS order_size
FROM orders
ORDER BY total_amt_usd DESC;

-- count how many orders fall in each size category
SELECT CASE WHEN total_amt_usd > 10000 THEN 'Large Order'
            WHEN total_amt_usd > 5000 THEN 'Medium Order'
            WHEN total_amt_usd > 1000 THEN 'Small Order'
            ELSE 'Tiny Order'
       END AS order_size,
       COUNT(*) AS total_orders
FROM orders
GROUP BY order_size
ORDER BY total_orders DESC;

-- =============================================
-- LESSON 2: SUBQUERIES
-- =============================================

-- find all orders where total amount is above average
SELECT account_id,
       total_amt_usd
FROM orders
WHERE total_amt_usd > (SELECT AVG(total_amt_usd) FROM orders)
ORDER BY total_amt_usd DESC;

-- find accounts that have more orders than average
SELECT account_id,
       COUNT(*) AS total_orders
FROM orders
GROUP BY account_id
HAVING COUNT(*) > (SELECT AVG(order_count)
                   FROM (SELECT COUNT(*) AS order_count
                         FROM orders
                         GROUP BY account_id) AS avg_orders)
ORDER BY total_orders DESC;

-- =============================================
-- LESSON 3: CTEs (WITH STATEMENT)
-- =============================================

-- use CTE to find accounts with total revenue above 100000
WITH account_revenue AS (
    SELECT account_id,
           SUM(total_amt_usd) AS total_revenue
    FROM orders
    GROUP BY account_id
)
SELECT account_id,
       total_revenue
FROM account_revenue
WHERE total_revenue > 100000
ORDER BY total_revenue DESC;

-- use multiple CTEs to find top accounts and their sales reps
WITH account_revenue AS (
    SELECT account_id,
           SUM(total_amt_usd) AS total_revenue
    FROM orders
    GROUP BY account_id
),
top_accounts AS (
    SELECT account_id,
           total_revenue
    FROM account_revenue
    WHERE total_revenue > 100000
)
SELECT accounts.name AS company_name,
       sales_reps.name AS sales_rep_name,
       top_accounts.total_revenue
FROM top_accounts
INNER JOIN accounts ON top_accounts.account_id = accounts.id
INNER JOIN sales_reps ON accounts.sales_rep_id = sales_reps.id
ORDER BY total_revenue DESC;

-- =============================================
-- LESSON 4: WINDOW FUNCTIONS
-- =============================================

-- rank orders by total amount for each account
SELECT account_id,
       total_amt_usd,
       ROW_NUMBER() OVER (PARTITION BY account_id
                          ORDER BY total_amt_usd DESC) AS order_rank
FROM orders
ORDER BY account_id, order_rank;

-- calculate running total of revenue over time
SELECT account_id,
       occurred_at,
       total_amt_usd,
       SUM(total_amt_usd) OVER (PARTITION BY account_id
                                ORDER BY occurred_at) AS running_total
FROM orders
ORDER BY account_id, occurred_at;

-- find top 3 accounts by total revenue for each region
WITH account_revenue AS (
    SELECT region.name AS region_name,
           accounts.name AS company_name,
           SUM(orders.total_amt_usd) AS total_revenue
    FROM orders
    INNER JOIN accounts ON orders.account_id = accounts.id
    INNER JOIN sales_reps ON accounts.sales_rep_id = sales_reps.id
    INNER JOIN region ON sales_reps.region_id = region.id
    GROUP BY region.name, accounts.name
),
ranked_accounts AS (
    SELECT region_name,
           company_name,
           total_revenue,
           RANK() OVER (PARTITION BY region_name
                        ORDER BY total_revenue DESC) AS rank
    FROM account_revenue
)
SELECT region_name,
       company_name,
       total_revenue,
       rank
FROM ranked_accounts
WHERE rank <= 3
ORDER BY region_name, rank;

-- =============================================
-- LESSON 5: DATE FUNCTIONS
-- =============================================

-- extract year and month from order date
SELECT account_id,
       occurred_at,
       EXTRACT(YEAR FROM occurred_at) AS order_year,
       EXTRACT(MONTH FROM occurred_at) AS order_month,
       total_amt_usd
FROM orders
ORDER BY occurred_at;

-- calculate total revenue by month
SELECT DATE_TRUNC('month', occurred_at) AS month,
       SUM(total_amt_usd) AS total_revenue,
       COUNT(*) AS total_orders
FROM orders
GROUP BY DATE_TRUNC('month', occurred_at)
ORDER BY month;

-- calculate total revenue by year
SELECT EXTRACT(YEAR FROM occurred_at) AS order_year,
       SUM(total_amt_usd) AS total_revenue,
       COUNT(*) AS total_orders
FROM orders
GROUP BY EXTRACT(YEAR FROM occurred_at)
ORDER BY order_year;