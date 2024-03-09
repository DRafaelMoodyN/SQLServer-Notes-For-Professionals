-- ==================================================================================================
-- MERGE Stock Example
-- ==================================================================================================

USE master
GO

DROP DATABASE IF EXISTS BDTesting
GO

CREATE DATABASE BDTesting
GO

USE BDTesting
GO

CREATE TABLE Product(
	ProductId INT PRIMARY KEY,
	ProductName NVARCHAR(50),
	IsDelete BIT DEFAULT 1
)

-- Entradas
CREATE TABLE Ticket(
	TicketId INT PRIMARY KEY,
	Quantity INT NOT NULL,
	ProductId INT FOREIGN KEY REFERENCES Product(ProductId),
	IsDelete BIT DEFAULT 1
)

-- Salidas
CREATE TABLE Departures(
	DeparturesId INT PRIMARY KEY,
	Quantity INT NOT NULL,
	ProductId INT FOREIGN KEY REFERENCES Product(ProductId),
	IsDelete BIT DEFAULT 1
)

CREATE TABLE Stock(
	StockID INT PRIMARY KEY,
	Quantity INT DEFAULT(0.00) NOT NULL,
	ProductId INT UNIQUE FOREIGN KEY REFERENCES Product(ProductId)
)
GO


CREATE OR ALTER PROC Up_Product_Insert(
	@ProductId INT,
	@ProductName NVARCHAR(50)
) AS
BEGIN 
BEGIN TRANSACTION 
	BEGIN TRY

		INSERT INTO Product(ProductId,ProductName)
		VALUES(@ProductId,@ProductName)

		MERGE Stock AS t
		USING Product as s
			ON t.StockID = s.ProductId
		-- INSERT
				WHEN NOT MATCHED BY TARGET THEN
					INSERT(StockID,ProductId)
					VALUES(@ProductId,@ProductId);

		COMMIT TRANSACTION
		PRINT 'Product Insert Correcto'
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		PRINT 'Product Insert Error'
	END CATCH
END
GO

-- Entradas
CREATE OR ALTER PROC Up_Ticke_Insert(
	@TicketId INT,
	@Quantity INT,
	@ProductId INT
) AS
BEGIN 
BEGIN TRANSACTION 
	BEGIN TRY

		INSERT INTO Ticket(TicketId,Quantity,ProductId)
		VALUES(@TicketId,@Quantity,@ProductId)

		MERGE Stock AS t
		USING Ticket as s
			ON t.ProductId = s.ProductId
		-- UPDATE
		WHEN MATCHED AND t.ProductId <> @ProductId THEN
			UPDATE SET t.Quantity = t.Quantity + s.Quantity;

		COMMIT TRANSACTION
		PRINT 'Ticket Insert Correcto'
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		PRINT 'Ticket Insert Error'
	END CATCH
END
GO

-- Salidas
CREATE OR ALTER PROC Up_Departures_Insert(
	@DeparturesId INT,
	@Quantity INT,
	@ProductId INT
) AS
BEGIN 
BEGIN TRANSACTION 
	BEGIN TRY

		INSERT INTO Departures(DeparturesId,Quantity,ProductId)
		VALUES(@DeparturesId,@Quantity,@ProductId)

		MERGE Stock AS t
		USING Departures as s
			ON t.ProductId = s.ProductId
		-- UPDATE
		WHEN MATCHED  AND t.ProductId <> @ProductId THEN
			UPDATE SET t.Quantity = t.Quantity - s.Quantity;

		COMMIT TRANSACTION
		PRINT 'Departures Insert Correcto'
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		PRINT 'Departures Insert Error'
	END CATCH
END
GO

-- Ingresando productos
EXEC Up_Product_Insert 1,'Producto 1'
SELECT * FROM Stock

EXEC Up_Product_Insert 2,'Producto 2'
SELECT * FROM Stock

EXEC Up_Product_Insert 3,'Producto 3'
SELECT * FROM Stock

EXEC Up_Product_Insert 4,'Producto 4'
SELECT * FROM Stock

-- Ingresando entradas
EXEC Up_Ticke_Insert 1,10,1
SELECT * FROM Stock

EXEC Up_Ticke_Insert 2,15,2
SELECT * FROM Stock

EXEC Up_Ticke_Insert 3,25,3
SELECT * FROM Stock

EXEC Up_Ticke_Insert 4,50,4
SELECT * FROM Stock

EXEC Up_Ticke_Insert 5,100,3
SELECT * FROM Stock
SELECT * FROM Ticket

