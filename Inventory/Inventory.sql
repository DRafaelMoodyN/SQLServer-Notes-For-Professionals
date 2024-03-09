USE master
GO

IF EXISTS (SELECT s.name FROM sys.databases s WHERE s.name = 'InventoryQuery')
BEGIN
	DROP DATABASE InventoryQuery
END
GO

CREATE DATABASE InventoryQuery
GO

USE InventoryQuery
GO

CREATE TABLE Product(
	ProductID INT IDENTITY PRIMARY KEY,
	Descripcion NVARCHAR(100) UNIQUE NOT NULL
)

CREATE TABLE HeaderEntrada(
	HeaderEntradaID INT IDENTITY PRIMARY KEY,
	Lote NVARCHAR(50),
	EstadoID INT NOT NULL,
	IsCanceled BIT NOT NULL
)

CREATE TABLE HeaderSalida(
	HeaderSalidaID INT IDENTITY PRIMARY KEY,
	EstadoID INT NOT NULL,
	Lote NVARCHAR(50),
	IsCanceled BIT NOT NULL
)

CREATE TABLE EntradaDetalle(
	EntradaDetalleID INT IDENTITY PRIMARY KEY,
	Cantidad INT NOT NULL,
	EstatusMercado NVARCHAR(50) NOT NULL,
	HeaderEntradaID INT FOREIGN KEY REFERENCES HeaderEntrada(HeaderEntradaID),
	ProductID INT FOREIGN KEY REFERENCES Product(ProductID)
)

CREATE TABLE Inventory(
	InventoryID INT IDENTITY PRIMARY KEY,
	Cantidad INT NOT NULL,
	Lote NVARCHAR(50) NOT NULL,
	EstatusMercado NVARCHAR(50) NOT NULL,
	ProductID INT FOREIGN KEY REFERENCES Product(ProductID),
	EntradaDetalleID INT FOREIGN KEY REFERENCES EntradaDetalle(EntradaDetalleID)
)

CREATE TABLE SalidaDetalle(
	EntradaSalidaID INT IDENTITY PRIMARY KEY,
	Cantidad INT NOT NULL,
	EstatusMercado NVARCHAR(50) NOT NULL,
	InventoryID INT FOREIGN KEY REFERENCES Inventory(InventoryID),
	ProductID INT FOREIGN KEY REFERENCES Product(ProductID),
	HeaderSalidaID INT FOREIGN KEY REFERENCES HeaderSalida(HeaderSalidaID)
)


INSERT INTO Product(Descripcion)
VALUES
('Producto 1'),
('Producto 2'),
('Producto 3'),
('Producto 4'),
('Producto 5')
GO

INSERT INTO HeaderEntrada(Lote,EstadoID,IsCanceled)
VALUES
('0001',1,0),
('0002',1,0),
('0003',1,0),
('0004',1,0),
('0005',1,0)


INSERT INTO EntradaDetalle(Cantidad,EstatusMercado,HeaderEntradaID,ProductID)
VALUES
(25,'B',1,1),
(20,'M',1,2),
(20,'M',1,3),
(30,'B',1,3)

INSERT INTO EntradaDetalle(Cantidad,EstatusMercado,HeaderEntradaID,ProductID)
VALUES
(20,'B',2,1),
(50,'M',2,5),
(60,'M',2,4),
(80,'B',2,3)


-- Finalizar Entrada

INSERT INTO Inventory(Cantidad,Lote,EstatusMercado,EntradaDetalleID, ProductID)
SELECT
	ed.Cantidad, he.Lote, ed.EstatusMercado, ed.EntradaDetalleID, ed.ProductID
FROM HeaderEntrada AS he
	INNER JOIN EntradaDetalle AS ed
		ON he.HeaderEntradaID = ed.HeaderEntradaID
WHERE he.HeaderEntradaID  IN (1,2) AND ed.EntradaDetalleID NOT IN (
					SELECT ed.EntradaDetalleID FROM EntradaDetalle AS ed
						INNER JOIN Inventory AS i
							ON i.EntradaDetalleID = ed.EntradaDetalleID
)
GO


-- Anular Entrada
DECLARE @List_DetalleEntrada NVARCHAR(MAX);

SELECT
	@List_DetalleEntrada = STRING_AGG(ed.EntradaDetalleID,',')
FROM HeaderEntrada AS he
	INNER JOIN EntradaDetalle AS ed
		ON he.HeaderEntradaID = ed.HeaderEntradaID
