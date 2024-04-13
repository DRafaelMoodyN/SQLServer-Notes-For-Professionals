-- LEFT JOIN
SELECT * FROM Producto.Categoria AS pc
LEFT JOIN Producto.SubCategoria AS ps
ON pc.CategoriaID = ps.CategoriaID

-- RIGHT JOIN
SELECT * FROM Producto.Categoria AS pc
RIGHT JOIN Producto.SubCategoria AS ps
ON pc.CategoriaID = ps.CategoriaID

-- INNE JOIN PK- FK
SELECT pc.Nombre Categoria, ps.Nombre SubCategoria 
FROM Producto.Categoria AS pc
INNER JOIN Producto.SubCategoria AS ps
ON pc.CategoriaID = ps.CategoriaID