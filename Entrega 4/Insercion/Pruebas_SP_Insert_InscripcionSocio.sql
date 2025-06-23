-- Pruebas de Store Procedures - SolNorte
-- Este script ejecuta pruebas positivas y negativas para cada SP del sistema.
-- Cada bloque incluye comentarios sobre el caso y el resultado esperado.

USE SolNorte;
GO

-- Limpiar datos de pruebas anteriores antes de comenzar.
DELETE FROM persona.Inscripcion;
GO

PRINT '*** PRUEBAS DEL SP persona.InsertarCategoriaSocio ***';
PRINT '';
PRINT 'REGLAS DE NEGOCIO:';
PRINT '- FECHA: fecha debe ser válida y no futura';
PRINT '';
GO

PRINT '*** PRUEBAS EXITOSAS ***';
PRINT '';
GO

PRINT '*** PRUEBA 1: Fecha válida (hoy) ***';
EXEC persona.InsertarInscripcionSocio @fecha = '2025-06-20';
GO

PRINT '*** PRUEBAS DE ERRORES ESPECÍFICOS ***';
PRINT '';
GO

-- ERROR COD 10 Nombre categoría vacío
EXEC persona.InsertarCategoriaSocio @fecha = null;

-- ERROR COD 11 fecha categoría vacío
EXEC persona.InsertarCategoriaSocio @fecha = '2026-06-20';

GO

PRINT '';
PRINT '******************************************';
PRINT 'PRUEBAS COMPLETADAS EXITOSAMENTE';
PRINT '******************************************';
PRINT '';
PRINT '   RESUMEN DE CÓDIGOS DE ERROR:';
PRINT '   10  = Fecha vacía';
PRINT '   11  = Fecha no permitida';
PRINT '   12  = Fecha duplicada';