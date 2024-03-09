
-- BACKUP MEDIA DISPOSITIVOS LOGICOS (MEDIOS DE RESPALDO)

-- CREACION DE DISPOSITIVOS LOGICOS

--EXEC sp_addumpdevice 
--	@devtype='disk',
--	@logicalname='Dispositivo_AdventureWorks2019',
--	@physicalname= 'C:\Programacion\Backups\AdventureWorks2019_Full.bak';
--GO

---- INFORMACION DEL DISPOSITIVOS LOGICOS

--EXEC sp_helpdevice 'Dispositivo_AdventureWorks2019'
--GO

---- INFORMACION DEL BACKUPS
RESTORE HEADERONLY FROM Dispositivo_AdventureWorks2019
GO

---- BORRAR EL DISPOSITIVO LOGICO
--EXEC sp_dropdevice 'Dispositivo_AdventureWorks2019'
--GO

-- BACKUPS FULL DINAMICO

--DECLARE @Sql_Command NVARCHAR(MAX); -- Cadena de commandos intruccion SQL dynamic
--DECLARE @Database_Name SYSNAME; -- Nombre de db que actualmente esta siendo respaldada
--DECLARE @Database_List TABLE(Data_Name SYSNAME) -- Tendra una lista de nuestras bd
--DECLARE @Description NVARCHAR(60)

--INSERT INTO @Database_List(Data_Name) 
--SELECT d.name FROM sys.databases AS d 
--WHERE d.name IN ('AdventureWorks2019')

--DECLARE Database_Cursor CURSOR LOCAL FAST_FORWARD FOR -- Curso para iterar las bd
--SELECT Data_Name FROM @Database_List
--OPEN Database_Cursor  
--FETCH NEXT FROM Database_Cursor INTO @Database_Name
--WHILE @@FETCH_STATUS = 0
--BEGIN 


--	EXEC('ALTER DATABASE '+@Database_Name+'  SET RECOVERY FULL')

--	SELECT @Sql_Command = '
--		BACKUP DATABASE ' + @Database_Name +'
--		TO Dispositivo_'+@Database_Name+'
--		WITH COMPRESSION, INIT, NAME='''+@Database_Name+'-FULL'',
--		DESCRIPTION  = '''+@Database_Name+' _Backup_Full'''

--	EXEC(@Sql_Command)

--	FETCH NEXT FROM Database_Cursor INTO @Database_Name;
--END

--CLOSE Database_Cursor; 
--DEALLOCATE Database_Cursor;


---- BACKUPS DIFFERENTIAL DINAMICO

--DECLARE @Sql_Command NVARCHAR(MAX); -- Cadena de commandos intruccion SQL dynamic
--DECLARE @Database_Name SYSNAME; -- Nombre de db que actualmente esta siendo respaldada
--DECLARE @Database_List TABLE(Data_Name SYSNAME) -- Tendra una lista de nuestras bd
--DECLARE @Description NVARCHAR(60)

--INSERT INTO @Database_List(Data_Name) 
--SELECT d.name FROM sys.databases AS d 
--WHERE d.name IN ('AdventureWorks2019')

--DECLARE Database_Cursor CURSOR LOCAL FAST_FORWARD FOR -- Curso para iterar las bd
--SELECT Data_Name FROM @Database_List
--OPEN Database_Cursor  
--FETCH NEXT FROM Database_Cursor INTO @Database_Name
--WHILE @@FETCH_STATUS = 0
--BEGIN 

---- CAMBIAR A MODO FULL
--	EXEC('ALTER DATABASE '+@Database_Name+'  SET RECOVERY FULL')

--	SELECT @Sql_Command = '
--		BACKUP DATABASE ' + @Database_Name +'
--		TO Dispositivo_'+@Database_Name+'
--		WITH COMPRESSION, NAME='''+@Database_Name+'-DIFF'',
--		DESCRIPTION  = '''+@Database_Name+' _Backup_DIFF'',
--		DIFFERENTIAL'

--	EXEC(@Sql_Command)

--	FETCH NEXT FROM Database_Cursor INTO @Database_Name;
--END

--CLOSE Database_Cursor; 
--DEALLOCATE Database_Cursor;



-- BACKUPS LOG DINAMICO
--Cada ves que se hace un Backups Log, el Log se limpia

DECLARE @Sql_Command NVARCHAR(MAX); -- Cadena de commandos intruccion SQL dynamic
DECLARE @Database_Name SYSNAME; -- Nombre de db que actualmente esta siendo respaldada
DECLARE @Database_List TABLE(Data_Name SYSNAME) -- Tendra una lista de nuestras bd
DECLARE @Description NVARCHAR(60)

INSERT INTO @Database_List(Data_Name) 
SELECT d.name FROM sys.databases AS d 
WHERE d.name IN ('AdventureWorks2019')

DECLARE Database_Cursor CURSOR LOCAL FAST_FORWARD FOR -- Curso para iterar las bd
SELECT Data_Name FROM @Database_List
OPEN Database_Cursor  
FETCH NEXT FROM Database_Cursor INTO @Database_Name
WHILE @@FETCH_STATUS = 0
BEGIN 

-- CAMBIAR A MODO FULL
	EXEC('ALTER DATABASE '+@Database_Name+'  SET RECOVERY FULL')

	SELECT @Sql_Command = '
		BACKUP LOG ' + @Database_Name +'
		TO Dispositivo_'+@Database_Name+'
		WITH COMPRESSION, NAME='''+@Database_Name+'-LOG'',
		DESCRIPTION  = '''+@Database_Name+' _Backup_LOG'''

	EXEC(@Sql_Command)

	FETCH NEXT FROM Database_Cursor INTO @Database_Name;
END

CLOSE Database_Cursor; 
DEALLOCATE Database_Cursor;