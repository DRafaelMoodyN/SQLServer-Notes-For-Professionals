-- ==================================================================================================
-- Server Roles
-- ==================================================================================================

/*

SQL Server proporciona un conjunto de roles de servidor integrados listos para usararse. 
Estos roles permiten asignacion a permisos a nivel de instancia a inicios de sesi�n que 
tengan requisitos comunes. 

-----------------------------------------------------------------------------------------------------
Server Roles, Roles a nivel de servidor

bulkadmin:
Puede ejecutar la instrucci�n BULK INSERT. para inserciones masivas de datos

dbcreator: 
Puede crear, modificar, eliminar y restaurar cualquier bd.

diskadmin: 
Pueden administrar archivos de disco.(Grupos de archivos)

processadmin: 
Pueden terminar los procesos que se ejecutan en una instancia del Motor de bd

public: 
Todos los usuarios, grupos y roles de SQL Server pertenecen al rol de servidor fijo 
p�blico de forma predeterminada.

securityadmin:
Administran los inicios de sesi�n y sus propiedades. Pueden OTORGAR, DENEGAR y REVOCAR 
permisos a nivel de servidor. Tambi�n pueden OTORGAR, DENEGAR y REVOCAR permisos a nivel
de base de datos. Adem�s, pueden restablecer contrase�as para inicios de sesi�n de SQL.

serveradmin:
Pueden cambiar las opciones de configuraci�n de todo el servidor y apagar el servidor.

setupadmin:
Pueden agregar y eliminar servidores vinculados, y pueden ejecutar algunos procedimientos 
almacenados del sistema.

sysadmin:
Pueden realizar cualquier actividad en el Motor de base de datos.

*/

-- Lista de roles
EXEC sp_helpsrvrole
GO

-- Informacion acerca de los miembros de un rol
EXEC sp_helpsrvrolemember 
GO

-- Muestra los permisos de un rol
EXEC sp_srvrolepermission 
GO 

-- Asignar rol a un login
EXEC sp_addsrvrolemember 'DavidSQL','dbcreator'
-- Eliminar rol a un login
EXEC sp_dropsrvrolemember 'DavidSQL','dbcreator'
