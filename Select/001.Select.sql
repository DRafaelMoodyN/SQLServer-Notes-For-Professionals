-- ==================================================================================================
-- SELECT
-- ==================================================================================================

/*
Permite la selección de una o varias filas o columnas de una o varias tablas de SQL Server

Orden de procesamiento logico de la instruccion SELECT

*/

USE AdventureWorks2019
GO

SELECT * FROM Production.ProductCategory
GO

SELECT e.* 
FROM Production.Product e
ORDER BY e.Name ASC
GO

SELECT e.* 
FROM Production.Product AS e
ORDER BY e.Name DESC
GO

SELECT 
	p.ProductID, 
	p.Name, 
	p.ProductNumber, 
	p.ListPrice AS Precio
FROM Production.Product AS p
ORDER BY p.Name 
GO

SELECT 
	e.BusinessEntityID, 
	e.JobTitle, 
	e.BirthDate, 
	e.MaritalStatus,
	e.Gender
FROM HumanResources.Employee AS e
WHERE e.MaritalStatus = 'M'
ORDER BY e.JobTitle ASC

SELECT 
	e.JobTitle,
	e.MaritalStatus
FROM HumanResources.Employee AS e
WHERE e.MaritalStatus = 'M'
GROUP BY e.JobTitle, e.MaritalStatus
ORDER BY e.JobTitle ASC

SELECT 
	e.ProductID, 
	CONVERT(NVARCHAR(40),SUM(e.OrderQty * e.UnitPrice),3) AS Total,
	SUM(e.LineTotal)
FROM Sales.SalesOrderDetail AS e
GROUP BY e.ProductID

SELECT 
	e.ProductID, 
	CONVERT(NVARCHAR(40),SUM(e.OrderQty * e.UnitPrice),3) AS Total,
	SUM(e.LineTotal)
FROM Sales.SalesOrderDetail AS e
--WHERE e.ProductID >= 800 AND e.ProductID <= 900
WHERE e.ProductID BETWEEN 800 AND 900
GROUP BY e.ProductID
GO

SELECT * 
FROM Person.Person AS p

SELECT * 
FROM Person.Person AS p
WHERE p.FirstName = 'David' AND p.LastName = 'Barber'

SELECT 
	p.BusinessEntityID, 
	p.PersonType, 
	p.FirstName +'-----'+ p.LastName 
FROM Person.Person AS p

SELECT 
	p.BusinessEntityID, 
	p.PersonType, 
	p.FirstName +'-----'+ p.LastName + ' ' + p.AdditionalContactInfo
FROM Person.Person AS p

SELECT 
	p.BusinessEntityID, 
	p.PersonType, 
	CONCAT(p.FirstName,'-----', p.LastName,'---', P.Title)
FROM Person.Person AS p
WHERE p.AdditionalContactInfo IS NOT NULL

SELECT 
	e.ProductID, 
	CONVERT(NVARCHAR(40),SUM(e.OrderQty * e.UnitPrice),3) AS Total
FROM Sales.SalesOrderDetail AS e
WHERE e.ProductID BETWEEN 800 AND 900
GROUP BY e.ProductID
HAVING SUM(e.OrderQty * e.UnitPrice) > 100000
GO

 
-- Para eliminar duplicados

SELECT
	DISTINCT e.JobTitle
FROM HumanResources.Employee e