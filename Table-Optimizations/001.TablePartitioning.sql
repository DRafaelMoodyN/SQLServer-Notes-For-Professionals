-- Table Partitioning

/*

Uno de los beneficios clave de la partición es que el Optimizador de consultas 
solo puede acceder a la particiones requeridas para satisfacer los resultados 
de una consulta, en lugar de toda la tabla

El particionamiento es una optimización del rendimiento para tablas e índices 
grandes que divide el objeto horizontalmente en unidades más pequeñas.

SQL Server puede realizar una optimización llamada eliminación de partición
que permite leer solo las particiones requeridas, a diferencia de la tabla 
completa.

Además, cada partición se puede almacenar en un grupo de archivos separado; 
esto te permite almacenar diferentes particiones en diferentes niveles de 
almacenamiento

Conceptos:
Claves de particion
Funciones de particion 
Schemas de particion
Aliniacion de particion

Partitioning Key
Se utiliza para determinar en qué partición debe estar cada fila de la tabla
Si su tabla tiene un índice agrupado, entonces la clave de partición debe ser 
un subconjunto de la clave de índice agrupado.

La clave no pude ser del CLR o una columna con un tipo de area, si embargo puede
ser una columna calculada

Partition Function
Los puntos de contorno se utilizan para establecer los límites superior e 
inferior de cada partición puede ver que los puntos límite se establecen como 
el 1 de enero de 2019 y el 1 de enero de 2017 denominandose funcion de particion

Partition Scheme
Cada partición se puede almacenar en un grupo de archivos separado. El esquema 
de partición es un objeto. que cree para especificar en qué grupo de archivos 
se almacenará cada partición.

Index Alignment
Un índice se considera alineado con la tabla si se basa en la misma función de 
partición como la mesa. También se considera alineado si se basa en una función 
de partición diferente, pero las dos funciones son idénticas, ya que comparten 
el mismo tipo de datos, el mismo número de particiones, y los mismos valores de 
punto límite. Dado que el nivel hoja de un índice agrupado consta de las páginas 
de datos reales del tabla, un índice agrupado siempre está alineado con la tabla. 
Sin embargo, un índice no agrupado se puede almacenar en un grupo de archivos 
separado del montón o del índice agrupado. Esto se extiende a partición, donde 
la tabla base o los índices no agrupados pueden ser independientes

*/

/*
Implementing Partitioning
1) Creacion de la funcion de particion y el schema de particion
2) Crear la tabla en el schema de particion
   Si la table existe borrar y crear el indice
*/

USE AdventureWorks2019
GO

DBCC FREEPROCCACHE WITH NO_INFOMSGS
GO  

SELECT * FROM Sales.SalesOrderHeader

-- Creating the Partition Function

CREATE PARTITION FUNCTION PartFuntData(DATE)
AS RANGE LEFT
FOR VALUES('2011-05-31','2013-12-31')

-- Creating the Partition Scheme

CREATE PARTITION SCHEME PartSchema
AS PARTITION PartFuntData
ALL TO ([PRIMARY]);

-- Creating the Partition Table

CREATE TABLE dbo.TablePartitionOrderHeader(
	TablePartitionOrderHeaderID INT NOT NULL,
	OrderDate DATE NOT NULL,
	CustomerID INT NOT NULL,
	SalesPersonID INT NOT NULL,
	TerrytoryID INT NOT NULL
) ON PartSchema(OrderDate)
GO

ALTER TABLE dbo.TablePartitionOrderHeader 
ADD CONSTRAINT Pk_Orders PRIMARY KEY 
CLUSTERED (TablePartitionOrderHeaderID,OrderDate)
WITH
(
	STATISTICS_NORECOMPUTE = OFF, 
	IGNORE_DUP_KEY = OFF,
	ALLOW_ROW_LOCKS = ON, 
	ALLOW_PAGE_LOCKS = ON
) ON PartSchema(OrderDate)
GO

INSERT INTO dbo.TablePartitionOrderHeader(
	TablePartitionOrderHeaderID,
	OrderDate,
	CustomerID,
	SalesPersonID,
	TerrytoryID
)
SELECT 
	s.SalesOrderID, 
	s.OrderDate, 
	s.CustomerID, 
	ISNULL(s.SalesPersonID,10), 
	s.TerritoryID
FROM Sales.SalesOrderHeader AS s


-- Property -> Storage
-- La tabla se ha creado en el grupo de archivos PRIMARIO 
-- y Table is partitioned true

/*
Monitoring Partitioned Tables

Es posible que desee realizar un seguimiento del número de filas en cada 
partición de su tabla. Haciendo por lo que le permite asegurarse de que 
sus filas se distribuyan de manera uniforme. Si no lo son, entonces es 
posible que desee volver a evaluar su estrategia de partición

*/

-- Using the $PARTITION Function

SELECT 
	COUNT(*) 'Number of Row',
	$PARTITION.PartFuntData(OrderDate) 'Partition'
FROM dbo.TablePartitionOrderHeader
GROUP BY $PARTITION.PartFuntData(OrderDate)


SELECT * FROM dbo.TablePartitionOrderHeader AS s
WHERE S.OrderDate BETWEEN '2011-05-31' AND '2011-12-31'

/*
Partition Elimination
*/
