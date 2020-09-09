--6. Which customers placed orders with items made inside the USA?
--Concepts: SELECT DISTINCT, WHERE, Temporary Table, Subquery

WITH
    usS AS (
        SELECT
            s.Id
            ,s.Country
        FROM Supplier AS s
        WHERE s.Country = 'USA'
    )
    ,usP AS (
        SELECT
            p.ID
        FROM Product AS p
        JOIN usS
        ON usS.Id = p.SupplierId
    )

SELECT DISTINCT
    c.FirstName
    ,c.LastName
    ,c.Country
FROM Customer AS c
JOIN [Order] AS o
ON o.customerID = c.Id
JOIN OrderItem AS oi
ON o.Id = oi.OrderId
JOIN usP
ON usP.Id = oi.ProductID
ORDER BY 3


--Alternative Answer 1
WITH
    usP AS (
        SELECT
            p.Id AS usProductID
            ,usS.country AS Country
            ,usS.Id As SupplierID
        FROM Product AS p
        JOIN (
            SELECT
                s.Id
                ,s.Country
            FROM Supplier AS s
            WHERE s.Country = 'USA'
        ) AS usS
        ON usS.Id = p.SupplierID
    )
    ,cp AS (
        SELECT
            c.FirstName
            ,c.LastName
            ,c.Country
            ,oi.ProductID
        FROM Customer AS c
        JOIN [Order] AS o
        ON o.CustomerID = c.Id
        JOIN OrderItem AS oi
        ON oi.OrderID = o.Id
    )

SELECT DISTINCT
    cp.FirstName
    ,cp.LastName
    ,cp.Country
FROM cp
JOIN usP
ON cp.ProductID = usP.usProductID
ORDER BY 3, 1
