-- Large Scale Searching

/*
Una de las formas más comunes, versátiles y útiles de implementar SQL dinámico es
al realizar búsquedas complejas

SQL dinámico puede permitirnos reducir nuestras consultas de búsqueda para procesar 
solo lo necesario. Además, también podemos personalizar mucho el búsqueda, así como 
los datos devueltos. Incluso podemos analizar la entrada para determinar lacurso de 
acción correcto, basado en su estructura

*/

-- Procedimiento almacenado de búsqueda, con seis parámetros opcionales

CREATE OR ALTER PROC dbo.search_product(
	@product_name NVARCHAR(50) = NULL, @product_number NVARCHAR(25) = NULL,
	@product_model NVARCHAR(50) = NULL, @product_subcategory NVARCHAR(50) = NULL,
	@product_sizemeasurecode NVARCHAR(50) = NULL, @product_weightunitmeasurecode
	NVARCHAR(50) = NULL
)	

