-- ==================================================================================================
-- ALL
-- ==================================================================================================

/*
Compara un valor escalar con un conjunto de valores de una sola columna.

Sintaxis

scalar_expression { = | <> | != | > | >= | !> | < | <= | !< } ALL ( subquery )

Es una instrucci�n SELECT restringida en la que no se permiten la cl�usula ORDER BY 
ni la palabra clave INTO.

Devuelve TRUE cuando la comparaci�n especificada es TRUE para todos los pares (scalar_expression, x), 
donde x es un valor del conjunto de una sola columna. De lo contrario, devuelve FALSE.

*/
