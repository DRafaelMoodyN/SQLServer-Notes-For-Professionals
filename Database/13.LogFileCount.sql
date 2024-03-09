-- ======================================================================================
-- Log File Count || Recuento de archivos
-- ======================================================================================

/*

Recuento de archivos de registro
Varias veces he sido testigo de la idea err�nea de que tener varios archivos de registro puede
mejorar el rendimiento de una base de datos. Esto es una falacia. La idea es impulsada por la creencia.
que si tiene varios archivos de registro en unidades separadas, puede distribuir IO y aliviar el
registro como un cuello de botella

La verdad es que el registro de transacciones es secuencial, e incluso si agrega varios registros
archivos, SQL Server los trata como si fueran un solo archivo. Esto significa que el segundo archivo
solo se usar� despu�s de que el primer archivo se llene. Como resultado, ning�n beneficio de rendimiento puede
obtener de esta pr�ctica. De hecho, la �nica raz�n posible por la que alguna vez necesitar�a
m�s de un archivo de registro de transacciones es si se qued� sin espacio en el LUN que estaba alojando
el registro, y por alguna raz�n no se puede mover a otro lugar y el volumen no se puede
expandido

*/