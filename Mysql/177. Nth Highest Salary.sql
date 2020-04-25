/*
Table: Employee
+----+--------+
| Id | Salary |
+----+--------+
| 1  | 100    |
| 2  | 200    |
| 3  | 300    |
+----+--------+
*/

CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
  DECLARE M INT;
  SET M = N-1;
  RETURN (
      # Write your MySQL query statement below.
      SELECT 
            DISTINCT 
            IF(N > (SELECT COUNT(DISTINCT Salary) FROM Employee), null, salary)
            AS Salary
      FROM
            Employee
      ORDER BY Salary DESC
      LIMIT M, 1
      # OFFSET M limit 1 row
      # MUST BE M cannot be N-1
      
  );
END

# Good Solution
CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
  DECLARE M INT;
  SET M = N-1;
  RETURN (
      # Write your MySQL query statement below.
      SELECT DISTINCT salary 
      FROM Employee 
      ORDER BY Salary DESC 
      LIMIT M,1
      # OFFSET M limit 1 row
      # LIMIT will automatically create null if out of boundary
      
  );
END
