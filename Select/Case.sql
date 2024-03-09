USE AdventureWorks2019
GO

SELECT p.*, 
	CASE WHEN (p.ListPrice = 133.34) THEN 0 
		ELSE 10 
		END 
FROM Production.Product AS p
WHERE ISNULL(p.ListPrice,'') != ''


SELECT p.*, 
	CASE WHEN (p.ListPrice > 200 AND p.ListPrice < 400) THEN 0 
		ELSE 10 
		END 
FROM Production.Product AS p
WHERE ISNULL(p.ListPrice,'') != ''


SELECT p.*, 
	CASE WHEN (p.ListPrice < 200) THEN 2
		WHEN (p.ListPrice < 300) THEN 3
		ELSE 10 
		END 
FROM Production.Product AS p
WHERE ISNULL(p.ListPrice,'') != ''


SELECT CASE DATEPART(WEEKDAY,GETDATE())
	WHEN 1 THEN 'Domingo'
	WHEN 2 THEN 'Lunes'
	WHEN 3 THEN 'Martes'
	WHEN 4 THEN 'Miercoles'
	WHEN 5 THEN 'Jueves'
	WHEN 6 THEN 'Viernes'
	WHEN 7 THEN 'Sabado'
END



