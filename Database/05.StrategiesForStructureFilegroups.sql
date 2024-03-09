-- ======================================================================================
-- Memory-Optimized Filegroups || Grupos de archivos optimizados para memoria
-- ======================================================================================

/*
Un DBA puede adoptar diferentes estrategias de grupos de archivos para ayudar con 
requisitos como rendimiento, tiempo de respaldo, objetivos de tiempo de recuperación y 
ofertas de almacenamiento en niveles.

Performance Strategies || Estrategia de rendimiento

Puede obtener el mejor rendimiento creando grupos de archivos en cada disco disponible
Esto le da al servidor lo mejor en rendimiento en términos de rendimiento de E/S y ayuda 
a evitar que el subsistema de E/S convirtiéndose en el cuello de botella.

Precaución:
La desventaja de este enfoque es que colocar particiones en filegroups le impide usar 
funciones de partición, como SWITCH.

Backup and Restore Strategies || Estrategias de copia de seguridad y restauración

SQL Server le permite realizar copias de seguridad a nivel de archivo y grupo de archivos,
Posteriormente, puede realizar lo que se conoce como una restauración por etapas

A) La restauración fragmentada le permite poner su base de datos en línea por etapas. 
Esto puede ser muy útil para bases de datos grandes que tienen un objetivo de tiempo de 
recuperación muy bajo.

Es una buena practica tener dos grupos de archivos secundarios, el primero contiene los 
datos criticos y el segundo tiene los datos historicos. En caso de desastre, puede 
restaurar el grupo de archivos principal y el primer grupo de archivos secundario.

Imagina un escenario en el que tienes una gran base de datos que toma 2 horas para hacer
una copia de seguridad. Desafortunadamente, tiene una larga duración Proceso ETL y solo 
una ventana de 1 hora en la que se puede hacer una copia de seguridad de la base de datos 
todas las noches.

Si este es el caso, puede dividir los datos entre dos grupos de archivos. El primer 
grupo de archivos se puede hacer una copia de seguridad los lunes, miércoles y viernes, 
y el segundo grupo de archivos se puede copia de seguridad los martes, jueves y sábados.


Storage-Tiering Strategies || Estrategias de almacenamiento en niveles

Algunas organizaciones pueden decidir que quieren implementar niveles de almacenamiento 
para grandes bases de datos Si este es el caso, a menudo necesitará implementar esto usando
fraccionamiento

Por ejemplo, imagine que una tabla contiene datos de 6 años. Los datos para el año en curso 
se accede y se actualiza muchas veces al día. Datos de los 3 anteriores años se accede en los 
informes mensuales, pero aparte de eso, rara vez se toca. Datos hasta ahora como 6 años debe 
estar disponible al instante, si es necesario por razones reglamentarias, pero en práctica, 
rara vez se accede a ella.

En el escenario que se acaba de describir, la partición podría usarse con particiones anuales. 
El grupo de archivos que contiene los datos del año actual podría consistir en archivos 
adjuntos localmente. RAID 10 LUN para un rendimiento óptimo. 
Las particiones que contienen datos para los años 2 y 3 podría colocarse en el nivel premium 
del dispositivo SAN corporativo. Particiones para datos mayores de 3 años podrían colocarse 
en almacenamiento de línea cercana dentro de la SAN, satisfaciendo así requisitos reglamentarios
de la manera más rentable.

*/