-- Index Usage and Maintenance

Para que la mayor�a de las consultas funcionen de manera �ptima,requieren un �ndice 
para seleccionar datos de manera eficiente. Alternativamente, los �ndices no utilizados 
en los objetos asociados.

Los �ndices fragmentados pueden desperdiciar espacio en disco y memoria a medida que se 
sobrecargan con espacio sin usar y datos desorganizados.
	SD.name AS database_name,
	SO.name AS object_name,
	SI.name AS index_name,
	IPS.index_type_desc,
	IPS.page_count,
	IPS.avg_fragmentation_in_percent
FROM sys.dm_db_index_physical_stats(NULL, NULL, NULL, NULL , NULL) IPS
	INNER JOIN sys.databases SD
		ON SD.database_id = IPS.database_id
	INNER JOIN sys.indexes SI
		ON SI.index_id = IPS.index_id
	INNER JOIN sys.objects SO
		ON SO.object_id = SI.object_id AND IPS.object_id = SO.object_id
	AND index_level = 0
	AND SD.name = @database_name
ORDER BY IPS.avg_fragmentation_in_percent DESC;
construido desde cero como si fuera reci�n creado
las p�ginas y volver a aplicar el factor de relleno seg�n sea necesario. Esta operaci�n es 
siempre en l�nea, independientemente de la edici�n de SQL Server que est� ejecutando
BEGIN
	DROP PROCEDURE dbo.index_maintenance_plan;
END
GO

CREATE OR ALTER PROCEDURE dbo.index_maintenance_demo(
	@reorganization_percentage TINYINT = 10,
	@rebuild_percentage TINYINT = 35,
	@print_results_only BIT = 1
)
AS
BEGIN

	DECLARE @sql_command NVARCHAR(MAX) = '';
	DECLARE @database_name NVARCHAR(MAX);
	DECLARE @database_list TABLE (database_name NVARCHAR(MAX) NOT NULL);
	DECLARE @parameter_list NVARCHAR(MAX); 
	SET @parameter_list = '@reorganization_percentage TINYINT, @rebuild_percentage TINYINT'

	INSERT INTO @database_list (database_name)
	SELECT name FROM sys.databases
	CREATE TABLE #index_maintenance (
		database_name NVARCHAR(MAX),
		schema_name NVARCHAR(MAX),
		object_name NVARCHAR(MAX),
		index_name NVARCHAR(MAX),
		index_type_desc NVARCHAR(MAX),
		page_count BIGINT,
		avg_fragmentation_in_percent FLOAT,
		index_operation NVARCHAR(MAX)
	);

	SELECT @sql_command = @sql_command + 'USE [' + database_name + ']

	INSERT INTO #index_maintenance (
		database_name, 
		schema_name, 
		object_name, 
		index_name,
		index_type_desc, 
		page_count, 
		avg_fragmentation_in_percent,
		index_operation
		CAST(SD.name AS NVARCHAR(MAX)) AS database_name,
		CAST(SS.name AS NVARCHAR(MAX)) AS schema_name,
		CAST(SO.name AS NVARCHAR(MAX)) AS object_name,
		CAST(SI.name AS NVARCHAR(MAX)) AS index_name,
		IPS.index_type_desc,
		IPS.page_count,
		IPS.avg_fragmentation_in_percent,
		CAST(CASE WHEN IPS.avg_fragmentation_in_percent >= @rebuild_percentage THEN "REBUILD" 
				  WHEN IPS.avg_fragmentation_in_percent >= @reorganization_percentage THEN "REORGANIZE"
				 END AS NVARCHAR(MAX)) AS index_operation
			INNER JOIN sys.databases SD
				ON SD.database_id = IPS.database_id
			INNER JOIN sys.indexes SI
				ON SI.index_id = IPS.index_id
			INNER JOIN sys.objects SO
				ON SO.object_id = SI.object_id
				AND IPS.object_id = SO.object_id
			INNER JOIN sys.schemas SS
				ON SS.schema_id = SO.schema_id
		WHERE alloc_unit_type_desc = "IN_ROW_DATA"
			AND index_level = 0
			AND SD.name = "' + database_name + '"
			AND IPS.avg_fragmentation_in_percent >= @reorganization_percentage
			AND SI.name IS NOT NULL
			AND SO.is_ms_shipped = 0
	WHERE database_name IN (SELECT name FROM sys.databases);
   SELECT @sql_command ='';
   SELECT @sql_command = @sql_command +
	' USE [' + database_name + '] 
	  ALTER INDEX [' + index_name + '] ON [' + schema_name + '].[' + object_name + ']
    ' + index_operation + ';'
	FROM #index_maintenance;

	SELECT * 
	FROM #index_maintenance
	ORDER BY avg_fragmentation_in_percent DESC;

	IF @print_results_only = 1
		PRINT @sql_command;
	ELSE
		EXEC sp_executesql @sql_command;

	DROP TABLE #index_maintenance;