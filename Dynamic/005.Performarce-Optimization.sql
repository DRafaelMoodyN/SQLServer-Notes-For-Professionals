/*
Qué sucede cuando ejecuta una declaración TSQL?

La ejecución de consultas normalmente se divide en cuatro pasos:

Parsing (Analizando)
Se verifica la sintaxis de una consulta y si hay algún TSQL no identificado o no válido
comandos, se generará un error. Además, la consulta se divide en una lista de muy
pasos de alto nivel que SQL Server seguirá durante el resto de este
proceso. Estos pasos son operaciones simples, como seleccionar datos de una tabla, unir
otra tabla, o ejecutando algún SQL dinámico o procedimiento almacenado

Binding (Vinculante)
Vinculante
Este paso se ocupa principalmente de validar objetos y garantizar que ambos sean
válido y utilizado en el contexto correcto. Tablas, columnas, funciones, procedimientos 
almacenados, y cualquier otro objeto con nombre se compara con los catálogos del sistema 
de SQL Server para verificar que los nombres sean correctos y que se haga referencia a 
ellos correctamente. En este punto, si no se ha recibido ningún error, entonces sabemos 
que la sintaxis y los nombres de los objetos son correctos.

Optimization (Mejoramiento)
Básicamente, el optimizador de consultas genera un
posible plan de ejecución y le asigna un costo, luego evalúa más planes de ejecución
hasta que decide que ha encontrado el mejor plan, o uno que es lo suficientemente bueno

Execution (Ejecución)
Se ejecutan los pasos del proceso de optimización y se realizan las acciones necesarias.
tomados para completarlos.


Optimization Tools (Herramientas de optimización)
Query Execution Plan
Statistics IO
Statistics time

SQL Server puede proporcionar información sobre qué tablas se leyeron y cuántas lecturas
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
Esto indica si un objeto fue leído varias veces. Un número alto aquí puede indicar que SQL Server 
lee los mismos datos una y otra vez, lo que puede ser un posible signo de una consulta ineficiente. 
Las causas más comunes de esto son las tablas comunes anidadas. expresiones, subconsultas 
correlacionadas u

Logical Reads (Lecturas lógicas)
Este es el número de lecturas realizadas sobre el objeto indicado, independientemente de si los datos
está almacenado en caché en la memoria o no.otros escenarios en los que se accede a una tabla más más 
de una vez dentro de una sola declaración.

Physical Reads (Lecturas fisicas)
Este es el número de lecturas en las que los datos aún no estaban en la memoria caché del búfer. Cuando
sea Los datos se leen para una consulta, se colocan en la memoria y permanecen allí hasta que caducan.
o se reemplaza en un momento posterior. La lectura inicial de datos en la memoria desde su almacenamiento.
El sistema puede resultar muy caro. Si las consultas realizan constantemente lecturas físicas, eso
podría ser una señal de que las consultas están leyendo demasiados datos o que hay memoria
presión sobre el servidor.
Cuando ejecuta una consulta y accede a los datos por primera vez, este número normalmente
será el mismo que las lecturas lógicas, pero todas las ejecuciones posteriores mostrarán cero para esto
métrica porque los datos ahora estarán en la memoria desde la primera ejecución.
*/

/*
ESTADÍSTICAS TIEMPO (STATISTICS TIME)

Lo que probablemente sea la métrica más importante para cualquier consumidor de datos es el tiempo que 
llevó para que el servidor nos devuelva los datos que estamos buscando

El tiempo de análisis y compilación es el tiempo que dedica SQL Server a realizar el análisis.

SQL Server parse and compile time:
 CPU time = 0 ms, elapsed time = 0 ms.
SQL Server Execution Times:
 CPU time = 0 ms, elapsed time = 64 ms.El tiempo de análisis y compilación será cero. Si los datos se almacenan en caché en la memoria, 
entonces el tiempo de ejecución será mucho más rápido. Factores externos, como latencia de red, 
latencia de E/S o contención de otros procesos pueden afectar el tiempo de ejecución
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

Pagaremos el precio de optimizar el consulte una vez y luego el plan de ejecución se 
reutilizará una y otra vez a partir de ese momento.
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
Rendimiento y Reutilización del Plan de Ejecución: Como mencionaste, el segundo código tiene ventajas 
en términos de almacenamiento en caché del plan de ejecución. Cuando utilizas parámetros con 
sp_executesql, el motor de base de datos puede optimizar y cachear el plan de ejecución para la consulta
dinámica. Esto significa que, una vez que el plan de ejecución se haya generado y almacenado en caché, 
se puede reutilizar para consultas futuras con valores de parámetro diferentes, lo que puede mejorar 
significativamente el rendimiento en comparación con la generación y optimización de un nuevo plan de 
ejecución cada vez que se ejecuta la consulta
*/

/*
La ejecución de este comando DBCC borrará todos los datos del plan de ejecución del caché.
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
El caché de planes de ejecución en SQL Server no afecta directamente la lectura de datos 
insertados después de que se haya creado un plan de ejecución. Los planes de ejecución 
almacenados en caché se utilizan para determinar cómo se ejecutará una consulta, pero no 
tienen control sobre qué datos se incluirán en el resultado de la consulta.

Si insertas nuevos datos en una tabla después de que se haya generado un plan de ejecución, 
esos datos serán considerados en las consultas que cumplan con los criterios de selección adecuados,
incluso si el plan de ejecución es más antiguo. SQL Server está diseñado para garantizar que las 
consultas siempre devuelvan datos actualizados, independientemente de cuándo se haya creado el plan 
de ejecución.


*/