--Window functions are permitted only in the SELECT list and the ORDER BY clause of the query. 
--You can’t use window functions and standard aggregations in the same query. 
--More specifically, hey are forbidden elsewhere, such as in GROUP BY, HAVING and WHERE clauses. 
SELECT sum(salary) OVER w, avg(salary) OVER w
  FROM empsalary
  WINDOW w AS (PARTITION BY depname ORDER BY salary DESC);
  
SELECT standard_amt_usd,
       SUM(standard_amt_usd) OVER (order by occurred_at) AS running_total
FROM orders;

SELECT standard_amt_usd,
       DATE_TRUNC('year', occurred_at),
       SUM(standard_amt_usd) OVER (PARTITION BY DATE_TRUNC('year', occurred_at) ORDER BY occurred_at) AS running_total
FROM orders;

-- rank() vs row_number()
-- with the same value in order by col, rank will have the same No. while row_number will offer different value
SELECT id, account_id, total,
       RANK() OVER (PARTITION BY account_id ORDER BY total DESC) AS total_rank
FROM orders;
-- dense_rank(): 2,3,3,4 rank():2,3,3,5
-- without order by is like ORDER BY clause like this: ORDER BY 0 (or "order by" any constant expression), 
-- or even, more emphatically, ORDER BY NULL.
-- WINDOW clause goes between the WHERE clause and the GROUP BY clause

--multi windows
SELECT id,
       account_id,
       DATE_TRUNC('year',occurred_at) AS year,
       DENSE_RANK() OVER account_year_window AS dense_rank,
       total_amt_usd,
       SUM(total_amt_usd) OVER account_window AS sum_total_amt_usd,
       COUNT(total_amt_usd) OVER account_year_window AS count_total_amt_usd,
       AVG(total_amt_usd) OVER account_year_window AS avg_total_amt_usd,
       MIN(total_amt_usd) OVER account_year_window AS min_total_amt_usd,
       MAX(total_amt_usd) OVER account_year_window AS max_total_amt_usd
FROM orders 
WINDOW account_year_window AS (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at)),
       account_window AS (PARTITION BY account_id)
       
-- LAG and LEAD
SELECT occurred_at,
       total_amt_usd,
       LEAD(total_amt_usd) OVER (ORDER BY occurred_at) AS lead,
       LEAD(total_amt_usd) OVER (ORDER BY occurred_at) - total_amt_usd AS lead_difference
FROM (
SELECT occurred_at,
       SUM(total_amt_usd) AS total_amt_usd
  FROM orders 
 GROUP BY 1
) sub

-- NTILE(*# of buckets*)
/* In other words, when you use a NTILE function but the number of rows in the partition is 
less than the NTILE(number of groups), then NTILE will divide the rows into as many groups as 
there are members (rows) in the set but then stop short of the requested number of groups. 
If you’re working with very small windows, keep this in mind and consider using quartiles or similarly small bands. */

SELECT account_id, occurred_at, total_std_qty,
       NTILE(4) OVER (PARTITION BY account_id ORDER BY total_std_qty DESC)
FROM(SELECT account_id, occurred_at,
       SUM(standard_qty) total_std_qty
FROM orders
GROUP BY 1,2) sub;

SELECT
       account_id,
       occurred_at,
       standard_qty,
       NTILE(4) OVER (PARTITION BY account_id ORDER BY standard_qty) AS standard_quartile
  FROM orders 
 ORDER BY account_id DESC;

