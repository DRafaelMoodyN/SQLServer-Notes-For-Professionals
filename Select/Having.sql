-- ==================================================================================================
-- HAVING
-- ==================================================================================================/*Especifica una condicion de busqueda para un gruopo o un agregado, Solo se puede usar con la intruccion SELECT, HAVING se usa tipicamente con la clausula GROUP BY,cuando no se usa GROUP BY, hay un unico grupo agregado implicitamente*/USE AdventureWorks2019-- Recupera el total que excede a 100000.00SELECT s.SalesOrderID, 	SUM(s.LineTotal) as Total FROM Sales.SalesOrderDetail AS sGROUP BY s.SalesOrderIDHAVING SUM(s.LineTotal) > 100000.00ORDER BY s.SalesOrderID