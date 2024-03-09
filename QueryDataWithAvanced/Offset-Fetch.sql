-- Filtering data with TOP and OFFSET-FETCH
-- Tareas especialisadas con la paginacion

-- Filtrado de datos con TOP(Valor)

USE AdventureWorks2019
GO

SELECT 
	TOP(3) * 
FROM Sales.SalesOrderHeader AS s
ORDER BY s.OrderDate DESC

-- Filtrado de datos con PERCENT

-- 31465 315
SELECT 
	TOP(1) PERCENT * 
FROM Sales.SalesOrderHeader AS s
ORDER BY s.OrderDate DESC

/* 
La Funcion no es determinista: nunca devolvera los mismo valores
Pero no hay garantía de que se devuelvan las mismas filas si vuelve a ejecutar la consulta. 
Si realmente está buscando tres filas arbitrarias, podría ser una buena idea agregar una 
cláusula ORDER BY con la expresión (SELECT NULL) para que la gente sepa que su elección es 
intencional y no un descuido

*/

SELECT 
	TOP(3) *
FROM Sales.SalesOrderHeader AS s

SELECT 
	TOP(3) *
FROM Sales.SalesOrderHeader AS s
ORDER BY (SELECT NULL)

/*
Tenga en cuenta que incluso cuando tiene una cláusula ORDER BY, para que la consulta sea
completamente determinista, el orden debe ser único

*/

SELECT 
	TOP(3) *
FROM Sales.SalesOrderHeader AS s
ORDER BY s.OrderDate DESC

--2014-06-30 00:00:00.000
--2014-06-30 00:00:00.000
--2014-06-30 00:00:00.000

/*
Pero, ¿qué pasa si hay otras filas en el resultado sin TOP que tienen la misma fecha de pedido?
como en la última fila aquí? No siempre se preocupa por garantizar resultados deterministas o 
repetibles. resultados; pero si lo hace, hay dos opciones disponibles para usted. Una opción es 
pedir que se incluyan todos los lazos con la última fila agregando la opción CON LAZOS, de la 
siguiente manera:

*/

SELECT 
	TOP(3) WITH TIES *
FROM Sales.SalesOrderHeader AS s
ORDER BY s.OrderDate DESC

/*
Ahora la selección de filas es determinista, pero aún así el orden de presentación entre filas
con la misma fecha de pedido no lo es.
La otra opción para garantizar el determinismo es romper los empates añadiendo un desempate
eso hace que el pedido sea único
*/

SELECT 
	TOP(3) WITH TIES s.OrderDate, s.SalesOrderID
FROM Sales.SalesOrderHeader AS s
ORDER BY s.OrderDate DESC, s.SalesOrderID DESC

--1	2014-06-30 00:00:00.000	75123
--2	2014-06-30 00:00:00.000	75122
--3	2014-06-30 00:00:00.000	75121


/*
Las cláusulas OFFSET y FETCH aparecen justo después de la cláusula ORDER BY y, de hecho, en
T-SQL, requieren una cláusula ORDER BY para estar presente.

OFFSET Indica cuantas filas desea omitir, 0 si no desea omitir ninguna
FETCH  Indica cuantas filas desea filtrar
*/


DECLARE @Page_Size INT = 10, @Page_Number INT = 2

SELECT 
	* 
FROM Person.Person p
ORDER BY (SELECT NULL)
OFFSET (@Page_Number -1) * @Page_Size ROWS FETCH NEXT @Page_Size ROW ONLY

/*
En términos de procesamiento de consultas lógicas, los filtros TOP y OFFSET-FETCH 
se procesan después las fases FROM, WHERE, GROUP, HAVING y SELECT.
*/