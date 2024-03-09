-- ======================================================================================
-- DataStorage || Almacenamiento de datos
-- ======================================================================================

/*

Dentro de una base de datos, los datos se almacenan en uno o m�s archivos de datos.
Estos archivos se agrupan en contenedores l�gicos llamados grupos de archivos. 
Cada base de datos tambi�n tiene al menos un archivo de registro.

Estructura de una base de datos

Una base de datos siempre consta de al menos un grupo de archivos:
Primary    .mdf 
Secundary  .ndf
Log        .ldf   

Primary    .mdf 
Puede cambiar esta extensi�n si lo desea, se puede usar para almacenar datos, metadatos, 
informaci�n de inicio y punteros a otros archivos dentro de la bd. 
El grupo de archivos que contiene el archivo principal se denomina filegroup primary.

Secundary  .ndf
Si se crean archivos adicionales dentro de la bd, se conocen como filegroup secondary
Puede cambiar esta extensi�n si lo desea. estos archivos se pueden crear en filegroup 
primary y/o en el secondary.
Son opcionales, pero pueden resultar muy �tiles para administradores de bases de datos.

Sugerencia 
Es una buena idea mantener las extensiones de archivo predeterminadas. No hay beneficios 
reales en usar diferentes extensiones y hacerlo agrega complejidad adicional.

*/
