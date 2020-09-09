-- 5. What is our total order amount and average order both inside the USA and outside the USA?
--Concepts: SELECT, WHERE, JOIN, UNION ALL, Aliasing, Aggregate Functions, CAST

SELECT
    'Inside USA' AS Country
    ,CAST(SUM(o.TotalAmount) AS DEC(12,2)) AS Total_Amount
    ,CAST(AVG(o.TotalAmount) AS DEC(12,2)) AS Avg_Amount
FROM [Order] AS o
JOIN Customer AS c
ON c.Id = o.CustomerId
WHERE c.Country = 'USA'
UNION ALL
SELECT
    'Outside USA' AS Country
    ,CAST(SUM(o.TotalAmount) AS DEC(12,2)) AS Total_Amount
    ,CAST(AVG(o.TotalAmount) AS DEC(12,2)) AS Avg_Amount
FROM [Order] AS o
JOIN Customer AS c
ON c.Id = o.CustomerId
WHERE c.Country != 'USA'


--Alternative Answer 1
SELECT
    'Inside USA' AS Country
    ,CAST(SUM(o.TotalAmount) AS DEC(12,2)) AS Total_Amount
    ,CAST(AVG(o.TotalAmount) AS DEC(12,2)) AS Avg_Amount
FROM [Order] AS o
JOIN Customer AS c
ON c.Id = o.CustomerId AND c.Country = 'USA'
UNION ALL
SELECT
    'Outside USA' AS Country
    ,CAST(SUM(o.TotalAmount) AS DEC(12,2)) AS Total_Amount
    ,CAST(AVG(o.TotalAmount) AS DEC(12,2)) AS Avg_Amount
FROM [Order] AS o
JOIN Customer AS c
ON c.Id = o.CustomerId AND c.Country != 'USA'
