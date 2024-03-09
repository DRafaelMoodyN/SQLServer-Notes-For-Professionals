
-- InventoryManagementControl

USE master
GO

-- Validacion y creacion de la bd
IF EXISTS ( SELECT * FROM sys.databases AS s WHERE s.name = 'InventoryManagementControl')
BEGIN
	DROP DATABASE InventoryManagementControl
END
GO

CREATE DATABASE InventoryManagementControl
GO

-- Validacion y creacion del login
IF EXISTS (SELECT * FROM sys.sql_logins AS l WHERE l.name = 'InventoryManagementControl' )
BEGIN
	DROP LOGIN InventoryManagementControl
END

CREATE LOGIN InventoryManagementControl WITH PASSWORD = 'InventoryManagementControl',
DEFAULT_DATABASE = InventoryManagementControl,
CHECK_EXPIRATION = OFF,  CHECK_POLICY = OFF

EXEC sp_addsrvrolemember 'InventoryManagementControl','dbcreator'
GO
 
USE InventoryManagementControl
GO

-- Creacion del usuario
CREATE USER InventoryManagementControl FOR LOGIN InventoryManagementControl
GO

EXEC sp_addrolemember 'db_owner','InventoryManagementControl'
GO


-- Creacion de schemas
CREATE SCHEMA Business
GO

CREATE SCHEMA Person
GO

CREATE SCHEMA HumanResources
GO

CREATE SCHEMA Sales
GO

CREATE SCHEMA Product
GO

CREATE SCHEMA Inventory
GO

CREATE SCHEMA Purcharse
GO

-- Creacion de tablas

-- Persona
CREATE TABLE Person.Person(
	PersonID UNIQUEIDENTIFIER PRIMARY KEY,
	IdentificationCard NVARCHAR(25) UNIQUE NOT NULL,
	FirtName1 NVARCHAR(50) NOT NULL,
    FirtName2 NVARCHAR(50),
    LastName1 NVARCHAR(50) NOT NULL,
    LastName2 NVARCHAR(50)
)
GO

CREATE TABLE Business.ContactNumberType(
	ContactNumberTypeID UNIQUEIDENTIFIER PRIMARY KEY,
	ContactName NVARCHAR(50) NOT NULL,
	IsDelete BIT DEFAULT 1 NOT NULL
)
GO

CREATE TABLE Business.ContactEmailType(
	ContactEmailTypeID UNIQUEIDENTIFIER PRIMARY KEY,
	ContactName NVARCHAR(50) NOT NULL,
	IsDelete BIT DEFAULT 1 NOT NULL
)
GO

CREATE Table Business.Business(
	BusinessId UNIQUEIDENTIFIER PRIMARY KEY,
	BusinessName NVARCHAR(50) UNIQUE NOT NULL,
	NumeroRuc NVARCHAR(50) UNIQUE NOT NULL,
	Direccion NVARCHAR(50) NOT NULL,
	DateCreation DATE DEFAULT GETDATE(),
	IsDelete BIT DEFAULT 1 NOT NULL,
	PersonID UNIQUEIDENTIFIER UNIQUE FOREIGN KEY REFERENCES Person.Person(PersonID)
)
GO

CREATE TABLE Business.BusinessContactNumber(
	BusinessContactNumberID UNIQUEIDENTIFIER PRIMARY KEY,
	ConctacNumber NVARCHAR(10) NOT NULL,
	IsDelete BIT DEFAULT 1 NOT NULL,
	BusinessId UNIQUEIDENTIFIER UNIQUE FOREIGN KEY REFERENCES Business.Business(BusinessId),
	ContactNumberTypeID UNIQUEIDENTIFIER FOREIGN KEY REFERENCES Business.ContactNumberType(ContactNumberTypeID)
)
GO

CREATE TABLE Business.BusinessContactEmail(
	BusinessContactEmailID UNIQUEIDENTIFIER PRIMARY KEY,
	ContactEmail NVARCHAR(50) UNIQUE NOT NULL,
	IsDelete BIT DEFAULT 1 NOT NULL,
	BusinessId UNIQUEIDENTIFIER UNIQUE FOREIGN KEY REFERENCES Business.Business(BusinessId),
	ContactEmailTypeID UNIQUEIDENTIFIER FOREIGN KEY REFERENCES Business.ContactEmailType(ContactEmailTypeID)
)
GO

