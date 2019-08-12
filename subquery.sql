
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
