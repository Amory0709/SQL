SELECT column_name(s)
FROM Table_A
FULL OUTER JOIN Table_B ON Table_A.column_name = Table_B.column_name;
-- return unmatched rows only
WHERE Table_A.column_name IS NULL OR Table_B.column_name IS NULL;

SELECT *
FROM accounts a
FULL OUTER JOIN sales_reps s
ON a.sales_rep_id = s.id
WHERE a.sales_rep_id IS NULL OR s.id is NULL;

-- JOIN with comparison
--the join clause is evaluated before the where clause
SELECT a.name , a.primary_poc, s.name sales_rep_name
FROM accounts a
LEFT JOIN sales_reps s
ON a.sales_rep_id = s.id
AND a.primary_poc < s.name;

--Self JOINs
SELECT we1.id AS we_id,
       we1.account_id AS we1_account_id,
       we1.occurred_at AS we1_occurred_at,
       we1.channel AS we1_channel,
       we2.id AS we2_id,
       we2.account_id AS we2_account_id,
       we2.occurred_at AS we2_occurred_at,
       we2.channel AS we2_channel
  FROM web_events we1 
 LEFT JOIN web_events we2
   ON we1.account_id = we2.account_id
  AND we1.occurred_at > we2.occurred_at
  AND we1.occurred_at <= we2.occurred_at + INTERVAL '1 day'
ORDER BY we1.account_id, we2.occurred_at
-- interval: https://www.postgresql.org/docs/8.2/static/functions-datetime.html

-- union: eliminate the same row as the upper table    union all: no elimination
SELECT * FROM accounts
UNION ALL
SELECT * FROM accounts; --351 vs all:702

SELECT *
    FROM accounts
    WHERE name = 'Walmart'

UNION ALL

SELECT *
  FROM accounts
  WHERE name = 'Disney'
  
  WITH double_accounts AS (
    SELECT *
      FROM accounts

    UNION ALL

    SELECT *
      FROM accounts
)

SELECT name,
       COUNT(*) AS name_count
 FROM double_accounts 
GROUP BY 1
ORDER BY 2 DESC

-- if aggregate , limit will be useless in improve performance but can be used in subquery to enhance
-- normally to test logic

-- reduce # of rows during JOIN

-- Add EXPLAIN
EXPLAIN SELECT...

-- break big join into 2 subqueries first
SELECT COALESCE(orders.date, web_events.date) AS date,
       orders.active_sales_reps,
       orders.orders,
       web_events.web_visits
FROM(SELECT DATE_TRUNC('day', o.occurred_at) AS date,
            COUNT(a.sales_rep_id) AS active_sales_reps,
            COUNT(o.id) AS orders
     FROM accounts a
     JOIN orders o
     ON o.account_id = a.id
     GROUP BY 1
     ) orders
FULL JOIN
(SELECT DATE_TRUNC('day', wb.occurred_at) AS date,
        COUNT(wb.id) AS web_visits
 FROM web_events wb
 GROUP BY 1
)web_events
ON web_events.date = orders.date
ORDER BY 1 DESC
