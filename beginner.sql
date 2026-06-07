-- =============================================
-- PARCH AND POSEY - BEGINNER SQL QUERIES
-- =============================================
-- Author: Muhammad Arslan
-- Database: PostgreSQL - Parch and Posey
-- Level: Beginner

-- =============================================
-- LESSON 1: SELECT AND FROM
-- =============================================

-- show all columns from accounts table
SELECT *
FROM accounts;

-- show only name and website from accounts table
SELECT name, website
FROM accounts;

-- show id, name, website and primary_poc from accounts table
SELECT id, name, website, primary_poc
FROM accounts;

-- show account_id, standard_qty, gloss_qty, poster_qty and total from orders table
SELECT account_id, standard_qty, gloss_qty, poster_qty, total
FROM orders;

-- =============================================
-- LESSON 2: LIMIT
-- =============================================

-- show only first 10 rows from orders table
SELECT *
FROM orders
LIMIT 10;

-- show only first 5 rows of name and website from accounts table
SELECT name, website
FROM accounts
LIMIT 5;

-- =============================================
-- LESSON 3: ORDER BY
-- =============================================

-- show all accounts sorted by name from A to Z
SELECT id, name, website
FROM accounts
ORDER BY name;

-- show orders sorted by total amount from highest to lowest
SELECT account_id, total_amt_usd, total
FROM orders
ORDER BY total_amt_usd DESC;

-- show top 10 biggest orders by total amount
SELECT account_id, total_amt_usd, total
FROM orders
ORDER BY total_amt_usd DESC
LIMIT 10;

-- show orders sorted by account_id first then by total amount highest to lowest
SELECT account_id, total_amt_usd, total
FROM orders
ORDER BY account_id ASC, total_amt_usd DESC;

-- =============================================
-- LESSON 4: WHERE
-- =============================================

-- show only orders where total amount is greater than 1000 dollars
SELECT account_id, total_amt_usd, total
FROM orders
WHERE total_amt_usd > 1000;

-- show only the account where name is equal to Mastercard
SELECT id, name, website
FROM accounts
WHERE name = 'Mastercard';

-- =============================================
-- LESSON 5: AND, OR, NOT
-- =============================================

-- show orders where total amount is greater than 1000 AND standard quantity is greater than 100
SELECT account_id, total_amt_usd, standard_qty
FROM orders
WHERE total_amt_usd > 1000 AND standard_qty > 100;

-- show orders where total amount is greater than 5000 OR poster quantity is greater than 100
SELECT account_id, total_amt_usd, poster_qty
FROM orders
WHERE total_amt_usd > 5000 OR poster_qty > 100;

-- show all accounts where name is NOT equal to Mastercard
SELECT id, name, website
FROM accounts
WHERE name != 'Mastercard';

-- =============================================
-- LESSON 6: IN
-- =============================================

-- show accounts where name is Mastercard, Apple or Google
SELECT id, name, website
FROM accounts
WHERE name IN ('Mastercard', 'Apple', 'Google');

-- =============================================
-- LESSON 7: BETWEEN
-- =============================================

-- show orders where total amount is between 1000 and 5000 dollars
SELECT account_id, total_amt_usd, total
FROM orders
WHERE total_amt_usd BETWEEN 1000 AND 5000;

-- =============================================
-- LESSON 8: LIKE
-- =============================================

-- show all accounts where name starts with C
SELECT id, name, website
FROM accounts
WHERE name LIKE 'C%';

-- show all accounts where name contains the word one anywhere
SELECT id, name, website
FROM accounts
WHERE name LIKE '%one%';

-- show all accounts where name ends with s
SELECT id, name, website
FROM accounts
WHERE name LIKE '%s';