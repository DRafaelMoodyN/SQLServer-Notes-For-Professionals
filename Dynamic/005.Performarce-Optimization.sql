/*
Qu� sucede cuando ejecuta una declaraci�n TSQL?

La ejecuci�n de consultas normalmente se divide en cuatro pasos:

Parsing (Analizando)
Se verifica la sintaxis de una consulta y si hay alg�n TSQL no identificado o no v�lido
comandos, se generar� un error. Adem�s, la consulta se divide en una lista de muy
pasos de alto nivel que SQL Server seguir� durante el resto de este
proceso. Estos pasos son operaciones simples, como seleccionar datos de una tabla, unir
otra tabla, o ejecutando alg�n SQL din�mico o procedimiento almacenado

Binding (Vinculante)
Vinculante
Este paso se ocupa principalmente de validar objetos y garantizar que ambos sean
v�lido y utilizado en el contexto correcto. Tablas, columnas, funciones, procedimientos 
almacenados, y cualquier otro objeto con nombre se compara con los cat�logos del sistema 
de SQL Server para verificar que los nombres sean correctos y que se haga referencia a 
ellos correctamente. En este punto, si no se ha recibido ning�n error, entonces sabemos 
que la sintaxis y los nombres de los objetos son correctos.

Optimization (Mejoramiento)
B�sicamente, el optimizador de consultas genera un
posible plan de ejecuci�n y le asigna un costo, luego eval�a m�s planes de ejecuci�n
hasta que decide que ha encontrado el mejor plan, o uno que es lo suficientemente bueno

Execution (Ejecuci�n)
Se ejecutan los pasos del proceso de optimizaci�n y se realizan las acciones necesarias.
tomados para completarlos.


Optimization Tools (Herramientas de optimizaci�n)
Query Execution Plan
Statistics IO
Statistics time

SQL Server puede proporcionar informaci�n sobre qu� tablas se leyeron y cu�ntas lecturas
ocurrido contra ellos
*/

USE AdventureWorks2019
GO

SET STATISTICS IO ON;
SELECT * FROM Person.Person
SET STATISTICS IO OFF;

/*
Object (Objeto)
Este es el nombre de la tabla o vista a la que se accede.

Scan Count (Conteno de scaneo)
Esto indica si un objeto fue le�do varias veces. Un n�mero alto aqu� puede indicar que SQL Server 
lee los mismos datos una y otra vez, lo que puede ser un posible signo de una consulta ineficiente. 
Las causas m�s comunes de esto son las tablas comunes anidadas. expresiones, subconsultas 
correlacionadas u

Logical Reads (Lecturas l�gicas)
Este es el n�mero de lecturas realizadas sobre el objeto indicado, independientemente de si los datos
est� almacenado en cach� en la memoria o no.otros escenarios en los que se accede a una tabla m�s m�s 
de una vez dentro de una sola declaraci�n.

Physical Reads (Lecturas fisicas)
Este es el n�mero de lecturas en las que los datos a�n no estaban en la memoria cach� del b�fer. Cuando
sea Los datos se leen para una consulta, se colocan en la memoria y permanecen all� hasta que caducan.
o se reemplaza en un momento posterior. La lectura inicial de datos en la memoria desde su almacenamiento.
El sistema puede resultar muy caro. Si las consultas realizan constantemente lecturas f�sicas, eso
podr�a ser una se�al de que las consultas est�n leyendo demasiados datos o que hay memoria
presi�n sobre el servidor.
Cuando ejecuta una consulta y accede a los datos por primera vez, este n�mero normalmente
ser� el mismo que las lecturas l�gicas, pero todas las ejecuciones posteriores mostrar�n cero para esto
m�trica porque los datos ahora estar�n en la memoria desde la primera ejecuci�n.
*/

