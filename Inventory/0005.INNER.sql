
use WmsProyecto
go

select pc.CategoriaID, pc.Nombre as Categoria, ps.Nombre as SubCategoia 

-- Trabajo con AND
from Producto.Categoria as pc
inner join Producto.SubCategoria as ps
on pc.CategoriaID = ps.CategoriaID
inner join Producto.Producto as pp
on ps.SubCategoriaID = pp.SubCategoriaID

-- 1 || 0 = True
-- 0 || 1 = True
-- 0 || 0 = Falso
-- 1 || 1 = True

-- 1 && 0 = False
-- 0 && 1 = False
-- 0 && 0 = Falso
-- 1 && 1 = True


update Producto.Producto set Nombre = '', IsActivo =1 where 


select pc.CategoriaID, pc.Nombre as Categoria, ps.Nombre as SubCategoia , pp.ProductoID, pp.Nombre
-- Trabajo con AND --1 
from Producto.Categoria as pc
inner join Producto.SubCategoria as ps
on pc.CategoriaID = ps.CategoriaID
-- OR --- 0
left join Producto.Producto as pp
on ps.SubCategoriaID = pp.SubCategoriaID
left join Costo.TipoImpuesto as ct
on ct.TipoImpuestoID = pp.TipoImpuestoID

select * from Producto.Categoria

-- (1 and 1) and (1 or 1 ) and (1 or 1)
-- 1 and 0 and 0
-- 0  and 
-- False

select * from Producto.SubCategoria

select * from Producto.Producto


select * from pro


select -- Define las columnas
from -- Selecionar la tabla
inner  -- Unir las tablas 
where -- Filtro and , or not
group by -- Agrupor por clasificacion
having -- Filtro siempre se usa con el grup by
order by -- Orderder


select * from Producto.SubCategoria as sp
inner join Producto.Producto as pp
on sp.SubCategoriaID = pp.SubCategoriaID


select * from Producto.SubCategoria as sp
left join Producto.Producto as pp
on sp.SubCategoriaID = pp.SubCategoriaID


select * from Producto.Producto as pp
left join Producto.SubCategoria as ps
on pp.SubCategoriaID = ps.SubCategoriaID


select * from Producto.SubCategoria as sp
right join Producto.Producto as pp
on sp.SubCategoriaID = pp.SubCategoriaID


select * from Producto.Producto as pp
full outer join Producto.SubCategoria as ps
on pp.SubCategoriaID = ps.SubCategoriaID


-- Categoria, ProductoID

-- select categoria, (select * from lsdf) from Categoriasdf





