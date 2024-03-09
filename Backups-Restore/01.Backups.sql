-- ========================================================================================================
-- Bakups
-- ========================================================================================================

/*

Una copia de seguridad es un respaldo que hacemos en caso de un desastre, existen miles de forma
en la que una base de datos falles, nuestro trabajo es reducir el riesgo de perdidad de datos

Tipos de Bakups
1) FULL
	Hace un respaldo completo de la base de datos, deja una marca para indicar hasta que data
	el realizo el respaldo

2) Differencial
	Hace un respaldo apartir de la marca del ultimo backups que se realizo, guardando solo la data
	que no incluye el backup completo

3)Log Transacional
	Hace un respaldo solo del tiempo espefico

4) Solo copia
	Hace un respaldo pero no deja marca, no podemos hacer una estrategia de backups

5) Parciales (Bakups de un file)
	Hace un repaldo espefico de un filegroup

6) De la cola de log
	Cuando nuestra base de datos esta dañada, y hemos reestablecidos los backups, existen datos
	que probablemente no tengas nuestros backups

*/


-- ========================================================================================================
-- En un mismo archivo pueden anexarse varios backups basico
-- ========================================================================================================
USE ProjectAccouting
GO

ALTER DATABASE ProjectAccouting
SET RECOVERY FULL
GO

-- Backups FULL
BACKUP DATABASE ProjectAccouting
TO DISK ='C:\Programacion\Net\SqlServer\File\Backups\ProjectAccoutingFull.bak'
-- WITH para agregarle parametros}
-- FORMAT sobre escribira la copia actual, si no se especifica se creara una nueva copia
WITH INIT, FORMAT, 
NAME ='Backup_Full_01',
DESCRIPTION  = 'ProjectAccouting_Full_01'
GO

-- Backups Diffierential
BACKUP DATABASE ProjectAccouting
TO DISK ='C:\Programacion\Net\SqlServer\File\Backups\ProjectAccoutingFull.bak'
WITH NAME ='Backup_Diferential_01', 
DESCRIPTION = 'ProjectAccouting_Diff_01',
DIFFERENTIAL 
GO

-- Backups Log
-- Cada ves que se hace un Backups Log, el Log se limpia
BACKUP LOG ProjectAccouting
TO DISK ='C:\Programacion\Net\SqlServer\File\Backups\ProjectAccoutingFull.bak'
WITH NAME = 'Backup_Log_01',
DESCRIPTION = 'ProjectAccouting_Log_01'
GO

-- Informacion de los backups dentro del archivo.bak
RESTORE HEADERONLY 
FROM DISK ='C:\Programacion\Net\SqlServer\File\Backups\ProjectAccoutingFull.bak'


-- ========================================================================================================
-- En un mismo archivo pueden anexarse varios backups con dispositivo
-- ========================================================================================================
USE master
GO

-- Crear un dispositivo
EXEC sp_addumpdevice 'disk', 'ProjectAccoutingDispositivo',
'C:\Programacion\Net\SqlServer\File\Backups\ProjectAccouting_Dispositivo_Full.bak';
GO

-- Informacion dispositivo
EXEC sp_helpdevice
GO

EXEC sp_helpdevice 'ProjectAccoutingDispositivo'
GO

USE ProjectAccouting
GO

-- Backups FULL
BACKUP DATABASE ProjectAccouting
TO ProjectAccoutingDispositivo
WITH INIT, FORMAT, 
NAME ='Backup_Full_01',
DESCRIPTION  = 'ProjectAccouting_Full_01'
GO

-- Backups Diffierential
BACKUP DATABASE ProjectAccouting
TO ProjectAccoutingDispositivo
WITH NAME ='Backup_Diferential_01', 
DESCRIPTION = 'ProjectAccouting_Diff_01',
DIFFERENTIAL 
GO

-- Backups Log
BACKUP LOG ProjectAccouting
TO ProjectAccoutingDispositivo
WITH NAME = 'Backup_Log_01',
DESCRIPTION = 'ProjectAccouting_Log_01'
GO

-- Backups Diffierential
BACKUP DATABASE ProjectAccouting
TO ProjectAccoutingDispositivo
WITH NAME ='Backup_Diferential_02', 
DESCRIPTION = 'ProjectAccouting_Diff_02',
DIFFERENTIAL 
GO

-- Backups Log
BACKUP LOG ProjectAccouting
TO ProjectAccoutingDispositivo
WITH NAME = 'Backup_Log_02',
DESCRIPTION = 'ProjectAccouting_Log_02'
GO



RESTORE HEADERONLY 
FROM ProjectAccoutingDispositivo

RESTORE HEADERONLY FROM DISK = ProjectAccoutingDispositivo

-- Borrar el dispositivo
EXEC sp_dropdevice 'ProjectAccoutingDispositivo'
GO





