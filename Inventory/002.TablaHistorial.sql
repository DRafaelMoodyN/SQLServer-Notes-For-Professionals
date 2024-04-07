USE master
GO

IF EXISTS(SELECT  d.name FROM sys.databases as d WHERE d.name= 'WmsProyecto')
BEGIN
	DROP DATABASE WmsProyecto
END
GO

CREATE DATABASE WmsProyecto
GO

USE WmsProyecto
GO

-- Los SCHEMAS es un contenedor que permite agrupar los objetos y clasificarlos por nombre
CREATE SCHEMA Producto
GO

CREATE TABLE Categoria(
	CategoriaID INT IDENTITY PRIMARY KEY NOT NULL,
	Nombre NVARCHAR(50) NOT NULL UNIQUE , -- No Duplicado
	IsActivo BIT DEFAULT 1 ,

	-- Tabla Historica
	FechaCreacion DATETIME2 GENERATED ALWAYS AS ROW START NOT NULL,
	FechaModifica DATETIME2 GENERATED ALWAYS AS ROW END NOT NULL,
	PERIOD FOR SYSTEM_TIME(FechaCreacion,FechaModifica)

) WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.Categoria_Historial))

GO

-- Separar la tabla Historial
ALTER TABLE Categoria set (SYSTEM_VERSIONING = OFF)
GO

