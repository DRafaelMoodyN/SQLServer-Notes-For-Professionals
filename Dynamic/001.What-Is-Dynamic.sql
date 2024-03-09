-- A Simple Example

/*
¿Qué pasaría si quisiéramos seleccionar datos de una tabla, pero no supiéramos el 
nombre? de la tabla hasta el tiempo de ejecución?
*/

USE AdventureWorks2019
GO

SELECT TOP(10) * FROM Person.Person

/*
¿T-SQL? Antes de responder a esa pregunta, introduzcamos SQL dinámico simplemente 
reescribiendo
*/

-- Por consistencia y confiabilidad, use NVARCHAR(MAX) como el tipo de datos para 
-- su cadenas de comandos SQL dinámicos
DECLARE @Sql_Consult NVARCHAR(50) = 'SELECT TOP(10) * FROM Person.Person';
EXEC (@Sql_Consult) -- Simpre poner parentesis
-- Sql trata las cadenas de comandos dinamicos con proc
GO

-- Cambiar el nombre de la tabla dynamic

DECLARE @Table_Name SYSNAME = 'Person.Person'
EXEC ('SELECT TOP(10) * FROM '+ @Table_Name)


-- Dynamic SQL in Action
-- Copia de seguridad de base de datos personalisadas

DECLARE @Sql_Command NVARCHAR(MAX); -- Cadena de commandos intruccion SQL dynamic
DECLARE @Database_Name SYSNAME; -- Nombre de db que actualmente esta siendo respaldada
DECLARE @Database_List TABLE(Data_Name SYSNAME) -- Tendra una lista de nuestras bd

INSERT INTO @Database_List(Data_Name) 
SELECT d.name FROM sys.databases AS d WHERE d.name = 'NodeJsRealStateProperty'

DECLARE Database_Cursor CURSOR LOCAL FAST_FORWARD FOR -- Curso para iterar las bd
SELECT Data_Name FROM @Database_List
OPEN Database_Cursor  
FETCH NEXT FROM Database_Cursor INTO @Database_Name
WHILE @@FETCH_STATUS = 0
BEGIN 
	SELECT @Sql_Command = '
		BACKUP DATABASE ' + @Database_Name +'
		TO DISK= ''C:\Programacion\Net\SqlServer\File\Backups\'+@Database_Name+'.bak''
		WITH COMPRESSION;'
	EXEC(@Sql_Command)
	FETCH NEXT FROM Database_Cursor INTO @Database_Name;
END

CLOSE Database_Cursor; 
DEALLOCATE Database_Cursor;
GO

/*
Concatenar una cadena con NULL dará como resultado NULL. Si la cadena de comando de 
SQL dinámico que construimos se le pasa un parámetro que es NULL, entonces toda nuestra 
declaración se convertirá en NULO. El resultado probablemente será T-SQL que no hace 
absolutamente nada.

SQL dinámico no se puede usar en funciones En pocas palabras, podemos usar SQL dinámico 
en procedimientos almacenados
Cualquier intento de incluir SQL dinámico dentro de las funciones
resultará en un error:

*/

/*
Sp_executesql
Hasta ahora, todas las sentencias SQL dinámicas se han ejecutado utilizando la palabra clave EXEC.
Este método de ejecución es simple, directo y conveniente para pruebas rápidas.
y depuración. EXEC viene con una serie de limitaciones y problemas de seguridad que
anímanos a encontrar una mejor solución:

1. EXEC es mucho más vulnerable a la inyección SQL y los efectos de
entrada inesperada. Los caracteres de escape y los apóstrofes pueden
arruinar una declaración SQL dinámica.

2. No hay una forma integrada de administrar las variables de entrada o salida
con EXEC.

3. Al usar EXEC, es poco probable que se reutilicen los planes de ejecución.
Esta reutilización de planes de ejecución, conocida como rastreo de parámetros, es una
característica útil y generalmente algo que queremos que ocurra

*/

SP_EXECUTESQL N'SELECT TOP(10) * FROM Person.Person'

/*
Se considera una mejor práctica en SQL Server, y que mejorará la confiabilidad,
seguridad y rendimiento de su SQL dinámico.

*/