DROP DATABASE ProjectAccouting
GO

-- ========================================================================================================
-- Proceso de restauracion
-- ========================================================================================================
USE master
GO

-- Cuando se esta restaurando tiene que estar en modo NORECOVERY
RESTORE DATABASE ProjectAccouting 
FROM ProjectAccoutingDispositivo
WITH FILE = 1, NORECOVERY
GO

RESTORE DATABASE ProjectAccouting 
FROM ProjectAccoutingDispositivo
WITH FILE = 2, NORECOVERY
GO

RESTORE DATABASE ProjectAccouting 
FROM ProjectAccoutingDispositivo
WITH FILE = 3, NORECOVERY
GO

RESTORE DATABASE ProjectAccouting 
FROM ProjectAccoutingDispositivo
WITH FILE = 4, NORECOVERY
GO

-- Cuando el ultimo Backup se restaura se deja modo RECOVERY
RESTORE DATABASE ProjectAccouting 
FROM ProjectAccoutingDispositivo
WITH FILE = 5, RECOVERY
GO

-- ========================================================================================================
--Backup de solo copia
-- ========================================================================================================

BACKUP DATABASE ProjectAccouting
TO DISK = 'C:\Programacion\Net\SqlServer\File\Backups\ProjectAccoutingCopy.bak' 
WITH FORMAT,
-- WITH FORMAT,
COPY_ONLY,  Name='Backup de solo Copia',
DESCRIPTION = 'Backup de solo copia de la base de datos ProjectAccouting'
GO


USE ProjectAccouting




CREATE PROC Pro_T (@url NVARCHAR(MAX)
)
AS
BEGIN 

--declare @backupFile varchar(max) = 'C:\Programacion\Net\SqlServer\File\Backups\ProjectAccoutingFull.bak';
declare @backupFile varchar(max) = @url;

declare @dbName varchar(256);

-- THIS IS SPECIFIC TO SQL SERVER 2012
--
declare @headers table 
( 
    BackupName varchar(256),
    BackupDescription varchar(256),
    BackupType varchar(256),        
    ExpirationDate varchar(256),
    Compressed varchar(256),
    Position varchar(256),
    DeviceType varchar(256),        
    UserName varchar(256),
    ServerName varchar(256),
    DatabaseName varchar(256),
    DatabaseVersion varchar(256),        
    DatabaseCreationDate varchar(256),
    BackupSize varchar(256),
    FirstLSN varchar(256),
    LastLSN varchar(256),        
    CheckpointLSN varchar(256),
    DatabaseBackupLSN varchar(256),
    BackupStartDate varchar(256),
    BackupFinishDate varchar(256),        
    SortOrder varchar(256),
    CodePage varchar(256),
    UnicodeLocaleId varchar(256),
    UnicodeComparisonStyle varchar(256),        
    CompatibilityLevel varchar(256),
    SoftwareVendorId varchar(256),
    SoftwareVersionMajor varchar(256),        
    SoftwareVersionMinor varchar(256),
    SoftwareVersionBuild varchar(256),
    MachineName varchar(256),
    Flags varchar(256),        
    BindingID varchar(256),
    RecoveryForkID varchar(256),
    Collation varchar(256),
    FamilyGUID varchar(256),        
    HasBulkLoggedData varchar(256),
    IsSnapshot varchar(256),
    IsReadOnly varchar(256),
    IsSingleUser varchar(256),        
    HasBackupChecksums varchar(256),
    IsDamaged varchar(256),
    BeginsLogChain varchar(256),
    HasIncompleteMetaData varchar(256),        
    IsForceOffline varchar(256),
    IsCopyOnly varchar(256),
    FirstRecoveryForkID varchar(256),
    ForkPointLSN varchar(256),        
    RecoveryModel varchar(256),
    DifferentialBaseLSN varchar(256),
    DifferentialBaseGUID varchar(256),        
    BackupTypeDescription varchar(256),
    BackupSetGUID varchar(256),
    CompressedBackupSize varchar(256),        
    Containment varchar(256),
	KeyAlgorithm varchar(256),
	EncryptorThumbprint varchar(256),
	EncryptorType varchar(256)


    --
    -- This field added to retain order by
    --
    --Seq int NOT NULL identity(1,1)
); 



insert into @headers exec('restore headeronly from disk = '''+ @backupFile +'''');

SELECT * FROM @headers

END

EXEC Pro_T 'C:\Programacion\Net\SqlServer\File\Backups\ProjectAccoutingFull.bak'




CREATE OR ALTER PROC Testing (@h NVARCHAR(40) ,@hk int)
AS
BEGIN

DECLARE @result INT = 2;

RETURN  @result
END 
GO

DECLARE @Num INT = 0;

EXEC @Num = Testing 'jj', 4

SELECT @Num