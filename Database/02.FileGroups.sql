-- ==================================================================================================
-- Filegroups
-- ==================================================================================================

/*

Las tablas y los índices se almacenan en un grupo de archivos, a diferencia de un archivo 
específico dentro del contenedor. Esto significa que para los grupos de archivos que 
contienen más de un archivo, no tiene control sobre qué archivo se utiliza para almacenar 
el objeto. De hecho, debido a que SQL asigna datos a archivos utilizando un enfoque de 
turno rotativo, cada objeto almacenado en el grupo de archivos tiene una alta probabilidad 
de dividirse en cada archivo dentro del grupo de archivos.

*/

USE master
GO

IF EXISTS (
			SELECT s.name FROM sys.databases s
			WHERE s.name = 'Chapter6'
		) 
BEGIN
	DROP DATABASE Chapter6
	PRINT 'DROP DATABASE Chapter6'
END


/*
Cree una base de datos con tres archivos en el grupo de archivos principal

Una bd se compone de 2 partes, de archivos de bases de datos y log de transacciones.

Toda insert, update, delete primero se carga en memoria cache los datos que seran afectados
donde esperan hacer confirmados(commit), si no se desechan.
*/

-- Podemos crear una bd de esta manera, y todos los datos predeterminos los tomas de la bd 
-- models
--CREATE DATABASE Chapter6
--GO

--DROP DATABASE Chapter6


CREATE DATABASE Chapter6
CONTAINMENT = NONE
ON PRIMARY

-- Especificacion de FILE PRIMARY
-- Recomendacion guardar en un disco dura diferente
-- Nombre logico            Path fisico
(NAME = 'Chapter6File_1', FILENAME = 'C:\Programming\Net\SqlServer\SqlServer-Notes-For-Professionals\Archivos\Chapter6File_1.mdf',
-- Tamaño inicial 
 SIZE = 50MB, 
-- Crecimiento, cuando nuestro archivo se llene el crecera de manera automatica 
 FILEGROWTH=25%
),

-- Especificacion de FILE SECONDARY
(NAME = 'Chapter6File_2', FILENAME = 'C:\Programming\Net\SqlServer\SqlServer-Notes-For-Professionals\Archivos\Chapter6File_2.ndf',
 SIZE = 50MB, FILEGROWTH = 25%
),
(NAME = 'Chapter6File_3', FILENAME = 'C:\Programming\Net\SqlServer\SqlServer-Notes-For-Professionals\Archivos\Chapter6File_3.ndf',
 SIZE = 50MB, FILEGROWTH= 25%)

 -- Especificicacion de FILE TRANSACTION
-- Recomentacion guadar un disco duro diferente
LOG ON
(NAME = 'Chapter6File_log', FILENAME = 'C:\Programming\Net\SqlServer\SqlServer-Notes-For-Professionals\Archivos\Chapter6File_log.ldf',
 SIZE = 50MB, FILEGROWTH= 25%)
GO

-- Informacion util 
EXEC SP_HELPDB Chapter6
GO

-- Listar las bases de datos
SELECT * FROM sys.databases 
GO


/*
Separar los archivos mdf y ldf ayuda a mejorar la velocidad de la base de datos, permitiendo 
que las acciones se hagan en paralelo y no de manera serial.

Configurando el crecimiento automático para los archivos cuando no especificamos
SIZE y FILEGROWTH

Los archivos en crecimiento utilizan recursos y también provocan la eliminación de bloqueos, 
bloqueando otros procesos.

Por lo tanto, es recomendable predimensionar los archivos de la base de datos de acuerdo con
la capacidad. en lugar de comenzar con un archivo pequeño y confiar en el crecimiento 
automático.

Por la misma razón, al especificar la configuración de crecimiento automático de un 
archivo, debe evitar lejos del valor predeterminado de 1 MB y especifique un valor mucho
mayor. Si no lo hace, si no el archivo se llena y se inicia el crecimiento automático, 
sus archivos crecerán en incrementos muy pequeños

Lo que es probable que perjudique el rendimiento, incluso si está utilizando la 
inicialización instantánea de archivos. El valor que debe establecer para que crezcan 
sus archivos dependerá de su entorno.
Debe tener en cuenta, por ejemplo, la cantidad de espacio libre que está disponible
en el volumen y el número de otras bases de datos que comparten el volumen.
*/


IF NOT EXISTS (
	SELECT name FROM sys.filegroups WHERE is_default = 1 AND name = 'PRIMARY' 
	)
	BEGIN
	-- Poner el archivo primario por defecto
	ALTER DATABASE Chapter6 MODIFY FILEGROUP [PRIMARY] DEFAULT
	END
