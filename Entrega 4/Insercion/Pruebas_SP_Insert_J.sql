-- PRUEBAS DEL STORED PROCEDURE: persona.InsertarCategoriaSocio
-- DESCRIPCIÓN: Conjunto pruebas para validar el funcionamiento
-- AUTOR: GRUPO 15
-- FECHA: 22 de Junio de 2025
-- VERSIÓN: 1.0

USE Com2900G15;
GO

-- Limpiar datos de pruebas anteriores (opcional)
-- DELETE FROM persona.Categoria WHERE nombre IN ('Mayor', 'Cadete', 'Menor');

PRINT '========================================';
PRINT 'PRUEBAS DEL SP persona.InsertarCategoriaSocio';
PRINT '========================================';
PRINT 'REGLAS DE NEGOCIO:';
PRINT '- MENOR: edad_max <= 12';
PRINT '- CADETE: edad_min >= 13 AND edad_max <= 17';
PRINT '- MAYOR: edad_min >= 18';
PRINT '- Solo nombres: "mayor", "cadete", "menor"';
PRINT '';
GO

-- ================================
-- PRUEBAS EXITOSAS
-- ================================
PRINT '=== PRUEBAS EXITOSAS ===';
PRINT '';
GO

-- PRUEBA 1: Menor válido (6-12)
PRINT '--- PRUEBA 1: Menor válido (6-12) ---';
DECLARE @resultado INT = 0;
DECLARE @mensaje NVARCHAR(500) = '';

EXEC persona.InsertarCategoriaSocio 
    @nombre = 'menor',
    @edad_min = 6,
    @edad_max = 12,
    @fecha_vigencia = '2025-07-01',
    @tarifa_categoria = 1500.00,
    @resultado = @resultado OUTPUT,
    @mensaje = @mensaje OUTPUT;

PRINT 'Resultado: ' + CAST(@resultado AS NVARCHAR(10));
PRINT 'Mensaje: ' + @mensaje;
PRINT '';
GO
