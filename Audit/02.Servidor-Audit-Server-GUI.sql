-- ========================================================================================================
-- Auditoria a nivel de Servidor
-- ========================================================================================================

/*
SQL Server Audit proporciona a los DBA la capacidad de capturar auditorías a nivel de instancia y de 
base de datos y guardar esta actividad en un archivo, Puede tener múltiples auditorías de servidor
en cada instancia. Esto es útil si tiene que auditar muchos eventos en un entorno ocupado,
ya que puede distribuir el IO utilizando un archivo como destino y colocando cada archivo de destino
en un volumen aparte.

Elegir el objetivo correcto es importante desde una perspectiva de seguridad.

Tipos de auditorias
1)File
El File de seguridad es mucho más seguro que la aplicación. 

2)Log
log pero también puede ser más complejo de configurar para SQL Server Audit. 

3)Application
Si tu escoges el registro  de la aplicación de Application como destino, entonces cualquier usuario 
de Windows que esté autenticado para el servidor puede acceder a él. 

La auditoría de SQL Server se puede asociar con una o más auditorías de servidor.
Las especificaciones definen las actividades que seran auditadas a nivel de instancia y a nivel de bd

// Recomendacion
Tener una especificacion para cada auditoria a nivel de base de datos

-----------------------------------------------------------------------------------------------------------
Create Audit con GUI, es el contenedor para nuestras auditorias a nivel de instancia y bd
Click Security-> Audits -> New

Audit name: nombre-de-la-auditoria

FILEPATH
Solo se aplica si elige un destino de archivo. Especifica la ruta del archivo, donde el
se generarán registros de auditoría

MAXSIZE
Solo se aplica si elige un destino de archivo. Especifica el tamaño más grande que el
archivo de auditoría puede crecer. El tamaño mínimo que puede especificar para esto es 2 MB

MAX_ROLLOVER_FILES
Solo se aplica si elige un destino de archivo. Cuando el archivo de auditoría se llena, usted
puede ciclar ese archivo o generar un nuevo archivo. Los MAX_ROLLOVER_FILES
La configuración controla cuántos archivos nuevos se pueden generar antes de que comiencen a
ciclo. El valor predeterminado es ILIMITADO, pero especificar un número limita el
número de archivos hasta este límite. Si lo establece en 0, entonces solo habrá uno.
archivo, y ciclará cada vez que se llene. Cualquier valor por encima de 0 indica
el número de archivos de transferencia que se permitirán. Entonces, por ejemplo, si especifica 5,
entonces habrá un máximo de seis archivos en total

AX_FILES
Solo se aplica si elige un destino de archivo. Como alternativa a MAX_
ROLLOVER_FILES, la configuración MAX_FILES especifica un límite para el número
de archivos de auditoría que se pueden generar, pero cuando se alcanza este número, el
los registros no ciclarán. En cambio, la auditoría falla y los eventos que provocan una auditoría
la acción que se va a producir se gestiona en función de la configuración de ON_FAILURE

RESERVE_DISK_SPACE
Solo se aplica si elige un destino de archivo. Preasignar espacio en el volumen
igual al valor establecido en MAXSIZE, en lugar de permitir que el registro de auditoría
crecer según sea necesario

QUEUE_DELAY
Especifica si los eventos de auditoría se escriben de forma síncrona o asíncrona. Si está configurado
a 0, los eventos se escriben en el registro de forma síncrona. De lo contrario, especifica el
duración en milisegundos que puede transcurrir antes de que se fuerce la escritura de eventos.
El valor predeterminado es 1000 (1 segundo), que también es el valor mínimo.

ON_FAILURE ¿ Que pasa si el archivo de aditoria falla?
Especifica lo que debe suceder si los eventos que provocan una acción de auditoría no se pueden
auditado al registro. Los valores aceptables son:

CONTINUE 
La operacion seguira, esto puede llevar a que se predusca una actividad no auditada.

SHUT DOWN SERVER 
Obliga a la instancia a detenerse si no se pueden escribir eventos auditables al registro, y se 
habilitar hasta que la auditoria vuelva activarse.

FAIL_OPERATION
Hace que los eventos auditables fallen, pero permite que continúen otras acciones.

AUDIT_GUID
Debido a que las especificaciones de auditoría del servidor y la base de datos se vinculan con el 
servidor auditoría a través de un GUID, hay ocasiones en que una especificación de auditoría puede 
quedar huérfano. Esto incluye cuando adjunta una base de datos a un instancia o cuando implementa 
tecnologías como la creación de reflejo de la base de datos. Esta opción le permite especificar un
GUID específico para la auditoría del servido

// Nota
Cuando se crea la auditoria hay que habilitarla
-----------------------------------------------------------------------------------------------------------

Create Server Audit Specifications con GUI
Click Security-> Server Audit Specifications -> New

// Nota
Cuando se crea la auditoria hay que habilitarla

Aunque hemos creado la auditoría del servidor y la especificación de auditoría del servidor, necesitamos
para habilitarlos antes de que se comience a recopilar cualquier dato

// Documentacion sobre los grupos de auditorias
https://learn.microsoft.com/es-es/sql/relational-databases/security/auditing/sql-server-audit-action-groups-and-actions?view=sql-server-ver16
*/

