use master
go

if exists (select * from sys.databases as s where s.name='Repuesto')
	drop database Repuesto
go

create database Repuesto
go

use Repuesto
go

create schema Person
go

create schema Region
go

create schema Automovil
go

create schema Almacen
go

create schema Inventario
go

create schema Entrada
go

create schema Salida
go

create schema Visita
go

create schema Seguridad
go

create table Person.Empleado(
	EmpleadoID int identity primary key not null,
)
go

create table Seguridad.Usuario(
	SeguridadD int identity primary key not null,
	EmpleadoID int unique foreign key references Person.Empleado(EmpleadoID)
)
go

create table Region.Departamento(
	DepartamentoID int identity primary key not null,
	Descripcion nvarchar(50) unique not null,
)
go

create table Region.Municipio(
	MunicipioID int identity primary key not null,
	Descripcion nvarchar(50) unique not null,
	DepartamentoID int foreign key references Region.Departamento(DepartamentoID)
)
go

create table Almacen.TipoBodega(
	BodegaID int identity primary key not null,
	Descripcion nvarchar(50) unique not null
)
go

create table Almacen.BodegaVirtual(
	BodegaVirtualID int identity primary key not null,
	Descripcion nvarchar(50) unique not null,
	TipoBodegaID int foreign key references Almacen.TipoBodega(BodegaID),
)
go

create table Almacen.Bodega(
	BodegaID int identity primary key not null,
	Descripcion nvarchar(50) unique not null,
	DepartamentoID int foreign key references Region.Departamento(DepartamentoID),
	TipoBodegaID int foreign key references Almacen.TipoBodega(BodegaID),
)
go

create table Almacen.Rack(
	RackID int identity primary key not null,
	Descripcion nvarchar(50) unique not null,
	BodegaID int foreign key references Almacen.Bodega(BodegaID)
)
go

create table Almacen.Nivel(
	NivelID int identity primary key not null,
	Descripcion nvarchar(50) unique not null,
	RackID int foreign key references Almacen.Rack(RackID)
)
go

create table Almacen.Estante(
	EstanteID int identity primary key not null,
	Descripcion nvarchar(50) unique not null,
	NivelID int foreign key references Almacen.Nivel(NivelID)
)
go

create table Visita.Taller(
	TallerID int identity primary key not null,
	Descripcion nvarchar(50) unique not null,
	DepartamentoID int foreign key references Region.Departamento(DepartamentoID)
)
go

create table Visita.Estado(
	EstadoID int identity primary key not null,
	Descripcion nvarchar(50) unique not null
)
go

create table Visita.Visita(
	VisitaID int identity primary key not null,
	Descripcion nvarchar(50) unique not null,
	EstadoID int foreign key references Visita.Estado(EstadoID),
	TallerID int foreign key references Visita.Taller(TallerID),
	EmpleadoID int unique foreign key references Person.Empleado(EmpleadoID)
)
go

create table Automovil.Color(
	ColorID int identity primary key not null,
	Descripcion nvarchar(50) unique not null
)
go

create table Automovil.Marca(
	MarcaID int identity primary key not null,
	Descripcion nvarchar(50) unique not null
)
go

create table Automovil.Modelo(
	ModeloID int identity primary key not null,
	Descripcion nvarchar(50) unique not null,
	MarcaID int foreign key references Automovil.Marca(MarcaID)
)
go

create table Automovil.Piesa(
	PiesaID int identity primary key not null,
	Descripcion nvarchar(100) unique not null
)
go

create table Entrada.TipoClase(
	ClaseID int identity primary key not null,
	Descripcion nvarchar(50) unique not null,
)
go

create table Entrada.MaestroEntradaRepuesto(
	EntradaID int identity primary key not null,
	Descripcion nvarchar(50) unique not null,
	foreign key(EntradaID) references Visita.Visita(VisitaID)
)
go

create table Entrada.DetalleEntradaRepuesto(
	DetalleID int identity primary key not null,
	Descripcion nvarchar(50) unique not null,
	EntradaID int foreign key references Entrada.MaestroEntradaRepuesto(EntradaID),
	TipoClaseID int foreign key references Entrada.TipoClase(ClaseID),
	ModeloID int foreign key references Automovil.Modelo(ModeloID),
	ColorID int foreign key references Automovil.Color(ColorID),
	PiesaID int foreign key references Automovil.Piesa(PiesaID)
)
go

create table Entrada.Imagen(
	ImagenID int identity primary key not null,
	Descripcion nvarchar(50) unique not null,
	DetalleID int foreign key references Entrada.DetalleEntradaRepuesto(DetalleID)
)
go

create table Salida.MaestroSalidaRepuesto(
	SalidaID int identity primary key not null,
	Descripcion nvarchar(50) unique not null
)
go

create table Salida.DetalleSalidaRepuesto(
	DetalleID int identity primary key not null,
	Descripcion nvarchar(50) unique not null,
	SalidaID int foreign key references Salida.MaestroSalidaRepuesto(SalidaID),
	PiesaID int foreign key references Automovil.Piesa(PiesaID)
)
go

create table Inventario.Inventario(
	InventarioID int identity primary key not null,
	DetalleEntradaID int foreign key references Entrada.DetalleEntradaRepuesto(DetalleID),
	DetalleSalidaID int foreign key references Salida.DetalleSalidaRepuesto(DetalleID),
	PiesaID int foreign key references Automovil.Piesa(PiesaID),
	ModeloID int foreign key references Automovil.Modelo(ModeloID),
	TipoBodega int foreign key references Almacen.BodegaVirtual(BodegaVirtualID),
	EstanteID int foreign key references Almacen.Estante(EstanteID)
)
go