-- ======================================================================================
-- Shrinking Files || Reducci�n de archivos
-- ======================================================================================

/*
As� como puede expandir los archivos de la base de datos, tambi�n puede reducirlos. Hay 
varios m�todos para lograr esto, incluida la reducci�n de un solo archivo, la reducci�n 
de todos los archivos dentro de un base de datos, incluido el registro, o incluso 
configurar una opci�n de reducci�n autom�tica en el nivel de la base de datos.

Para reducir un archivo individual, debe usar el comando DBCC SHRINKFILE. Cuando
utiliza esta opci�n, puede especificar el tama�o de destino del archivo o puede especificar
el opci�n ARCHIVO VAC�O. La opci�n EMPTYFILE mover� todos los datos dentro del archivo a 
otros archivos dentro del mismo grupo de archivos. Esto significa que posteriormente puede 
eliminar el archivo de la base de datos.

Si especifica un tama�o de destino para la base de datos, puede optar por especificar
TRUNCATEONLY o NOTRUNCATE. Si selecciona el primero, entonces SQL Server comenzar� en el
final del archivo y recuperar espacio hasta que alcance la �ltima extensi�n asignada. 
Si tu escoges el �ltimo, luego comenzando al final del archivo, SQL Server comenzar� 
un proceso de mover extensiones asignadas al primer espacio libre al comienzo del archivo.

*/

USE Chapter6
GO

-- Shrinking a File with TRUNCATEONLY || Reducir un archivo con TRUNCATEONLY

EXEC sp_helpdb Chapter6
GO

DBCC SHRINKFILE ('Chapter6File_4',0,TRUNCATEONLY)
GO

-- Si quisi�ramos recuperar el espacio no utilizado al final de todos los 
-- archivos en la base de datos
-- Shrinking a Database via T-SQL || Reducir una base de datos a trav�s de T-SQL

DBCC SHRINKDATABASE('Chapter6')
GO

/*
Hay muy pocas ocasiones en las que sea aceptable reducir una base de datos o incluso
un archivo individual. Existe la idea err�nea de que los archivos grandes y vac�os 
tardan m�s en respaldarse, pero esto es una falacia.

En t�rminos generales, no debe buscar reducir su
archivos de base de datos, y ciertamente nunca deber�a usar la opci�n Auto Shrink en un
base de datos.

*/