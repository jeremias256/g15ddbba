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

PRINT '*** PRUEBAS DEL SP actividad.InsertarColonia ***';
PRINT '';
PRINT 'REGLAS DE NEGOCIO:';
PRINT '- El nombre de la colonia debe ser único.';
PRINT '- La fecha de inicio y fin no deben ser nulas.';
PRINT '- La fecha de inicio debe ser anterior a la de fin.';
PRINT '- La tarifa debe ser un valor positivo.';
PRINT '';
GO

PRINT '*** PRUEBAS EXITOSAS ***';
PRINT '';
GO

PRINT '*** PRUEBA 1: Inserción de colonia válida ***';
EXEC actividad.InsertarColonia
    @nombre = 'Colonia de Verano',
    @fecha_inicio = '2026-01-01',
    @fecha_fin = '2026-01-31',
    @tarifa = 15000.00;
EXEC actividad.InsertarColonia
    @nombre = 'Colonia de Invierno',
    @fecha_inicio = '2026-06-01',
    @fecha_fin = '2026-06-30',
    @tarifa = 25000.00;

PRINT '';
PRINT '*** PRUEBAS DE ERRORES ESPECÍFICOS ***';
PRINT '';
GO

-- ERROR COD 10 Nombre colonia vacío
EXEC actividad.InsertarColonia
    @nombre = '',
    @tarifa = 25000.00,
    @fecha_inicio = '2025-12-31',
    @fecha_fin = '2025-12-31';

-- ERROR COD 11 Nombre colonia duplicado
EXEC actividad.InsertarColonia 
    @nombre = 'Colonia de Verano',
    @tarifa = 15000.00,
    @fecha_inicio = '2026-01-01',
    @fecha_fin = '2026-01-31';

PRINT '';
PRINT '******************************************';
PRINT 'PRUEBAS COMPLETADAS EXITOSAMENTE';
PRINT '******************************************';
PRINT '';
PRINT '   RESUMEN DE CÓDIGOS DE ERROR:';
PRINT '   10  = El nombre de la colonia no puede estar vacío.';
PRINT '   11  = El nombre de la colonia ya existe.';
PRINT '   20  = Las fechas de inicio y fin no pueden estar vacías.';
PRINT '   21  = La fecha de fin debe ser posterior a la de inicio.';
PRINT '   30  = La tarifa debe ser un valor positivo.';
PRINT '   999 = Error interno';
GO