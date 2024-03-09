-- ======================================================================================
-- Log Maintenance || Mantenimiento de registros
-- ======================================================================================

/*
El registro de transacciones es una herramienta vital en el arsenal de SQL Server; 
proporciona recuperación pero también es compatible con muchas funciones, 
como grupos de disponibilidad AlwaysOn, replicación transaccional, captura de datos 
modificados y muchos más.

VLF (archivos de registro virtuales)

Internamente, el archivo de registro se divide en una serie de VLF. 
Cuando el VLF final en el archivo de registro se llena, SQL Server intentará volver 
al primer VLF al comienzo del registro. Si este VLF no se ha truncado y no se puede 
reutilizado, SQL Server intentará hacer crecer el archivo de registro. Si no es capaz 
de expandir el archivo debido a la falta de espacio en disco o a la configuración de 
tamaño máximo, se generará un error 9002


*/