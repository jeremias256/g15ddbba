-- PRUEBAS DEL STORED PROCEDURE: persona.InsertarSocio
-- DESCRIPCIÓN: Conjunto pruebas para validar el funcionamiento
-- AUTOR: GRUPO 15
-- FECHA: 24 de Junio de 2025
-- VERSIÓN: 1.0

USE Com2900G15;
GO

-- Limpiar datos de pruebas anteriores antes de comenzar.
--DELETE FROM actividad.InscripcionActividad;
GO

PRINT '*** PRUEBAS DEL SP actividad.InsertarInscripcionActividad ***';
PRINT '';
GO

PRINT '*** PRUEBAS EXITOSAS ***';
PRINT '';
GO
PRINT '*** PRUEBA 1: Inserción ***';
EXEC actividad.InsertarInscripcionActividad 
    @id_actividad = 1,
    @id_socio = 1,
    @fecha_inscripcion = '2025-06-01';
EXEC actividad.InsertarInscripcionActividad 
    @id_actividad = 1,
    @id_socio = 3,
    @fecha_inscripcion = '2025-06-01';


PRINT '';
PRINT '******************************************';
PRINT 'PRUEBAS COMPLETADAS EXITOSAMENTE';
PRINT '******************************************';
PRINT '';
PRINT '   RESUMEN DE CÓDIGOS DE ERROR:';
PRINT '   10  = El nro de la actividad no puede estar vacío.';
PRINT '   999 = Error interno';
GO