CREATE TABLE Product.Brand(
    BrandID UNIQUEIDENTIFIER PRIMARY KEY,
    BrandDescription NVARCHAR(50) UNIQUE NOT NULL,
	IsDelete BIT DEFAULT 1 NOT NULL
)
GO

CREATE TABLE Product.Model
(
    ModelID UNIQUEIDENTIFIER PRIMARY KEY,
    ModelDescription NVARCHAR(50) NOT NULL,
	IsDelete BIT DEFAULT 1 NOT NULL,
    BrandID UNIQUEIDENTIFIER FOREIGN KEY REFERENCES Product.Brand (BrandID)
)
GO

-- Podemos agregar un table catalogo para los Level
CREATE TABLE Product.Category
(
    CategoryID UNIQUEIDENTIFIER PRIMARY KEY,
	CategoryCode INT UNIQUE NOT NULL,
    CategoryDecription NVARCHAR(50) UNIQUE NOT NULL,
	CategorySubCode INT,
	CategoryLevel INT NOT NULL,
	IsDelete BIT DEFAULT 1 NOT NULL
)
GO

-- Unidad de medida
CREATE TABLE Product.UnitMeasure
(
    UnitMeasureID UNIQUEIDENTIFIER PRIMARY KEY,
    UnitMeasureDescription NVARCHAR(50) NOT NULL,
    UnitMeasureAbreviature NVARCHAR(12) NOT NULL,
	QuantityUnit INT NOT NULL,
	IsDelete BIT DEFAULT 1 NOT NULL
)
GO

-- Product
CREATE TABLE Product.ProductBase
(
    ProductBaseID UNIQUEIDENTIFIER PRIMARY KEY,
    CodeProductBase NVARCHAR(35) NOT NULL,
    ProductBaseDescription NVARCHAR(250) NOT NULL,
    DateCreation DATETIME DEFAULT GETDATE() NOT NULL,
	ProductImage VARBINARY(MAX) NULL,
	IsDelete BIT DEFAULT 1 NOT NULL,
	CostoUnit DECIMAL(20,4) NOT NULL,
	PriceUnit DECIMAL(20,4) NOT NULL,
	Medida NVARCHAR(30) NULL,
    UnitMeasureID UNIQUEIDENTIFIER FOREIGN KEY REFERENCES Product.UnitMeasure(UnitMeasureID),
    CategoryID UNIQUEIDENTIFIER FOREIGN KEY REFERENCES Product.Category (CategoryID),
	ModelID UNIQUEIDENTIFIER FOREIGN KEY REFERENCES Product.Model(ModelID)
)
GO

-- Estado Factura: Comprar, Coticacion, Devolucion
CREATE TABLE Sales.TypeSalesHeader(
	TypeSalesHeaderID UNIQUEIDENTIFIER PRIMARY KEY,
	TypeSales NVARCHAR(50) UNIQUE NOT NULL,
	IsDelete BIT DEFAULT 1 NOT NULL
)
GO


CREATE TABLE Sales.SalesHeader(
	SalesHaderID INT PRIMARY KEY,
	SalesDescription NVARCHAR(100) NOT NULL,
	CreateDate DATETIME DEFAULT GETDATE() NOT NULL,
	IsDelete BIT DEFAULT 1 NOT NULL,
	TypeSalesHeaderID UNIQUEIDENTIFIER FOREIGN KEY REFERENCES Sales.TypeSalesHeader(TypeSalesHeaderID),
)
GO

CREATE TABLE Sales.SalesHeaderDetails(
	SalesHeaderDetailsID UNIQUEIDENTIFIER PRIMARY KEY,
	SalesDescription NVARCHAR(100) NOT NULL,
	CostoUnit DECIMAL(20,4) NOT NULL,
	PriceUnit DECIMAL(20,4) NOT NULL,
	Quantity INT NOT NULL,
	IsDelete BIT DEFAULT 1 NOT NULL,
	ProductBaseID UNIQUEIDENTIFIER FOREIGN KEY REFERENCES  Product.ProductBase(ProductBaseID),
	SalesHaderID INT FOREIGN KEY REFERENCES Sales.SalesHeader(SalesHaderID)
)
GO

