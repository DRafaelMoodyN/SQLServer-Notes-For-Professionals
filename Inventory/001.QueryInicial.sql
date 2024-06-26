------------------------------------------------------------------------------------
-- SQL Structured Query Language
------------------------------------------------------------------------------------

/*
	Que son DDL, DML, DQL y DCL en SQL?

	DDL= CREATE, ALTER, DROP
	DML= INSERT, UPDATE, DELETE
	DQL= SELECT
	DCL= PERMISOS
*/


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

CREATE SCHEMA Costo
GO

CREATE SCHEMA Catalogo
GO

CREATE TABLE Producto.Categoria(
	CategoriaID INT IDENTITY PRIMARY KEY NOT NULL,
	Nombre NVARCHAR(50) UNIQUE NOT NULL,
	IsActivo BIT DEFAULT 1 NOT NULL,
	UsuarioCrea NVARCHAR(50) NOT NULL,
	UsuarioModifica NVARCHAR(50) NOT NULL,
	-- Tabla Historica
	FechaCreacion DATETIME2 GENERATED ALWAYS AS ROW START NOT NULL,
	FechaModifica DATETIME2 GENERATED ALWAYS AS ROW END NOT NULL,
	PERIOD FOR SYSTEM_TIME (FechaCreacion,FechaModifica)
) WITH(SYSTEM_VERSIONING = ON (HISTORY_TABLE = Producto.Categoria_Historial))
GO

SELECT CURRENT_USER

SET IDENTITY_INSERT Producto.Categoria ON
INSERT INTO Producto.Categoria(CategoriaID,Nombre,UsuarioCrea,UsuarioModifica)
SELECT pc.ProductCategoryID, pc.Name, CURRENT_USER, CURRENT_USER 
FROM AdventureWorks2019.Production.ProductCategory AS pc
WHERE pc.ProductCategoryID <> 5
SET IDENTITY_INSERT Producto.Categoria OFF
GO

-- SELECT * FROM Producto.Categoria
-- DELETE FROM Producto.Categoria

CREATE TABLE Producto.SubCategoria(
	SubCategoriaID INT IDENTITY PRIMARY KEY NOT NULL,
	Nombre NVARCHAR (50) UNIQUE NOT NULL,
	IsActivo BIT DEFAULT 1 NOT NULL,
	UsuarioCrea NVARCHAR (50) NOT NULL,
	UsuarioModifica NVARCHAR(50) NOT NULL,
	CategoriaID INT FOREIGN KEY REFERENCES Producto.Categoria(CategoriaID),
	-- Tabla Historial
	FechaCreacion DATETIME2 GENERATED ALWAYS AS ROW START NOT NULL,
	FechaModifica DATETIME2 GENERATED ALWAYS AS ROW END NOT NULL,
	PERIOD FOR SYSTEM_TIME (FechaCreacion,FechaModifica)
)WITH(SYSTEM_VERSIONING = ON (HISTORY_TABLE = Producto.SubCategoria_Historial))
GO

-- Informacion de la tabla
-- SP_HELP 'Producto.SubCategoria'

SET IDENTITY_INSERT Producto.SubCategoria ON
INSERT INTO Producto.SubCategoria(SubCategoriaID,Nombre,UsuarioCrea,UsuarioModifica,CategoriaID)
SELECT ps.ProductSubcategoryID, ps.Name, CURRENT_USER, CURRENT_USER, ps.ProductCategoryID
FROM AdventureWorks2019.Production.ProductSubcategory AS ps
SET IDENTITY_INSERT Producto.SubCategoria OFF
GO

--SELECT * FROM Producto.SubCategoria
--DELETE FROM Producto.SubCategoria

