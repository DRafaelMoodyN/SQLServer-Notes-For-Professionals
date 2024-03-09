-- ==================================================================================================
-- Combining sets with set operators || Combinacion de operadores de conjuntos
-- ==================================================================================================

/*
Los operadores de conjuntos operan en dos conjuntos de resultados de consultas, comparando filas 
completas entre los resultados. Según el resultado de la comparación y el operador utilizado, 
el operador determina si devolver la fila o no.

T-SQL supports the operators: UNION, UNION ALL, INTERSECT, EXCEPT.

Cuando trabaje con estos operadores, debe recordar las siguientes pautas:

Debido a que las filas completas coinciden entre los conjuntos de resultados, el número de 
columnas en las consultas tiene que ser el mismo y los tipos de columna de las columnas 
correspondientes necesita ser compatible (implícitamente convertible).

Estos operadores utilizan una comparación basada en la distinción y no basada en la igualdad. 
En consecuencia, una comparación entre dos NULL produce verdadero, y una comparación entre un
NULL y un valor no NULL produce un falso. Esto contrasta con las cláusulas de filtrado como
WHERE, ON y HAVING, que arrojan datos desconocidos al comparar un NULL con cualquier cosa usando
operadores de igualdad y desigualdad.

Debido a que estos operadores son operadores de conjunto y no operadores de cursor, el
las consultas no pueden tener cláusulas ORDER BY.

Opcionalmente, puede agregar una cláusula ORDER BY que determina el orden de presentación de
el resultado del operador conjunto.

Los nombres de columna de las columnas de resultados están determinados por la primera consulta.

// Nota
El operador de conjunto de términos no es un término preciso para describir 
UNION, INERSECT y  EXCEPT
operadores, más bien operador relacional es un mejor término

*/

USE AdventureWorks2019
GO


-- UNION and UNION ALL 

/*
El operador UNION unifica los resultados de las dos consultas de entrada. Como operador de 
conjuntos, UNION tiene una propiedad DISTINCT implícita, lo que significa que no devuelve 
filas duplicadas
*/

-- Usando una UNION simple

IF OBJECT_ID ('dbo.Gloves','U') IS NOT NULL
DROP TABLE dbo.Gloves
GO

-- Create Gloves tables
SELECT ProductModelID, Name   
INTO dbo.Gloves  
FROM Production.ProductModel  
WHERE ProductModelID IN (3, 4, 5);  
GO  
  
SELECT * FROM dbo.Gloves
GO

-- tiene una propiedad DISTINCT implícita

SELECT ProductModelID, Name  
FROM Production.ProductModel  
WHERE ProductModelID NOT IN (3, 4) -- Que no sea 3 o 4 nos traera lo demas
UNION  
SELECT ProductModelID, Name  
FROM dbo.Gloves  
ORDER BY ProductModelID
GO

SELECT p.FirstName+' '+ p.LastName As Empleados  FROM HumanResources.Employee AS e
	INNER JOIN Person.Person AS p
	ON p.BusinessEntityID = e.BusinessEntityID
UNION 
SELECT  p.FirstName +' '+ p.LastName As Customer FROM Sales.Customer AS c
	INNER JOIN Person.Person AS p
	ON p.BusinessEntityID = c.PersonID
GO

-- El operador UNION  LL unifica los resultados de las dos consultas de entrada, 
-- pero no intenta eliminar los duplicados.

SELECT p.FirstName+' '+ p.LastName As Empleados  FROM HumanResources.Employee AS e
	INNER JOIN Person.Person AS p
	ON p.BusinessEntityID = e.BusinessEntityID
UNION ALL
SELECT  p.FirstName +' '+ p.LastName As Customer FROM Sales.Customer AS c
	INNER JOIN Person.Person AS p
	ON p.BusinessEntityID = c.PersonID
GO

-- Si los conjuntos que está unificando están disjuntos y no hay posibilidad de duplicados, 
-- UNION y UNION ALL devuelve el mismo resultado
-- Sin embargo, es importante usar UNION ALL en tal caso desde el punto de vista del 
-- rendimiento porque con UNION, SQL Server puede intentar eliminar los duplicados, incurriendo
-- en costos innecesarios.

-- Plan de Ejecucion

SELECT p.FirstName+' '+ p.LastName As Empleados  FROM HumanResources.Employee AS e
	INNER JOIN Person.Person AS p
	ON p.BusinessEntityID = e.BusinessEntityID
UNION 
SELECT  p.FirstName +' '+ p.LastName As Customer FROM Sales.Customer AS c
	INNER JOIN Person.Person AS p
	ON p.BusinessEntityID = c.PersonID
GO

SELECT p.FirstName+' '+ p.LastName As Empleados  FROM HumanResources.Employee AS e
	INNER JOIN Person.Person AS p
	ON p.BusinessEntityID = e.BusinessEntityID
UNION ALL
SELECT  p.FirstName +' '+ p.LastName As Customer FROM Sales.Customer AS c
	INNER JOIN Person.Person AS p
	ON p.BusinessEntityID = c.PersonID
GO


-- INTERSECT 

/*
El operador INTERSECT devuelve solo filas distintas que son comunes a ambos conjuntos.
Si una fila aparece al menos una vez en el primer conjunto y al menos una vez en el 
segundo conjunto, aparece una vez en el resultado del operador INTERSECT.

*/

SELECT p.FirstName+' '+ p.LastName As Empleados  FROM HumanResources.Employee AS e
	INNER JOIN Person.Person AS p
	ON p.BusinessEntityID = e.BusinessEntityID
INTERSECT
SELECT  p.FirstName +' '+ p.LastName As Customer FROM Sales.Customer AS c
	INNER JOIN Person.Person AS p
	ON p.BusinessEntityID = c.PersonID
GO

-- EXCEPT

/*
El operador EXCEPT realiza la diferencia de conjuntos. Devuelve filas distintas que 
aparecen en el resultado. de la primera consulta pero no de la segunda. En otras palabras,
si una fila aparece al menos una vez en la primera resultado de la consulta y cero veces 
en el segundo, se devuelve una vez en la salida

*/

SELECT p.FirstName+' '+ p.LastName As Empleados  FROM HumanResources.Employee AS e
	INNER JOIN Person.Person AS p
	ON p.BusinessEntityID = e.BusinessEntityID
EXCEPT
SELECT  p.FirstName +' '+ p.LastName As Customer FROM Sales.Customer AS c
	INNER JOIN Person.Person AS p
	ON p.BusinessEntityID = c.PersonID
GO