-- ======================================================================================
-- Memory-Optimized Filegroups || Grupos de archivos optimizados para memoria
-- ======================================================================================

/*
Un DBA puede adoptar diferentes estrategias de grupos de archivos para ayudar con 
requisitos como rendimiento, tiempo de respaldo, objetivos de tiempo de recuperaci�n y 
ofertas de almacenamiento en niveles.

Performance Strategies || Estrategia de rendimiento

Puede obtener el mejor rendimiento creando grupos de archivos en cada disco disponible
Esto le da al servidor lo mejor en rendimiento en t�rminos de rendimiento de E/S y ayuda 
a evitar que el subsistema de E/S convirti�ndose en el cuello de botella.

Precauci�n:
La desventaja de este enfoque es que colocar particiones en filegroups le impide usar 
funciones de partici�n, como SWITCH.

Backup and Restore Strategies || Estrategias de copia de seguridad y restauraci�n

SQL Server le permite realizar copias de seguridad a nivel de archivo y grupo de archivos,
Posteriormente, puede realizar lo que se conoce como una restauraci�n por etapas

A) La restauraci�n fragmentada le permite poner su base de datos en l�nea por etapas. 
Esto puede ser muy �til para bases de datos grandes que tienen un objetivo de tiempo de 
recuperaci�n muy bajo.

Es una buena practica tener dos grupos de archivos secundarios, el primero contiene los 
datos criticos y el segundo tiene los datos historicos. En caso de desastre, puede 
restaurar el grupo de archivos principal y el primer grupo de archivos secundario.

Imagina un escenario en el que tienes una gran base de datos que toma 2 horas para hacer
una copia de seguridad. Desafortunadamente, tiene una larga duraci�n Proceso ETL y solo 
una ventana de 1 hora en la que se puede hacer una copia de seguridad de la base de datos 
todas las noches.

Si este es el caso, puede dividir los datos entre dos grupos de archivos. El primer 
grupo de archivos se puede hacer una copia de seguridad los lunes, mi�rcoles y viernes, 
y el segundo grupo de archivos se puede copia de seguridad los martes, jueves y s�bados.


Storage-Tiering Strategies || Estrategias de almacenamiento en niveles

Algunas organizaciones pueden decidir que quieren implementar niveles de almacenamiento 
para grandes bases de datos Si este es el caso, a menudo necesitar� implementar esto usando
fraccionamiento

Por ejemplo, imagine que una tabla contiene datos de 6 a�os. Los datos para el a�o en curso 
se accede y se actualiza muchas veces al d�a. Datos de los 3 anteriores a�os se accede en los 
informes mensuales, pero aparte de eso, rara vez se toca. Datos hasta ahora como 6 a�os debe 
estar disponible al instante, si es necesario por razones reglamentarias, pero en pr�ctica, 
rara vez se accede a ella.

En el escenario que se acaba de describir, la partici�n podr�a usarse con particiones anuales. 
El grupo de archivos que contiene los datos del a�o actual podr�a consistir en archivos 
adjuntos localmente. RAID 10 LUN para un rendimiento �ptimo. 
Las particiones que contienen datos para los a�os 2 y 3 podr�a colocarse en el nivel premium 
del dispositivo SAN corporativo. Particiones para datos mayores de 3 a�os podr�an colocarse 
en almacenamiento de l�nea cercana dentro de la SAN, satisfaciendo as� requisitos reglamentarios
de la manera m�s rentable.

*/