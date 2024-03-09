-- ========================================================================================================
-- SqlServer Profiler
-- ========================================================================================================

/*

Al trabajar con datos es necesario contar con un seguimiento de las actividades que relalizan los usuarios.

Habilidar herramientas para auditar; Enable Common Criteria compliance o conocidad como auditoria C3
Click en la instancia -> Security -> Options
Con C2 Audita todo, cuando de activa hay que reiniciar los servicios de sql 
Cliek en la instancia -> Restart

Nuestros archivos de auditoria esta por defecto en los archivos de sql en la carpeta DATA,
los archivos de auditoria se pueden abri con SqlServerProfiler.

SqlServerProfile tambien nos permite llevar un seguimiento de actividad
File -> New Trance 

Elegir el tipo de auditoria standar y darle run y SqlServerProfile empesara a rastrear toda actividad
*/

-- Datos de pruebas
CREATE DATABASE AuditTesting
GO

USE AuditTesting
GO

SELECT * FROM sys.sql_logins
GO

USE master
GO

DROP DATABASE AuditTesting
GO

-- Esta herramienta pronto ya estara sin soporte