-- Estado Factura: Comprar, Devolucion, Cancelada
CREATE TABLE Purcharse.TypIngresoHeader(
	TypIngresoHeaderID UNIQUEIDENTIFIER PRIMARY KEY,
	TypeOrder NVARCHAR(50) UNIQUE NOT NULL,
	IsDelete BIT DEFAULT 1 NOT NULL
)
GO

CREATE TABLE Purcharse.OrderHeader(
	OrderHeaderID INT PRIMARY KEY,
	CreateDate DATETIME DEFAULT GETDATE() NOT NULL,
	IsDelete BIT DEFAULT 1 NOT NULL,
	TypIngresoHeaderID UNIQUEIDENTIFIER FOREIGN KEY REFERENCES Purcharse.TypIngresoHeader(TypIngresoHeaderID)
)
GO

CREATE TABLE Purcharse.OrderHeaderDetails(
	OrderHeaderDetailsID UNIQUEIDENTIFIER PRIMARY KEY,
	SalesDescription NVARCHAR(100) NOT NULL,
	CostoUnit DECIMAL(20,4) NOT NULL,
	PriceUnit DECIMAL(20,4) NOT NULL,
	Quantity INT NOT NULL,
	IsDelete BIT DEFAULT 1 NOT NULL,
	ProductBaseID UNIQUEIDENTIFIER FOREIGN KEY REFERENCES  Product.ProductBase(ProductBaseID),
	OrderHeaderID  INT  FOREIGN KEY REFERENCES Purcharse.OrderHeader(OrderHeaderID)
)
GO

-- Proc

CREATE OR ALTER PROC US_Business_Create(
	@IdentificationCard NVARCHAR(25),
	@FirtName1 NVARCHAR(50),
    @FirtName2 NVARCHAR(50),
    @LastName1 NVARCHAR(50),
    @LastName2 NVARCHAR(50),
	@BusinessName NVARCHAR(50),
	@NumeroRuc NVARCHAR(50),
	@Direccion NVARCHAR(50),
	@ContactNumberTypeID UNIQUEIDENTIFIER,
	@ConctacNumber NVARCHAR(10),
	@ContactEmailTypeID UNIQUEIDENTIFIER,
	@ConctatEmail NVARCHAR(50)
) AS
BEGIN

BEGIN TRANSACTION
	BEGIN TRY
		DECLARE @PersonID UNIQUEIDENTIFIER = NEWID()
		DECLARE @BusinessID UNIQUEIDENTIFIER = NEWID()

		INSERT INTO Person.Person(
			PersonID,
			IdentificationCard,
			FirtName1,
			FirtName2,
			LastName1,
			LastName2
		) VALUES(
			@PersonID,
			@IdentificationCard,
			@FirtName1,
			@FirtName2,
			@LastName1,
			@LastName2
		)

		INSERT INTO Business.Business(
			BusinessId,
			BusinessName,
			NumeroRuc,
			Direccion,
			PersonID
		) VALUES(
			@BusinessID,
			@BusinessName,
			@NumeroRuc,
			@Direccion,
			@PersonID)

		INSERT INTO Business.BusinessContactNumber(
			BusinessContactNumberID,
			ConctacNumber,
			BusinessId,
			ContactNumberTypeID
		) VALUES(
			NEWID(),
			@ConctacNumber,
			@BusinessID,
			@ContactNumberTypeID
		)

		INSERT INTO Business.BusinessContactEmail(
			BusinessContactEmailID,
			ContactEmail,
			BusinessId,
			ContactEmailTypeID
		) VALUES(
			NEWID(),
			@ConctatEmail,
			@BusinessID,
			@ContactEmailTypeID
		)

		COMMIT TRANSACTION
		PRINT 'Business create correct'
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		PRINT 'Business create error'
	END CATCH
END
GO

