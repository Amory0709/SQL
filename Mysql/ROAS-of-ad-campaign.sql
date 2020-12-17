/*
Table:campaign 
+-----+---------------+-------------+--------+------+------------+
|date | campaign_name | impressions | clicks | cost | conversion |
+-----+---------------+-------------+--------+------+------------+


Table:revenue
+-----+---------------+-------------+
|date | campaign_name | revenue     |
+-----+---------------+-------------+
*/

SELECT
  date,
  platform,
  sum(cost)/sum(revenue) AS roas,
FROM 
(SELECT 
  c.date
  RIGHT(c.campaign_name,1) AS platform,
  c.cost, 
  r.revenue
FROM campaign c
JOIN revenue r
ON c.date = r.date 
AND c.campaign_name = r.campaign_name) AS tmp
GROUP BY 
  date, 
  platform;
