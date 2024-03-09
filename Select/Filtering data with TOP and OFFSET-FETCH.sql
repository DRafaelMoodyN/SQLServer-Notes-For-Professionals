-- ==================================================================================================
-- Filtering data with TOP and OFFSET-FETCH
-- ==================================================================================================

/*
T-SQL admite filtros que se basan en un número o porcentaje de filas y ordenación. 

Filtering data with TOP
El primero se usa en muchas tareas comunes de filtrado.
TOP se basa en la misma cláusula ORDER BY que normalmente se usa para orden de presentación

OFFSET-FETCH
Se utiliza normalmente en tareas más especializadas relacionadas con la paginación.
tiene un capacidad de omision

Las cláusulas OFFSET y FETCH aparecen justo después de la cláusula ORDER BY y, de hecho, 
en T-SQL, requieren una cláusula ORDER BY para estar presente.

Primero especifica la cláusula OFFSET
indicando cuántas filas desea omitir (0 si no desea omitir ninguna)

luego, opcionalmente, especifica la cláusula FETCH que indica cuántas filas desea filtrar

*/

USE AdventureWorks2019
GO


-- TOP

SELECT 
	TOP (10) * 
FROM Person.Person AS p
ORDER BY p.FirstName
GO

SELECT 
	TOP (10) * 
FROM Person.Person AS p
ORDER BY p.FirstName DESC
GO


-- Tambien puede especificar un % de fila para filtar en lugar de un numero
-- PERCENT

SELECT 
	COUNT(*) AS 'Total Count Person' 
FROM Person.Person AS p
GO

SELECT 
	 TOP (10) PERCENT *
FROM Person.Person AS p
ORDER BY p.FirstName DESC
GO


-- Tenga en cuenta que incluso cuando tiene una cláusula ORDER BY, para que la consulta 
-- sea completamente determinista, el orden debe ser único
-- La columna de fecha de pedido no es única, por lo que el orden en caso de empate es 
-- arbitrario

SELECT 
	TOP (3) *
FROM Sales.SalesOrderHeader AS soh
ORDER BY soh.OrderDate
GO

--Result
/*
43662	2011-05-31 00:00:00.000
43661	2011-05-31 00:00:00.000
43660	2011-05-31 00:00:00.000
*/


-- ¿Qué pasa si hay otras filas en el resultado sin TOP que tienen la misma fecha de pedido?
-- No siempre se preocupa por garantizar resultados deterministas o repetibles.
-- pero si lo hace, hay dos opciones disponibles para usted. Una opción es pedir que se incluyan 
-- todos los lazos con la última fila agregando la opción CON LAZOS

-- Por supuesto, esto podría generar más filas de las que solicitó
SELECT 
	TOP (3) WITH TIES *
FROM Sales.SalesOrderHeader AS soh
ORDER BY soh.OrderDate
GO

-- La otra opción para garantizar el determinismo es romper los empates añadiendo un desempate
-- eso hace que el pedido sea único
-- Ahora tanto la selección de filas como el orden de presentación son deterministas
SELECT 
	TOP (3)*
FROM Sales.SalesOrderHeader AS soh
ORDER BY soh.OrderDate, soh.SalesOrderID
GO


-- OFFSET-FETCH

-- la siguiente consulta define el pedido en función de la fecha del pedido descendente, 
-- seguido del ID del pedido descendiendo; luego salta las primeras 50 filas y obtiene 
-- las siguientes 25 filas:

SELECT 
	* 
FROM Sales.SalesOrderHeader AS soh
ORDER BY soh.OrderDate DESC, soh.SalesOrderID
OFFSET 50 ROWS FETCH NEXT 25 ROW ONLY
GO

/*
La cláusula ORDER BY ahora juega dos roles: un rol es decirle a la opción OFFSET-FETCH
qué filas necesita filtrar. Otro rol es determinar el orden de presentación en la consulta.

Cuando no se salta ninguna fila, podría ser más intuitivo para usted usar las palabras 
clave FETCH FIRST
*/

SELECT 
	* 
FROM Sales.SalesOrderHeader AS soh
ORDER BY soh.OrderDate DESC, soh.SalesOrderID
OFFSET 0 ROWS FETCH FIRST 25 ROW ONLY
GO

-- Siguiente consulta solicita omitir 50 filas y devolver el resto.

SELECT 
	* 
FROM Sales.SalesOrderHeader AS soh
ORDER BY soh.OrderDate DESC, soh.SalesOrderID
OFFSET 50 ROWS
GO

-- Como se mencionó anteriormente, la opción OFFSET-FETCH requiere una cláusula 
-- ORDER BY. Pero que si necesita filtrar una cierta cantidad de filas en función
-- de un orden arbitrario?

SELECT 
	* 
FROM Sales.SalesOrderHeader AS soh
ORDER BY (SELECT NULL)
OFFSET 50 ROWS FETCH NEXT 30 ROWS ONLY
GO

-- Con las cláusulas OFFSET y FETCH, puede usar expresiones como entradas. 
-- Esto es muy útil cuando necesita calcular los valores de entrada dinámicamente
-- Implementacion de paginacion

DECLARE @PageSize AS BIGINT = 3;
DECLARE @PageNumber AS BIGINT = 100;

SELECT 
	* 
FROM Person.Person AS p
ORDER BY p.BusinessEntityID
OFFSET (@PageNumber-1) * @PageSize ROWS FETCH NEXT @PageNumber ROW ONLY
GO

/*
En términos de procesamiento de consultas lógicas, los filtros TOP y OFFSET-FETCH se procesan 
después las fases FROM, WHERE, GROUP, HAVING y SELECT. Puedes considerar estos filtros
como una extensión de la cláusula ORDER BY. Entonces, por ejemplo, si la consulta es un grupo
consulta, y también implica un filtro TOP o OFFSET-FETCH, el filtro se aplica después de la
agrupación. Lo mismo se aplica si la consulta tiene una cláusula DISTINCT y/o un cálculo de 
ROW_NUMBER como parte de la cláusula SELECT, así como un filtro TOP o OFFSET-FETCH. El filtro 
se aplica después la cláusula DISTINCT y/o el cálculo de ROW_NUMBER.
*/

/*
Debido a que la opción OFFSET-FETCH es estándar y TOP no lo es, en los casos en que son 
lógicamente equivalentes, se recomienda ceñirse a la primera. Recuerde que OFFSET-FETCH también
tiene una ventaja sobre TOP en el sentido de que admite una capacidad de salto. Sin embargo, por
ahora, OFFSET-FETCH no admite opciones similares a TOP'S PERCENT y WITH TIES, incluso
aunque la norma sí los define.
Desde el punto de vista del rendimiento, debería considerar indexar las columnas ORDER BY para
admite las opciones TOP y OFFSET-FETCH. Dicha indexación tiene un propósito similar al de la 
indexación de columnas filtradas y puede ayudar a evitar el escaneo de datos innecesarios, 
así como la clasificación.
*/