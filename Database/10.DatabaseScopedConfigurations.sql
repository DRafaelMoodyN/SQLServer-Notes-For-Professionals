-- ======================================================================================
-- Database Scoped Configurations || Configuracion de ambito de base de datos
-- ======================================================================================

-- Turn On Autogrow All Files || Activar el crecimiento automatico de los archivos

ALTER DATABASE Chapter6 MODIFY FILEGROUP [PRIMARY] AUTOGROW_ALL_FILES
GO

-- Turn Off Mixed Page Allocations || Desactivar asignacion de pag mixtas

ALTER DATABASE Chapter6 SET MIXED_PAGE_ALLOCATION OFF
GO