-- Cts
CREATE OR ALTER PROC Us_Category_CTS
AS
BEGIN
WITH cts AS(
	SELECT 
		c1.CategoryID, c1.CategoryCode, c1.CategoryDecription,
		c1.CategorySubCode, c1.CategoryLevel, c1.IsDelete,
		Ruta = CAST(c1.CategoryLevel AS VARCHAR(8000)),
		RutaOrder = CAST(c1.CategoryCode AS VARBINARY(MAX))
	FROM Product.Category AS c1
	WHERE c1.CategoryLevel = 1 
		UNION ALL
	SELECT 
		c2.CategoryID, c2.CategoryCode, c2.CategoryDecription,
		c2.CategorySubCode, c2.CategoryLevel, c2.IsDelete,
		ruta = ct.Ruta +'.'+ CAST(c2.CategoryLevel AS VARCHAR(8000)),
		rutaOrder = ct.RutaOrder + CAST(c2.CategoryCode AS VARBINARY(MAX))
	FROM Product.Category AS c2
		INNER JOIN cts AS ct
		ON c2.CategorySubCode = ct.CategoryCode
) 
SELECT 
	cts.CategoryID, cts.CategoryCode, cts.CategoryDecription, cts.CategorySubCode,
	cts.CategoryLevel, cts.Ruta AS Level
FROM cts 
WHERE cts.IsDelete = 1
ORDER BY RutaOrder
END
GO

CREATE OR ALTER PROC Us_SubCategoryId(
	@CategoryCode INT
)
AS
BEGIN
WITH cts AS(
	SELECT 
		c1.CategoryID, c1.CategoryCode, c1.CategoryDecription,
		c1.CategorySubCode, c1.CategoryLevel, c1.IsDelete,
		Ruta = CAST(c1.CategoryLevel AS VARCHAR(8000)),
		RutaOrder = CAST(c1.CategoryCode AS VARBINARY(MAX))
	FROM Product.Category AS c1
	WHERE c1.CategoryLevel = 1 AND c1.CategoryCode = @CategoryCode
		UNION ALL
	SELECT 
		c2.CategoryID, c2.CategoryCode, c2.CategoryDecription,
		c2.CategorySubCode, c2.CategoryLevel, c2.IsDelete,
		ruta = ct.Ruta +'.'+ CAST(c2.CategoryLevel AS VARCHAR(8000)),
		rutaOrder = ct.RutaOrder + CAST(c2.CategoryCode AS VARBINARY(MAX))
	FROM Product.Category AS c2
		INNER JOIN cts AS ct
		ON c2.CategorySubCode = ct.CategoryCode
) 
SELECT 
	cts.CategoryID, cts.CategoryCode, cts.CategoryDecription, cts.CategorySubCode,
	cts.CategoryLevel, cts.Ruta AS Level
FROM cts 
WHERE cts.IsDelete = 1
ORDER BY RutaOrder
END
GO

-- Catalogos de telefonos

INSERT INTO Business.ContactNumberType(ContactNumberTypeID,ContactName)
VALUES('5E8926F2-DBE1-47AC-A4AA-E41B1E320050','Claro')

INSERT INTO Business.ContactNumberType(ContactNumberTypeID,ContactName)
VALUES('51A3E836-BAA2-4542-90D6-8BECE0D92CE7','Tigo')

-- Catalogos de correos

INSERT INTO Business.ContactEmailType(ContactEmailTypeID,ContactName)
VALUES('D813D73E-75E0-4FBE-8C50-494CDB70149F','Email')

INSERT INTO Business.ContactEmailType(ContactEmailTypeID,ContactName)
VALUES('72349C5A-6323-4062-ACB5-48E6FE6CD0BC','Outlook')

GO

EXEC US_Business_Create 
	'001-230580-0002Q',
	'Flor',
	'',
	'Lanuza',
	'',
	'TIENDA DE MODA',
	'RucNotengo22',
	'Ciudad Jardin Del POWER 0.99 1/2c SUR.',
	'5E8926F2-DBE1-47AC-A4AA-E41B1E320050',
	'7661-094432',
	'D813D73E-75E0-4FBE-8C50-494CDB70149F',
	'business@gmail.com'
