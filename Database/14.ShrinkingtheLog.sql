-- ======================================================================================
-- Log Fragmentation ||
-- ======================================================================================


/*

Shrinking the Log || Reducir

La reducción de su archivo de registro nunca debe ser parte de sus rutinas de mantenimiento estándar.
No hay ningún beneficio por adoptar esta política. Hay algunas ocasiones, sin embargo, cuando
es posible que deba reducir un archivo de registro y, afortunadamente, no presenta los mismos peligros
como reducir un archivo de datos.
La razón habitual por la que necesita reducir su archivo de registro es cuando una actividad atípica
ocurre en su base de datos, como una población de datos inicial o una carga ETL única.

Si este es el caso, y su archivo de registro se expande más allá del punto donde los umbrales de espacio en
su volumen está siendo violado, entonces es probable que reducir el tamaño del archivo sea el
mejor curso de acción, en lugar de expandir el volumen que lo aloja. En esto
eventualidad, sin embargo, debe analizar cuidadosamente la situación para asegurarse de que realmente
es un evento atípico. Si parece que podría volver a ocurrir, entonces debería considerar
aumentar la capacidad para hacerle frente.
*/

-- Shrinking a Log with TRUNCATEONLY

USE [Chapter6]
GO

DBCC SHRINKFILE (N'Chapter6File_log' , 0, TRUNCATEONLY);
GO

/*

Sugerencia Porque reducir el registro de transacciones siempre implica recuperar espacio de
el final del registro, hasta que se alcance el primer VLF activo, es sensato tomar un registro
haga una copia de seguridad y coloque la base de datos en modo de usuario único antes de realizar esta actividad
*/

