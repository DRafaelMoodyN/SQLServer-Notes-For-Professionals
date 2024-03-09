-- ==================================================================================================
-- IN
-- ==================================================================================================

/*
Determina si un valor especificado coincide con algún valor de una subconsulta o una lista.

Tipo de resultado: Boolean

El uso de NOT IN niega el valor de subquery o de expression.

La utilización de valores NULL con IN o NOT IN puede provocar resultados inesperados.
*/

USE AdventureWorks2019
GO

-- Comparar OR e IN

SELECT p.FirstName, p.LastName, e.JobTitle  
FROM Person.Person AS p  
JOIN HumanResources.Employee AS e  
    ON p.BusinessEntityID = e.BusinessEntityID  
WHERE e.JobTitle = 'Design Engineer'   
   OR e.JobTitle = 'Tool Designer'   
   OR e.JobTitle = 'Marketing Assistant'  
GO  

SELECT p.FirstName, p.LastName, e.JobTitle  
FROM Person.Person AS p  
JOIN HumanResources.Employee AS e  
    ON p.BusinessEntityID = e.BusinessEntityID  
WHERE e.JobTitle IN ('Design Engineer', 'Tool Designer', 'Marketing Assistant');  
GO  

-- Utilizar IN con una subconsulta
-- Se buscan todos los identificadores de vendedor de la tabla SalesPerson
-- para los empleados cuya cuota de ventas sea superior a 250.000 dólares al año y, después, 
-- se seleccionan en la tabla Employee los nombres de todos los empleados cuyo EmployeeID 
-- coincida con los resultados de la subconsulta SELECT


-- ¿Cuándo se utiliza una subconsulta en SQL?
-- Cuando necesita incluir en la cláusula WHERE criterios de selección que solamente 
-- existen en otra tabla

SELECT 
	p.FirstName, p.LastName, sp.SalesQuota
FROM Person.Person AS p
	INNER JOIN Sales.SalesPerson AS sp
	ON p.BusinessEntityID = sp.BusinessEntityID
WHERE p.BusinessEntityID IN 
	(SELECT
		sub.BusinessEntityID
	 FROM Sales.SalesPerson sub 
	 WHERE sub.SalesQuota >250000
	)
GO

-- Utilizar NOT IN con una subconsulta

SELECT 
	p.FirstName, p.LastName, sp.SalesQuota
FROM Person.Person AS p
	INNER JOIN Sales.SalesPerson AS sp
	ON p.BusinessEntityID = sp.BusinessEntityID
WHERE p.BusinessEntityID NOT IN 
	(SELECT
		sub.BusinessEntityID
	 FROM Sales.SalesPerson sub 
	 WHERE sub.SalesQuota >250000
	)
GO
