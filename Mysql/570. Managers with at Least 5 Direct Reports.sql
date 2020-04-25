
/*Table: Employee
+------+----------+-----------+----------+
|Id    |Name 	  |Department|ManagerId |
+------+----------+-----------+----------+
|101   |John 	  |A 	      |null      |
|102   |Dan 	  |A 	      |101       |
|103   |James   |A 	      |101       |
|104   |Amy 	  |A 	      |101       |
|105   |Anne 	  |A 	      |101       |
|106   |Ron 	  |B 	      |101       |
+------+----------+-----------+----------+

*/

SELECT Name
FROM Employee e
JOIN
  (SELECT ManagerId
   FROM Employee
   GROUPBY ManagerId
   HAVING COUNT(ManagerId) >= 5) AS t
ON e.Id = t.ManagerId;

