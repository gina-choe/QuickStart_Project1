--2. Who are our customers in Germany and France?
--Concepts: SELECT, WHERE, IN

SELECT
    c.FirstName
    ,c.LastName
    ,c.Country -- Column for country included to verify output.
FROM Customer AS c
WHERE c.Country IN ('Germany', 'France')
ORDER BY 3;


--Alternative answer 1
SELECT
    c.FirstName
    ,c.LastName
    ,c.Country
FROM Customer AS c
WHERE c.Country ='Germany' OR c.Country = 'France'
ORDER BY 3;
