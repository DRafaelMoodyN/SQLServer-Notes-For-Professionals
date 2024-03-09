-- ======================================================================================
-- Strategies for Memory-Optimized Filegroups 
-- Estrategias para grupos de archivos optimizados para memoria
-- ======================================================================================

/*
Al igual que los grupos de archivos estructurados, los grupos de archivos optimizados 
para memoria usarán un turno rotatorio. enfoque para la asignación de datos entre 
contenedores. Es una práctica común colocar estos múltiples contenedores en husillos 
separados para maximizar el rendimiento de E/S.

Entonces el enfoque de operación por turnos colocará todos los archivos de datos en un 
volumen y todos los archivos Delta en el otro volumen.
Para evitar este problema, es una buena práctica colocar dos contenedores en cada uno
de los volúmenes. que desea usar para su grupo de archivos optimizado para memoria. 
Esto asegurará que obtenga una distribución equilibrada de IO

File and Filegroup Maintenance || Mantenimiento de archivos y grupos de archivos

Durante el ciclo de vida de una aplicación de nivel de datos, en ocasiones es posible 
que deba realizar actividades de mantenimiento en sus archivos de base de datos y 
grupos de archivos por razones tales como gestión del rendimiento o de la capacidad

Adding Files

Es posible que deba agregar archivos a un grupo de archivos por motivos de capacidad y 
rendimiento.

Si su base de datos crece más allá de sus estimaciones de capacidad y el volumen que 
aloja sus datos no se puede cambiar el tamaño de los archivos, entonces puede agregar 
archivos adicionales al grupo de archivos, que está alojado en diferentes LUN.
Es posible que también deba agregar archivos adicionales al grupo de archivos para 
aumentar la Rendimiento de E/S si el subsistema de almacenamiento se convierte en un 
cuello de botella para su aplicación
*/

USE Chapter6
GO

-- Adding a New File Using T-SQL
ALTER DATABASE Chapter6 ADD FILE(
	NAME = 'Chapter6File_4',
	FILENAME = 'C:\Programacion\Net\SqlServer\Pro-SqlServer-2019-Administration\Files\Chapter6File_4.ndf',
	SIZE = 5120KB,
	FILEGROWTH = 1024KB
) TO FILEGROUP [PRIMARY]
GO

/*
En este escenario, sin embargo, es importante recordar el algoritmo de llenado 
proporcional. Si agrega archivos a un grupo de archivos, SQL Server apuntará 
primero a los archivos vacíos, hasta que tienen la misma cantidad de espacio 
libre restante que los archivos originales.

*/


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
Sin embargo, también vale la pena mencionar que cuando crea inicialmente su
grupo de archivos, debe crear los archivos dentro de ese grupo de archivos, 
con tamaños iguales, para tomar ventaja del algoritmo
*/