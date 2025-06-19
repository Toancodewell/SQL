-- ================================================
-- PURPOSE:
--   1. Calculate cumulative (running) total of standard_amt_usd 
--      ordered by occurred_at.
--   2. Calculate yearly cumulative totals using PARTITION BY.
-- ================================================

-- ================================================
-- PART 1: Running total across all orders based on occurred_at.
-- ================================================
SELECT 
    standard_amt_usd,
    SUM(standard_amt_usd) OVER (ORDER BY occurred_at) AS running_total
FROM 
    orders;
-- Explanation: Computes the cumulative sum of standard_amt_usd 
--              in chronological order using window function.

-- ================================================
-- PART 2: Running total reset for each year (partitioned by year).
-- ================================================
SELECT 
    standard_amt_usd,
    DATE_TRUNC('year', occurred_at) AS year,
    SUM(standard_amt_usd) OVER (
        PARTITION BY DATE_TRUNC('year', occurred_at) 
        ORDER BY occurred_at
    ) AS running_total
FROM 
    orders;
-- Explanation: Uses PARTITION BY to calculate running totals 
--              separately for each year.


-- ================================================
-- PURPOSE:
--   Assign a rank to each order per account based on the order total,
--   in descending order.
--   Note: Orders with the same total receive the same rank (RANK()).
-- ================================================

SELECT 
    id,
    account_id,
    total,
    RANK() OVER (
        PARTITION BY account_id 
        ORDER BY total DESC
    ) AS total_rank
FROM 
    orders;

-- Explanation:
-- - RANK() assigns the same rank to rows with equal total amounts.
-- - Ranking restarts for each account (PARTITION BY account_id).
