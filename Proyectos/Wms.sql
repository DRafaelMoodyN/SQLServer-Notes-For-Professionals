-- CODIGO BASE INVENTARIO

USE master
GO

IF EXISTS (SELECT * FROM sys.databases AS b WHERE b.name = 'Wms')
	DROP DATABASE Wms
GO

CREATE DATABASE Wms
GO

USE Wms
GO

CREATE SCHEMA Producto
GO

CREATE TABLE Producto.TipoImpuesto(
	TipoImpuestoID INT PRIMARY KEY IDENTITY NOT NULL,
	Nombre NVARCHAR(100) UNIQUE NOT NULL,
	Costo DECIMAL(14,4) DEFAULT 0.0 NOT NULL,
	FCreacion DATETIME DEFAULT GETDATE() NOT NULL,
	FModificacion DATETIME,
	IsDelete BIT DEFAULT 1
)
GO

INSERT INTO Producto.TipoImpuesto(Nombre,Costo,FCreacion,FModificacion,IsDelete)
VALUES('NO APLICA',0.0,GETDATE(),GETDATE(),1)
GO

CREATE TABLE Producto.TipoColor(
	TipoColorID INT PRIMARY KEY IDENTITY NOT NULL,
	Nombre NVARCHAR(100) UNIQUE NOT NULL,
	FCreacion DATETIME DEFAULT GETDATE() NOT NULL,
	FModificacion DATETIME,
	IsDelete BIT DEFAULT 1
)
GO

INSERT INTO Producto.TipoColor(Nombre,FCreacion,FModificacion,IsDelete)
SELECT DISTINCT(ISNULL(P.Color,'NO Aplica')), GETDATE(),GETDATE(),1 
FROM AdventureWorks2019.Production.Product AS p
GO

CREATE TABLE Producto.Marca(
	MarcaID INT PRIMARY KEY IDENTITY NOT NULL,
	Nombre NVARCHAR(100) UNIQUE NOT NULL,
	FCreacion DATETIME DEFAULT GETDATE() NOT NULL,
	FModificacion DATETIME,
	IsDelete BIT DEFAULT 1
)
GO


INSERT INTO Producto.Marca(Nombre,FCreacion,FModificacion,IsDelete)
VALUES('NO APLICA',GETDATE(),GETDATE(),1)
GO

CREATE TABLE Producto.Modelo(
	ModeloID INT PRIMARY KEY IDENTITY NOT NULL,
	Nombre NVARCHAR(100) UNIQUE NOT NULL,
	FCreacion DATETIME DEFAULT GETDATE() NOT NULL,
	FModificacion DATETIME,
	IsDelete BIT DEFAULT 1,
	MarcaID INT FOREIGN KEY REFERENCES Producto.Marca(MarcaID)
)
GO

INSERT INTO Producto.Modelo(Nombre,FCreacion,FModificacion,IsDelete, MarcaID)
VALUES('NO APLICA',GETDATE(),GETDATE(),1,1)
GO

CREATE TABLE Producto.Categoria(
	CategoriaID INT PRIMARY KEY IDENTITY NOT NULL,
	Nombre NVARCHAR(100) UNIQUE NOT NULL,
	FCreacion DATETIME DEFAULT GETDATE() NOT NULL,
	FModificacion DATETIME,
	IsDelete BIT DEFAULT 1
)
GO

SET IDENTITY_INSERT Producto.Categoria ON
INSERT INTO Producto.Categoria(CategoriaID,Nombre,FCreacion, FModificacion, IsDelete)
SELECT c.ProductCategoryID, c.Name, c.ModifiedDate, c.ModifiedDate, 1
FROM AdventureWorks2019.Production.ProductCategory AS c
SET IDENTITY_INSERT Producto.Categoria OFF
GO

CREATE TABLE Producto.SubCategoria(
	SubCategoriaID INT PRIMARY KEY IDENTITY NOT NULL,
	Nombre NVARCHAR(100) UNIQUE NOT NULL,
	FCreacion DATETIME DEFAULT GETDATE() NOT NULL,
	FModificacion DATETIME,
	IsDelete BIT DEFAULT 1,
	CategoriaID INT FOREIGN KEY REFERENCES Producto.Categoria(CategoriaID)
)
GO

