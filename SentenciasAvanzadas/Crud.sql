USE master
GO

CREATE DATABASE DevTesting
GO

DROP DATABASE DevTesting
GO

USE DevTesting
GO

CREATE TABLE Person(
	PersonID INT IDENTITY PRIMARY KEY,
	FirstName NVARCHAR(50) NOT NULL,
	LastName NVARCHAR(50)  NOT NULL,
	UserCreate NVARCHAR(50) NOT NULL,
	EmailPromotion BIT DEFAULT 0 NOT NULL,
	ISActive BIT DEFAULT 1 NOT NULL
)

-- Llenar una tabla a partir de otra

INSERT INTO Person(FirstName, LastName,UserCreate,ISActive)
SELECT FirstName, LastName,SYSTEM_USER, 1 
FROM AdventureWorks2019.Person.Person

SELECT * FROM Person

-- Actualizar un campo 

SELECT COUNT(*) FROM AdventureWorks2019.Person.Person p
WHERE p.FirstName = 'David'

UPDATE AdventureWorks2019.Person.Person SET EmailPromotion = 0
FROM AdventureWorks2019.Person.Person p1
WHERE p1.FirstName = 'David'

-- Eliminar un registro

DELETE e
FROM AdventureWorks2019.Person.EmailAddress e
INNER JOIN AdventureWorks2019.Person.BusinessEntity b
ON e.BusinessEntityID = b.BusinessEntityID
INNER JOIN AdventureWorks2019.HumanResources.Employee p
ON b.BusinessEntityID = p.BusinessEntityID
WHERE p.JobTitle = 'Tool Designer'
