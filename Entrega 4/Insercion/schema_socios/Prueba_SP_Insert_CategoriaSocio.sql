-- PRUEBAS DEL STORED PROCEDURE: persona.InsertarCategoriaSocio
-- DESCRIPCIÓN: Conjunto pruebas para validar el funcionamiento
-- AUTOR: GRUPO 15
-- FECHA: 22 de Junio de 2025
-- VERSIÓN: 1.0

USE Com2900G15;
GO

-- Limpiar datos de pruebas anteriores antes de comenzar.
DELETE FROM persona.Categoria WHERE nombre IN ('Mayor', 'Cadete', 'Menor');
GO

PRINT '*** PRUEBAS DEL SP persona.InsertarCategoriaSocio ***';
PRINT '';
PRINT 'REGLAS DE NEGOCIO:';
PRINT '- MENOR: edad_max <= 12';
PRINT '- CADETE: edad_min >= 13 AND edad_max <= 17';
PRINT '- MAYOR: edad_min >= 18';
PRINT '- Solo nombres: "mayor", "cadete", "menor"';
PRINT '';
GO

PRINT '*** PRUEBAS EXITOSAS ***';
PRINT '';
GO

PRINT '*** PRUEBA 1: Menor válido (6-12) ***';
EXEC persona.InsertarCategoriaSocio 
    @nombre = 'menor',
    @edad_min = 6,
    @edad_max = 12,
    @fecha_vigencia = '2025-12-25',
    @tarifa_categoria = 10000.00
GO

PRINT '*** PRUEBA 2: Cadete válido (13-17) ***';
EXEC persona.InsertarCategoriaSocio 
    @nombre = 'CADETE',
    @edad_min = 13,
    @edad_max = 17,
    @fecha_vigencia = '2025-12-25',
    @tarifa_categoria = 15000.00
GO

PRINT '*** PRUEBA 3: Mayor válido (18-99) ***';
EXEC persona.InsertarCategoriaSocio 
    @nombre = 'MaYoR',
    @edad_min = 18,
    @edad_max = 99,
    @fecha_vigencia = '2025-12-25',
    @tarifa_categoria = 25000.00
GO


PRINT '*** PRUEBAS DE ERRORES ESPECÍFICOS ***';
PRINT '';
GO

-- ERROR COD 10 Nombre categoría vacío
EXEC persona.InsertarCategoriaSocio 
    @nombre = '',
    @edad_min = 18,
    @edad_max = 65,
    @fecha_vigencia = '2025-12-25',
    @tarifa_categoria = 25000.00
GO

-- ERROR 11: Nombre no permitido
EXEC persona.InsertarCategoriaSocio 
    @nombre = 'infantil',  -- ERROR: nombre no permitido
    @edad_min = 6,
    @edad_max = 12,
    @fecha_vigencia = '2025-12-25',
    @tarifa_categoria = 1.00
GO

-- ERROR 12: Nombre duplicado
EXEC persona.InsertarCategoriaSocio 
    @nombre = 'MENOR', 
    @edad_min = 0,
    @edad_max = 10,
    @fecha_vigencia = '2025-12-25',
    @tarifa_categoria = 10000.00
GO

-- ERROR 21: Menor con edad_max > 12
EXEC persona.InsertarCategoriaSocio 
    @nombre = 'menor',
    @edad_min = 8,
    @edad_max = 15,  -- ERROR: debe ser <= 12
    @fecha_vigencia = '2025-12-25',
    @tarifa_categoria = 10000.00
GO

-- ERROR 22: Cadete con edad_min < 13
EXEC persona.InsertarCategoriaSocio 
    @nombre = 'cadete',
    @edad_min = 10,  -- ERROR: debe ser >= 13
    @edad_max = 16,
    @fecha_vigencia = '2025-12-25',
    @tarifa_categoria = 15000.00
GO

-- ERROR 22: Cadete con edad_max > 17
EXEC persona.InsertarCategoriaSocio 
    @nombre = 'cadete',
    @edad_min = 14,
    @edad_max = 20,  -- ERROR: debe ser <= 17
    @fecha_vigencia = '2025-12-25',
    @tarifa_categoria = 15000.00
GO

-- ERROR 23: Mayor con edad_min < 18
EXEC persona.InsertarCategoriaSocio 
    @nombre = 'mayor',
    @edad_min = 16,  -- ERROR: debe ser >= 18
    @edad_max = 65,
    @fecha_vigencia = '2025-12-25',
    @tarifa_categoria = 25000.00
GO

-- ERROR 30: Fecha pasada
EXEC persona.InsertarCategoriaSocio 
    @nombre = 'mayor',
    @edad_min = 18,
    @edad_max = 65,
    @fecha_vigencia = '2024-01-01',  -- ERROR: fecha pasada
    @tarifa_categoria = 25000.00
GO

-- ERROR 40: Tarifa inválida
EXEC persona.InsertarCategoriaSocio 
    @nombre = 'mayor',
    @edad_min = 18,
    @edad_max = 65,
    @fecha_vigencia = '2025-12-25',
    @tarifa_categoria = -25000.00  -- ERROR: debe ser > 0
GO

PRINT '';
PRINT '******************************************';
PRINT 'PRUEBAS COMPLETADAS EXITOSAMENTE';
PRINT '******************************************';
PRINT '';
PRINT '   RESUMEN DE CÓDIGOS DE ERROR:';
PRINT '   10  = Nombre vacío';
PRINT '   11  = Nombre no permitido';
PRINT '   12  = Nombre duplicado';
PRINT '   21  = MENOR: edad_max > 12';
PRINT '   22  = CADETE: edad fuera de 13-17';
PRINT '   23  = MAYOR: edad_min < 18';
PRINT '   30  = Fecha de vigencia pasada';
PRINT '   40  = Tarifa inválida';
PRINT '   999 = Error interno';
GO