WHERE he.Lote  IN('0001','0002')


UPDATE Inventory SET Cantidad -= d.Cantidad
FROM Inventory AS i
	INNER JOIN EntradaDetalle AS d
		ON i.EntradaDetalleID = d.EntradaDetalleID
WHERE i.EntradaDetalleID IN
						(
							SELECT CONVERT(INT, VALUE) 
							FROM STRING_SPLIT(@List_DetalleEntrada,',')
						) AND i.Cantidad > 0
GO

-- Habilitar Entrada
DECLARE @List_DetalleEntrada NVARCHAR(MAX);

SELECT
	@List_DetalleEntrada = STRING_AGG(ed.EntradaDetalleID,',')
FROM HeaderEntrada AS he
	INNER JOIN EntradaDetalle AS ed
		ON he.HeaderEntradaID = ed.HeaderEntradaID
WHERE he.Lote IN('0001','0002')


UPDATE Inventory SET Cantidad += d.Cantidad
FROM Inventory AS i
	INNER JOIN EntradaDetalle AS d
		ON i.EntradaDetalleID = d.EntradaDetalleID
WHERE i.EntradaDetalleID IN
						(
							SELECT CONVERT(INT, VALUE) 
							FROM STRING_SPLIT(@List_DetalleEntrada,',')
						)
GO

SELECT 
	i.Lote, 
	p.ProductID, p.Descripcion,
	i.EstatusMercado,
	SUM(i.Cantidad) Cantidad
FROM Inventory AS i
	INNER JOIN Product AS p
		ON p.ProductID = i.ProductID
GROUP BY 
	i.Lote, i.EstatusMercado, p.ProductID, p.Descripcion
HAVING SUM(i.Cantidad) > 0


INSERT INTO HeaderSalida(EstadoID,Lote,IsCanceled)
VALUES(1,'NIC-0001',0)
GO

INSERT INTO SalidaDetalle(Cantidad,EstatusMercado,ProductID,HeaderSalidaID,InventoryID)
VALUES
(6,'B',1,1,1),
(10,'B',3,1,2)
GO

INSERT INTO HeaderSalida(EstadoID,Lote,IsCanceled)
VALUES(1,'NIC-0002',0)
GO

INSERT INTO SalidaDetalle(Cantidad,EstatusMercado,ProductID,HeaderSalidaID,InventoryID)
VALUES
(2,'B',1,2,1),
(6,'B',3,2,2)
GO

INSERT INTO HeaderSalida(EstadoID,Lote,IsCanceled)
VALUES(1,'NIC-0003',0)
GO

INSERT INTO SalidaDetalle(Cantidad,EstatusMercado,ProductID,HeaderSalidaID,InventoryID)
VALUES
(10,'B',1,3,1),
(3,'B',3,3,2)
GO

-- Finalizar Salida
DECLARE @List_DetalleSalida NVARCHAR(MAX);

SELECT
	@List_DetalleSalida = STRING_AGG(ed.EntradaSalidaID,',')
FROM HeaderSalida AS he
	INNER JOIN SalidaDetalle AS ed
		ON he.HeaderSalidaID = ed.HeaderSalidaID
WHERE he.Lote = 'NIC-0003'


UPDATE Inventory SET Cantidad -= d.Cantidad
FROM Inventory AS i
	INNER JOIN SalidaDetalle AS d
		ON i.InventoryID = d.InventoryID
WHERE d.EntradaSalidaID IN
						(
							SELECT CONVERT(INT, VALUE) 
							FROM STRING_SPLIT(@List_DetalleSalida,',')
						) 
GO

-- Aular Salida
DECLARE @List_DetalleSalida NVARCHAR(MAX);

SELECT
	@List_DetalleSalida = STRING_AGG(ed.EntradaSalidaID,',')
FROM HeaderSalida AS he
	INNER JOIN SalidaDetalle AS ed
		ON he.HeaderSalidaID = ed.HeaderSalidaID
WHERE he.Lote = 'NIC-0003'

UPDATE Inventory SET Cantidad += d.Cantidad
FROM Inventory AS i
	INNER JOIN SalidaDetalle AS d
		ON i.InventoryID = d.InventoryID
WHERE d.EntradaSalidaID IN
						(
							SELECT CONVERT(INT, VALUE) 
							FROM STRING_SPLIT(@List_DetalleSalida,',')
						) 
GO

SELECT * FROM Inventory