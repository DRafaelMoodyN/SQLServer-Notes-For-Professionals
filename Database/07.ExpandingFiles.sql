-- ======================================================================================
-- Expanding Files || Expansion de archivos
-- ======================================================================================

-- Puedes ver cu�nto espacio queda en un archivo
-- Este DMV devolver� una columna llamada unallocated_extent_page_count, 
-- que nos dir� cu�ntas p�ginas libres quedan por asignar

USE Chapter6
GO

SELECT * FROM sys.dm_db_file_space_usage
GO

-- C�lculo del espacio libre en cada archivo
SELECT 
	file_id, 
	unallocated_extent_page_count * 1.0 /128 'Espacio libre (MB)'
FROM sys.dm_db_file_space_usage
GO


-- Si queremos expandir un archivo, no necesitamos esperar a que se active el crecimiento 
-- autom�tico, podemos expandir el archivo manualmente

ALTER DATABASE Chapter6 MODIFY FILE (
	NAME = 'Chapter6File_3',
	SIZE = 20480KB
)

ALTER DATABASE Chapter6 MODIFY FILE (
	NAME = 'Chapter6File_4',
	SIZE = 20480KB
)
