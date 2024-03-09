-- Plan de Bakups

-- Paso 1 -----------------------------------------------------------------------------------
USE master
GO

-- Creacion del dispositivo logico
EXEC sp_addumpdevice 'disk', 'Dispositivo_AdventureWork2019',
'C:\Programacion\Net\SqlServer\File\Backups\AdventureWorks2019_Full.bak';
GO

-- Paso 2 -----------------------------------------------------------------------------------
-- Crear un Proc que retorne el numero de backups dependiento del type 

CREATE OR ALTER PROC GetNumberBackupType(@URL NVARCHAR(MAX), @Type INT)
AS
BEGIN 

-- Creacion de una variable table
DECLARE @headers TABLE 
( 
    BackupName VARCHAR(256),
    BackupDescription VARCHAR(256),
    BackupType VARCHAR(256),        
    ExpirationDate VARCHAR(256),
    Compressed VARCHAR(256),
    Position VARCHAR(256),
    DeviceType VARCHAR(256),        
    UserName VARCHAR(256),
    ServerName VARCHAR(256),
    DatabaseName VARCHAR(256),
    DatabaseVersion VARCHAR(256),        
    DatabaseCreationDate VARCHAR(256),
    BackupSize VARCHAR(256),
    FirstLSN VARCHAR(256),
    LastLSN VARCHAR(256),        
    CheckpointLSN VARCHAR(256),
    DatabaseBackupLSN VARCHAR(256),
    BackupStartDate VARCHAR(256),
    BackupFinishDate VARCHAR(256),        
    SortOrder VARCHAR(256),
    CodePage VARCHAR(256),
    UnicodeLocaleId VARCHAR(256),
    UnicodeComparisonStyle VARCHAR(256),        
    CompatibilityLevel VARCHAR(256),
    SoftwareVendorId VARCHAR(256),
    SoftwareVersionMajor VARCHAR(256),        
    SoftwareVersionMinor VARCHAR(256),
    SoftwareVersionBuild VARCHAR(256),
    MachineName VARCHAR(256),
    Flags VARCHAR(256),        
    BindingID VARCHAR(256),
    RecoveryForkID VARCHAR(256),
    Collation VARCHAR(256),
    FamilyGUID VARCHAR(256),        
    HasBulkLoggedData VARCHAR(256),
    IsSnapshot VARCHAR(256),
    IsReadOnly VARCHAR(256),
    IsSingleUser VARCHAR(256),        
    HasBackupChecksums VARCHAR(256),
    IsDamaged VARCHAR(256),
    BeginsLogChain VARCHAR(256),
    HasIncompleteMetaData VARCHAR(256),        
    IsForceOffline VARCHAR(256),
    IsCopyOnly VARCHAR(256),
    FirstRecoveryForkID VARCHAR(256),
    ForkPointLSN VARCHAR(256),        
    RecoveryModel VARCHAR(256),
    DifferentialBaseLSN VARCHAR(256),
    DifferentialBaseGUID VARCHAR(256),        
    BackupTypeDescription VARCHAR(256),
    BackupSetGUID VARCHAR(256),
    CompressedBackupSize VARCHAR(256),        
    Containment VARCHAR(256),
	KeyAlgorithm VARCHAR(256),
	EncryptorThumbprint VARCHAR(256),
	EncryptorType VARCHAR(256)
); 

-- Insertamos datos en nuestra table variable con los datos del backups
INSERT INTO @headers EXEC('RESTORE HEADERONLY FROM DISK = '''+ @URL +'''');

DECLARE @Position INT = 0; 

SELECT @Position =  COUNT(s.BackupType) FROM  @headers as s
WHERE s.BackupType = @Type
GROUP BY s.BackupType

SET @Position += 1

RETURN @Position
END
GO

-- Paso 3 -----------------------------------------------------------------------------------
-- Crear una Task

-- Modo Recovery Full
ALTER DATABASE AdventureWorks2019
SET RECOVERY FULL
 
-- Nombre para el backups de forma dinamica
DECLARE @NameBackupsFull NVARCHAR(40) ='AwExamenBDII_' + CONVERT(NVARCHAR(40), GETDATE(), 103) + '_Full'

-- Primer Backups Full
BACKUP DATABASE AdventureWorks2019
TO Dispositivo_AdventureWork2019
WITH INIT, FORMAT, 
NAME = @NameBackupsFull,
DESCRIPTION  = 'AdventureWork_Backup_Full'
GO


CREATE OR ALTER PROC AdventureWord_Backups_Diff
AS
BEGIN
-- Get dela cantidad de Bakups Diff
	DECLARE @Number INT = 0;	
	EXEC @Number = GetNumberBackupType 'C:\Programacion\Net\SqlServer\File\Backups\AdventureWorks2019_Full.bak', 5

	DECLARE @NameBackups NVARCHAR(40) = 'AwExamenBDII' +  CONVERT(NVARCHAR(40), GETDATE(), 103) + '_Diff_' + CONVERT(NVARCHAR(40),@Number)

	BACKUP DATABASE AdventureWorks2019
	TO Dispositivo_AdventureWork2019
	WITH NAME = @NameBackups,
	DESCRIPTION = 'AdventureWork_Backup_Diff',
	DIFFERENTIAL;
END
GO

EXEC AdventureWord_Backups_Diff

-- Paso 4 -----------------------------------------------------------------------------------

-- Backups Log


DECLARE @Number INT = 0;	
EXEC @Number = GetNumberBackupType 'C:\Programacion\Net\SqlServer\File\Backups\AdventureWorks2019_Full.bak', 5

DECLARE @NameBackups NVARCHAR(40) = 'AwExamenBDII' +  CONVERT(NVARCHAR(40), GETDATE(), 103) + '_Diff_' + CONVERT(NVARCHAR(40),@Number)

BACKUP LOG AdventureWorks2019
TO Dispositivo_AdventureWork2019
WITH NAME =  @NameBackups,
DESCRIPTION = 'ProjectAccouting_Log_02'
GO

