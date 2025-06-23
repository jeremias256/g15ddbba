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

-- PRUEBA 2: Cadete válido (13-17)
PRINT '--- PRUEBA 2: Cadete válido (13-17) ---';
DECLARE @resultado INT;
DECLARE @mensaje NVARCHAR(500);

EXEC persona.InsertarCategoriaSocio 
    @nombre = 'CADETE',
    @edad_min = 13,
    @edad_max = 17,
    @fecha_vigencia = '2025-07-01',
    @tarifa_categoria = 2000.00,
    @resultado = @resultado OUTPUT,
    @mensaje = @mensaje OUTPUT;

PRINT 'Resultado: ' + CAST(@resultado AS NVARCHAR(10));
PRINT 'Mensaje: ' + @mensaje;
PRINT '';
GO

-- PRUEBA 3: Mayor válido (18-99)
PRINT '--- PRUEBA 3: Mayor válido (18-99) ---';
DECLARE @resultado INT;
DECLARE @mensaje NVARCHAR(500);

EXEC persona.InsertarCategoriaSocio 
    @nombre = 'MaYoR',
    @edad_min = 18,
    @edad_max = 99,
    @fecha_vigencia = '2025-07-01',
    @tarifa_categoria = 3000.00,
    @resultado = @resultado OUTPUT,
    @mensaje = @mensaje OUTPUT;

PRINT 'Resultado: ' + CAST(@resultado AS NVARCHAR(10));
PRINT 'Mensaje: ' + @mensaje;
PRINT '';
GO

-- ================================
-- PRUEBAS DE ERRORES ESPECÍFICOS
-- ================================
PRINT '=== PRUEBAS DE ERRORES ESPECÍFICOS ===';
PRINT '';
GO

-- ERROR -1: Nombre vacío
PRINT '--- ERROR -10: Nombre categoría vacío ---';
DECLARE @resultado INT;
DECLARE @mensaje NVARCHAR(500);

EXEC persona.InsertarCategoriaSocio 
    @nombre = '',
    @edad_min = 18,
    @edad_max = 65,
    @fecha_vigencia = '2025-07-01',
    @tarifa_categoria = 3000.00,
    @resultado = @resultado OUTPUT,
    @mensaje = @mensaje OUTPUT;

PRINT 'Resultado: ' + CAST(@resultado AS NVARCHAR(10));
PRINT 'Mensaje: ' + @mensaje;
PRINT '';
GO

-- ERROR -11: Nombre no permitido
PRINT '--- ERROR -11: Nombre no permitido ---';
DECLARE @resultado INT;
DECLARE @mensaje NVARCHAR(500);

EXEC persona.InsertarCategoriaSocio 
    @nombre = 'infantil',  -- ERROR: nombre no permitido
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

-- ERROR -12: Nombre duplicado
PRINT '--- ERROR -12: Nombre duplicado ---';
DECLARE @resultado INT;
DECLARE @mensaje NVARCHAR(500);

EXEC persona.InsertarCategoriaSocio 
    @nombre = 'MENOR',  -- Ya existe (case-insensitive)
    @edad_min = 0,
    @edad_max = 10,
    @fecha_vigencia = '2025-08-01',
    @tarifa_categoria = 1200.00,
    @resultado = @resultado OUTPUT,
    @mensaje = @mensaje OUTPUT;

PRINT 'Resultado: ' + CAST(@resultado AS NVARCHAR(10));
PRINT 'Mensaje: ' + @mensaje;
PRINT '';
GO

-- ERROR -21: Menor con edad_max > 12
PRINT '--- ERROR -21: Menor con edad_max > 12 ---';
DECLARE @resultado INT;
DECLARE @mensaje NVARCHAR(500);

EXEC persona.InsertarCategoriaSocio 
    @nombre = 'menor',
    @edad_min = 8,
    @edad_max = 15,  -- ERROR: debe ser <= 12
    @fecha_vigencia = '2025-07-01',
    @tarifa_categoria = 1500.00,
    @resultado = @resultado OUTPUT,
    @mensaje = @mensaje OUTPUT;

PRINT 'Resultado: ' + CAST(@resultado AS NVARCHAR(10));
PRINT 'Mensaje: ' + @mensaje;
PRINT '';
GO

-- ERROR -22: Cadete con edad_min < 13
PRINT '--- ERROR -22: Cadete con edad_min < 13 ---';
DECLARE @resultado INT;
DECLARE @mensaje NVARCHAR(500);

