-- ================================================
-- FILE: sales_rep_performance.sql
-- PURPOSE: 
--   Classify sales reps into 'top', 'middle', or 'low' 
--   based on order count and total sales amount.
-- ================================================

SELECT 
    s.name, 
    COUNT(*) AS total_orders, 
    SUM(o.total_amt_usd) AS total_spent, 
    CASE 
        WHEN COUNT(*) > 200 OR SUM(o.total_amt_usd) > 750000 THEN 'top'
        WHEN COUNT(*) > 150 OR SUM(o.total_amt_usd) > 500000 THEN 'middle'
        ELSE 'low' 
    END AS sales_rep_level
FROM 
    orders o
    JOIN accounts a ON o.account_id = a.id 
    JOIN sales_reps s ON s.id = a.sales_rep_id
GROUP BY 
    s.name
ORDER BY 
    total_spent DESC;
