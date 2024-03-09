-- ==================================================================================================
-- MERGE
-- ==================================================================================================

/*
Ejecuta operacion de insercion, actualizacion o eliminacion en una tabla de destion 
a partir de los resultados de una combinacion con una tabla de orgine, por ejemplo:
sincronisa dos tablas insertando, actualizando o eliminando filas en una tabla en 
funcion de las diferencias encontradas en la otra.

Ejemplo: inserte una fila si no existe o actualize una fila si coincide

*/

USE master
GO

DROP DATABASE IF EXISTS BDTesting
GO

CREATE DATABASE BDTesting
GO

USE BDTesting
GO

CREATE TABLE TableOrigin(
	TableId INT PRIMARY KEY,
	CreditRating INT NOT NULL
)

CREATE TABLE TableDestino(
	TableId INT PRIMARY KEY,
	CreditRating INT NOT NULL
)
GO

INSERT INTO TableOrigin(TableId,CreditRating)
VALUES(1,12)

INSERT INTO TableOrigin(TableId,CreditRating)
VALUES(2,15)

INSERT INTO TableOrigin(TableId,CreditRating)
VALUES(3,20)

INSERT INTO TableOrigin(TableId,CreditRating)
VALUES(4,55)

INSERT INTO TableOrigin(TableId,CreditRating)
VALUES(5,20)
GO

INSERT INTO TableOrigin(TableId,CreditRating)
VALUES(6,100)
GO

-- Una instruccion merge debe de terminar con un ;
-- Insert
--MERGE TableDestino AS t
--USING TableOrigin AS s
--	ON t.TableId = s.TableId
--		WHEN NOT MATCHED BY TARGET THEN
--			INSERT(TableId,CreditRating)
--				VALUES(s.TableId,s.CreditRating);

---- Update
--MERGE TableDestino AS t
--USING TableOrigin AS s
--	ON t.TableId = s.TableId
--		WHEN MATCHED THEN
--			UPDATE SET t.CreditRating = t.CreditRating + s.CreditRating;

---- Delete
--MERGE TableDestino AS t
--USING TableOrigin AS s 
--	ON t.TableId = s.TableId
--		WHEN MATCHED AND s.CreditRating < 15 THEN DELETE;

/*
	En una declaración MERGE, una cláusula 'WHEN MATCHED' con una 
	condición de búsqueda no puede aparecer después de una cláusula '
	WHEN MATCHED' sin condición de búsqueda.
*/

MERGE TableDestino AS t
USING TableOrigin AS s
	ON t.TableId = s.TableId
	 -- DELETE
	    WHEN MATCHED AND s.CreditRating <= 50 THEN
			DELETE
	-- INSERT
		WHEN NOT MATCHED BY TARGET THEN
			INSERT(TableId,CreditRating)
				VALUES(s.TableId,s.CreditRating)
	-- UPDATE
		WHEN MATCHED THEN
			UPDATE SET t.CreditRating = t.CreditRating + s.CreditRating;


SELECT * FROM TableOrigin
SELECT * FROM TableDestino