-- =====================================================================================
-- STORED PROCEDURE
-- =====================================================================================

USE AdventureWorks2019
GO

SELECT * FROM Person.CountryRegion
GO

CREATE DATABASE SqlServerNotesForProfessionals
GO

USE SqlServerNotesForProfessionals
GO

CREATE SCHEMA UsProc
GO

-- Crear una nueva tabla apartir de los datos de otra tabla

SELECT * 
INTO CountryRegion
FROM AdventureWorks2019.Person.CountryRegion

SELECT * FROM CountryRegion
GO

-- Crear proc con buenas practicas

CREATE OR ALTER PROC UsProc.US_CountryRegion_Select
WITH ENCRYPTION -- Cifrarlo
AS 
-- Desactiva los msj que se devuelve despues que se ejecutan las intrucciones 
-- SELECT, INSERT, UPDATE, MERGE y DELETE.
SET NOCOUNT ON 
BEGIN
	SELECT * FROM CountryRegion AS c
	ORDER BY c.Name
END
GO

-- Listar todos los proc
EXEC sp_stored_procedures
GO

-- Definicon
EXEC sp_helptext 'UsProc.US_CountryRegion_Select'
GO

-- Ejecutar 
EXEC UsProc.US_CountryRegion_Select
GO

-- Renombrar 
EXEC sp_rename 'sp_original','sp_modificar'
GO

-- DELETE
DROP PROC UsProc.US_CountryRegion_Select
GO
