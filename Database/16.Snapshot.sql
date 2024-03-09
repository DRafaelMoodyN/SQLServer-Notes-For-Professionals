-- ===================================================================================================
-- Snapshot || Instancias de base de datos
-- ===================================================================================================

/*
Un Snapshot es un punto o un estado de la bd al que podemos retornar por cualquier
imprevisto

Práctica recomendada: denominación de instantáneas de bases de datos

Antes de crear instantáneas, es importante considerar cómo nombrarlas. Cada instantánea  de la bd 
requiere un nombre de base de datos único. Para facilitar la administración, el nombre de una 
instantánea puede incorporar información que identifique la base de datos, como:

1) El nombre de la base de datos de origen.
2) Una indicación de que el nuevo nombre es para una instantánea.
3) La fecha y hora de creación de la instantánea, un número de secuencia o alguna otra información, 
   como la hora del día, para distinguir las instantáneas secuenciales en una base de datos determinada.

Por ejemplo, considere una serie de instantáneas para la base de AdventureWorks2019datos. 
Se crean tres instantáneas diarias en intervalos de 6 horas entre las 6 a. m. y las 6 p. m., 
en función de un reloj de 24 horas. Cada instantánea diaria se conserva durante 24 horas 
antes de eliminarse y reemplazarse por una nueva instantánea con el mismo nombre. 
Tenga en cuenta que cada nombre de instantánea indica la hora, pero no el día:

AdventureWorks_snapshot_0600  
AdventureWorks_snapshot_1200  
AdventureWorks_snapshot_1800 

La .ss extensión utilizada en los ejemplos es arbitraria.

¿ Se pueden tener multiples Snapshot de una bd?

*/


-- Creación de un Snapshot en la base de datos AdventureWorks
-- Se omiten los archivos .log

-- Informacion util 
EXEC SP_HELPDB SistemaContable
GO

CREATE DATABASE AdventureWorks_snapshot_0600
ON (
	NAME = SistemaContable, -- Nombre de la bd origen
	FILENAME = 'C:\Programming\Net\SqlServer\SqlServer-Notes-For-Professionals\Archivos\AdventureWorks_snapshot_0600.ss'
)
AS SNAPSHOT OF SistemaContable
GO

CREATE DATABASE AdventureWorks_snapshot_1200
ON (
	NAME = SistemaContable,
	FILENAME = 'C:\Programming\Net\SqlServer\SqlServer-Notes-For-Professionals\Archivos\AdventureWorks_snapshot_1200.ss'
)
AS SNAPSHOT OF SistemaContable
GO

CREATE DATABASE AdventureWorks_snapshot_1800
ON (
	NAME = SistemaContable,
	FILENAME = 'C:\Programming\Net\SqlServer\SqlServer-Notes-For-Professionals\Archivos\AdventureWorks_snapshot_1800.ss'
)
AS SNAPSHOT OF SistemaContable
GO


-- Revertir un Snapsho en la base de datos AdventureWorks

USE master
GO

RESTORE DATABASE SistemaContable 
FROM
DATABASE_SNAPSHOT = 'AdventureWorks_snapshot_0600'
GO

RESTORE DATABASE SistemaContable
FROM
DATABASE_SNAPSHOT = 'AdventureWorks_snapshot_1200'
GO

RESTORE DATABASE SistemaContable 
FROM
DATABASE_SNAPSHOT = 'AdventureWorks_snapshot_1800'
GO


-- Eliminar un SNAPSHOT

DROP DATABASE AdventureWorks_snapshot_0600
DROP DATABASE AdventureWorks_snapshot_1200
DROP DATABASE AdventureWorks_snapshot_1800