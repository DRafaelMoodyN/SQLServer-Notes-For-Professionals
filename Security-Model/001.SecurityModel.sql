-- ==================================================================================================
-- SQL Server Security Model
-- ==================================================================================================

/*
Al implementar la seguridad en SQL Server, siempre es importante tener en cuenta y aplicar el 
principio de privilegio mínimo. En otras palabras, los usuarios solo se les debe dar acceso a 
los bienes asegurables que necesitan para realizar su trabajo diario operaciones. 

Por ejemplo, si la entidad de seguridad UserA solo necesita leer datos de la TablaA asegurable, 
entonces el UsuarioA solo debe recibir permisos de lectura para la TablaA, no permiso para 
escribir en la tabla.

Para usar la autenticación de SQL Server, el Motor de base de datos debe usar la autenticación de 
modo mixto.

Selecionar la instancia -> Properties -> Security -> Server authenticacion 

*/