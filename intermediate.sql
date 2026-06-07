-- =============================================
-- PARCH AND POSEY - INTERMEDIATE SQL QUERIES
-- =============================================
-- Author: Muhammad Arslan
-- Database: PostgreSQL - Parch and Posey
-- Level: Intermediate

-- =============================================
-- LESSON 1: ALIASES (AS)
-- =============================================

-- give columns a nickname using AS
SELECT id AS account_number,
       name AS company_name,
       website AS company_website
FROM accounts;

-- =============================================
-- LESSON 2: AGGREGATE FUNCTIONS
-- =============================================

-- count how many accounts exist in the database
SELECT COUNT(*) AS total_accounts
FROM accounts;

-- calculate total revenue from all orders
SELECT SUM(total_amt_usd) AS total_revenue
FROM orders;

-- calculate average order amount
SELECT AVG(total_amt_usd) AS average_order_amount
FROM orders;

-- find the smallest and biggest order amount
SELECT MIN(total_amt_usd) AS smallest_order,
       MAX(total_amt_usd) AS biggest_order
FROM orders;

-- get complete summary of all orders
SELECT COUNT(*) AS total_orders,
       SUM(total_amt_usd) AS total_revenue,
       AVG(total_amt_usd) AS average_order,
       MIN(total_amt_usd) AS smallest_order,
       MAX(total_amt_usd) AS biggest_order
FROM orders;

-- =============================================
-- LESSON 3: GROUP BY
-- =============================================

-- calculate total revenue for each account
SELECT account_id,
       SUM(total_amt_usd) AS total_revenue
FROM orders
GROUP BY account_id
ORDER BY total_revenue DESC;

-- count how many orders each account has placed
SELECT account_id,
       COUNT(*) AS total_orders
FROM orders
GROUP BY account_id
ORDER BY total_orders DESC;

-- calculate total events for each channel
SELECT account_id,
       channel,
       COUNT(*) AS total_events
FROM web_events
GROUP BY account_id, channel
ORDER BY account_id ASC, total_events DESC;

-- =============================================
-- LESSON 4: HAVING
-- =============================================

-- show only accounts that spent more than 100000 dollars total
SELECT account_id,
       SUM(total_amt_usd) AS total_revenue
FROM orders
GROUP BY account_id
HAVING SUM(total_amt_usd) > 100000
ORDER BY total_revenue DESC;

-- =============================================
-- LESSON 5: JOINS
-- =============================================

-- join accounts and orders to see company name with their orders
SELECT accounts.name AS company_name,
       orders.total_amt_usd AS order_amount,
       orders.occurred_at AS order_date
FROM orders
INNER JOIN accounts ON orders.account_id = accounts.id;

-- show all accounts even if they have no orders
SELECT accounts.name AS company_name,
       accounts.website,
       orders.total_amt_usd AS order_amount
FROM accounts
LEFT JOIN orders ON accounts.id = orders.account_id
ORDER BY accounts.name;

-- join accounts, orders and sales_reps together
SELECT accounts.name AS company_name,
       sales_reps.name AS sales_rep_name,
       orders.total_amt_usd AS order_amount
FROM orders
INNER JOIN accounts ON orders.account_id = accounts.id
INNER JOIN sales_reps ON accounts.sales_rep_id = sales_reps.id
ORDER BY order_amount DESC;

-- join all 5 tables together
SELECT region.name AS region_name,
       sales_reps.name AS sales_rep_name,
       accounts.name AS company_name,
       orders.total_amt_usd AS order_amount,
       web_events.channel AS channel
FROM orders
INNER JOIN accounts ON orders.account_id = accounts.id
INNER JOIN sales_reps ON accounts.sales_rep_id = sales_reps.id
INNER JOIN region ON sales_reps.region_id = region.id
INNER JOIN web_events ON accounts.id = web_events.account_id
ORDER BY order_amount DESC
LIMIT 20;

-- find which region makes the most total revenue
SELECT region.name AS region_name,
       SUM(orders.total_amt_usd) AS total_revenue
FROM orders
INNER JOIN accounts ON orders.account_id = accounts.id
INNER JOIN sales_reps ON accounts.sales_rep_id = sales_reps.id
INNER JOIN region ON sales_reps.region_id = region.id
GROUP BY region.name
ORDER BY total_revenue DESC;