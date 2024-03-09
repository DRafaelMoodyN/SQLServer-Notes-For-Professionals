-- ======================================================================================
-- Shrinking Files || Reducción de archivos
-- ======================================================================================

/*
Así como puede expandir los archivos de la base de datos, también puede reducirlos. Hay 
varios métodos para lograr esto, incluida la reducción de un solo archivo, la reducción 
de todos los archivos dentro de un base de datos, incluido el registro, o incluso 
configurar una opción de reducción automática en el nivel de la base de datos.

Para reducir un archivo individual, debe usar el comando DBCC SHRINKFILE. Cuando
utiliza esta opción, puede especificar el tamaño de destino del archivo o puede especificar
el opción ARCHIVO VACÍO. La opción EMPTYFILE moverá todos los datos dentro del archivo a 
otros archivos dentro del mismo grupo de archivos. Esto significa que posteriormente puede 
eliminar el archivo de la base de datos.

Si especifica un tamaño de destino para la base de datos, puede optar por especificar
TRUNCATEONLY o NOTRUNCATE. Si selecciona el primero, entonces SQL Server comenzará en el
final del archivo y recuperar espacio hasta que alcance la última extensión asignada. 
Si tu escoges el último, luego comenzando al final del archivo, SQL Server comenzará 
un proceso de mover extensiones asignadas al primer espacio libre al comienzo del archivo.

*/

USE Chapter6
GO

-- Shrinking a File with TRUNCATEONLY || Reducir un archivo con TRUNCATEONLY

EXEC sp_helpdb Chapter6
GO

DBCC SHRINKFILE ('Chapter6File_4',0,TRUNCATEONLY)
GO

-- Si quisiéramos recuperar el espacio no utilizado al final de todos los 
-- archivos en la base de datos
-- Shrinking a Database via T-SQL || Reducir una base de datos a través de T-SQL

DBCC SHRINKDATABASE('Chapter6')
GO

/*
Hay muy pocas ocasiones en las que sea aceptable reducir una base de datos o incluso
un archivo individual. Existe la idea errónea de que los archivos grandes y vacíos 
tardan más en respaldarse, pero esto es una falacia.

En términos generales, no debe buscar reducir su
archivos de base de datos, y ciertamente nunca debería usar la opción Auto Shrink en un
base de datos.

*/