-- ==================================================================================================
-- Logins
-- ==================================================================================================

/*

Un inicio de sesión es la identidad de la persona o el proceso que se conecta a una instancia de 
SQL Server

*/

--  Create a SQL Login T-SQL

USE master
GO

IF NOT EXISTS (SELECT * FROM sys.sql_logins AS l WHERE l.name = 'DavidSQL' )
BEGIN
	CREATE LOGIN DavidSQL WITH PASSWORD = 'DavidSQL',
    DEFAULT_DATABASE = master,
	CHECK_EXPIRATION = OFF,  CHECK_POLICY = OFF
	PRINT 'Login Creado'
END
ELSE 
	PRINT 'Login Existe'
GO

SELECT * FROM sys.sql_logins AS l
GO

-- Cambiar la base de datos predeterminada para un login

ALTER LOGIN DavidSQL WITH PASSWORD = 'DavidSQL',
DEFAULT_DATABASE = master,
CHECK_EXPIRATION = OFF , CHECK_POLICY = OFF
GO

-- DROP LOGIN DavidSQL
