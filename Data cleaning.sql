SELECT DISTINCT(RIGHT(website,4)) AS extension, 
       COUNT(*) extension_counts
FROM accounts
GROUP BY 1;

SELECT LEFT(UPPER(name),1) AS first_letter, COUNT(*) counts
FROM accounts
GROUP BY 1;

SELECT SUM(num) nums, SUM(letter) letters
FROM (SELECT name, CASE WHEN LEFT(UPPER(name), 1) IN ('0','1','2','3','4','5','6','7','8','9') 
                   THEN 1 ELSE 0 END AS num, 
                   CASE WHEN LEFT(UPPER(name), 1) IN ('0','1','2','3','4','5','6','7','8','9') 
                   THEN 0 ELSE 1 END AS letter
      FROM accounts) t1;

SELECT vowel_start, COUNT(*)
FROM (SELECT name, CASE WHEN LEFT(UPPER(name), 1) IN ('A','E','I','O','U') THEN 1 ELSE 0 END AS vowel_start
      FROM accounts) t1
GROUP BY 1;

SELECT primary_poc, 
       POSITION(' ' IN primary_poc) AS space_position,
       LEFT(primary_poc, POSITION(' ' IN primary_poc)) firstname,
       RIGHT(primary_poc, LENGTH(primary_poc)-POSITION(' ' IN primary_poc)) lastname
FROM accounts;

SELECT name, 
       STRPOS(name, ' ') AS space_position,
       LEFT(name, STRPOS(name, ' ')) firstname,
       RIGHT(name, LENGTH(name)-STRPOS(name, ' ')) lastname
FROM sales_reps

WITH t1 AS (SELECT name, primary_poc, 
                   POSITION(' ' IN primary_poc) AS space_position,
                   LEFT(primary_poc, POSITION(' ' IN primary_poc)) firstname,
                   RIGHT(primary_poc, LENGTH(primary_poc)-POSITION(' ' IN primary_poc)) lastname
            FROM accounts)
SELECT firstname||'.'||lastname||'@'||name||'.com' AS email
FROM t1;

WITH t1 AS (SELECT primary_poc, 
                   REPLACE(name,' ','') AS no_space_name,
                   POSITION(' ' IN primary_poc) AS space_position,
                   LEFT(primary_poc, POSITION(' ' IN primary_poc)) firstname,
                   RIGHT(primary_poc, LENGTH(primary_poc)-POSITION(' ' IN primary_poc)) lastname
            FROM accounts)
SELECT CONCAT(firstname,'.',lastname,'@',no_space_name,'.com') AS email
FROM t1;

WITH t1 AS (SELECT primary_poc, 
                   REPLACE(name,' ','') AS no_space_name,
                   POSITION(' ' IN primary_poc) AS space_position,
                   LEFT(primary_poc, POSITION(' ' IN primary_poc)-1) firstname,
                   RIGHT(primary_poc, LENGTH(primary_poc)-POSITION(' ' IN primary_poc)) lastname
            FROM accounts)
SELECT LOWER(LEFT(firstname,1))||
        LOWER(RIGHT(firstname,1))||
        LOWER(LEFT(lastname,1))||
        LOWER(RIGHT(lastname,1))||
        LENGTH(firstname)||
        LENGTH(lastname)||
        UPPER(no_space_name) AS password,
        firstname,
        lastname
FROM t1;

/*LEFT, RIGHT, and TRIM are all used to select only certain elements of strings, 
but using them to select elements of a number or date will treat them as strings for the purpose of the function.*/

SELECT *
FROM sf_crime_data
LIMIT 10;

WITH t1 AS (SELECT SUBSTRING(date,1,2) AS month,
       SUBSTRING(date,4,2) AS day,
       SUBSTRING(date,7,4) AS year,
       date
FROM sf_crime_data)
SELECT CONCAT(year,'-',month,'-',day)::date formatted_date
FROM t1
/*OR 
SELECT CAST(CONCAT(year,'-',month,'-',day) AS DATE) formatted_date
FROM t1
*/

SELECT *, 
COALESCE(a.id,a.id) AS id,
COALESCE(o.account_id,a.id) AS account_id,
COALESCE(standard_qty, 0) AS standard_qty
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
WHERE o.total IS NULL;
