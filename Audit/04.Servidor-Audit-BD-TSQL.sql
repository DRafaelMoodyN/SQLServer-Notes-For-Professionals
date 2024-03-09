-- ========================================================================================================
-- Auditoria a nivel de Base de datos
-- ========================================================================================================

-- Datos para la prueba

USE Master
GO

DROP DATABASE IF EXISTS Chapter10Audit

CREATE DATABASE Chapter10Audit
GO

USE Chapter10Audit
GO

CREATE TABLE dbo.SensitiveData (
	ID INT PRIMARY KEY NOT NULL,
	Data NVARCHAR(256) NOT NULL
) 
GO

CREATE USER Danielle FOR LOGIN InventoryLogin WITH DEFAULT_SCHEMA=dbo;
GO
GRANT SELECT ON dbo.SensitiveData TO Danielle ;
GRANT INSERT ON dbo.SensitiveData TO Danielle ;
GRANT DELETE ON dbo.SensitiveData TO Danielle ;

--Creating Server Audit
USE master
GO

CREATE SERVER AUDIT [Audit-Chapter10AuditTSQL]
TO FILE
( 
	FILEPATH = N'C:\Programacion\Net\SqlServer\File\Audit\',
	MAXSIZE = 512 MB,
	MAX_ROLLOVER_FILES = 2147483647,
	RESERVE_DISK_SPACE = OFF
)
WITH
( 
	QUEUE_DELAY = 1000,
	ON_FAILURE = CONTINUE
)


ALTER SERVER AUDIT [Audit-Chapter10AuditTSQL] WITH (STATE = ON)

-- Creating the Database Audit Specification

USE Chapter10Audit
GO

CREATE DATABASE AUDIT SPECIFICATION [DatabaseAuditSpecification-Chapter10-SensitiveData]
-- Asignando a una auditoria
FOR SERVER AUDIT  [Audit-Chapter10AuditTSQL]
-- Asignar los tipos de auditoria a rastrear
ADD (INSERT ON OBJECT::dbo.SensitiveData BY Danielle),
ADD (SELECT ON OBJECT::dbo.SensitiveData BY Danielle),
ADD (DELETE ON OBJECT::dbo.SensitiveData BY Danielle)


-- Enabling the Database Audit Specification

USE Chapter10Audit
GO
ALTER DATABASE AUDIT SPECIFICATION [DatabaseAuditSpecification-Chapter10-SensitiveData]
WITH (STATE = ON) ;
GO

-- Datos para la prueba, entrar con el usuario creado


USE master

USE Chapter10Audit

SELECT * FROM SensitiveData

INSERT INTO SensitiveData(ID,Data)
VALUES(11,'11')

INSERT INTO SensitiveData(ID,Data)
VALUES(12,'21')

INSERT INTO SensitiveData(ID,Data)
VALUES(13,'41')

DELETE FROM SensitiveData WHERE ID = 12
DELETE FROM SensitiveData WHERE ID = 13
DELETE FROM SensitiveData WHERE ID = 14
-- 