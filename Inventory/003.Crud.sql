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

-- Desactivar propiedad IDENTITY 
SET IDENTITY_INSERT Categoria ON

-- INSERT
INSERT INTO Categoria(CategoriaID, Nombre, IsActivo)
VALUES(1,'Categoria 1',1)

-- Activar propiedad IDENTITY 
SET IDENTITY_INSERT Categoria OFF

-- INSERT
-- Agregar nuevos valores a la tabla
INSERT INTO Categoria(Nombre, IsActivo)
VALUES('Categoria 2',1)

-- INSERT MULTIPLES
INSERT INTO Categoria(Nombre)
VALUES
('Categoria 3'),
('Categoria 4')

-- SELECT 
-- Lista la informacion de la tabla

SELECT * FROM Categoria
SELECT c.CategoriaID, c.Nombre FROM Categoria as c 
GO

-- DELETE 
-- Eliminar de forma logica, siempre se elimina en base ala PRIMARY KEY
DELETE FROM Categoria WHERE CategoriaID = 1
GO

-- DELETE 
-- Eliminar de forma logica, siempre se elimina en base ala PRIMARY KEY
UPDATE Categoria SET IsActivo = 0 WHERE CategoriaID = 2
GO

-- UPDATE
-- Actualizar la informacio de una tabla
UPDATE Categoria SET IsActivo = 1, Nombre ='Modificando' WHERE CategoriaID = 3
GO