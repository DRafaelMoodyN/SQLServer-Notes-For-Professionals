-- CONTAINS
-- Busca coicidencias precisas o aproximadas de palabras o frases
-- Se usa con WHERE

USE AdventureWorks2019
GO

SELECT 
	* 
FROM Production.ProductDescription AS p
WHERE CONTAINS (p.Description,'alloy')
GO