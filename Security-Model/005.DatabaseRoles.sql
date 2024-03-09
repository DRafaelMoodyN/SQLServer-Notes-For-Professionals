-- ==================================================================================================
-- DATABASE ROLES
-- ==================================================================================================

/*

db_accessadmin:
Pueden agregar y quitar usuarios de la base de datos del base de datos.

db_backupoperator:
Otorga a los usuarios los permisos que necesita hacer una copia de seguridad de la bd, 
de forma nativa. Es posible que no funcione con herramientas de copia de seguridad de 
terceros, como CommVault o Backup Exec, ya que estas las herramientas a menudo exigen 
derechos de administrador del sistema

db_datareader: 
pueden ejecutar sentencias SELECT contra cualquier tabla en la base de datos. 
Es posible anular esto para tablas específicas negando explícitamente a un usuario, 
los permisos para leer esas mesas. DENY siempre anula GRANT

db_datawriter:
pueden realizar DML (Data Manipulation Language) contra cualquier tabla en el
base de datos. Es posible anular esto para tablas específicas por negar específicamente a 
un usuario los permisos para escribir en una tabla. NEGAR siempre anulará GRANT.

db_denydatareader:
Niega el permiso SELECT contra cada tabla en la base de datos

db_denydatawriter:
Niega a sus miembros los permisos
para realizar sentencias DLM en cada tabla de la base de datos.

db_ddladmin:
Los miembros de este rol tienen la capacidad de ejecutar CREATE, ALTER,
y declaraciones DROP contra cualquier objeto en la base de datos. Este
rara vez se usa, pero he visto un par de ejemplos de mal
aplicaciones escritas que crean objetos de base de datos sobre la marcha. Si usted es
responsable de administrar una aplicación como esta, entonces el
El rol ddl_admin puede ser útil.

db_owner:
Pueden realizar cualquier acción dentro del base de datos que no ha sido específicamente 
denegada

db_securityadmin:
Los miembros de este rol pueden CONCEDER, DENEGAR y REVOCAR la autorización de un usuario.
permisos a asegurables. También pueden modificar la pertenencia a funciones,
con la excepción del rol db_owner

*/

USE AdventureWorks2019
GO

-- Crear rol
CREATE ROLE rol_sales AUTHORIZATION DavidSQL
GO

-- Dar permisos
GRANT SELECT ON SCHEMA::Sales TO rol_sales;
GRANT INSERT ON SCHEMA::Sales TO rol_sales;
GRANT UPDATE ON SCHEMA::Sales TO rol_sales;
-- GRANT DELETE ON SCHEMA::Sales TO rol_sales;

-- GRANT CREATE TABLE TO rol_sales

ALTER ROLE rol_sales ADD MEMBER DavidSQL
GO

-- Denegar permisos
--DENY SELECT ON SCHEMA::Sales TO rol_sales;
--DENY INSERT ON SCHEMA::Sales TO rol_sales;
--DENY UPDATE ON SCHEMA::Sales TO rol_sales;
--DENY DELETE ON SCHEMA::Sales TO rol_sales;

-- Revocar permisos
--REVOKE SELECT ON SCHEMA::Sales TO rol_sales;
--REVOKE INSERT ON SCHEMA::Sales TO rol_sales;
--REVOKE UPDATE ON SCHEMA::Sales TO rol_sales;
--REVOKE DELETE ON SCHEMA::Sales TO rol_sales;


-- Agregar al usuario roles de base de datos
EXEC sp_addrolemember 'db_owner','DavidSQL'
GO

EXEC sp_droprolemember'db_owner','DavidSQL'
GO

-- Habilitar al usuario habilitado
--GRANT CONNECT TO t testing
--DENY CONNECT TO t tes

-- Moverme entre usuarios
SELECT USER
EXEC AS USER = 'DavidSQL'
REVERT