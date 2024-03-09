-- ======================================================================================
-- Memory-Optimized Filegroups || Grupos de archivos optimizados para memoria
-- ======================================================================================

/*
SQL Server 2014 introdujo una característica llamada tablas optimizadas para memoria.

Estas tablas se almacenan por completo en la memoria, sin embargo, los datos también 
se escriben en archivos en el disco.

Las transacciones contra tablas en memoria tienen el mismo ACID (atómico, consistentes,
aisladas y duraderas) como tablas tradicionales basadas en disco.

Primero, solo puedes crear uno grupo de archivos optimizado para memoria por base de 
datos, Los datos en memoria se conservan en el disco mediante el uso de dos tipos de 
archivos. siempre funcionan en pares y cubren un rango específico de transacciones

El archivo se usa para rastrear las inserciones que se realizan en las tablas en memoria, 
y el archivo Delta se usa para realizar un seguimiento de las eliminaciones.

*/

USE Chapter6
GO

-- Adding an In-Memory Filegroup and Container

ALTER DATABASE Chapter6 ADD FILEGROUP [Chapter6_InMemory] 
CONTAINS MEMORY_OPTIMIZED_DATA
GO

ALTER DATABASE Chapter6 ADD FILE(
	NAME = 'InMemory',
	FILENAME = 'C:\Programacion\Net\SqlServer\Pro-SqlServer-2019-Administration\Files\InMemory'
)
TO FILEGROUP [Chapter6_InMemory]
GO