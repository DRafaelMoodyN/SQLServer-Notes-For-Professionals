-- ======================================================================================
-- Log File Count || Recuento de archivos
-- ======================================================================================

/*

Recuento de archivos de registro
Varias veces he sido testigo de la idea errónea de que tener varios archivos de registro puede
mejorar el rendimiento de una base de datos. Esto es una falacia. La idea es impulsada por la creencia.
que si tiene varios archivos de registro en unidades separadas, puede distribuir IO y aliviar el
registro como un cuello de botella

La verdad es que el registro de transacciones es secuencial, e incluso si agrega varios registros
archivos, SQL Server los trata como si fueran un solo archivo. Esto significa que el segundo archivo
solo se usará después de que el primer archivo se llene. Como resultado, ningún beneficio de rendimiento puede
obtener de esta práctica. De hecho, la única razón posible por la que alguna vez necesitaría
más de un archivo de registro de transacciones es si se quedó sin espacio en el LUN que estaba alojando
el registro, y por alguna razón no se puede mover a otro lugar y el volumen no se puede
expandido

*/