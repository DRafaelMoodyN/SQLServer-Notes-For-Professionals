-- ==================================================================================================
-- Filtering data with TOP and OFFSET-FETCH
-- ==================================================================================================

/*
T-SQL admite filtros que se basan en un n�mero o porcentaje de filas y ordenaci�n. 

Filtering data with TOP
El primero se usa en muchas tareas comunes de filtrado.
TOP se basa en la misma cl�usula ORDER BY que normalmente se usa para orden de presentaci�n

OFFSET-FETCH
Se utiliza normalmente en tareas m�s especializadas relacionadas con la paginaci�n.
tiene un capacidad de omision

Las cl�usulas OFFSET y FETCH aparecen justo despu�s de la cl�usula ORDER BY y, de hecho, 
en T-SQL, requieren una cl�usula ORDER BY para estar presente.

Primero especifica la cl�usula OFFSET
indicando cu�ntas filas desea omitir (0 si no desea omitir ninguna)

luego, opcionalmente, especifica la cl�usula FETCH que indica cu�ntas filas desea filtrar

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


-- Tenga en cuenta que incluso cuando tiene una cl�usula ORDER BY, para que la consulta 
-- sea completamente determinista, el orden debe ser �nico
-- La columna de fecha de pedido no es �nica, por lo que el orden en caso de empate es 
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


-- �Qu� pasa si hay otras filas en el resultado sin TOP que tienen la misma fecha de pedido?
-- No siempre se preocupa por garantizar resultados deterministas o repetibles.
-- pero si lo hace, hay dos opciones disponibles para usted. Una opci�n es pedir que se incluyan 
-- todos los lazos con la �ltima fila agregando la opci�n CON LAZOS

-- Por supuesto, esto podr�a generar m�s filas de las que solicit�
SELECT 
	TOP (3) WITH TIES *
FROM Sales.SalesOrderHeader AS soh
ORDER BY soh.OrderDate
GO

-- La otra opci�n para garantizar el determinismo es romper los empates a�adiendo un desempate
-- eso hace que el pedido sea �nico
-- Ahora tanto la selecci�n de filas como el orden de presentaci�n son deterministas
SELECT 
	TOP (3)*
FROM Sales.SalesOrderHeader AS soh
ORDER BY soh.OrderDate, soh.SalesOrderID
GO


-- OFFSET-FETCH

-- la siguiente consulta define el pedido en funci�n de la fecha del pedido descendente, 
-- seguido del ID del pedido descendiendo; luego salta las primeras 50 filas y obtiene 
-- las siguientes 25 filas:

SELECT 
	* 
FROM Sales.SalesOrderHeader AS soh
ORDER BY soh.OrderDate DESC, soh.SalesOrderID
OFFSET 50 ROWS FETCH NEXT 25 ROW ONLY
GO

/*
La cl�usula ORDER BY ahora juega dos roles: un rol es decirle a la opci�n OFFSET-FETCH
qu� filas necesita filtrar. Otro rol es determinar el orden de presentaci�n en la consulta.

Cuando no se salta ninguna fila, podr�a ser m�s intuitivo para usted usar las palabras 
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

-- Como se mencion� anteriormente, la opci�n OFFSET-FETCH requiere una cl�usula 
-- ORDER BY. Pero que si necesita filtrar una cierta cantidad de filas en funci�n
-- de un orden arbitrario?

SELECT 
	* 
FROM Sales.SalesOrderHeader AS soh
ORDER BY (SELECT NULL)
OFFSET 50 ROWS FETCH NEXT 30 ROWS ONLY
GO

-- Con las cl�usulas OFFSET y FETCH, puede usar expresiones como entradas. 
-- Esto es muy �til cuando necesita calcular los valores de entrada din�micamente
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
En t�rminos de procesamiento de consultas l�gicas, los filtros TOP y OFFSET-FETCH se procesan 
despu�s las fases FROM, WHERE, GROUP, HAVING y SELECT. Puedes considerar estos filtros
como una extensi�n de la cl�usula ORDER BY. Entonces, por ejemplo, si la consulta es un grupo
consulta, y tambi�n implica un filtro TOP o OFFSET-FETCH, el filtro se aplica despu�s de la
agrupaci�n. Lo mismo se aplica si la consulta tiene una cl�usula DISTINCT y/o un c�lculo de 
ROW_NUMBER como parte de la cl�usula SELECT, as� como un filtro TOP o OFFSET-FETCH. El filtro 
se aplica despu�s la cl�usula DISTINCT y/o el c�lculo de ROW_NUMBER.
*/

/*
Debido a que la opci�n OFFSET-FETCH es est�ndar y TOP no lo es, en los casos en que son 
l�gicamente equivalentes, se recomienda ce�irse a la primera. Recuerde que OFFSET-FETCH tambi�n
tiene una ventaja sobre TOP en el sentido de que admite una capacidad de salto. Sin embargo, por
ahora, OFFSET-FETCH no admite opciones similares a TOP'S PERCENT y WITH TIES, incluso
aunque la norma s� los define.
Desde el punto de vista del rendimiento, deber�a considerar indexar las columnas ORDER BY para
admite las opciones TOP y OFFSET-FETCH. Dicha indexaci�n tiene un prop�sito similar al de la 
indexaci�n de columnas filtradas y puede ayudar a evitar el escaneo de datos innecesarios, 
as� como la clasificaci�n.
*/