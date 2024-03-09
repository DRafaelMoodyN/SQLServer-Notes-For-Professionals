USE master
GO

DROP DATABASE DevTesting
GO

CREATE DATABASE DevTesting
GO

USE DevTesting
GO

-- Crear una tabla apartir de otra
-- No copia PK ni Index

SELECT * INTO ProductoRespaldo1 
FROM AdventureWorks2019.Production.Product
WHERE 1=0

SELECT * INTO ProductoRespaldo2 
FROM AdventureWorks2019.Production.Product

SELECT p.ProductID, p.Name INTO ProductoRespaldo3 
FROM AdventureWorks2019.Production.Product As p

-- Copiar entre base de datos (..)
SELECT p.ProductID, p.Name INTO DevTesting..ProductoRespaldo4
FROM AdventureWorks2019.Production.Product As p

SELECT IDENTITY(INT,1,1) AS ID , p.Name INTO DevTesting..ProductoRespaldo5
FROM AdventureWorks2019.Production.Product As p
