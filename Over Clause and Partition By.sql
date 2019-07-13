create proc OverClauseDemos
as
begin

--Using Over Clause, Partition by, Row_Number
--OVER clause with ROW_NUMBER function to display a row number for each row within a partition
SELECT ROW_NUMBER() OVER(PARTITION BY PostalCode ORDER BY SalesYTD DESC) AS "Row Number",   
       p.LastName, s.SalesYTD, a.PostalCode  
FROM Sales.SalesPerson AS s   
JOIN Person.Person AS p   
ON s.BusinessEntityID = p.BusinessEntityID  
JOIN Person.Address AS a   
ON a.AddressID = p.BusinessEntityID  
WHERE TerritoryID IS NOT NULL   
      AND SalesYTD <> 0  
ORDER BY PostalCode;  

--OVER clause with aggregate functions over all rows returned by the query
--OVER clause is more efficient than using subqueries to derive the aggregate values
SELECT SalesOrderID, ProductID, OrderQty, SUM(OrderQty) OVER(PARTITION BY SalesOrderID) AS Total,
       AVG(OrderQty) OVER(PARTITION BY SalesOrderID) AS "Avg", 
	   COUNT(OrderQty) OVER(PARTITION BY SalesOrderID) AS "Count",
	   MIN(OrderQty) OVER(PARTITION BY SalesOrderID) AS "Min",
	   MAX(OrderQty) OVER(PARTITION BY SalesOrderID) AS "Max"  
FROM Sales.SalesOrderDetail   
WHERE SalesOrderID IN(43659,43664);  

--Over clause with an aggregate function in a calculated value
SELECT SalesOrderID, ProductID, OrderQty, SUM(OrderQty) OVER(PARTITION BY SalesOrderID) AS Total, 
       CAST(1.*OrderQty/SUM(OrderQty) OVER(PARTITION BY SalesOrderID)*100 AS DECIMAL(5,2)) AS "Percent by ProductID"  
FROM Sales.SalesOrderDetail   
WHERE SalesOrderID IN(43659,43664);  

--AVG and SUM functions with OVER clause for moving average and cumulative total yearly sales each territory
--Partitioned by TerritoryID, Ordered by Sales
--AVG function computed for each territory within sales year
--SUM function computed for each territory within sales year
SELECT BusinessEntityID, TerritoryID, DATEPART(yy,ModifiedDate) AS SalesYear, 
       CONVERT(varchar(20),SalesYTD,1) AS  SalesYTD, 
       CONVERT(varchar(20),AVG(SalesYTD) OVER (PARTITION BY TerritoryID ORDER BY DATEPART(yy,ModifiedDate)),1) AS MovingAvg,  
       CONVERT(varchar(20),SUM(SalesYTD) OVER (PARTITION BY TerritoryID ORDER BY DATEPART(yy,ModifiedDate)),1) AS CumulativeTotal  
FROM Sales.SalesPerson  
WHERE TerritoryID IS NULL OR TerritoryID < 5  
ORDER BY TerritoryID,SalesYear;

--Compare
--Order clause with no Partition by
--Notice difference in MovingAVG and CumulativeTotal
SELECT BusinessEntityID, TerritoryID, DATEPART(yy,ModifiedDate) AS SalesYear,  
       CONVERT(varchar(20),SalesYTD,1) AS  SalesYTD, 
       CONVERT(varchar(20),AVG(SalesYTD) OVER (ORDER BY DATEPART(yy,ModifiedDate)),1) AS MovingAvg,
       CONVERT(varchar(20),SUM(SalesYTD) OVER (ORDER BY DATEPART(yy,ModifiedDate)),1) AS CumulativeTotal  
FROM Sales.SalesPerson  
WHERE TerritoryID IS NULL OR TerritoryID < 5  
ORDER BY SalesYear;

--ROWS clause define window of which rows are computed as current row and the N number of rows that follow
SELECT BusinessEntityID, TerritoryID, CONVERT(varchar(20),SalesYTD,1) AS  SalesYTD, 
       DATEPART(yy,ModifiedDate) AS SalesYear,
       CONVERT(varchar(20),SUM(SalesYTD) OVER (PARTITION BY TerritoryID ORDER BY DATEPART(yy,ModifiedDate)   
       ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING),1) AS CumulativeTotal  
FROM Sales.SalesPerson  
WHERE TerritoryID IS NULL OR TerritoryID < 5;

--Rows clause 'unbounded Preceding'
SELECT BusinessEntityID, TerritoryID, CONVERT(varchar(20),SalesYTD,1) AS  SalesYTD,
       DATEPART(yy,ModifiedDate) AS SalesYear,
       CONVERT(varchar(20),SUM(SalesYTD) OVER (PARTITION BY TerritoryID ORDER BY DATEPART(yy,ModifiedDate)   
       ROWS UNBOUNDED PRECEDING),1) AS CumulativeTotal  
FROM Sales.SalesPerson  
WHERE TerritoryID IS NULL OR TerritoryID < 5;

end