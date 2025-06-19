-- ================================================
-- FILE: monthly_sales_analysis.sql
-- PURPOSE: 
--   1. Get monthly total spending from 2014–2017.
--   2. Find the month Walmart spent the most.
-- ================================================

-- ================================================
-- PART 1: Monthly total spending from all customers.
-- ================================================
SELECT 
    DATE_PART('month', occurred_at) AS ord_month,
    SUM(total_amt_usd) AS total_spent
FROM 
    orders
WHERE 
    occurred_at BETWEEN '2014-01-01' AND '2017-01-01'
GROUP BY 
    1
ORDER BY 
    2 DESC;

-- ================================================
-- PART 2: Top spending month for Walmart.
-- ================================================
SELECT 
    DATE_TRUNC('month', o.occurred_at) AS ord_date,
    SUM(o.gloss_amt_usd) AS tot_spent
FROM 
    orders o
    JOIN accounts a ON a.id = o.account_id
WHERE 
    a.name = 'Walmart'
GROUP BY 
    1
ORDER BY 
    2 DESC
LIMIT 1;