GO


CREATE TABLE dbo.RoundRobinTable(
	ID INT IDENTITY PRIMARY KEY,
	DummyTxt NCHAR(1000)
)
GO

DECLARE @Numbers TABLE
(
 Number INT
)

;WITH CTE(Number)
AS(
	SELECT 1 Number UNION ALL
	SELECT Number + 1
	FROM CTE
	WHERE Number <= 99
)
INSERT INTO @Numbers SELECT * FROM CTE

INSERT INTO dbo.RoundRobinTable
SELECT 'DummyText'
FROM @Numbers a
CROSS JOIN @Numbers b;

SELECT b.file_id, COUNT(*) AS [RowCount]
FROM
(
 SELECT ID, DummyTxt, a.file_id
 FROM dbo.RoundRobinTable
 CROSS APPLY sys.fn_PhysLocCracker(%%physloc%%) a
) b
GROUP BY b.file_id;

/*

Muestran que las filas se han distribuido uniformemente sobre los tres archivos dentro 
del filegroup. Si los archivos son de diferentes tamaños, entonces el archivo con la 
mayor cantidad de espacio recibe más filas debido al algoritmo de relleno proporcional, 
que intenta sopesar las asignaciones a cada archivo para distribuir uniformemente los 
datos a través cada uno de los archivos

Puede notar que no se devuelven filas para el archivo 2. Esto se debe a que file_id 2 
es siempre el archivo de registro de transacciones (o el primer archivo de registro de 
transacciones si tiene más de uno). file_id 1 es siempre el file de bd primary.

*/

-- Puedes ver cuánto espacio queda en un archivo
-- Este DMV devolverá una columna llamada unallocated_extent_page_count, 
-- que nos dirá cuántas páginas libres quedan por asignar

USE Chapter6
GO

SELECT * FROM sys.dm_db_file_space_usage
GO


-- Revisar el estado de la opcion de ajustes automatica de tamaño de archivos
-- Si tengo una tabla con 20 m de registro y eliminio 1 m sql no devulve el espacio
-- de la eliminacion de ese registro, amenos que este activo

ALTER DATABASE Chapter6
SET AUTO_SHRINK ON WITH NO_WAIT
GO

-- 1 activo, 0 desactivado
SELECT DATABASEPROPERTYEX('Chapter6','ISAUTOSHRINK')

-- Creacion de un grupo adicinal

ALTER DATABASE Chapter6
ADD FILEGROUP SECUNDARIO
GO

-- Agreando al grupo primary
ALTER DATABASE Chapter6
ADD FILE(
	NAME = 'Chapter6SecondariFile_1', 
	FILENAME = 'C:\Programming\Net\SqlServer\SqlServer-Notes-For-Professionals\Archivos\Chapter6SecondarioFile_1.ndf',
 SIZE = 50MB, FILEGROWTH= 25%
) 
GO

-- Agreando al grupo secondari
ALTER DATABASE Chapter6
ADD FILE(
	NAME = 'Chapter6SecondariFile_11', 
	FILENAME = 'C:\Programming\Net\SqlServer\SqlServer-Notes-For-Professionals\Archivos\Chapter6SecondarioFile_11.ndf',
 SIZE = 50MB, FILEGROWTH= 25%
) TO FILEGROUP SECUNDARIO
GO

-- Informacion de un grupo
EXEC sp_helpfilegroup SECUNDARIO
GO

-- Informacion de un file
EXEC sp_helpfile Chapter6SecondariFile_11
GO

-- Eliminar un archivo
ALTER DATABASE Chapter6
REMOVE FILE Chapter6SecondariFile_1
GO

-- Si el archivo esta tiene datos no se puede borrar
ALTER DATABASE Chapter6
REMOVE FILE Chapter6File_3
GO

ALTER DATABASE Chapter6
REMOVE FILE Chapter6SecondariFile_11
GO

-- Reducir un archivo 
EXEC sp_helpdb Chapter6
-- Reducir 2MB de archivos de datos, si no se puede reducir el 1MB por que el
-- espacio no lo permite, se reduce lo mas que se pueda.
dbcc SHRINKFILE(Chapter6File_1,1) 
-- Reducir la bd en un 10%
dbcc SHRINKDATABASE(Chapter6,10) 

-- Es importante mantener una supervicion del tamaño de los archivos
-- Si el .log topa en el disco dura, nuestra bd se volvera solo de lectura