SET IDENTITY_INSERT Producto.SubCategoria ON
INSERT INTO Producto.SubCategoria(SubCategoriaID,Nombre,FCreacion,FModificacion,IsDelete,CategoriaID)
SELECT 
	p.ProductSubcategoryID,
	p.Name,
	p.ModifiedDate,
	p.ModifiedDate,
	1,
	p.ProductCategoryID
FROM AdventureWorks2019.Production.ProductSubcategory AS p
SET IDENTITY_INSERT Producto.SubCategoria OFF
GO

CREATE TABLE Producto.UnidadMedida(
	UnidadMedidaID INT PRIMARY KEY IDENTITY NOT NULL,
	Nombre NVARCHAR(100) UNIQUE NOT NULL,
	Abreviatura NVARCHAR(5) UNIQUE NOT NULL,
	FCreacion DATETIME DEFAULT GETDATE() NOT NULL,
	FModificacion DATETIME,
	IsDelete BIT DEFAULT 1
)
GO

INSERT INTO Producto.UnidadMedida(Nombre,Abreviatura,FCreacion, FModificacion, IsDelete)
SELECT c.Name, c.UnitMeasureCode, c.ModifiedDate, c.ModifiedDate, 1
FROM AdventureWorks2019.Production.UnitMeasure AS c
GO

CREATE TABLE Producto.TipoPresentacion(
	TipoPresentacionID INT PRIMARY KEY IDENTITY NOT NULL,
	Nombre NVARCHAR(100) UNIQUE NOT NULL,
	FCreacion DATETIME DEFAULT GETDATE() NOT NULL,
	FModificacion DATETIME,
	IsDelete BIT DEFAULT 1
)
GO

INSERT INTO Producto.TipoPresentacion(Nombre,FCreacion,FModificacion,IsDelete)
VALUES('NO APLICA',GETDATE(),GETDATE(),1)
GO

CREATE TABLE Producto.TipoArticuloInventario(
	TipoArticuloInventarioID INT PRIMARY KEY NOT NULL,
	Nombre NVARCHAR(100) UNIQUE NOT NULL,
	FCreacion DATETIME DEFAULT GETDATE() NOT NULL,
	FModificacion DATETIME,
	IsDelete BIT DEFAULT 1
)
GO

INSERT INTO Producto.TipoArticuloInventario(TipoArticuloInventarioID,Nombre,FCreacion,FModificacion,IsDelete)
VALUES(1,'MATERIA PRIMA',GETDATE(),GETDATE(),1)
INSERT INTO Producto.TipoArticuloInventario(TipoArticuloInventarioID,Nombre,FCreacion,FModificacion,IsDelete)
VALUES(2,'MATERIA PROCESO',GETDATE(),GETDATE(),1)
INSERT INTO Producto.TipoArticuloInventario(TipoArticuloInventarioID,Nombre,FCreacion,FModificacion,IsDelete)
VALUES(3,'PRODUCTO TERMINADO',GETDATE(),GETDATE(),1)
GO

CREATE TABLE Producto.Producto(
	ProductoID INT PRIMARY KEY IDENTITY NOT NULL,
	Nombre NVARCHAR(100) UNIQUE NOT NULL,
	Codigo NVARCHAR(100) UNIQUE NOT NULL,
	NivelStockSeguridad INT,
	PuntoReorden INT, -- Existencia minia en la que se debe realizar un pedido
	StandardCosto DECIMAL(14,4) DEFAULT 0.0,
	StandardPrecio DECIMAL(14,4) DEFAULT 0.0,
	Ancho DECIMAL(14,4) DEFAULT 0.0 NOT NULL,
	Alto DECIMAL(14,4) DEFAULT 0.0 NOT NULL,
	Peso DECIMAL(14,4) DEFAULT 0.0 NOT NULL,
	PesoUnidadMedidaId INT FOREIGN KEY REFERENCES Producto.UnidadMedida(UnidadMedidaId),
	FCreacion DATETIME DEFAULT GETDATE() NOT NULL,
	FModificacion DATETIME,
	IsDelete BIT DEFAULT 1,
	SubCategoriaID INT FOREIGN KEY REFERENCES Producto.SubCategoria(SubCategoriaID),
	ModeloID INT FOREIGN KEY REFERENCES Producto.Modelo(ModeloID),
	TipoArticuloInventarioID INT FOREIGN KEY REFERENCES Producto.TipoArticuloInventario(TipoArticuloInventarioID),
	TipoPresentacionID INT FOREIGN KEY REFERENCES Producto.TipoPresentacion(TipoPresentacionID),
	TipoImpuestoID INT FOREIGN KEY REFERENCES Producto.TipoImpuesto(TipoImpuestoID)
)
GO

