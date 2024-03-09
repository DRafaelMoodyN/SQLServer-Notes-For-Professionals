-- ==================================================================================================
-- WHERE 
-- ==================================================================================================

/*
Especifica la condición de búsqueda para las filas devueltas por la consulta

Filtrado de datos con predicados
*/

USE AdventureWorks2019
GO

-- Predicado de igualdad

SELECT * FROM Person.CountryRegion AS e
WHERE e.CountryRegionCode = N'WS'
GO

-- Predicado de desigualda

SELECT * FROM Person.CountryRegion AS e
WHERE e.CountryRegionCode <> 'WS'
GO

-- IS NULL

SELECT 
	pm.ProductModelID, 
	pm.Name , 
	pp.ProductID, 
	pp.Name , 
	pp.ProductModelID
FROM Production.ProductModel pm 
LEFT JOIN  Production.Product pp
	ON pm.ProductModelID = pp.ProductModelID
WHERE pp.ProductModelID IS NULL -- Filtra los valores que son null
ORDER BY pp.ProductID

-- IS NOT NULL

SELECT 
	pm.ProductModelID, 
	pm.Name , 
	pp.ProductID, 
	pp.Name , 
	pp.ProductModelID
FROM Production.ProductModel pm 
LEFT JOIN  Production.Product pp
	ON pm.ProductModelID = pp.ProductModelID
WHERE pp.ProductModelID IS NOT NULL -- Filtra los valores que son null
ORDER BY pp.ProductID

-- Filtrar datos de fecha y hora

SELECT * FROM Sales.SalesOrderHeader AS s
WHERE s.OrderDate = '2011-5-31'

SELECT * FROM Sales.SalesOrderHeader AS s
WHERE s.OrderDate = '20110531' -- Recomendacion

-- Convertir la cadena explicitamente con CONVERT

SELECT 
	TOP 1 
	CAST(s.OrderDate AS DATETIME) 
FROM Sales.SalesOrderHeader AS s 

SELECT * FROM Sales.SalesOrderHeader AS s
WHERE s.OrderDate = CONVERT(NVARCHAR(50),'20110531',101)

-- Comparar entre un rango 

SELECT * FROM Sales.SalesOrderHeader AS s
WHERE s.OrderDate 
	BETWEEN CONVERT(NVARCHAR(50),'20110531',101)  AND '20110630'

-- Comparar entre un rango

SELECT * 
FROM Sales.SalesOrderHeader AS s
WHERE s.OrderDate >= '20110531' AND s.OrderDate <= '20110720'

SELECT * 
FROM Sales.SalesOrderHeader AS s
WHERE s.OrderDate <= '20110531' AND s.OrderDate >= '20110720'

-- Comparar Or // Cuidado con este tipo de consulta

SELECT * 
FROM Sales.SalesOrderHeader AS s
WHERE s.OrderDate >= '20110531' OR s.OrderDate <= '20110720'

SELECT * 
FROM Sales.SalesOrderHeader AS s
WHERE s.OrderDate = '20110531' OR s.OrderDate = '20110720'

SELECT * 
FROM Sales.SalesOrderHeader AS s
WHERE s.OrderDate < '20110531' OR s.OrderDate > '20110720'

