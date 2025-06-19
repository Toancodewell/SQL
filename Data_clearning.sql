-- ================================================
-- FILE: account_name_domain_analysis.sql
-- PURPOSE: 
--   1. Count companies grouped by website domain suffix.
--   2. Count how many account names start with a number vs a letter.
-- ================================================

-- ================================================
-- PART 1: Count number of companies by website domain (last 3 letters).
-- ================================================
SELECT 
    RIGHT(website, 3) AS domain, 
    COUNT(*) AS num_companies
FROM 
    accounts
GROUP BY 
    1
ORDER BY 
    2 DESC;

-- ================================================
-- PART 2: Count how many account names start with a number or letter.
-- ================================================
SELECT 
    SUM(num) AS nums, 
    SUM(letter) AS letters
FROM (
    SELECT 
        name, 
        CASE 
            WHEN LEFT(UPPER(name), 1) IN ('0','1','2','3','4','5','6','7','8','9') THEN 1 
            ELSE 0 
        END AS num, 
        CASE 
            WHEN LEFT(UPPER(name), 1) IN ('0','1','2','3','4','5','6','7','8','9') THEN 0 
            ELSE 1 
        END AS letter
    FROM 
        accounts
) t1;

-- ================================================
-- PURPOSE: 
--   Split the primary point of contact's full name 
--   into first name and last name.
-- ================================================

SELECT 
    LEFT(primary_poc, STRPOS(primary_poc, ' ') - 1) AS first_name, 
    RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) AS last_name
FROM 
    accounts;

-- ================================================
-- PURPOSE: 
--   1. Generate email addresses from primary POC and company name.
--   2. Generate a simple ID code based on POC name and company.
-- ================================================

-- ================================================
-- PART 1: Generate email address using format: firstname.lastname@company.com
-- ================================================
WITH t1 AS (
    SELECT 
        LEFT(primary_poc, STRPOS(primary_poc, ' ') - 1) AS first_name,  
        RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) AS last_name, 
        name
    FROM 
        accounts
)
SELECT 
    first_name, 
    last_name, 
    CONCAT(first_name, '.', last_name, '@', name, '.com') AS email
FROM 
    t1;

-- ================================================
-- PART 2: Generate a simple code based on name and company.
-- Format: first_last initials + name lengths + UPPER(company name, no spaces)
-- ================================================
WITH t1 AS (
    SELECT 
        LEFT(primary_poc, STRPOS(primary_poc, ' ') - 1) AS first_name,  
        RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) AS last_name, 
        name
    FROM 
        accounts
)
SELECT 
    first_name, 
    last_name, 
    CONCAT(first_name, '.', last_name, '@', name, '.com') AS email,
    LEFT(LOWER(first_name), 1) || 
    RIGHT(LOWER(first_name), 1) || 
    LEFT(LOWER(last_name), 1) || 
    RIGHT(LOWER(last_name), 1) || 
    LENGTH(first_name) || 
    LENGTH(last_name) || 
    REPLACE(UPPER(name), ' ', '') AS generated_code
FROM 
    t1;


-- ================================================
-- PURPOSE: 
--   1. Convert raw date strings from 'MM/DD/YYYY' to ISO format 'YYYY-MM-DD'.
--   2. Cast the formatted string to DATE type for further processing.
--   3. (Optionally) Use DATE_PART or DATE_TRUNC for date analysis.
-- ================================================

-- ================================================
-- PART 1: Reformat raw date string to ISO 8601 format (YYYY-MM-DD).
-- ================================================
SELECT 
    date AS orig_date, 
    (SUBSTR(date, 7, 4) || '-' || LEFT(date, 2) || '-' || SUBSTR(date, 4, 2)) AS new_date
FROM 
    sf_crime_data;
-- Output example: '2014-01-31'

-- ================================================
-- PART 2: Cast reformatted date string into DATE type.
-- ================================================
SELECT 
    date AS orig_date, 
    (SUBSTR(date, 7, 4) || '-' || LEFT(date, 2) || '-' || SUBSTR(date, 4, 2))::DATE AS new_date
FROM 
    sf_crime_data;
-- Output example: '2014-01-31T00:00:00.000Z'

-- ================================================
-- PART 3 (optional): Use DATE_PART or DATE_TRUNC for further analysis.
-- ================================================

-- Example: Extract year and month from the new_date
SELECT 
    DATE_PART('year', (SUBSTR(date, 7, 4) || '-' || LEFT(date, 2) || '-' || SUBSTR(date, 4, 2))::DATE) AS year,
    DATE_PART('month', (SUBSTR(date, 7, 4) || '-' || LEFT(date, 2) || '-' || SUBSTR(date, 4, 2))::DATE) AS month
FROM 
    sf_crime_data;

-- Example: Truncate to the first day of the month
SELECT 
    DATE_TRUNC('month', (SUBSTR(date, 7, 4) || '-' || LEFT(date, 2) || '-' || SUBSTR(date, 4, 2))::DATE) AS month_start
FROM 
    sf_crime_data;
