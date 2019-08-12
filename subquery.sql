-- Subquery

SELECT DATE_TRUNC('day', occurred_at) AS day,
	   channel,
	   count(*) AS event_count
FROM web_events
GROUP BY 1,2
ORDER BY 1;

SELECT * FROM
(SELECT DATE_TRUNC('day', occurred_at) AS day,
	   channel,
	   count(*) AS event_count
FROM web_events
GROUP BY 1,2
ORDER BY 3 DESC) sub;

SELECT channel, 
		AVG(event_count) AS avg_event_count
FROM
(SELECT DATE_TRUNC('day', occurred_at) AS day,
	   channel,
	   count(*) AS event_count
FROM web_events
GROUP BY 1,2
ORDER BY 3 DESC) sub
GROUP BY 1;

/*
Note that you should not include an alias when you write a subquery in a conditional statement. 
This is because the subquery is treated as an individual value (or set of values in the IN case) rather than as a table.

Also, notice the query here compared a single value. If we returned an entire column IN would need to be used to perform 
a logical argument. If we are returning an entire table, then we must use an ALIAS for the table, and perform additional 
logic on the entire table.
*/

SELECT DATE_TRUNC('month',occurred_at),
       AVG(standard_qty) AS std_qty_avg, 
       AVG(gloss_qty) AS gls_qty_avg, 
       AVG(poster_qty) AS pos_qty_avg
FROM orders
WHERE DATE_TRUNC('month',occurred_at) = (SELECT DATE_TRUNC('month',MIN(occurred_at)) AS first_order_month
	    FROM orders)
GROUP BY 1;

--Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.
SELECT name, t1.region_id, sale
FROM (SELECT s.name, 
             s.region_id, 
             SUM(o.total_amt_usd) as sale
      FROM sales_reps s
      JOIN accounts a
      ON s.id = a.sales_rep_id
      JOIN orders o
      ON a.id = o.account_id
      GROUP BY 1,2
      ORDER BY 2) t1 
JOIN (SELECT region_id, 
             MAX(sale) as max_sale
      FROM (SELECT s.name, 
                   s.region_id, 
                   SUM(o.total_amt_usd) as sale
            FROM sales_reps s
            JOIN accounts a
            ON s.id = a.sales_rep_id
            JOIN orders o
            ON a.id = o.account_id
            GROUP BY 1,2
            ORDER BY 2) t3
      GROUP BY 1) t2
ON t1.region_id = t2.region_id AND t1.sale = t2.max_sale;

--For the region with the largest (sum) of sales total_amt_usd, how many total (count) orders were placed? 
SELECT r.name,
	   SUM(o.total_amt_usd) AS total_amt_usd_sum,
	   COUNT(o.*) AS order_count
FROM orders o
JOIN accounts a
ON o.account_id = a.id
JOIN sales_reps s
ON s.id = a.sales_rep_id
JOIN region r
ON r.id = s.region_id
GROUP BY 1
HAVING SUM(o.total_amt_usd) = (SELECT MAX(total_amt_usd_sum) FROM (SELECT s.region_id,
	   SUM(o.total_amt_usd) AS total_amt_usd_sum,
	   COUNT(o.*) AS order_count
FROM orders o
JOIN accounts a
ON o.account_id = a.id
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY 1) t1);

--WITH  (CTE)

--Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.
WITH t1 AS
(SELECT s.name, 
             s.region_id, 
             SUM(o.total_amt_usd) as sale
      FROM sales_reps s
      JOIN accounts a
      ON s.id = a.sales_rep_id
      JOIN orders o
      ON a.id = o.account_id
      GROUP BY 1,2
      ORDER BY 2),
   t2 AS (SELECT region_id, 
             MAX(sale) as max_sale
           FROM t1
           GROUP BY 1)
SELECT *
FROM t1
JOIN t2
ON t1.region_id = t2.region_id AND t1.sale = t2.max_sale; 

--For the region with the largest (sum) of sales total_amt_usd, how many total (count) orders were placed? 
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
