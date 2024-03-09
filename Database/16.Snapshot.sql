-- ===================================================================================================
-- Snapshot || Instancias de base de datos
-- ===================================================================================================

/*
Un Snapshot es un punto o un estado de la bd al que podemos retornar por cualquier
imprevisto

Pr�ctica recomendada: denominaci�n de instant�neas de bases de datos

Antes de crear instant�neas, es importante considerar c�mo nombrarlas. Cada instant�nea  de la bd 
requiere un nombre de base de datos �nico. Para facilitar la administraci�n, el nombre de una 
instant�nea puede incorporar informaci�n que identifique la base de datos, como:

1) El nombre de la base de datos de origen.
2) Una indicaci�n de que el nuevo nombre es para una instant�nea.
3) La fecha y hora de creaci�n de la instant�nea, un n�mero de secuencia o alguna otra informaci�n, 
   como la hora del d�a, para distinguir las instant�neas secuenciales en una base de datos determinada.

Por ejemplo, considere una serie de instant�neas para la base de AdventureWorks2019datos. 
Se crean tres instant�neas diarias en intervalos de 6 horas entre las 6 a. m. y las 6 p. m., 
en funci�n de un reloj de 24 horas. Cada instant�nea diaria se conserva durante 24 horas 
antes de eliminarse y reemplazarse por una nueva instant�nea con el mismo nombre. 
Tenga en cuenta que cada nombre de instant�nea indica la hora, pero no el d�a:

AdventureWorks_snapshot_0600  
AdventureWorks_snapshot_1200  
AdventureWorks_snapshot_1800 

La .ss extensi�n utilizada en los ejemplos es arbitraria.

� Se pueden tener multiples Snapshot de una bd?

*/


-- Creaci�n de un Snapshot en la base de datos AdventureWorks
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