EXEC persona.InsertarCategoriaSocio 
    @nombre = 'cadete',
    @edad_min = 10,  -- ERROR: debe ser >= 13
    @edad_max = 16,
    @fecha_vigencia = '2025-07-01',
    @tarifa_categoria = 2000.00,
    @resultado = @resultado OUTPUT,
    @mensaje = @mensaje OUTPUT;

PRINT 'Resultado: ' + CAST(@resultado AS NVARCHAR(10));
PRINT 'Mensaje: ' + @mensaje;
PRINT '';
GO

-- ERROR -22: Cadete con edad_max > 17
PRINT '--- ERROR -23: Cadete con edad_max > 17 ---';
DECLARE @resultado INT;
DECLARE @mensaje NVARCHAR(500);

EXEC persona.InsertarCategoriaSocio 
    @nombre = 'cadete',
    @edad_min = 14,
    @edad_max = 20,  -- ERROR: debe ser <= 17
    @fecha_vigencia = '2025-07-01',
    @tarifa_categoria = 2000.00,
    @resultado = @resultado OUTPUT,
    @mensaje = @mensaje OUTPUT;

PRINT 'Resultado: ' + CAST(@resultado AS NVARCHAR(10));
PRINT 'Mensaje: ' + @mensaje;
PRINT '';
GO

-- ERROR -23: Mayor con edad_min < 18
PRINT '--- ERROR -10: Mayor con edad_min < 18 ---';
DECLARE @resultado INT;
DECLARE @mensaje NVARCHAR(500);

EXEC persona.InsertarCategoriaSocio 
    @nombre = 'mayor',
    @edad_min = 16,  -- ERROR: debe ser >= 18
    @edad_max = 65,
    @fecha_vigencia = '2025-07-01',
    @tarifa_categoria = 3000.00,
    @resultado = @resultado OUTPUT,
    @mensaje = @mensaje OUTPUT;

PRINT 'Resultado: ' + CAST(@resultado AS NVARCHAR(10));
PRINT 'Mensaje: ' + @mensaje;
PRINT '';
GO

-- ERROR -30: Fecha pasada
PRINT '--- ERROR -5: Fecha de vigencia pasada ---';
DECLARE @resultado INT;
DECLARE @mensaje NVARCHAR(500);

EXEC persona.InsertarCategoriaSocio 
    @nombre = 'mayor',
    @edad_min = 18,
    @edad_max = 65,
    @fecha_vigencia = '2024-01-01',  -- ERROR: fecha pasada
    @tarifa_categoria = 3000.00,
    @resultado = @resultado OUTPUT,
    @mensaje = @mensaje OUTPUT;

PRINT 'Resultado: ' + CAST(@resultado AS NVARCHAR(10));
PRINT 'Mensaje: ' + @mensaje;
PRINT '';
GO

-- ERROR -40: Tarifa inválida
PRINT '--- ERROR -40: Tarifa inválida ---';
DECLARE @resultado INT;
DECLARE @mensaje NVARCHAR(500);

EXEC persona.InsertarCategoriaSocio 
    @nombre = 'mayor',
    @edad_min = 18,
    @edad_max = 65,
    @fecha_vigencia = '2025-07-01',
    @tarifa_categoria = -100.00,  -- ERROR: debe ser > 0
    @resultado = @resultado OUTPUT,
    @mensaje = @mensaje OUTPUT;

PRINT 'Resultado: ' + CAST(@resultado AS NVARCHAR(10));
PRINT 'Mensaje: ' + @mensaje;
PRINT '';
GO

PRINT '';
PRINT '========================================';
PRINT 'PRUEBAS COMPLETADAS EXITOSAMENTE';
PRINT '========================================';
PRINT '';
PRINT '   RESUMEN DE CÓDIGOS DE ERROR:';
PRINT '   -10  = Nombre vacío';
PRINT '   -11  = Nombre no permitido';
PRINT '   -12  = Nombre duplicado';
PRINT '   -21  = MENOR: edad_max > 12';
PRINT '   -22  = CADETE: edad fuera de 13-17';
PRINT '   -23  = MAYOR: edad_min < 18';
PRINT '   -30  = Fecha de vigencia pasada';
PRINT '   -40  = Tarifa inválida';
PRINT '   -999 = Error interno';
GO