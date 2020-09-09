--Question 8. Which five suppliers provided the products that generated the biggest revenue, and which five generated the smallest revenue during the last year(365 days) of data collection?

/* Assuming that profit correlates with revenue, knowing which suppliers are associated with the largest and smallest revenues would influence our future decisions regarding which suppliers to expand our relationship with, and which suppliers to consider discontinuing orders from.

We might consider trying new products that the well-performing suppliers, or explore ways to optimize our current transactions with them.

For supplier who are not performing well, it might be necessary to further investigate why their products are not as popular, and whether their products are worth maintaining in our inventory. */

WITH
    LatestOrders AS ( --Orders placed in the last year(365 days)
        SELECT
            oi.OrderId
            ,o.OrderDate
        FROM [Order] AS o
        JOIN OrderItem AS oi
        ON oi.OrderID = o.Id
        WHERE o.OrderDate > (
            SELECT
                MAX(DATEADD(year, -1, o.OrderDate))
            FROM [Order] AS o
        )
    )
    ,ProductRevenue AS (--Products and their respective revenues from the last year's order
        SELECT
            oi.ProductID
            ,p.ProductName
            ,p.SupplierId
            ,SUM(oi.UnitPrice * oi.Quantity) AS Revenue
        FROM OrderItem AS oi
        JOIN Product AS p
        ON p.Id = oi.ProductId
        JOIN LatestOrders AS lo
        ON lo.OrderId = oi.OrderId
        GROUP BY oi.ProductId, p.ProductName, p.SupplierId
    )

SELECT TOP (5) --Top 5 suppliers ranked by revenue in descending order
    'TOP ' + CAST(RANK() OVER (ORDER BY SUM(pr.Revenue) DESC) AS NVARCHAR(10)) AS RANK
    ,s.Id AS SupplierID
    ,s.CompanyName
    ,SUM(pr.Revenue) AS TotalRevenue
FROM Supplier AS s
JOIN ProductRevenue AS pr
ON pr.SupplierId = s.Id
GROUP BY s.Id, s.CompanyName

UNION ALL

SELECT TOP (5) --Bottom 5 suppliers ranked by revenue in ascending order
    'BOTTOM ' + CAST(RANK() OVER (ORDER BY SUM(pr.Revenue) ASC) AS NVARCHAR(10)) AS RANK
    ,s.Id AS SupplierID
    ,s.CompanyName
    ,SUM(pr.Revenue) AS TotalRevenue
FROM Supplier AS s
JOIN ProductRevenue AS pr
ON pr.SupplierId = s.Id
GROUP BY s.Id, s.CompanyName
ORDER BY TotalRevenue DESC;
