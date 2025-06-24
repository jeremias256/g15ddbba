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

PRINT '*** PRUEBAS DEL SP actividad.InsertarSum ***';
PRINT '';
PRINT 'REGLAS DE NEGOCIO:';
PRINT '- La fecha no debe ser nula o anterior a la fecha actual.';
PRINT '- La hora de fin debe ser posterior a la hora de inicio.';
PRINT '- La tarifa debe ser un valor positivo.';
PRINT '';
GO

PRINT '*** PRUEBAS EXITOSAS ***';
PRINT '';
GO

PRINT '*** PRUEBA 1: Inserción de sum válida ***';
EXEC actividad.InsertarSum
    @fecha = '2025-12-24',
    @hora_inicio = '08:00',
    @hora_fin = '10:00',
    @tarifa = 250000.00;

EXEC actividad.InsertarSum
    @fecha = '2025-12-31',
    @hora_inicio = '08:00',
    @hora_fin = '10:00',
    @tarifa = 300000.00;

PRINT '*** PRUEBAS DE ERRORES ESPECÍFICOS ***';
PRINT '';
GO

PRINT '';
PRINT '******************************************';
PRINT 'PRUEBAS COMPLETADAS EXITOSAMENTE';
PRINT '******************************************';
PRINT '';
PRINT '   RESUMEN DE CÓDIGOS DE ERROR:';
PRINT '   10  = La fecha no puede ser nula o anterior a la fecha actual.';
PRINT '   11  = La hora de fin debe ser posterior a la hora de inicio.';
PRINT '   20  = La tarifa debe ser un valor positivo.';
PRINT '   999 = Error interno';
GO