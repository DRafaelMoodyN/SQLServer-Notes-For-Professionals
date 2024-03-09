-- ========================================================================================================
-- Auditoria a nivel de Servidor 
-- ========================================================================================================

-- Creating a Server Audit TSQL

USE Master
GO

CREATE SERVER AUDIT [Audit-ProSQLAdminTSQL]
TO FILE
( 
	FILEPATH = N'C:\Programacion\Net\SqlServer\File\Audit\',
	MAXSIZE = 512 MB,
	MAX_ROLLOVER_FILES = 2147483647
	,RESERVE_DISK_SPACE = OFF
)
WITH
( 
	QUEUE_DELAY = 1000,
	ON_FAILURE = CONTINUE
)
-- Limitnado la auditoria
WHERE object_name = 'sysadmin'
GO

-- Encender la  Auditing
ALTER SERVER AUDIT [Audit-ProSQLAdminTSQL] WITH (STATE = ON);

-- Apagar la Auditing
ALTER SERVER AUDIT [Audit-ProSQLAdminTSQL] WITH (STATE = OFF);

-- Delete a Server Audit TSQL
DROP SERVER AUDIT [Audit-ProSQLAdminTSQL]


-- Creating the Server Audit Specification
CREATE SERVER AUDIT SPECIFICATION [ServerAuditSpecification-ProSQLAdminTSQL]
-- Asignacion a una auditoria
FOR SERVER AUDIT [Audit-ProSQLAdminTSQL]
-- Asignar el tipo de auditoria a seguir
ADD (SERVER_ROLE_MEMBER_CHANGE_GROUP)