CREATE TABLE Producto.Presentacion(
	PresentacionID INT IDENTITY PRIMARY KEY NOT NULL,
	Nombre NVARCHAR(50) UNIQUE NOT NULL,
	IsActivo BIT DEFAULT 1 NOT NULL,
	UsuarioCrea NVARCHAR(50) NOT NULL,
	UsuarioModifica NVARCHAR(50) NOT NULL,
	-- Tabla Historial
	FechaCrea DATETIME2 GENERATED ALWAYS AS ROW START NOT NULL,
	FechaModifica DATETIME2 GENERATED ALWAYS AS ROW END NOT NULL,
	PERIOD FOR SYSTEM_TIME(FechaCrea,FechaModifica)
) WITH(SYSTEM_VERSIONING = ON (HISTORY_TABLE = Producto.Presentacion_Historial))

GO

CREATE TABLE Producto.UnidadMedida(
	UnidadMedidaID INT IDENTITY PRIMARY KEY NOT NULL,
	Nombre NVARCHAR(50) NOT NULL,
	Abreviacion NVARCHAR(4)  NOT NULL,
	UNIQUE(Nombre,Abreviacion),
	IsActivo BIT DEFAULT 1 NOT NULL,
	UsuarioCrea NVARCHAR(50) NOT NULL,
	UsuarioModifica NVARCHAR(50) NOT NULL,
	-- Tabla Historial
	FechaCrea DATETIME2 GENERATED ALWAYS AS ROW START NOT NULL,
	FechaModifica DATETIME2 GENERATED ALWAYS AS ROW END NOT NULL,
	PERIOD FOR SYSTEM_TIME(FechaCrea,FechaModifica)
) WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = Producto.UnidadMedida_Historial))
GO

CREATE TABLE Producto.Marca(
	MarcaID INT IDENTITY PRIMARY KEY NOT NULL,
	Nombre NVARCHAR(50) UNIQUE NOT NULL,
	IsActivo BIT DEFAULT 1 NOT NULL,
	UsuarioCrea NVARCHAR(50) NOT NULL,
	UsuarioModifica NVARCHAR(50) NOT NULL,
	-- Tabla Historial
	FechaCrea DATETIME2 GENERATED ALWAYS AS ROW START NOT NULL,
	FechaModifica DATETIME2 GENERATED ALWAYS AS ROW END NOT NULL,
	PERIOD FOR SYSTEM_TIME(FechaCrea,FechaModifica)
) WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = Producto.Marca_Historial))
GO

CREATE TABLE Producto.Modelo (
	ModeloID INT IDENTITY PRIMARY KEY NOT NULL,
	Nombre NVARCHAR(50) UNIQUE NOT NULL,
	IsActivo BIT DEFAULT 1 NOT NULL,
	UsuarioCrea NVARCHAR (50) NOT NULL,
	UsuarioModifica NVARCHAR(50) NOT NULL,
	MarcaID INT FOREIGN KEY REFERENCES Producto.Marca(MarcaID),
	-- Table Historial
	FechaCrea DATETIME2 GENERATED ALWAYS AS ROW START NOT NULL,
	FechaModifica DATETIME2 GENERATED ALWAYS AS ROW END NOT NULL,
	PERIOD FOR SYSTEM_TIME(FechaCrea,FechaModifica)
) WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = Producto.Modelo_Historial))
GO

CREATE TABLE Costo.TipoImpuesto (
	TipoImpuestoID INT IDENTITY PRIMARY KEY NOT NULL,
	Nombre NVARCHAR(50) UNIQUE NOT NULL,
	Costo DECIMAL(10,4) DEFAULT (0.0) NOT NULL,
	IsActivo BIT DEFAULT 1 NOT NULL,
	UsuarioCrea NVARCHAR (50) NOT NULL,
	UsuarioModifica NVARCHAR(50) NOT NULL,
	-- Table Historial
	FechaCrea DATETIME2 GENERATED ALWAYS AS ROW START NOT NULL,
	FechaModifica DATETIME2 GENERATED ALWAYS AS ROW END NOT NULL,
	PERIOD FOR SYSTEM_TIME(FechaCrea,FechaModifica)
) WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = Costo.TipoImpuesto_Impuesto))
GO

