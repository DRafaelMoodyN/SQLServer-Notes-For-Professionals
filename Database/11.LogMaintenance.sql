-- ======================================================================================
-- Log Maintenance || Mantenimiento de registros
-- ======================================================================================

/*
El registro de transacciones es una herramienta vital en el arsenal de SQL Server; 
proporciona recuperaci�n pero tambi�n es compatible con muchas funciones, 
como grupos de disponibilidad AlwaysOn, replicaci�n transaccional, captura de datos 
modificados y muchos m�s.

VLF (archivos de registro virtuales)

Internamente, el archivo de registro se divide en una serie de VLF. 
Cuando el VLF final en el archivo de registro se llena, SQL Server intentar� volver 
al primer VLF al comienzo del registro. Si este VLF no se ha truncado y no se puede 
reutilizado, SQL Server intentar� hacer crecer el archivo de registro. Si no es capaz 
de expandir el archivo debido a la falta de espacio en disco o a la configuraci�n de 
tama�o m�ximo, se generar� un error 9002


*/