/*
ESTAD�STICAS TIEMPO (STATISTICS TIME)

Lo que probablemente sea la m�trica m�s importante para cualquier consumidor de datos es el tiempo que 
llev� para que el servidor nos devuelva los datos que estamos buscando

El tiempo de an�lisis y compilaci�n es el tiempo que dedica SQL Server a realizar el an�lisis.

SQL Server parse and compile time:
 CPU time = 0 ms, elapsed time = 0 ms.
SQL Server Execution Times:
 CPU time = 0 ms, elapsed time = 64 ms.El tiempo de an�lisis y compilaci�n ser� cero. Si los datos se almacenan en cach� en la memoria, 
entonces el tiempo de ejecuci�n ser� mucho m�s r�pido. Factores externos, como latencia de red, 
latencia de E/S o contenci�n de otros procesos pueden afectar el tiempo de ejecuci�n
*/


-- Execution Plan Caching (Almacenamiento en cache del plan de ejecucion)

DECLARE @FirstName NVARCHAR(MAX) = 'Richard';
DECLARE @sql_command NVARCHAR(MAX);

SELECT @sql_command = '
	SELECT
		*
	FROM Person.Person
	WHERE FirstName = ''' + @FirstName + ''';
';

EXEC sp_executesql @sql_command;
GO

/*
SQL Dynamic

Pagaremos el precio de optimizar el consulte una vez y luego el plan de ejecuci�n se 
reutilizar� una y otra vez a partir de ese momento.
*/

DECLARE @FirstName NVARCHAR(MAX) = 'David';
DECLARE @sql_command NVARCHAR(MAX);
DECLARE @parameter_list NVARCHAR(MAX) = '@first_name NVARCHAR(MAX)';

SELECT @sql_command = '
 SELECT
 *
 FROM Person.Person
 WHERE FirstName = @first_name;'

EXEC sp_executesql @sql_command, @parameter_list, @FirstName;
GO

/*
Rendimiento y Reutilizaci�n del Plan de Ejecuci�n: Como mencionaste, el segundo c�digo tiene ventajas 
en t�rminos de almacenamiento en cach� del plan de ejecuci�n. Cuando utilizas par�metros con 
sp_executesql, el motor de base de datos puede optimizar y cachear el plan de ejecuci�n para la consulta
din�mica. Esto significa que, una vez que el plan de ejecuci�n se haya generado y almacenado en cach�, 
se puede reutilizar para consultas futuras con valores de par�metro diferentes, lo que puede mejorar 
significativamente el rendimiento en comparaci�n con la generaci�n y optimizaci�n de un nuevo plan de 
ejecuci�n cada vez que se ejecuta la consulta
*/

/*
La ejecuci�n de este comando DBCC borrar� todos los datos del plan de ejecuci�n del cach�.
*/

DBCC FREEPROCCACHE;
GO


SELECT
 cached_plans.objtype AS ObjectType,
 OBJECT_NAME(sql_text.objectid, sql_text.dbid) AS ObjectName,
 cached_plans.usecounts AS ExecutionCount,
 sql_text.TEXT AS QueryText
FROM sys.dm_exec_cached_plans AS cached_plans
CROSS APPLY sys.dm_exec_sql_text(cached_plans.plan_handle) AS sql_text
WHERE sql_text.TEXT LIKE '%Person.Person%';

/*
El cach� de planes de ejecuci�n en SQL Server no afecta directamente la lectura de datos 
insertados despu�s de que se haya creado un plan de ejecuci�n. Los planes de ejecuci�n 
almacenados en cach� se utilizan para determinar c�mo se ejecutar� una consulta, pero no 
tienen control sobre qu� datos se incluir�n en el resultado de la consulta.

Si insertas nuevos datos en una tabla despu�s de que se haya generado un plan de ejecuci�n, 
esos datos ser�n considerados en las consultas que cumplan con los criterios de selecci�n adecuados,
incluso si el plan de ejecuci�n es m�s antiguo. SQL Server est� dise�ado para garantizar que las 
consultas siempre devuelvan datos actualizados, independientemente de cu�ndo se haya creado el plan 
de ejecuci�n.


*/