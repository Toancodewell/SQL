-- Purpose: This SQL script contains two parts, each serving different analytical goals.

-- PART 1: Retrieve the top 2 highest total order amounts (total_amt_usd) 
--         from the bottom 3457 orders when sorted in ascending order.
-- Explanation:
--   - First, a CTE (Common Table Expression) named `tb1` selects the lowest 3457 values 
--     of `total_amt_usd` from the `orders` table.
--   - Then, from these 3457 records, we select the top 2 highest values by sorting in descending order.

WITH tb1 AS (
    SELECT total_amt_usd
    FROM orders
    ORDER BY total_amt_usd
    LIMIT 3457
)
SELECT *
FROM tb1
ORDER BY total_amt_usd DESC
LIMIT 2;


-- PART 2: Find out the number of total orders placed in the region 
--         that had the highest total sales (`total_amt_usd`).
-- Explanation:
--   - CTE `t1` computes the total sales per region by joining the `sales_reps`, `accounts`, 
--     `orders`, and `region` tables.
--   - CTE `t2` retrieves the maximum total sales amount across all regions.
--   - The final query counts the number of orders (`COUNT(o.total)`) in the region(s) whose
--     total sales match the maximum found in `t2`.

WITH t1 AS (
      SELECT r.name region_name, SUM(o.total_amt_usd) total_amt
      FROM sales_reps s
      JOIN accounts a
      ON a.sales_rep_id = s.id
      JOIN orders o
      ON o.account_id = a.id
      JOIN region r
      ON r.id = s.region_id
      GROUP BY r.name), 
t2 AS (
      SELECT MAX(total_amt)
      FROM t1)
SELECT r.name, COUNT(o.total) total_orders
FROM sales_reps s
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
JOIN region r
ON r.id = s.region_id
GROUP BY r.name
HAVING SUM(o.total_amt_usd) = (SELECT * FROM t2);
