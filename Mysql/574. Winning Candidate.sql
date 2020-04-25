/*
Table: Candidate

+-----+---------+
| id  | Name    |
+-----+---------+
| 1   | A       |
| 2   | B       |
| 3   | C       |
| 4   | D       |
| 5   | E       |
+-----+---------+  

Table: Vote

+-----+--------------+
| id  | CandidateId  |
+-----+--------------+
| 1   |     2        |
| 2   |     4        |
| 3   |     3        |
| 4   |     2        |
| 5   |     5        |
+-----+--------------+

*/

# my first attempt
/*SELECT Name
FROM Candidate c
JOIN 
  (SELECT CandidateId, 
          MAX(COUNT(CandidateId)) AS max_counts,
   FROM Vote
   GROUP BY CandidateId
  ) AS w
ON c.id = w.CandidateId;*/ 

SELECT Name
FROM Candidate
WHERE id =
    (SELECT
    candidateId
    FROM vote
    GROUP BY candidateId
    ORDER BY count(*) desc
    LIMIT 1);
