-- ======================================================================================
-- FILESTREAM Filegroups ||
-- ======================================================================================

/*
FILESTREAM es una tecnolog�a que le permite almacenar datos binarios en un formato no 
estructurado. Los datos binarios a menudo se almacenan en el sistema operativo, a 
diferencia de la base de datos, y FILESTREAM le brinda la posibilidad de continuar 
con esto y, al mismo tiempo, ofrece consistencia transaccional entre estos datos no 
estructurados y los metadatos estructurados almacenado en la base de datos.

El uso de esta tecnolog�a le permitir� superar los problemas de SQL Server.
Es probable que el rendimiento de lectura sea mas rapido.

FILESTREAM usan Cach� de Windows en lugar de la cach� del b�fer de SQL Server. 
Esto tiene la ventaja de que Ud. no tenga archivos grandes que llenen su cach� de b�fer,
lo que hace que otros datos se vac�en a ya sea la extensi�n de cach� de b�fer o al disco. 
Por otro lado, significa que cuando est�s configurando la configuraci�n de Max Server 
Memory para la instancia, debe recordar que Windows requiere memoria adicional si planea 
almacenar en cach� los objetos, porque el binario Se utiliza la memoria cach� de Windows, 
a diferencia de la memoria cach� de b�fer de SQL Server.

Se requieren grupos de archivos separados para los datos de FILESTREAM. En lugar de 
contener archivos, estos grupos de archivos apuntan a ubicaciones de carpetas en el 
sistema operativo. Cada uno de estos lugares se llama contenedor. FILESTREAM debe 
estar habilitado en la instancia para poder crear un grupo de archivos FILESTREAM.

*/

USE Chapter6
GO

-- Habilitar y configurar FILESTREAM

EXEC sp_configure 'filestream access level',2
RECONFIGURE
GO
-- Reinicie el servicio de SQL Server


-- Adding a FILESTREAM Filegroup

ALTER DATABASE Chapter6 ADD FILEGROUP Chapter_FS_FG CONTAINS FILESTREAM
GO

ALTER DATABASE Chapter6 ADD FILE(
	NAME = 'Chapter6_FA_File1',
	FILENAME = 'C:\Programacion\Net\SqlServer\Pro-SqlServer-2019-Administration\Files\FilesStram1'
)
TO FILEGROUP [Chapter_FS_FG]
GO

CREATE TABLE dbo.FileStreamExample(
	FileStreamExampleID UNIQUEIDENTIFIER ROWGUIDCOL NOT NULL UNIQUE,
	PictureDescription NVARCHAR(500),
	Picture VARBINARY(MAX) FILESTREAM
)

INSERT INTO FileStreamExample SELECT NEWID(), 'Imagen 1', * 
FROM
OPENROWSET(BULK
	'C:\Users\David Moody\Pictures\Screenshots\Img1.jpg',
	SINGLE_BLOB) AS IMPORT;

SELECT * FROM FileStreamExample
GO

/*
Si ahora abrimos la ubicaci�n del contenedor en el sistema de archivos, podemos ver 
que tenemos una carpeta, que tiene un GUID como su nombre. Esto representa la tabla 
que creada

Dentro de esta carpeta hay otra carpeta que tambi�n tiene un GUID como nombre. esta
carpeta representa la columna FILESTREAM que creamos

Dentro de esta carpeta, encontraremos un archivo, que es la imagen que insertamos 
en la columna

En el nivel ra�z del contenedor, tambi�n encontrar� un archivo llamado filestream.hdr, 
que contiene los metadatos del contenedor y una carpeta llamada $FSLog. Esta carpeta 
contiene una serie de archivos que componen el equivalente FILESTREAM del registro de 
transacciones

*/


/*
FileTable es una tecnolog�a que se basa en FILESTREAM y permite que los datos se 
almacenen en el sistema de archivos. 

Por lo tanto, para usarlo, debe habilitar FILESTREAM con acceso de transmisi�n. 
Sin embargo, a diferencia de FILESTREAM, FileTable permite transacciones no 
transaccionales. acceso a los datos. 

Esto significa que puede mover datos para que se almacenen en el motor SQL en lugar 
de en el sistema operativo sin necesidad de modificar las aplicaciones existentes. 
T� Tambi�n puede abrir y modificar los archivos a trav�s del Explorador de Windows 
como cualquier otro archivo en el sistema operativo.

Para lograr esto, SQL Server permite que las aplicaciones de Windows soliciten un 
identificador de archivo sin tener una transacci�n.

Que Nivel de acceso no transaccional pueden solicitar las aplicaciones?

NONE (predeterminado: solo se permite el acceso transaccional)
READ_ONLY (El objeto en el sistema de archivos se puede ver pero no modificar)
FULL (El objeto en el sistema de archivos se puede ver y modificar)
IN_TRANSITION_TO_READ_ONLY (Transici�n a READ_ONLY)
IN_TRANSITION_TO_OFF (Transici�n a NINGUNO)

*/

-- Configuraci�n del nivel de acceso no transaccional

ALTER DATABASE Chapter6
	SET FILESTREAM (
		NON_TRANSACTED_ACCESS = FULL,
		DIRECTORY_NAME = 'Chapter6_FileTable'
	)
GO

/*

SQL Server ahora crea un recurso compartido, que tiene el mismo nombre que su instancia. 
En el interior este recurso compartido, encontrar� una carpeta con el nombre que especific�. 

Cuando creas un FileTable, puede volver a especificar un nombre de directorio. 
Esto crea una subcarpeta con el nombre que tu espec�ficas. Dado que las FileTables no 
tienen un esquema relacional y los metadatos que se almacenado sobre los archivos es fijo.

*/

-- Creating a FileTable

CREATE TABLE dbo.cho6_test AS FILETABLE
	WITH(
		FILETABLE_DIRECTORY = 'Chapter6_FileTable',
		FILETABLE_COLLATE_FILENAME = database_default
	)
GO

/*
	Para cargar archivos en la tabla, simplemente puede copiarlos o moverlos a la carpeta
	ubicaci�n, o los desarrolladores pueden usar el espacio de nombres System.IO dentro de
	sus aplicaciones.sql El servidor actualizar� las columnas de metadatos de FileTable 
	en consecuencia.
*/