GO

-- UnitMeasured

INSERT INTO Product.UnitMeasure(UnitMeasureID,UnitMeasureDescription,UnitMeasureAbreviature,QuantityUnit)
VALUES('E239A9D0-3F81-4BFB-A0CC-88A5C1E081F6','Caja','Pies',1)

-- Categorias y sub categorias

INSERT INTO Product.Category(CategoryID,CategoryCode,CategoryDecription,CategorySubCode,CategoryLevel)
VALUES('0F924C1F-3EF5-4F0F-8F03-8D63D0A7C706',1,'Electrodomesticos',NULL,1)
GO

INSERT INTO Product.Category(CategoryID,CategoryCode,CategoryDecription,CategorySubCode,CategoryLevel)
VALUES('64FFC112-C1BC-4767-9092-A6C3963FB890',2,'Zapato',NULL,1)
GO

INSERT INTO Product.Category(CategoryID,CategoryCode,CategoryDecription,CategorySubCode,CategoryLevel)
VALUES('03DDB86A-09DE-4355-8E45-195831604DB3',3,'Baul',NULL,1)
GO

INSERT INTO Product.Category(CategoryID,CategoryCode,CategoryDecription,CategorySubCode,CategoryLevel)
VALUES('AD40DC4E-A436-4897-8F7E-45A40C14F16E',4,'Cartera',NULL,1)
GO

INSERT INTO Product.Category(CategoryID,CategoryCode,CategoryDecription,CategorySubCode,CategoryLevel)
VALUES('90830D3A-FAC0-4BF3-B4B4-FC78088AE492',5,'Bolso',NULL,1)
GO

INSERT INTO Product.Category(CategoryID,CategoryCode,CategoryDecription,CategorySubCode,CategoryLevel)
VALUES('C647ED05-DF46-4C3E-8700-A37AB17D25FD',6,'Canguro',NULL,1)
GO

INSERT INTO Product.Category(CategoryID,CategoryCode,CategoryDecription,CategorySubCode,CategoryLevel)
VALUES('84727903-C56C-4F2C-ACFB-02AECB921265',7,'Muchila',NULL,1)
GO

INSERT INTO Product.Category(CategoryID,CategoryCode,CategoryDecription,CategorySubCode,CategoryLevel)
VALUES('CE4B3E08-59BF-40B3-A736-247B2C12F68F',8,'Reloj',NULL,1)
GO

INSERT INTO Product.Category(CategoryID,CategoryCode,CategoryDecription,CategorySubCode,CategoryLevel)
VALUES('ED6A4376-DE6B-4B58-AE8D-A6608D9732A4',9,'Botas',NULL,1)
GO

INSERT INTO Product.Category(CategoryID,CategoryCode,CategoryDecription,CategorySubCode,CategoryLevel)
VALUES('AE13123D-082D-4B37-BF9E-4761DE9BA851',10,'Sandalias',NULL,1)
GO

-- Marcas

INSERT INTO Product.Brand(BrandID,BrandDescription)
VALUES('7D975610-F3E8-49DC-BD51-FD471BB143A9','Fila')
GO

INSERT INTO Product.Brand(BrandID,BrandDescription)
VALUES('E0DD87B4-F2CE-4A2B-9E66-3918845CD10F','Jordan')
GO

INSERT INTO Product.Brand(BrandID,BrandDescription)
VALUES('4024DAFD-EE86-4716-B294-819E2AF3E356','Adidas')
GO

INSERT INTO Product.Brand(BrandID,BrandDescription)
VALUES('5CE4DCB5-A34D-4DEF-A062-FA5B098D0071','Nike')
GO

INSERT INTO Product.Brand(BrandID,BrandDescription)
VALUES('DE9C38BC-C52E-44BC-9616-28A483A10B11','Mochila Vans')
GO

INSERT INTO Product.Brand(BrandID,BrandDescription)
VALUES('2C11AF1B-3DD0-44F4-8A87-83010F98A9C0','HERSCHEL')
GO

