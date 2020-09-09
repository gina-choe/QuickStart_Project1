--4. Who placed orders in the month of July? Show in order.
--Concepts: SELECT, WHERE, BETWEEN, ORDER BY

SELECT
    c.FirstName
    ,c.LastName
    ,o.OrderDate
FROM Customer AS c
JOIN [Order] AS o
ON o.CustomerId = c.Id
WHERE o.Id IN (
    SELECT
        o.Id AS OrderID
    FROM [Order] AS o
    WHERE MONTH(o.OrderDate) = 7 AND DAY(o.OrderDate) BETWEEN 1 AND 31
)
ORDER BY o.OrderDate;


--Alternative Answer 1
SELECT
    c.FirstName
    ,c.LastName
    ,o.OrderDate
FROM Customer AS c
JOIN [Order] AS o
ON o.CustomerId = c.Id
WHERE o.Id IN (
    SELECT
        o.Id AS OrderID
    FROM [Order] AS o
    WHERE OrderDate BETWEEN '2012-07-01' AND '2012-07-31'
    OR OrderDate BETWEEN '2013-07-01' AND '2013-07-31'
)
ORDER BY o.OrderDate;
