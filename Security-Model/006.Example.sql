-- ==================================================================================================
-- Example 
-- ==================================================================================================

USE master
GO

IF NOT EXISTS (SELECT * FROM sys.sql_logins AS l WHERE l.name = 'DavidSQLServer' )
BEGIN
	CREATE LOGIN DavidSQLServer WITH PASSWORD = 'DavidSQLServer',
	CHECK_EXPIRATION = OFF,  CHECK_POLICY = OFF
	PRINT 'Login Creado'
END
ELSE 
	ALTER LOGIN DavidSQLServer WITH PASSWORD = 'DavidSQLServer',
	CHECK_EXPIRATION = OFF,  CHECK_POLICY = OFF
	PRINT 'Login Modificado'
GO

-- Asignar rol a un login
EXEC sp_addsrvrolemember 'DavidSQLServer','dbcreator'
GO

USE AdventureWorks2019
GO

CREATE USER DavidSQLServer FOR LOGIN DavidSQLServer
WITH DEFAULT_SCHEMA = dbo
GO

EXEC sp_addrolemember 'db_owner','DavidSQLServer'
GO