CREATE TABLE Producto.TipoArticuloInventario (
	TipoArticuloInventarioID INT IDENTITY PRIMARY KEY NOT NULL,
	Nombre NVARCHAR(50) UNIQUE NOT NULL,
	IsActivo BIT DEFAULT 1 NOT NULL,
	UsuarioCrea NVARCHAR (50) NOT NULL,
	UsuarioModifica NVARCHAR(50) NOT NULL,
	-- Table Historial
	FechaCrea DATETIME2 GENERATED ALWAYS AS ROW START NOT NULL,
	FechaModifica DATETIME2 GENERATED ALWAYS AS ROW END NOT NULL,
	PERIOD FOR SYSTEM_TIME(FechaCrea,FechaModifica)
) WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = Producto.TipoArticuloInventario_Historial))
GO


CREATE TABLE Producto.Producto (
	ProductoID INT IDENTITY PRIMARY KEY NOT NULL,
	Nombre NVARCHAR(50) UNIQUE NOT NULL,
	IsActivo BIT DEFAULT 1 NOT NULL,
	UsuarioCrea NVARCHAR (50) NOT NULL,
	UsuarioModifica NVARCHAR(50) NOT NULL,
	ModeloID INT FOREIGN KEY REFERENCES Producto.Modelo(ModeloID),
	UnidadMedidaID INT FOREIGN KEY REFERENCES Producto.UnidadMedida(UnidadMedidaID),
	PresentacionID INT FOREIGN KEY REFERENCES Producto.Presentacion(PresentacionID),
	SubCategoriaID INT FOREIGN KEY REFERENCES Producto.SubCategoria(SubCategoriaID),
	TipoImpuestoID INT FOREIGN KEY REFERENCES Costo.TipoImpuesto(TipoImpuestoID),
	TipoArticuloInventarioID INT FOREIGN KEY REFERENCES Producto.TipoArticuloInventario(TipoArticuloInventarioID),
	-- Table Historial
	FechaCrea DATETIME2 GENERATED ALWAYS AS ROW START NOT NULL,
	FechaModifica DATETIME2 GENERATED ALWAYS AS ROW END NOT NULL,
	PERIOD FOR SYSTEM_TIME(FechaCrea,FechaModifica)
) WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = Producto.Producto_Historial))
GO

CREATE TABLE Catalogo.TipoColor(
	TipoColorID INT IDENTITY PRIMARY KEY NOT NULL,
	Nombre NVARCHAR(50) UNIQUE NOT NULL
)
GO

CREATE TABLE Producto.ListaHistoricaPrecio (
	ListaHistoricaPrecioID INT IDENTITY PRIMARY KEY NOT NULL,
	Nombre NVARCHAR(50) UNIQUE NOT NULL,
	Costo DECIMAL(10,4) NOT NULL,
	Precio DECIMAL(10,4) NOT NULL,
	ProductoID INT FOREIGN KEY REFERENCES Producto.Producto(ProductoID),
	-- Table Historial
	FechaInicio DATETIME2 DEFAULT GETDATE(),
	FechaFin DATETIME2 DEFAULT GETDATE()
)
GO

CREATE TABLE Producto.Color (
	Color INT IDENTITY PRIMARY KEY NOT NULL,
	Nombre NVARCHAR(50) UNIQUE NOT NULL,
	Costo DECIMAL(10,4) NOT NULL,
	Precio DECIMAL(10,4) NOT NULL,
	ProductoID INT FOREIGN KEY REFERENCES Producto.Producto(ProductoID),
	TipoColorID INT FOREIGN KEY REFERENCES Catalogo.TipoColor(TipoColorID)
)
GO

CREATE TABLE Producto.Foto (
	FotoID INT IDENTITY PRIMARY KEY NOT NULL,
	Nombre NVARCHAR(100) UNIQUE NOT NULL,
	ProductoID INT FOREIGN KEY REFERENCES Producto.Producto(ProductoID)
)
GO

CREATE TABLE Producto.ProductoDetalle (
	ProductoDetalleID INT IDENTITY PRIMARY KEY NOT NULL,
	Nombre NVARCHAR(50) UNIQUE NOT NULL,
	ProductoID INT FOREIGN KEY REFERENCES Producto.Producto(ProductoID)
)
GO