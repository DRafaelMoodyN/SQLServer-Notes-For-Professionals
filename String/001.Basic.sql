-- Functions String

-- CONCAT -> Concatenar cadenas
SELECT 'David'+'-'+'Moody'
SELECT 'David'+NULL+'Moody'
SELECT 'David'+ISNULL(NULL,'-')+'Moody'
SELECT CONCAT('David','-','Moody')
SELECT CONCAT('David',NULL,'Moody')

-- CONCAT_WS -> Concatenar cadenas con separador
SELECT CONCAT_WS(',','1','2','3','4')

-- LEN -> Devuelve el tamaño de una cadena
SELECT LEN('Cadena')

-- LEFT -> Devuelve la parte izquierda
SELECT LEFT('David Moody',5)
SELECT LEFT('David Moody',LEN('David Moody')-1)

-- RIGHT -> Devuelve la parte derecha
SELECT RIGHT('David Moody',5)

-- LOWER -> Convertir a menor
SELECT LOWER('David Moody')

-- UPPER -> Convertir a mayor
SELECT UPPER('David Moody')

-- LTRIM -> Eliminar espacios iniciales
SELECT LTRIM(' David Moody')

-- RTRIM -> Eliminar espacios finales
SELECT RTRIM('David Moody ')

-- PATINDEX -> Devuelve la posicion incial de un patro, de lo contrario 0
SELECT PATINDEX('%Ra%','David Rafael Moody Nuñez')

-- REEMPLAZAR -> Reemplazar una cadena
SELECT REPLACE('12131415','15','0')

-- REVERSE -> Devuelve la cadena inversa
SELECT REVERSE('Hacker')

-- SOUINDEX -> Comparar cadenas
SELECT SOUNDEX('David'), SOUNDEX('David')
SELECT SOUNDEX('David'), SOUNDEX('DaviD')
SELECT SOUNDEX('Daviddddd'), SOUNDEX('DaviD')

-- SPACE -> Devuelve una cadena de espacios repetidos
SELECT (CONCAT('David',SPACE(5),'Moody'))

-- Lo mismo que CONCAT_WS
USE AdventureWorks2019
GO

SELECT STRING_AGG(c.Name,'---') FROM Production.ProductCategory AS c

-- SUBSTRING -> Extraer parte de una cadena
SELECT SUBSTRING('David Rafael Moody',1,2)

-- TRANSLATE
SELECT TRANSLATE('2*[3+4]/{7-2}', '[]{}', '()()');
SELECT TRANSLATE('David Moody[] David', '[]', '()');

-- TRIM -> Quitar espacios al principio y al final
SELECT TRIM('  David Moody  ')