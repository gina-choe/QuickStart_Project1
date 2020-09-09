--3. Who have orders with discontinued items? Show them in a single field, in LastName, FirstName format.
--Concepts: SELECT, WHERE, IN, CONCAT, Subquery

SELECT DISTINCT
    CONCAT(c.LastName, ', ', c.FirstName) AS CustomerName
FROM Customer AS c
JOIN [Order] AS o
ON o.CustomerId = c.Id
WHERE o.ID IN (
        SELECT
            oi.OrderID
        FROM OrderItem AS oi
        JOIN (
            SELECT
                p.Id AS ProductID
            FROM Product AS p
            WHERE p.IsDiscontinued = 1
        ) AS t1
        ON oi.ProductID = t1.ProductID
)
ORDER BY 1;

/*  Note: This query revealed 77 out of 91 total customers have ordered discontinued products! If the products were discontinued after the orders were fulfilled, it might be useful to consider reintroducing previously popular items into our inventory. If the orders have not been fullfilled, then the customers should be notified or we should find alternative ways to fulfill the order.
*/
