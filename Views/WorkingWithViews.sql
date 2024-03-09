-- VIEWS

USE AdventureWorks2019
GO

SELECT * FROM Sales.SalesOrderHeader
SELECT * FROM Sales.SalesOrderDetail
GO

CREATE OR ALTER VIEW Sales.ViewOrderTotal
-- Vinculacion del objecto al esquema de todas las table y view
-- Para evitar cambios estructurales mientras exista la views
	--WITH SCHEMABINDING 
AS
	SELECT 
		soh.OrderDate, 
		(
			CASE WHEN soh.OnlineOrderFlag = 0 THEN 'FISICO' ELSE 'VIRTUAL' END
		) AS OnLineOrderFlag,
		sod.ProductID, SUM(sod.OrderQty) OrderQty, 
		FORMAT(sod.UnitPrice,'N','en-us') AS UnitPrice, 
		FORMAT(sod.LineTotal,'N','en-us') AS LineTotal
	FROM Sales.SalesOrderHeader AS soh
		INNER JOIN Sales.SalesOrderDetail AS sod
			ON soh.SalesOrderID = sod.SalesOrderID
	GROUP BY soh.OrderDate, soh.OnlineOrderFlag,
			 sod.ProductID, sod.UnitPrice, sod.LineTotal

GO

SELECT * FROM sales.ViewOrderTotal as t
GO

-- Requisitos
-- Todas las columnas deben tener nombres y unicos
-- No se permite que la consulta interna tenga un ORDER BY

-- Definicion
PRINT OBJECT_DEFINITION(OBJECT_ID(N'sales.ViewOrderTotal'))
GO
/*
T-SQL admite la definición de vistas basadas en una consulta contra un CTE. 
Como ejemplo, el siguiente código define una vista llamada Sales.CustLast5OrderDates 
basada en una consulta que para cada cliente, devuelve las últimas cinco fechas de 
pedido distintas:
*/

CREATE OR ALTER VIEW Sales.ViewCliente
WITH SCHEMABINDING
AS
WITH C AS -- CTE Table Expresion Comun
(
	SELECT 
		s.CustomerID, s.OrderDate,
		DENSE_RANK() OVER(PARTITION BY s.CustomerID ORDER BY s.OrderDate DESC) AS Cliente
	FROM Sales.SalesOrderHeader AS s
)
SELECT CustomerID,[1],[2],[3],[4],[5]
FROM C
	PIVOT(MAX(c.OrderDate) FOR Cliente IN([1],[2],[3],[4],[5])) AS p
GO

PRINT OBJECT_DEFINITION(OBJECT_ID(N'Sales.ViewCliente'))

SELECT * FROM Sales.ViewCliente