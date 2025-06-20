-- ================================================
-- FILE: lag_difference_by_account.sql
-- PURPOSE:
--   1. Calculate total standard quantity per account.
--   2. Use LAG() to compare each account's total to the previous one.
--   3. Compute the difference in standard_sum between consecutive accounts.
-- ================================================

SELECT 
    account_id,
    standard_sum,
    LAG(standard_sum) OVER (ORDER BY standard_sum) AS lag,
    standard_sum - LAG(standard_sum) OVER (ORDER BY standard_sum) AS lag_difference
FROM (
    SELECT 
        account_id,
        SUM(standard_qty) AS standard_sum
    FROM 
        orders 
    GROUP BY 
        1
) sub;

-- Explanation:
-- - LAG() retrieves the standard_sum of the previous row based on ordering.
-- - lag_difference shows how much standard_sum increased (or decreased)
--   compared to the previous account in the sorted list.
-- ================================================
-- ================================================
-- FILE: standard_qty_quartile.sql
-- PURPOSE:
--   Divide each account's orders into 4 quartiles 
--   based on standard quantity ordered.
-- ================================================

SELECT
    account_id,
    occurred_at,
    standard_qty,
    NTILE(4) OVER (
        PARTITION BY account_id 
        ORDER BY standard_qty
    ) AS standard_quartile
FROM 
    orders 
ORDER BY 
    account_id DESC;

-- Explanation:
-- - NTILE(4) splits the ordered rows into 4 approximately equal groups (quartiles).
-- - PARTITION BY ensures quartiles are calculated separately per account.
