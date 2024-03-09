-- Clonar una base de datos de solo lectura
-- En propiedades Optiones -> State -> Database Read-Only True lo cambiamos por falso

DBCC CLONEDATABASE(AdventureWorks2019,AdventureWorks2019Copy)
DROP DATABASE AdventureWorks2019Copy