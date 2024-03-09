-- ======================================================================================
-- Recovery Model || Modelo de recuperacion
-- ======================================================================================

/*
El modelo de recuperación es una propiedad a nivel de la base de datos que controla 
cómo se realizan las transacciones. 
registrado y, por lo tanto, tiene un impacto en el mantenimiento del registro de 
transacciones.

Recovery Model types

SIMPLE:
En este modelo no es posible realizar una copia de seguridad de registro de transacciones
Las transacciones se registran mínimamente y el registro se trunca automáticamente
El registro de transacciones solo existe para permitir transacciones
para ser revertida. Es incompatible con varios HADR (alta disponibilidad/desastres).
recuperación) tecnologías, como grupos de disponibilidad AlwaysOn, envío de registros,
y duplicación de bases de datos. Este modelo es apropiado para bases de datos de informes.
donde las actualizaciones solo ocurren con poca frecuencia. Esto se debe a que en un 
punto en el tiempo la recuperación no es posible. El objetivo del punto de recuperación 
será el tiempo de la última Respaldo COMPLETO o DIFERENCIAL

FULL:
En el modelo de recuperación COMPLETA, se deben realizar copias de seguridad del registro de transacciones. El registro se
solo se truncará durante el proceso de copia de seguridad del registro. Las transacciones se registran por completo
y esto significa que la recuperación puntual es posible. También significa que usted
debe tener una cadena completa de copias de seguridad de archivos de registro para restaurar una base de datos a la
punto más reciente

BULK LOGGED: 

El modelo de recuperación BULK_LOGGED está destinado a usarse de forma temporal
cuando está utilizando el modelo de recuperación COMPLETO pero necesita realizar una gran BULK
Operación INSERTAR. Cuando cambia a este modo, las operaciones BULK INSERT
se registran mínimamente. Luego, vuelve al modelo de recuperación COMPLETO cuando el
la importación está completa. En este modelo de recuperación, puede restaurar hasta el final de cualquier
copia de seguridad, pero no a un punto específico en el tiempo entre las copias de seguridad.

*/
