=========================================================================================
-- TRIGGER || Disparadores
=========================================================================================

/*

Los tigres es un tipo especial de procedimiento almacenado que se ejecuta  
automáticamente cuando ocurre un evento en el servidor o en la base de datos.
	
Crea un disparador DML, DDL o de inicio de sesión

Los eventos DML: INSERT, UPDATE o DELETE en una tabla o vista. 
Los eventos DDL: CREATE, ALTER y DROP


Optimización de disparadores DML
--------------------------------
Los activadores funcionan en transacciones (implícitas o no) y, mientras están abiertos, 
bloquean los recursos
El bloqueo permanece en su lugar hasta que la transacción se confirma (con COMMIT) o se 
rechaza (con ROLLBACK)
Cuanto más se ejecuta un disparador, mayor es la probabilidad de que otro proceso se bloquee

Para liberar el activador de un comando que no cambia ninguna fila
IF (ROWCOUNT_BIG() = 0)
RETURN;
*/


USE master
GO

DROP DATABASE IF EXISTS SqlServerNotesForProfessionals
GO

CREATE DATABASE SqlServerNotesForProfessionals
GO

USE SqlServerNotesForProfessionals
GO


CREATE TABLE MyTrigger(
	MyTriggerId UNIQUEIDENTIFIER PRIMARY KEY,
	MyName NVARCHAR(50) NOT NULL,
	UNIQUE (MyName),
	ModificateDate DATETIME DEFAULT GETDATE()
)
GO

CREATE TABLE MyTriggerHistorial(
	MyTriggerId UNIQUEIDENTIFIER,
	MyName NVARCHAR(50) NOT NULL,
	ServidorName NVARCHAR(100) NOT NULL,
	DateElimination DATETIME NULL,
	ModificateDate DATETIME DEFAULT GETDATE(),
	Historial NVARCHAR(20) NOT NULL
)
GO


-- CREATE TRIGGER 
-- A nivel de base de datos (DML)

--CREATE TRIGGER MyTriggerInsert
--	ON MyTrigger AFTER INSERT
--GO

--CREATE TRIGGER MyTriggerUpdate
--	ON MyTrigger AFTER UPDATE
--GO

--CREATE TRIGGER MyTriggerUpdate
--	ON MyTrigger AFTER DELETE
--GO

--CREATE TRIGGER MyTriggerDML
--	ON MyTrigger AFTER INSERT, UPDATE,DELETE
--GO


-- Tablas logicas conceptuales: INSERTED, DELETED

CREATE OR ALTER TRIGGER MyTriggerInsert
ON MyTrigger AFTER INSERT  
AS
BEGIN  
	IF (ROWCOUNT_BIG() = 0) RETURN;
BEGIN TRANSACTION
	BEGIN TRY
		INSERT INTO MyTriggerHistorial(
			MyTriggerId,
			MyName,
			ServidorName,
			Historial
		)
		SELECT i.MyTriggerId, i.MyName, SYSTEM_USER,'INSERT'
			FROM INSERTED AS i
		COMMIT TRANSACTION
		PRINT 'MyTriggerInsert Correcto'
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		PRINT 'MyTriggerInsert Incorrecto'
	END CATCH
END
GO


CREATE OR ALTER TRIGGER MyTriggerUpdate
ON MyTrigger AFTER UPDATE
AS
BEGIN  
	IF (ROWCOUNT_BIG() = 0) RETURN;
BEGIN TRANSACTION
	BEGIN TRY
		INSERT INTO MyTriggerHistorial(
			MyTriggerId,
			MyName,
			ServidorName,
			Historial
		)
		SELECT i.MyTriggerId, i.MyName, SYSTEM_USER,'UPDATE'
			FROM INSERTED AS i
		COMMIT TRANSACTION
		PRINT 'MyTriggerUpdate Correcto'
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		PRINT 'MyTriggerUpdate Incorrecto'
	END CATCH
END
GO


CREATE OR ALTER TRIGGER MyTriggerDelete
	ON MyTrigger AFTER DELETE
AS
BEGIN
	IF (ROWCOUNT_BIG() = 0) RETURN;
BEGIN TRANSACTION
	BEGIN TRY
		INSERT INTO MyTriggerHistorial(
			MyTriggerId,	
			MyName,
			ServidorName,
			Historial
		)
		SELECT i.MyTriggerId, i.MyName, SYSTEM_USER,'DELETE'
			FROM deleted AS i
		COMMIT TRANSACTION 
		PRINT 'MyTriggerDelete Correcto'
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		PRINT 'MyTriggerDelete Incorrecto'
	END CATCH
END
GO

INSERT INTO MyTrigger(MyTriggerId,MyName) 
VALUES('B94CC1FE-3EAF-4535-9196-24710A943FE7','David 1')

INSERT INTO MyTrigger(MyTriggerId,MyName) 
VALUES('D9463CB8-27BD-4703-BE57-2DE76CEFA44B','David 2')

INSERT INTO MyTrigger(MyTriggerId,MyName) 
VALUES('F2DBF4DB-7AB7-4DF2-9441-8D61FD9434BD','David 3')

INSERT INTO MyTrigger(MyTriggerId,MyName) 
VALUES('1AEF6F19-A807-41F6-9114-EE1DB5A8FE83','David 4')
GO

UPDATE MyTrigger SET MyName = 'David 1 Modificado'
WHERE MyTriggerId = 'B94CC1FE-3EAF-4535-9196-24710A943FE7'
GO

DELETE FROM MyTrigger WHERE MyTriggerId = 'F2DBF4DB-7AB7-4DF2-9441-8D61FD9434BD'
GO

SELECT * FROM MyTrigger
SELECT * FROM MyTriggerHistorial
GO


-- DROP TRIGGER

-- Listar todos los triggers
SELECT [name] FROM sys.triggers
GO

IF EXISTS (SELECT [name] FROM sys.triggers WHERE name = 'MyTriggerInsert')
BEGIN
	DROP TRIGGER MyTriggerInsert
	PRINT 'Trigger MyTriggerInsert Drop'
END

IF EXISTS (SELECT [name] FROM sys.triggers WHERE name = 'MyTriggerUpdate')
BEGIN
	DROP TRIGGER MyTriggerUpdate
	PRINT 'Trigger MyTriggerUpdate Drop'
END

IF EXISTS (SELECT [name] FROM sys.triggers WHERE name = 'MyTriggerDelete')
BEGIN
	DROP TRIGGER MyTriggerDelete
	PRINT 'Trigger MyTriggerDelete Drop'
END