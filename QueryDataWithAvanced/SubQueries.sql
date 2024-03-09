-- ==================================================================================================
-- SubQueries
-- ==================================================================================================

/*

Una subconsulta es una consulta anidada en una instrucción SELECT, INSERT, UPDATE o DELETE, o 
bien en otra subconsulta.

Las subconsultas pueden ser independientes, independientes de la consulta externa; o pueden estar 
correlacionados, es decir, tener una referencia a una columna de la tabla en la consulta externa. 
En términos de el resultado de la subconsulta, puede ser escalar, de varios valores (tabla con una 
sola columna) o de varias columnas con valores de tabla (tabla con varias columnas).

Self-contained subqueries

Las subconsultas independientes son subconsultas que no dependen de la consulta externa. Si usted
desea, puede resaltar la consulta interna en SSMS y ejecutarla de forma independiente. Esto hace 
que el la resolución de problemas con subconsultas independientes es más fácil en comparación con 
las subconsultas correlacionadas subconsultas Como se mencionó, una subconsulta puede devolver 
diferentes formas de resultados. Puede devolver un solo valor, tabla con múltiples valores en una 
sola columna, o incluso un resultado de tabla de varias columnas

*/

USE Northwind
GO

-- La siguiente consulta utiliza una subconsulta independiente para devolver 
-- los productos con el precio unitario mínimo:

SELECT 
	p.ProductID, p.ProductName, p.UnitPrice
FROM dbo.Products AS p
WHERE p.UnitPrice = (
	SELECT MIN(sp.UnitPrice)
	FROM dbo.Products AS sp
);
GO

/*
Como puede ver, la subconsulta devuelve el precio unitario mínimo de la Producción.
tabla de productos. La consulta externa luego devuelve información sobre productos 
con el mínimo precio unitario.

Una subconsulta también puede devolver múltiples valores en forma de una sola columna 
y múltiples filas Tal subconsulta se puede usar cuando se espera un resultado de varios 
valores

*/

-- Producto que el proveedor es de japan

SELECT 
	p.ProductID, p.ProductName, p.UnitPrice
FROM dbo.Products AS p
WHERE p.SupplierID IN(
	SELECT sp.SupplierID
	FROM dbo.Suppliers AS sp
	WHERE sp.Country = N'JAPAN'
);
GO

-- Producto con el precio minimo que el proveedor es de japan

SELECT * FROM dbo.Products AS t
WHERE t.UnitPrice = (
SELECT 
	MIN(p.UnitPrice)
FROM dbo.Products AS p
WHERE p.SupplierID IN(
	SELECT sp.SupplierID
	FROM dbo.Suppliers AS sp
	WHERE sp.Country = N'JAPAN' 
	)
)
GO

SELECT * FROM dbo.Products AS t
WHERE t.UnitPrice = (
SELECT 
	MIN(p.UnitPrice)
FROM dbo.Products AS p
WHERE p.SupplierID NOT IN(
	SELECT sp.SupplierID
	FROM dbo.Suppliers AS sp
	WHERE sp.Country = N'JAPAN' 
	)
)
GO


-- Producto con el precio minimo que el proveedor que no es de japan

SELECT * FROM dbo.Products AS t
WHERE t.UnitPrice = (
SELECT 
	MIN(p.UnitPrice)
FROM dbo.Products AS p
WHERE p.SupplierID NOT IN (
	SELECT sp.SupplierID
	FROM dbo.Suppliers AS sp
	WHERE sp.Country = N'JAPAN' 
	)
)
GO

/*
El predicado ALL devuelve verdadero solo si al aplicar el operador a la expresión de entrada
y todos los valores devueltos por la subconsulta, obtienes un verdadero en todos los casos.

La siguiente
consulta es una solución alternativa a la mostrada anteriormente para devolver el producto 
con el precio unitario mínimo

*/

SELECT 
	* 
FROM dbo.Products AS p
WHERE p.UnitPrice <= ALL(
	SELECT 
		s.UnitPrice 
	FROM dbo.Products AS s)


/*
La forma en que se formula la consulta es "devolver los productos donde el precio unitario 
es mayor que los precios unitarios de cualquier producto”. Esto será falso solo para el 
producto con el precio mínimo.

La siguiente consulta devuelve todos los productos con un precio unitario mayor que el
mínimo.
*/

SELECT 
	* 
FROM dbo.Products AS p
WHERE p.UnitPrice > ANY (
	SELECT 
		s.UnitPrice 
	FROM dbo.Products AS s)

-- Error fatal

--SELECT 
--	P.ProductID, P.ProductName, P.UnitPrice, AVG(p.UnitPrice)
--FROM dbo.Products p

SELECT 
	p.ProductID, p.ProductName, p.UnitPrice,
	(SELECT AVG(s.UnitPrice) FROM dbo.Products AS s) AS PromediO
FROM dbo.Products AS p
GO

-- SubConsulta como una tabla derivada

SELECT t.CustomerID, t.CompanyName, t.OrderID, t.UnitPrice, t.Quantity,
	   t.UnitPrice * t.Quantity AS Total
FROM
(SELECT 
	c.CustomerID, 
	c.CompanyName, 
	o.OrderID, 
	o.OrderDate, 
	p.ProductName, 
	od.UnitPrice, 
	od.Quantity
FROM dbo.Customers AS c 
	INNER JOIN dbo.Orders AS o
		ON c.CustomerID = o.CustomerID
	INNER JOIN dbo.[Order Details] AS od
		ON od.OrderID = od.OrderID
	INNER JOIN dbo.Products AS p
	ON od.ProductID = p.ProductID
	) AS t
GO


SELECT t.CompanyName, t.OrderID, t.UnitPrice, t.Quantity,
	  SUM(t.UnitPrice * t.Quantity) AS Total
FROM
(SELECT 
	c.CustomerID, 
	c.CompanyName, 
	o.OrderID, 
	o.OrderDate, 
	p.ProductName, 
	od.UnitPrice, 
	od.Quantity
FROM dbo.Customers AS c 
	INNER JOIN dbo.Orders AS o
		ON c.CustomerID = o.CustomerID
	INNER JOIN dbo.[Order Details] AS od
		ON od.OrderID = od.OrderID
	INNER JOIN dbo.Products AS p
	ON od.ProductID = p.ProductID
	) AS t
GROUP BY t.CompanyName, t.OrderID, t.UnitPrice, t.Quantity


-- SubConsultas Correlacionadas
-- Si la consulta de dentro del parentesis devuelve un valor
-- Entonces se ejecuta la consulta externa

--  Devolvera solo los clientes que tiene una orden
SELECT 
	c.CompanyName
FROM dbo.Customers AS c
WHERE EXISTS
	(SELECT 
		o.CustomerID
		FROM dbo.Orders AS o
		WHERE c.CustomerID = o.CustomerID
)


-- Correlated subqueries

/*
Las subconsultas correlacionadas son subconsultas donde la consulta interna tiene una referencia 
a una columna de la tabla en la consulta externa. Es más complicado trabajar con ellas en 
comparación con las subconsultas independientes porque no puede simplemente resaltar la parte 
interna y ejecutarla de forma independiente. 

Ejemplo: suponga que necesita devolver productos con el precio unitario mínimo por categoría.
*/

SELECT 
	p.CategoryID, p.ProductID, p.ProductName , p.UnitPrice
FROM dbo.Products AS p
WHERE p.UnitPrice = (
	SELECT MIN(c.UnitPrice)
	FROM dbo.Products AS c
	WHERE c.CategoryID = p.CategoryID
)
GO


-- Optimization of subqueries versus joins