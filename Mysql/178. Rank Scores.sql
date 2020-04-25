/*
+----+-------+
| Id | Score |
+----+-------+
| 1  | 3.50  |
| 2  | 3.65  |
| 3  | 4.00  |
| 4  | 3.85  |
| 5  | 4.00  |
| 6  | 3.65  |
+----+-------+
*/
/* Write your PL/SQL query statement below */
/* ORICALE DB*/  
SELECT 
    Score,
    DENSE_RANK() OVER (Order by Score DESC) "Rank"
FROM Scores

# Write your MySQL query statement below

SELECT S1.Score, (
    SELECT COUNT(DISTINCT Score) FROM Scores WHERE Score >= S1.Score) AS Rank
FROM Scores S1
ORDER BY S1.Score DESC
