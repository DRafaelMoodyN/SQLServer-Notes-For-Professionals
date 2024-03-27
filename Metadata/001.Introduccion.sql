/*
Los metadatos son datos que describen otros datos.

Metadatos estructurales, que describen cada objeto, 
metadatos descriptivos, que describe los datos en sí

Los metadatos se exponen a través de una serie de:
• Catalog views
• Information schema views
• Dynamic management views and functions
• System functions
• System stored procedures

En este capítulo, discutiremos cómo se pueden utilizar los metadatos para realizar 
acciones en el nivel de instancia, como exponer los valores del registro, examinar 
cómo los metadatos pueden ayudar en la planificación de capacidad y discutir cómo 
se pueden utilizar los metadatos para la resolución de problemas y la optimización 
del rendimiento. Finalmente, veremos cómo se pueden utilizar los metadatos para 
impulsar la automatización. mantenimiento.

*/


-- Using Catalogo View

SELECT * FROM sys.databases where recovery_model_desc = 'FULL'


-- Using Information Schema Views, devuelven menos informacion que los Catalogo View
-- Se basan en los estandares ISO Esto significa que puede transferir sus consultas 
-- entre RDBMS

SELECT  * FROM INFORMATION_SCHEMA.TABLE_PRIVILEGES


-- Dynamic management views and functions(DMV), brindan informacion sobre la situacion
-- actual de la instancia, se puede utilizar para solucionar problemas de rendimiento
-- Siempre comiensan con el prefijo dm_ seguido de 2 caracteres que describen la categoria
-- del objecto, a esto le sigue el nombre del objecto
-- Categorias


/*
• AlwaysOn Availability Groups
• Change data capture
• Change tracking
• Common language runtime (CLR)
• Database mirroring
• Databases
• Execution
• Extended events
• FILESTREAM and FileTable
• Full-text search and semantic search
• Geo-Replication
• Indexes
• I/O
• Memory-optimized tables
• Objects
• Query notifications
• Replication
• Resource Governor
• Security
• Server
• Service broker
• Spatial
• SQL Data Warehouse and PDW
• SQL Server operating system
• Stretch Databases
• Transactions

*/


-- Buscar logins connected a una base de datos

USE AdventureWorks2019
GO

SELECT login_name , * 
FROM sys.dm_exec_sessions
WHERE database_id = DB_ID('AdventureWorks2019')


-- Devuelve detalles de las páginas de datos que almacenan la tabla 

SELECT *
FROM sys.dm_db_database_page_allocations(DB_ID('AdventureWorks2019'),
	OBJECT_ID('dbo.Customers'),
	NULL,
	NULL,
	'DETAILED') ;


-- Using System Functions

SELECT DATALENGTH(FirstName) FROM Person.Person


/*
Metadatos a nivel de servidor y a nivel de instancia 

Metadatos a nivel de servidor Puede ser muy útil para los administradores de bases de datos 
que necesitan encontrar información de configuración o solucionar problemas.

*/


-- Recuparar informacion del registro del servidor como configuraciones y opciones de configuracon
-- que estan almacenadas en los registro de windows,  Puede ser útil para diagnosticar problemas 
-- de configuración o para obtener información detallada sobre la configuración del servidor SQL.

select * from sys.dm_server_registry