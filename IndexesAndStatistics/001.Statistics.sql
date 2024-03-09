
USE AdventureWorks2019
GO

-- Información de la estructura del Índice

/*

Necesitamos obtener sobre los índices es la lista de índices disponibles 
en nuestra base de datos, la lista de columnas participando en cada índice 
y las propiedades de esos índices. 

*/

EXEC SP_HELPINDEX 'Person.Person'

SELECT 
	Tab.name  Table_Name ,
	IX.name  Index_Name,
	IX.type_desc Index_Type,
	Col.name  Index_Column_Name,
	IXC.is_included_column Is_Included_Column
FROM  sys.indexes IX  
INNER JOIN sys.index_columns IXC  
ON IX.object_id = IXC.object_id AND IX.index_id = IXC.index_id  
INNER JOIN sys.columns Col  
ON IX.object_id = Col.object_id AND IXC.column_id = Col.column_id     
INNER JOIN sys.tables Tab      
ON IX.object_id = Tab.object_id


SELECT 
	Tab.name  Table_Name,
	IX.name  Index_Name,
	IX.type_desc Index_Type,
	Col.name  Index_Column_Name,
	IXC.is_included_column Is_Included_Column,
	IX.fill_factor,
	IX.is_disabled,
	IX.is_primary_key,
	IX.is_unique	 		  
FROM  sys.indexes IX 
INNER JOIN sys.index_columns IXC ON IX.object_id = IXC.object_id AND IX.index_id = IXC.index_id  
INNER JOIN sys.columns Col ON IX.object_id = Col.object_id  AND IXC.column_id = Col.column_id     
INNER JOIN sys.tables Tab  ON IX.object_id = Tab.object_id


-- Información de fragmentación de Indices

SELECT  
	OBJECT_NAME(IDX.OBJECT_ID) AS Table_Name, 
	IDX.name AS Index_Name, 
	IDXPS.index_type_desc AS Index_Type, 
	IDXPS.avg_fragmentation_in_percent  Fragmentation_Percentage
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, NULL) IDXPS 
INNER JOIN sys.indexes IDX  ON IDX.object_id = IDXPS.object_id 
AND IDX.index_id = IDXPS.index_id 
ORDER BY Fragmentation_Percentage DESC

