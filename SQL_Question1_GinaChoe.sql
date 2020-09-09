-- Question 1. Who are our customers not in the United States?
-- Concepts: SELECT, WHERE

SELECT
    c.FirstName
    ,c.LastName
    ,c.Country --Column for country included to verify output.
FROM Customer AS c
WHERE c.Country != 'USA';


-- Alternative answer 1
SELECT
    c.FirstName
    ,c.LastName
    ,c.Country
FROM Customer AS c
WHERE c.Country NOT IN ('USA');


-- Alternative answer 2
SELECT
    c.FirstName
    ,c.LastName
    ,c.Country
FROM Customer AS c
WHERE c.Country NOT LIKE 'USA';
