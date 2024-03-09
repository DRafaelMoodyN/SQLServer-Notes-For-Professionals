-- ======================================================================================
-- Log Fragmentation || Fragmentacion de registro
-- ======================================================================================

/*

Cuando el registro se trunca debido a una copia de seguridad en el Model Recovery FULL 
o una operación de punto de control en el Model Recovery Simple, lo que realmente sucede 
es que cualquiera de los VLF que se pueden reutilizar se truncan. 
Motivos por los que es posible que no se pueda reutilizar un VLF
incluir VLF que contengan registros asociados con transacciones activas o transacciones
que aún no se han enviado a otras bases de datos en topologías de replicación o AlwaysOn. En
De manera similar, si reduce el archivo de registro, los VLF se eliminarán del final del
archivo hasta que se alcance el primer VLF activo.

No existe una regla estricta y rápida para el número óptimo de VLF dentro de un archivo de registro, pero
Trato de mantener aproximadamente dos VLF por GB para registros de transacciones grandes, en el rango de decenas de gigabytes. Para registros de transacciones más pequeños, es probable que la proporción sea mayor. Si usted
tiene demasiados VLF, entonces puede presenciar una degradación del rendimiento de cualquier actividad que
utiliza el registro de transacciones. Por otro lado, tener muy pocos VLF también puede plantear un problema.
En tal caso, donde cada VLF tiene un tamaño de GB, cuando cada VLF se trunca, tomará
una cantidad sustancial de tiempo para borrar, y podría presenciar una ralentización del sistema mientras
esto tiene lugar Por lo tanto, para archivos de registro grandes, se recomienda que haga crecer su
registro de transacciones en fragmentos de 8 GB para mantener la cantidad y el tamaño óptimos de VLF.
Para demostrar este fenómeno, crearemos una nueva base de datos llamada
Chapter6LogFragmentation, que tiene una sola tabla en el grupo de archivos principal, llamada
Inserts, y luego rellénelo con 1 millón de filas usando el script en el Listado 6-17. Este
hará que se cree una gran cantidad de VLF, lo que tendrá un impacto negativo en
actuación


*/

-- Creating the Chapter6LogFragmentation Database

CREATE DATABASE Chapter6LogFragmentation
CONTAINMENT = NONE
ON PRIMARY( 
	NAME = 'Chapter6LogFragmentation', 
	FILENAME = 'C:\Programacion\Net\SqlServer\Pro-SqlServer-2019-Administration\Files\Chapter6LogFragmentation.mdf' , 
	SIZE = 5120KB ,
	FILEGROWTH = 1024KB
)
 LOG ON ( 
	NAME = 'Chapter6LogFragmentation_log', 
	FILENAME = 'C:\Programacion\Net\SqlServer\Pro-SqlServer-2019-Administration\Files\Chapter6LogFragmentation_log.ldf' , 
	SIZE = 1024KB ,
	FILEGROWTH = 10%
);
GO

USE Chapter6LogFragmentation
GO

CREATE TABLE dbo.Inserts
(ID INT IDENTITY,
DummyText NVARCHAR(50)
);

DECLARE @Numbers TABLE
(
 Number INT
)

;WITH CTE(Number)
AS
(SELECT 1 Number
 UNION ALL
 SELECT Number +1
 FROM CTE
 WHERE Number <= 99
)
INSERT INTO @Numbers
SELECT *
FROM CTE;

INSERT INTO dbo.Inserts
SELECT 'DummyText'
FROM @Numbers a
CROSS JOIN @Numbers b
CROSS JOIN @Numbers c;

-- Create a variable to store the results of DBCC LOGINFO

DECLARE @DBCCLogInfo TABLE
(
RecoveryUnitID TINYINT
,FieldID TINYINT
,FileSize BIGINT
,StartOffset BIGINT
,FseqNo INT
,Status TINYINT
,Parity TINYINT
,CreateLSN NUMERIC
);

INSERT INTO @DBCCLogInfo
EXEC('DBCC LOGINFO');

SELECT
 name
 ,[Size in MBs]
 ,[Number of VLFs]
 ,[Number of VLFs] / ([Size in MBs] / 1024) 'VLFs per GB'
FROM
(
 SELECT
 name
 ,size * 1.0 / 128 'Size in MBs'
 ,(SELECT COUNT(*)
 FROM @DBCCLogInfo) 'Number of VLFs'
 FROM sys.database_files
 WHERE type = 1
 ) a;


 /*
 
 Puede ver que hay 61 VLF, lo cual es un exceso
cantidad dada el tamaño del registro es de 345 MB.
 */