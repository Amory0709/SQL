--Query all columns for all American cities in CITY with populations larger than 100000. The CountryCode for America is USA.
SELECT *
FROM CITY
WHERE (COUNTRYCODE = 'USA') & (POPULATION > 100000);

--Query the names of all American cities in CITY with populations larger than 120000. The CountryCode for America is USA.
SELECT NAME
FROM CITY
WHERE (COUNTRYCODE = 'USA') & (POPULATION > 120000);

-- Query all columns (attributes) for every row in the CITY table.
SELECT *
FROM CITY;

-- Query all columns for a city in CITY with the ID 1661.
SELECT *
FROM CITY
WHERE ID=1661;

-- Query all attributes of every Japanese city in the CITY table. The COUNTRYCODE for Japan is JPN.
SELECT *
FROM CITY
WHERE COUNTRYCODE ='JPN';

/*
Enter your query here.
Query a list of CITY names from STATION with even ID numbers only. You may print the results in any order, but must exclude duplicates from your answer.
*/
SELECT DISTINCT CITY
FROM STATION
WHERE ID%2=0;