INSERT INTO Product.Brand(BrandID,BrandDescription)
VALUES('BB46BD62-FFD0-43D2-8046-1DCDBE8E915F','Caterpillar')
GO

INSERT INTO Product.Brand(BrandID,BrandDescription)
VALUES('0815B3DA-6911-4EC9-92A6-8BFB4D12BCA6','Larnmern')
GO

INSERT INTO Product.Brand(BrandID,BrandDescription)
VALUES('ADF33122-089F-428C-A5D2-111D3504DEEA','Mango')
GO

INSERT INTO Product.Brand(BrandID,BrandDescription)
VALUES('2EBEA9F0-D23F-42BD-BB7B-44ED9A8DBEC5','Camper')
GO 

-- Modelo
INSERT INTO Product.Model(ModelID,ModelDescription,BrandID)
VALUES('662C5E1E-2509-4F64-B91B-4CD1B33068E3','AF1','5CE4DCB5-A34D-4DEF-A062-FA5B098D0071')


-- Producto

INSERT INTO Product.ProductBase
(ProductBaseID,CodeProductBase,ProductBaseDescription,CostoUnit,PriceUnit,Medida,UnitMeasureID,CategoryID,ModelID)
VALUES('DE03A9A6-DECC-4641-8ADA-F4631BE8CE90','NAF1M650C2','Mickye',500,600,'40','E239A9D0-3F81-4BFB-A0CC-88A5C1E081F6','64FFC112-C1BC-4767-9092-A6C3963FB890','662C5E1E-2509-4F64-B91B-4CD1B33068E3')

INSERT INTO Product.ProductBase
(ProductBaseID,CodeProductBase,ProductBaseDescription,CostoUnit,PriceUnit,Medida,UnitMeasureID,CategoryID,ModelID)
VALUES('28EB5254-9152-4BD5-9109-DCEB65EFA457','NAF1R690C2','Rosado',600,700,'40','E239A9D0-3F81-4BFB-A0CC-88A5C1E081F6','64FFC112-C1BC-4767-9092-A6C3963FB890','662C5E1E-2509-4F64-B91B-4CD1B33068E3')

INSERT INTO Product.ProductBase
(ProductBaseID,CodeProductBase,ProductBaseDescription,CostoUnit,PriceUnit,Medida,UnitMeasureID,CategoryID,ModelID)
VALUES('A776AC11-06F6-4D88-94C2-A8F631118157','NAF1N400BT','Niño',400,500,'20','E239A9D0-3F81-4BFB-A0CC-88A5C1E081F6','64FFC112-C1BC-4767-9092-A6C3963FB890','662C5E1E-2509-4F64-B91B-4CD1B33068E3')

INSERT INTO Product.ProductBase
(ProductBaseID,CodeProductBase,ProductBaseDescription,CostoUnit,PriceUnit,Medida,UnitMeasureID,CategoryID,ModelID)
VALUES('B59315DE-35DA-47FF-B83E-DC0C87763368','NAF1L800C2','Levi',450,680,'35','E239A9D0-3F81-4BFB-A0CC-88A5C1E081F6','64FFC112-C1BC-4767-9092-A6C3963FB890','662C5E1E-2509-4F64-B91B-4CD1B33068E3')

INSERT INTO Product.ProductBase
(ProductBaseID,CodeProductBase,ProductBaseDescription,CostoUnit,PriceUnit,Medida,UnitMeasureID,CategoryID,ModelID)
VALUES('0F674A6B-22C2-423B-A131-41F0D63A0EDB','NAF1B600C2','Botin Candy',450,980,'44','E239A9D0-3F81-4BFB-A0CC-88A5C1E081F6','64FFC112-C1BC-4767-9092-A6C3963FB890','662C5E1E-2509-4F64-B91B-4CD1B33068E3')

INSERT INTO Product.ProductBase
(ProductBaseID,CodeProductBase,ProductBaseDescription,CostoUnit,PriceUnit,Medida,UnitMeasureID,CategoryID,ModelID)
VALUES('783088B8-68F4-4AFF-822F-052251B1080F','NAF1HGG700C2','HGG',500,980,'33','E239A9D0-3F81-4BFB-A0CC-88A5C1E081F6','64FFC112-C1BC-4767-9092-A6C3963FB890','662C5E1E-2509-4F64-B91B-4CD1B33068E3')

