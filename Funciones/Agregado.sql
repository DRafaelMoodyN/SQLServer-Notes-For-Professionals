use AdventureWorks2019
go

-- APPROX_COUNT_DISTINCT
-- Proporciona una estimación aproximada del número de valores distintos en una columna.
-- Es más rápido y consume menos recursos en comparación con COUNT(DISTINCT)

select * from sales.SalesOrderHeader

select APPROX_COUNT_DISTINCT(CustomerID)
from Sales.SalesOrderHeader

select count(distinct(CustomerID))
from Sales.SalesOrderHeader -- 19119


-- AVG
-- Promedio de los valores de un grupo

-- Ejemplo basico
DECLARE @t TABLE (val dec(10,2));
INSERT INTO @t(val) VALUES( 1),(2),(3),(4),(4),(5),(5),(6);
--SELECT val FROM @t;

-- (1 + 2 + 3 + 4 + 4 + 5 + 5 + 6) /  8 = 3.75
select avg(val) from @t
select avg(all val) from @t
select avg(distinct val) from @t

-- Ejemplo mas real

select 
	 cast(round(avg(s.TotalDue),2) as decimal(10,2)) as [AVG], -- 1906.26
	 sum(s.TotalDue) as [SUM] -- 22419498.3157
from Sales.SalesOrderHeader as s
inner join sales.Customer as c
on s.CustomerID = c.CustomerID
inner join Person.Person as p
on p.BusinessEntityID = c.PersonID
where year(s.OrderDate) = 2014

select 
	 p.BusinessEntityID,
	 p.FirstName, 
	 p.LastName,
	 avg(s.TotalDue) as [AVG],
	 sum(s.TotalDue)
from Sales.SalesOrderHeader as s
inner join sales.Customer as c
on s.CustomerID = c.CustomerID
inner join Person.Person as p
on p.BusinessEntityID = c.PersonID
where year(s.OrderDate) = 2014
group by p.BusinessEntityID, p.FirstName, p.LastName


select 
	p.BusinessEntityID,
	 p.FirstName, 
	 p.LastName,
	 avg(s.TotalDue) as [AVG],
	 sum(s.TotalDue)
from Sales.SalesOrderHeader as s
inner join sales.Customer as c
on s.CustomerID = c.CustomerID
inner join Person.Person as p
on p.BusinessEntityID = c.PersonID
-- 11407	Jill	Martin	47.9017	143.7053
where year(s.OrderDate) = 2014 and p.BusinessEntityID = 11407
group by p.BusinessEntityID, p.FirstName, p.LastName


-- Verificar

select 
	p.BusinessEntityID,
	 p.FirstName, 
	 p.LastName,
	 s.CustomerID as [AVG],
	 s.TotalDue
from Sales.SalesOrderHeader as s
inner join sales.Customer as c
on s.CustomerID = c.CustomerID
inner join Person.Person as p
on p.BusinessEntityID = c.PersonID
-- 11407	Jill	Martin	47.9017	143.7053
where year(s.OrderDate) = 2014 and p.BusinessEntityID = 11407
