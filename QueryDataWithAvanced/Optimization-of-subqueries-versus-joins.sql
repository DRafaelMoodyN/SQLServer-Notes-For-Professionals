-- ==================================================================================================
-- Optimization of subqueries versus joins
-- ==================================================================================================

/*
Al comparar el rendimiento de las soluciones que utilizan subconsultas frente a las soluciones que 
utilizan uniones, encontrará que no es como si una herramienta siempre funcionara mejor que la otra. 
hay casos donde obtendrá los mismos planes de ejecución de consultas para ambos, casos en los que se
realizan subconsultas mejor, y casos en los que las uniones funcionan mejor. En última instancia, en 
casos críticos de rendimiento, quiere probar soluciones basadas en ambas herramientas. Sin embargo, 
hay aspectos específicos de estas herramientas donde se sabe que SQL Server maneja uno mejor que el
otro que desea asegurarse que eres consciente.

*/

USE Northwind
GO


CREATE INDEX idx_cid_i_frt_oid
	ON dbo.Orders(CustomerID) INCLUDE (Freight,OrderID)

-- Aquí está la solución para la tarea usando subconsultas correlacionadas
-- Con el index esta consulta toma un 63%
-- sin el index esta consulta toma un 71%

SELECT 
	o.OrderID, o.CustomerID, o.Freight,
	o.Freight / (
		SELECT SUM(o1.Freight) 
		FROM dbo.Orders o1
		WHERE o1.CustomerID = o.CustomerID) As SumTotal,
	o.Freight - (
	SELECT AVG(o2.Freight) 
	FROM dbo.Orders o2
	WHERE o2.CustomerID = o.CustomerID) As AvgTotal
FROM dbo.Orders AS o

-- Aquí está la solución para la tarea usando una tabla derivada y una combinación
-- Con el index esta consulta toma un 37%
-- sin el index esta consulta toma un 29%

SELECT 
	o.OrderID, o.CustomerID, o.Freight,
	o.Freight / SumTotal,
	o.Freight - AvgTotal
FROM dbo.Orders AS o
	INNER JOIN (SELECT 
				sub.CustomerID, 
				SUM(sub.Freight) AS SumTotal, 
				AVG(sub.Freight) AS AvgTotal
				FROM dbo.Orders sub
				GROUP BY sub.CustomerID
) AS SubTable
ON o.CustomerID = SubTable.CustomerID
GO


--DROP INDEX idx_cid_i_frt_oid 
--ON dbo.Orders
--GO