SET IDENTITY_INSERT Producto.Producto ON
INSERT INTO Producto.Producto(
	ProductoID,
	Nombre,
	Codigo,
	NivelStockSeguridad,
	PuntoReorden, 
	StandardCosto, 
	StandardPrecio,
	Peso, 
	PesoUnidadMedidaId,
	FCreacion,FModificacion,
	IsDelete,
	SubCategoriaID,
	TipoArticuloInventarioID,
	ModeloID,
	TipoImpuestoID,
	TipoPresentacionID
)
SELECT 
	P.ProductID,P.Name, p.ProductNumber,
	p.SafetyStockLevel,
	p.ReorderPoint,
	p.StandardCost,
	p.ListPrice,
	isnull(p.Weight,0.0),
	pu.UnidadMedidaID,
	getdate(),getdate(),1,
	p.ProductSubcategoryID,
	1,1,1,1
FROM AdventureWorks2019.Production.Product AS P
left join AdventureWorks2019.Production.UnitMeasure as u
on u.UnitMeasureCode = p.WeightUnitMeasureCode
left join Producto.UnidadMedida as pu
on pu.Abreviatura = u.UnitMeasureCode

SET IDENTITY_INSERT Producto.Producto OFF

CREATE TABLE Producto.Color(
	ColorID INT PRIMARY KEY IDENTITY NOT NULL,
	ProductoID INT FOREIGN KEY REFERENCES Producto.Producto(ProductoId),
	TipoColorID INT FOREIGN KEY REFERENCES Producto.TipoColor(TipoColorID),
)
GO

INSERT INTO Producto.Color(ProductoID,TipoColorID)
SELECT 
	p1.ProductID, 
	case when p1.Color = 'Black' then 1
		when p1.Color = 'Blue' then 2
		when p1.Color = 'Grey' then 3
		when p1.Color = 'Multi' then 4
		when p1.Color = 'Red' then 6
		when p1.Color = 'Silver' then 7
		when p1.Color = 'Silver/Black' then 8
		when p1.Color = 'White' then 9
		when p1.Color = 'Yellow' then 10
		else 5 end
FROM AdventureWorks2019.Production.Product AS P1
INNER JOIN Producto.Producto AS P2
ON P2.ProductoID = P1.ProductID
go

CREATE TABLE Producto.CostoHistoriy(
	CostoHistoriID INT PRIMARY KEY IDENTITY NOT NULL,
	StartDate DATETIME NOT NULL,
	EndDate DATETIME,
	StandarCosto DECIMAL(14,4) NOT NULL,
	ProductoID INT FOREIGN KEY REFERENCES Producto.Producto(ProductoID)
)
GO

INSERT INTO Producto.CostoHistoriy(StartDate,EndDate,StandarCosto,ProductoID)
SELECT  c.StartDate, c.EndDate, c.StandardCost, C.ProductID FROM AdventureWorks2019.Production.ProductCostHistory as c
inner join AdventureWorks2019.Production.Product as p
on p.ProductID = c.ProductID
GO

CREATE TABLE Producto.PrecioHistoriy(
	PrecioHistoriID INT PRIMARY KEY IDENTITY NOT NULL,
	StartDate DATETIME NOT NULL,
	EndDate DATETIME,
	StandarPrecio DECIMAL(14,4) NOT NULL,
	ProductoID INT FOREIGN KEY REFERENCES Producto.Producto(ProductoID)
)
GO

INSERT INTO Producto.PrecioHistoriy(StartDate,EndDate,StandarPrecio,ProductoID)
SELECT  c.StartDate, c.EndDate, c.ListPrice, C.ProductID FROM AdventureWorks2019.Production.ProductListPriceHistory as c
inner join AdventureWorks2019.Production.Product as p
on p.ProductID = c.ProductID
go

CREATE TABLE Producto.Detalle(
	DetalleID INT PRIMARY KEY IDENTITY NOT NULL,
	Clave NVARCHAR(50),
	VALOR NVARCHAR(50),
	ProductoID INT FOREIGN KEY REFERENCES Producto.Producto(ProductoID)
)
GO