INSERT INTO Product.ProductBase
(ProductBaseID,CodeProductBase,ProductBaseDescription,CostoUnit,PriceUnit,Medida,UnitMeasureID,CategoryID,ModelID)
VALUES('ECE0CBFD-B35A-46F0-B906-B1E378079B92','NAF1B600C3','Blanco',500,890,'33','E239A9D0-3F81-4BFB-A0CC-88A5C1E081F6','64FFC112-C1BC-4767-9092-A6C3963FB890','662C5E1E-2509-4F64-B91B-4CD1B33068E3')

INSERT INTO Product.ProductBase
(ProductBaseID,CodeProductBase,ProductBaseDescription,CostoUnit,PriceUnit,Medida,UnitMeasureID,CategoryID,ModelID)
VALUES('F872739E-9B43-4707-BD14-811CD441D700','NAF1B600C3','Premiun',500,890,'33','E239A9D0-3F81-4BFB-A0CC-88A5C1E081F6','64FFC112-C1BC-4767-9092-A6C3963FB890','662C5E1E-2509-4F64-B91B-4CD1B33068E3')

-- Tipo de factura

INSERT INTO Sales.TypeSalesHeader(TypeSalesHeaderID,TypeSales)
VALUES('FFABFEC4-5B46-44C2-BE36-42CA6CFE9499','Venta')

INSERT INTO Sales.TypeSalesHeader(TypeSalesHeaderID,TypeSales)
VALUES('5A9623A4-200E-4383-94D4-75BFFDC9736B','Cotizacion')

INSERT INTO Sales.TypeSalesHeader(TypeSalesHeaderID,TypeSales)
VALUES('1626D860-6270-4473-9953-00EE939A5632','Devolucion')

INSERT INTO Purcharse.TypIngresoHeader(TypIngresoHeaderID,TypeOrder)
VALUES('AAD9E9C1-FA24-4619-9261-43859916AB91','Compra')

INSERT INTO Purcharse.TypIngresoHeader(TypIngresoHeaderID,TypeOrder)
VALUES('9CF6A43B-33A8-4192-9802-BC77028F36C2','Devolucion')

INSERT INTO Purcharse.TypIngresoHeader(TypIngresoHeaderID,TypeOrder)
VALUES('260AFBA3-E712-4B5F-9182-8DAD4C783A92','Cancelada')
GO


CREATE OR ALTER PROC Us_Stock_Fisico
AS
BEGIN
SELECT p.ProductBaseID, b.BrandDescription, m.ModelDescription, c.CategoryDecription, p.CodeProductBase, p.ProductBaseDescription,
	   um.UnitMeasureAbreviature, p.Medida, p.CostoUnit, p.PriceUnit,
( CASE 
	WHEN t1.TotalIngreso IS NULL
		THEN 0
		ELSE t1.TotalIngreso
		END
	) TotalIngreso,
( CASE 
	WHEN t2.TotalVentas IS NULL
		THEN 0
		ELSE t2.TotalVentas
		END
	) TotalVentas,
