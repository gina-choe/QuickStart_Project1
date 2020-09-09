--Question 7. Check if the total amount billed for each order is correct.

/*Because the TotalAmount values in the Order table are not directly derived from the information stored in the OrderItem table, it is important to confirm that the data was inserted correctly.

This will ensure that customers are not overcharged or undercharged for each order.*/

WITH
    calc AS (
        SELECT
            oi.OrderID
            ,SUM(oi.UnitPrice * oi.Quantity) AS TotalCalculated
        FROM OrderItem AS oi
        GROUP BY oi.OrderId
    )

SELECT
    o.Id AS OrderID
    ,o.TotalAmount AS TotalBilled
    ,calc.TotalCalculated
    ,CASE
        WHEN o.TotalAmount - calc.TotalCalculated = 0 THEN 'None'
        ELSE CAST(o.TotalAmount - calc.TotalCalculated AS NVARCHAR(20))
     END AS Discrepency
FROM [Order] AS o
JOIN calc
ON calc.OrderId = o.Id
ORDER BY 1

-- This query revealed that there were no discrepencies between the TotalAmount on the Order and the actual total calculated by multiplying the UnitPrice and Quantity indicated by the itemized order invoice.

-- Then, I decided to further examine the consistency of the database by using the UnitPrice from the Product table instead of the OrderItem table.

WITH
    calc AS (
        SELECT
            oi.OrderID
            ,SUM(p.UnitPrice * oi.Quantity) AS TotalCalculated --Used Product.UnitPrice instead of OrderItem.Unitprice
        FROM OrderItem AS oi
        JOIN Product AS p
        ON p.ID = oi.ProductID
        GROUP BY oi.OrderId
    )

SELECT
    o.Id AS OrderID
    ,o.TotalAmount AS TotalBilled
    ,calc.TotalCalculated
    ,CASE
        WHEN o.TotalAmount - calc.TotalCalculated = 0 THEN 'None'
        ELSE CAST(o.TotalAmount - calc.TotalCalculated AS NVARCHAR(20))
     END AS Discrepency
FROM [Order] AS o
JOIN calc
ON calc.OrderId = o.Id
ORDER BY OrderID

-- Interestingly, this query generated several orders with discrepencies, all of them showing that customers were undercharged. Why did the two queries generate such different results? To get to the bottom of it, I checked the UnitPrices for a product in both OrderItem and Product tables.

SELECT DISTINCT
    oi.ProductId
    ,oi.UnitPrice AS OI_UnitPrice
    ,p.UnitPrice AS P_UnitPrice
FROM OrderItem AS oi
JOIN Product AS p
ON p.Id = oi.ProductId
ORDER BY 1

-- This comparison showed that in the OrderItem table, UnitPrice of every product had exactly two different values. Furthermore, one value was always lower than the Product table's UnitPrice, and the other was the same.
-- I realized there must have been a price increase at some point during the collection of this data, and the Product table only contains the current prices.

-- Subsequently, I wanted to see if I could determine when the prices were changed.
WITH
    calc AS (
        SELECT
            oi.OrderID
            ,SUM(p.UnitPrice * oi.Quantity) AS TotalCalculated
        FROM OrderItem AS oi
        JOIN Product AS p
        ON p.ID = oi.ProductID
        GROUP BY oi.OrderId
    )

SELECT
    o.Id AS OrderID
    ,o.TotalAmount AS TotalBilled
    ,calc.TotalCalculated
    ,CASE
        WHEN o.TotalAmount - calc.TotalCalculated = 0 THEN 'None'
        ELSE CAST(o.TotalAmount - calc.TotalCalculated AS NVARCHAR(20))
     END AS Discrepency
    ,o.OrderDate -- Added the OrderDate
FROM [Order] AS o
JOIN calc
ON calc.OrderId = o.Id
ORDER BY 1

-- From the result, it was evident that there was an overall price increase of products sometime between 2013-04-04 and 2013-04-06 (after Order 250 and before Order 251 was placed).

--Lastly, I wanted to know the net change and percent change of each product price.
SELECT DISTINCT
    oi.ProductId
    ,p.ProductName
    ,oi.UnitPrice AS OI_UnitPrice
    ,p.UnitPrice AS P_UnitPrice
    ,p.UnitPrice - oi.UnitPrice AS Net_Price_Change
    ,CAST((p.UnitPrice - oi.UnitPrice)*100/oi.UnitPrice AS DEC(5,2)) AS Percent_Price_Change
FROM OrderItem AS oi
JOIN Product AS p
ON p.Id = oi.ProductId
WHERE oi.UnitPrice != p.UnitPrice
ORDER BY Percent_Price_Change DESC

--Other than the large relative price increases by Queso Cabrales(50.0%) and Singaporean Hokkien Fried Mee(42.86%), most products' prices increased by 25%.
