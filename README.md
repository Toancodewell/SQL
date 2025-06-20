
# 📊 SQL Query Collection 

This repository contains structured SQL scripts written in **PostgreSQL**, focused on data cleaning, subqueries, window functions, rankings, and sales analytics. Each file is clearly named by function and use case.

---

## 📁 Files Overview

### 🔹 `Data_clearning.sql`
- Perform basic data cleaning tasks:
  - Extract first/last names from full strings.
  - Format and cast dates into standard ISO format.
  - Replace or parse strings as needed for consistency.

---

### 🔹 `NTILE_lag_difference_by_account.sql`
- **NTILE(4)**: Divide each account's orders into **quartiles** based on `standard_qty`.
- **LAG()**: Compare total `standard_qty` of an account to the previous one.
- **lag_difference**: Show the change between accounts' quantities.

---

### 🔹 `Subquery_advanced_sales_queries.sql`
- Use **subqueries** and **nested CTEs** to:
  - Calculate average quantities in the earliest order month.
  - Identify the top sales rep per region based on revenue.
  - Count total orders in the region with the highest sales.

---

### 🔹 `monthly_sales_analysis.sql`
- Aggregate spending by **month** from 2014–2017.
- Use `DATE_PART()` and `DATE_TRUNC()` for time-based grouping.
- Identify the month **Walmart** spent the most.

---

### 🔹 `running_totals_by_year.sql`
- Use `SUM() OVER (...)` for cumulative (running) totals.
- Apply `PARTITION BY DATE_TRUNC('year', occurred_at)` to reset totals each year.
- Track annual order trends over time.

---

### 🔹 `sales_rep_performance.sql`
- Categorize sales reps into `top`, `middle`, or `low` performance levels based on:
  - Total number of orders placed.
  - Total sales amount.
- Use `CASE WHEN` logic for classification.

---

### 🔹 `top_order_analysis.sql`
- Extract the top 2 order values from the bottom 3,457 total orders.
- Identify the **region** with the highest total sales and count the number of orders placed there.
- Use nested subqueries and aggregation to find the result.

---

## 🛠 Tech Stack

- **SQL Dialect**: My SQL  


