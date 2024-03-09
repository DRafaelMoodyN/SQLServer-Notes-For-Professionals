USE master
GO

IF EXISTS(SELECT * FROM sys.databases AS s WHERE s.name = 'Sba')
	DROP DATABASE Sba
GO

CREATE DATABASE Sba
GO

USE Sba
GO

CREATE SCHEMA Vehiculo
GO

CREATE SCHEMA Person
GO

CREATE SCHEMA Region
GO

CREATE SCHEMA Catalogo
GO

CREATE SCHEMA Prestamo
GO

CREATE TABLE Catalogo.TipoPrestamo(
	TipoPrestamoID INT PRIMARY KEY 
)
GO


CREATE TABLE Person.TipoPersona(
	TipoPersonID INT PRIMARY KEY 
)
GO

CREATE TABLE Region.Pais(
	PaisID INT PRIMARY KEY 
)
GO

CREATE TABLE Region.Departamento(
	DepartamentoID INT PRIMARY KEY,
	PaisID INT FOREIGN KEY REFERENCES Region.Pais(PaisID)
)
GO

CREATE TABLE Region.SucursalBancaria(
	SucursalBancariaID INT PRIMARY KEY,
	DepartamentoID INT FOREIGN KEY REFERENCES Region.Departamento(DepartamentoID)
)
GO

CREATE TABLE Vehiculo.Marca(
	MarcaID INT IDENTITY PRIMARY KEY
)
GO

CREATE TABLE Vehiculo.Modelo(
	ModeloID INT IDENTITY PRIMARY KEY,
	MarcaID INT FOREIGN KEY REFERENCES Vehiculo.Marca(MarcaID)
)
GO

CREATE TABLE Vehiculo.TipoUbicacion(
	TipoUbicacionID INT IDENTITY PRIMARY KEY
)
GO

CREATE TABLE Vehiculo.TipoGravamen(
	TipoGravamenID INT IDENTITY PRIMARY KEY
)
GO

CREATE TABLE Vehiculo.TipoCombustible(
	TipoCombustibleID INT IDENTITY PRIMARY KEY
)
GO

CREATE TABLE Vehiculo.TipoTransmision(
	TipoTransmisionID INT IDENTITY PRIMARY KEY
)
GO

CREATE TABLE Vehiculo.TipoVehiculo(
	TipoVehiculoID INT IDENTITY PRIMARY KEY
)
GO

CREATE TABLE Vehiculo.AutoLote(
	AutoLoteID INT IDENTITY PRIMARY KEY
)
GO

CREATE TABLE Vehiculo.TipoCategoria(
	TipoCategoriaID INT IDENTITY PRIMARY KEY,
	TipoVehiculoID INT FOREIGN KEY REFERENCES Vehiculo.TipoVehiculo(TipoVehiculoID)
)
GO

CREATE TABLE Vehiculo.Vehiculo(
	VehiculoID INT PRIMARY KEY,
	TipoTransmisionID INT FOREIGN KEY REFERENCES Vehiculo.TipoTransmision(TipoTransmisionID),
	TipoCategoriaID INT FOREIGN KEY REFERENCES Vehiculo.TipoCategoria(TipoCategoriaID),
	TipoCombustibleID INT FOREIGN KEY REFERENCES Vehiculo.TipoCombustible(TipoCombustibleID),
	TipoGravamenID INT FOREIGN KEY REFERENCES Vehiculo.TipoGravamen(TipoGravamenID),
	TipoUbicacionID INT FOREIGN KEY REFERENCES Vehiculo.TipoUbicacion(TipoUbicacionID),
	AutoLoteID INT FOREIGN KEY REFERENCES Vehiculo.AutoLote(AutoLoteID)
)
GO

CREATE TABLE Person.Ejecutivo(
	EjecutivoID INT PRIMARY KEY,
	PaisID INT FOREIGN KEY REFERENCES Region.Pais(PaisID)
)
GO

CREATE TABLE Prestamo.ResponsableEntrega(
	ResponsableEntregaID INT PRIMARY KEY
)
GO

CREATE TABLE Prestamo.EstatusSaldoInsoluto(
	EstatusSaldoInsolutoID INT PRIMARY KEY
)
GO

CREATE TABLE Person.Cliente(
	ClienteID INT PRIMARY KEY,
	TipoPersonaID INT FOREIGN KEY REFERENCES Person.TipoPersona(TipoPersonID),
	DepartamentoID INT FOREIGN KEY REFERENCES Region.Departamento(DepartamentoID)
)
GO

CREATE TABLE Prestamo.MaestroPrestamo(
	MaestroPrestamoID INT PRIMARY KEY,
	ClienteID INT FOREIGN KEY REFERENCES Person.Cliente(ClienteID),
	TipoPrestamoID INT FOREIGN KEY REFERENCES Catalogo.TipoPrestamo(TipoPrestamoID),
	EjecutivoID INT FOREIGN KEY REFERENCES Person.Ejecutivo(EjecutivoID),
	ResponsableEntrega INT FOREIGN KEY REFERENCES Prestamo.ResponsableEntrega(ResponsableEntregaID),
	SucursalBancaria INT FOREIGN KEY REFERENCES Region.SucursalBancaria(SucursalBancariaID),
	EstatusSaldoInsolutoID INT FOREIGN KEY REFERENCES Prestamo.EstatusSaldoInsoluto(EstatusSaldoInsolutoID),
	VehiculoID INT FOREIGN KEY REFERENCES Vehiculo.Vehiculo(VehiculoID)
)
GO