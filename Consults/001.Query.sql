USE AdventureWorks2019
GO

-- Buscar valores duplicados ---------------------------------------------------------------
SELECT p.FirstName FROM Person.Person AS p
GROUP BY p.FirstName
HAVING COUNT(p.FirstName) > 1

SELECT 
	p.FirstName NumerBuplicado,
	(
		SELECT COUNT(t.FirstName) 
		FROM Person.Person AS t
		WHERE p.FirstName = t.FirstName
	)
FROM Person.Person AS p
GROUP BY p.FirstName
HAVING COUNT(p.FirstName) > 1

