-- ==================================================================================================
-- Users
-- ==================================================================================================

/*
Por lo general, se creará un usuario de base de datos a partir de un inicio de sesión en el nivel 
de instancia. Esto significa que al mismo principal de seguridad de nivel de instancia se le 
pueden otorgar permisos en los recursos en múltiples bases de datos.

*/

-- Create a User From a Login

USE AdventureWorks2019
GO

-- Si no hay un esquema predeterminado especificado para un usuario
-- su esquema predeterminado será dbo

CREATE USER DavidSQL FOR LOGIN DavidSQL
WITH DEFAULT_SCHEMA = Sales
GO
 
-- Agregando schema

--CREATE SCHEMA Sales AUTHORIZATION DavidSQL
--GO