(CASE 
	WHEN t1.TotalIngreso IS NULL
		THEN 0
	WHEN t1.TotalIngreso >= t2.TotalVentas AND t2.TotalVentas IS NOT NULL
		THEN t1.TotalIngreso - t2.TotalVentas
	ELSE t1.TotalIngreso
	END
) Stock
FROM  
Product.Brand AS b
INNER JOIN Product.Model AS m
ON b.BrandID = m.BrandID
INNER JOIN Product.ProductBase AS p
INNER JOIN Product.Category AS c
ON c.CategoryID = p.CategoryID
ON m.ModelID = p.ModelID
INNER JOIN Product.UnitMeasure AS um
ON um.UnitMeasureID = p.UnitMeasureID
LEFT JOIN 
(SELECT ohd.ProductBaseID, SUM(ohd.Quantity) TotalIngreso
FROM Purcharse.TypIngresoHeader AS tih
LEFT JOIN  Purcharse.OrderHeader AS oh
ON tih.TypIngresoHeaderID = oh.TypIngresoHeaderID
INNER JOIN Purcharse.OrderHeaderDetails AS ohd
ON oh.OrderHeaderID = ohd.OrderHeaderID
WHERE tih.TypeOrder = 'Compra' AND  oh.IsDelete = 1 AND ohd.IsDelete = 1
GROUP BY ohd.ProductBaseID) AS t1
ON p.ProductBaseID = t1.ProductBaseID
LEFT JOIN 
(SELECT shd.ProductBaseID , SUM(shd.Quantity) TotalVentas
FROM Sales.TypeSalesHeader AS tsh 
INNER JOIN Sales.SalesHeader AS sh
ON tsh.TypeSalesHeaderID = sh.TypeSalesHeaderID
INNER JOIN Sales.SalesHeaderDetails AS shd
ON sh.SalesHaderID = shd.SalesHaderID
WHERE tsh.TypeSales = 'Venta' AND sh.IsDelete = 1 AND shd.IsDelete = 1
GROUP BY shd.ProductBaseID) AS t2
ON t1.ProductBaseID = t2.ProductBaseID
WHERE p.IsDelete = 1
END


EXEC Us_Stock_Fisico


CREATE OR ALTER VIEW StockFisico
AS
SELECT p.ProductBaseID, b.BrandDescription, m.ModelDescription, c.CategoryDecription, p.CodeProductBase, p.ProductBaseDescription,
	   um.UnitMeasureAbreviature, p.Medida,
( CASE 
	WHEN t1.TotalIngreso IS NULL
		THEN 0
		ELSE t1.TotalIngreso
		END
	) TotalIngreso,
( CASE 
	WHEN t2.TotalVentas IS NULL
		THEN 0
		ELSE t2.TotalVentas
		END
	) TotalVentas,
(CASE 
	WHEN t1.TotalIngreso IS NULL
		THEN 0
	WHEN t1.TotalIngreso >= t2.TotalVentas AND t2.TotalVentas IS NOT NULL
		THEN t1.TotalIngreso - t2.TotalVentas
	ELSE t1.TotalIngreso
	END
) Stock
FROM  
Product.Brand AS b
INNER JOIN Product.Model AS m
ON b.BrandID = m.BrandID
INNER JOIN Product.ProductBase AS p
INNER JOIN Product.Category AS c
ON c.CategoryID = p.CategoryID
ON m.ModelID = p.ModelID
INNER JOIN Product.UnitMeasure AS um
ON um.UnitMeasureID = p.UnitMeasureID
LEFT JOIN 
(SELECT ohd.ProductBaseID, SUM(ohd.Quantity) TotalIngreso
FROM Purcharse.TypIngresoHeader AS tih
LEFT JOIN  Purcharse.OrderHeader AS oh
ON tih.TypIngresoHeaderID = oh.TypIngresoHeaderID
INNER JOIN Purcharse.OrderHeaderDetails AS ohd
ON oh.OrderHeaderID = ohd.OrderHeaderID
WHERE tih.TypeOrder = 'Compra' AND  oh.IsDelete = 1 AND ohd.IsDelete = 1
GROUP BY ohd.ProductBaseID) AS t1
ON p.ProductBaseID = t1.ProductBaseID
LEFT JOIN 
(SELECT shd.ProductBaseID , SUM(shd.Quantity) TotalVentas
FROM Sales.TypeSalesHeader AS tsh 
INNER JOIN Sales.SalesHeader AS sh
ON tsh.TypeSalesHeaderID = sh.TypeSalesHeaderID
INNER JOIN Sales.SalesHeaderDetails AS shd
ON sh.SalesHaderID = shd.SalesHaderID
WHERE tsh.TypeSales = 'Venta' AND sh.IsDelete = 1 AND shd.IsDelete = 1
GROUP BY shd.ProductBaseID) AS t2
ON t1.ProductBaseID = t2.ProductBaseID
WHERE p.IsDelete = 1 
GO

SELECT * FROM Sales.SalesHeader

SELECT * FROM StockFisico

SELECT * FROM Sales.SalesHeaderDetails










