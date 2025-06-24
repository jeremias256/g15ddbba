-- PRUEBAS DEL STORED PROCEDURE: persona.InsertarSocio
-- DESCRIPCIÓN: Conjunto pruebas para validar el funcionamiento
-- AUTOR: GRUPO 15
-- FECHA: 24 de Junio de 2025
-- VERSIÓN: 1.0

USE Com2900G15;
GO

-- Limpiar datos de pruebas anteriores antes de comenzar.
--DELETE FROM actividad.Actividad;
GO

PRINT '*** PRUEBAS DEL SP actividad.InsertarActividad ***';
PRINT '';
PRINT 'REGLAS DE NEGOCIO:';
PRINT '- El nombre de la actividad debe ser único.';
PRINT '- La tarifa debe ser un valor positivo.';
PRINT '- La fecha de vigencia debe ser válida y no pasada.';
PRINT '';
PRINT '*** PRUEBAS EXITOSAS ***';
PRINT '';
GO
PRINT '*** PRUEBA 1: Inserción de actividad válida ***';
EXEC actividad.InsertarActividad 
    @nombre = 'Futsal',
    @tarifa = 25000.00,
    @fecha_vigencia = '2025-12-31';
GO
EXEC actividad.InsertarActividad 
    @nombre = 'Ajedrez',
    @tarifa = 2000.00,
    @fecha_vigencia = '2025-12-31';
GO
EXEC actividad.InsertarActividad 
    @nombre = 'Taekwondo',
    @tarifa = 25000.00,
    @fecha_vigencia = '2025-12-31';
GO
PRINT '*** PRUEBAS DE ERRORES ESPECÍFICOS ***';
PRINT '';
GO

-- ERROR COD 10 Nombre actividad vacío
EXEC actividad.InsertarActividad 
    @nombre = '',
    @tarifa = 25000.00,
    @fecha_vigencia = '2025-12-31';

-- ERROR COD 11 Nombre actividad duplicado
EXEC actividad.InsertarActividad 
    @nombre = 'Futsal',
    @tarifa = 25000.00,
    @fecha_vigencia = '2025-12-31';

PRINT '';
PRINT '******************************************';
PRINT 'PRUEBAS COMPLETADAS EXITOSAMENTE';
PRINT '******************************************';
PRINT '';
PRINT '   RESUMEN DE CÓDIGOS DE ERROR:';
PRINT '   10  = El nombre de la actividad no puede estar vacío.';
PRINT '   20  = La tarifa debe ser un valor positivo.';
PRINT '   30  = La fecha de vigencia no puede ser pasada.';
PRINT '   999 = Error interno';
GO