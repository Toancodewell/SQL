-- ================================================
-- FILE: advanced_sales_queries.sql
-- PURPOSE: 
--   1. Get average product quantities for the first order month.
--   2. Identify top-performing sales rep in each region.
--   3. Find number of orders in the region with highest total sales.
-- AUTHOR: Nguyễn Văn Toàn
-- ================================================

-- ================================================
-- PART 1: Average quantities in the earliest month of orders.
-- ================================================
SELECT 
    AVG(standard_qty) AS avg_std, 
    AVG(gloss_qty) AS avg_gls, 
    AVG(poster_qty) AS avg_pst
FROM 
    orders
WHERE 
    DATE_TRUNC('month', occurred_at) = (
        SELECT DATE_TRUNC('month', MIN(occurred_at)) 
        FROM orders
    );

-- ================================================
-- PART 2: Top sales rep (by revenue) in each region.
-- ================================================
SELECT 
    t3.rep_name, 
    t3.region_name, 
    t3.total_amt
FROM (
    SELECT 
        region_name, 
        MAX(total_amt) AS total_amt
    FROM (
        SELECT 
            s.name AS rep_name, 
            r.name AS region_name, 
            SUM(o.total_amt_usd) AS total_amt
        FROM 
            sales_reps s
            JOIN accounts a ON a.sales_rep_id = s.id
            JOIN orders o ON o.account_id = a.id
            JOIN region r ON r.id = s.region_id
        GROUP BY 
            1, 2
    ) t1
    GROUP BY 
        1
) t2
JOIN (
    SELECT 
        s.name AS rep_name, 
        r.name AS region_name, 
        SUM(o.total_amt_usd) AS total_amt
    FROM 
        sales_reps s
        JOIN accounts a ON a.sales_rep_id = s.id
        JOIN orders o ON o.account_id = a.id
        JOIN region r ON r.id = s.region_id
    GROUP BY 
        1, 2
    ORDER BY 
        3 DESC
) t3
ON 
    t3.region_name = t2.region_name 
    AND t3.total_amt = t2.total_amt;

-- ================================================
-- PART 3: Total orders in the region with highest sales.
-- ================================================
SELECT 
    r.name, 
    COUNT(o.total) AS total_orders
FROM 
    sales_reps s
    JOIN accounts a ON a.sales_rep_id = s.id
    JOIN orders o ON o.account_id = a.id
    JOIN region r ON r.id = s.region_id
GROUP BY 
    r.name
HAVING 
    SUM(o.total_amt_usd) = (
        SELECT 
            MAX(total_amt)
        FROM (
            SELECT 
                r.name AS region_name, 
                SUM(o.total_amt_usd) AS total_amt
            FROM 
                sales_reps s
                JOIN accounts a ON a.sales_rep_id = s.id
                JOIN orders o ON o.account_id = a.id
                JOIN region r ON r.id = s.region_id
            GROUP BY 
                r.name
        ) sub
    );
