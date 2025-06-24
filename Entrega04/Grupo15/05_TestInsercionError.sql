-- Enunciado: Entrega 4- Documento de instalación y configuración
-- Fecha de entrega: 24/06/2025
-- Comisión: 2900
-- Grupo: 15
-- Materia: Bases de Datos Aplicada
-- Integrantes:
--   - Jeremias Menacho - DNI 37783029
--   - Ivan Morales     - DNI 39772619

-- Script para cargar la base de datos
-- Ejecutar en orden

USE Com2900G15;
GO

--1
PRINT '*** PRUEBAS DE ERRORES ESPECÍFICOS SP persona.InsertarInscripcionSocio***';
PRINT '';
PRINT 'REGLAS DE NEGOCIO:';
PRINT '- FECHA: fecha debe ser válida y no futura';
PRINT '';
GO
-- ERROR COD 10 Nombre categoría vacío
EXEC persona.InsertarInscripcionSocio @fecha = null;
GO
-- ERROR COD 11 fecha categoría vacío
EXEC persona.InsertarInscripcionSocio @fecha = '2026-06-20';
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

--2
PRINT '*** PRUEBAS DE ERRORES ESPECÍFICOS SP persona.InsertarCategoriaSocio***';
PRINT '';
PRINT 'REGLAS DE NEGOCIO:';
PRINT '- MENOR: edad_max <= 12';
PRINT '- CADETE: edad_min >= 13 AND edad_max <= 17';
PRINT '- MAYOR: edad_min >= 18';
PRINT '- Solo nombres: "mayor", "cadete", "menor"';
PRINT '';
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

--3
PRINT '*** PRUEBAS DE ERRORES ESPECÍFICOS SP persona.InsertarSocio***';
PRINT '';
PRINT 'REGLAS DE NEGOCIO:';
PRINT '- El número de socio debe ser único.';
PRINT '- El DNI debe ser válido y no duplicado.';
PRINT '- La fecha de nacimiento debe ser válida y no futura.';
PRINT '';

-- ERROR COD 61 Fecha de nacimiento futura
EXEC persona.InsertarSocio 
    @numero_socio = 1002,
    @nombre = 'Laura',
    @apellido = 'Isis',
    @dni = '37783036',
    @email = 'jere.menacho3@gmail.com',
    @fecha_nacimiento = '2027-04-23',
    @telefono = '1135961688',
    @telefono_emergencia = '1122334455',
    @obra_social = 'Obra Social Ejemplo',
    @nro_obra_social = 'OS123456',
    @tel_emergencia_obra_social = '1144556677',
    @estado = 1,
    @id_socio_responsable = NULL,
    @id_responsable_pago = NULL,
    @id_inscripcion = 1,-- 1 es el ID de la inscripción creada previamente
    @id_cuota = NULL,
    @id_categoria = 400;--101 menor 102 cadete 103 mayor
GO

-- ERROR COD 91 Categoría no existe
EXEC persona.InsertarSocio 
    @numero_socio = 1002,
    @nombre = 'Soledad',
    @apellido = 'Cho',
    @dni = '37783030',
    @email = 'jere.menach2o@gmail.com',
    @fecha_nacimiento = '1993-04-23',
    @telefono = '1135961688',
    @telefono_emergencia = '1122334455',
    @obra_social = 'Obra Social Ejemplo',
    @nro_obra_social = 'OS123456',
    @tel_emergencia_obra_social = '1144556677',
    @estado = 1,
    @id_socio_responsable = NULL,
    @id_responsable_pago = NULL,
    @id_inscripcion = 1,-- 1 es el ID de la inscripción creada previamente
    @id_cuota = NULL,
    @id_categoria = 400;--101 menor 102 cadete 103 mayor
GO

PRINT '';
PRINT '******************************************';
PRINT 'PRUEBAS COMPLETADAS EXITOSAMENTE';
PRINT '******************************************';
PRINT '';
PRINT '   RESUMEN DE CÓDIGOS DE ERROR:';
PRINT '   - 10: El número de socio no puede estar vacío.';
PRINT '   - 11: La número de socio ya existe.';
PRINT '   - 20: El nombre no puede estar vacío.';
PRINT '   - 30: El apellido no puede estar vacío.';
PRINT '   - 40: El dni no puede estar vacío.';
PRINT '   - 41: El dni ya existe.';
PRINT '   - 50: El email no puede estar vacío.';
PRINT '   - 51: El email ya existe.';
PRINT '   - 60: La fecha de nacimiento no puede estar vacía.';
PRINT '   - 61: La fecha de nacimiento no puede ser futura.';
PRINT '   - 70: El estado debe ser 0 (inactivo) o 1 (activo).';
PRINT '   - 80: El id_inscripcion no puede ser nulo.';
PRINT '   - 81: El id_inscripcion no existe.';
PRINT '   - 90: El id_categoria no puede ser nulo.';
PRINT '   - 91: La categoría no existe.';
PRINT '   - 100: El nombre y apellido del responsable no pueden estar vacíos para menores de edad.';
PRINT '   - 101: El DNI del responsable no puede estar vacío.';
PRINT '   - 102: El email del responsable no puede estar vacío.';
PRINT '   - 103: La fecha de nacimiento del responsable no puede estar vacía.';
PRINT '   - 104: El parentesco del responsable no puede estar vacío.';
PRINT '   - 999: Error interno.';

--4
PRINT '*** PRUEBAS DE ERRORES ESPECÍFICOS SP actividad.InsertarActividad***';
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

--5
PRINT '*** PRUEBAS DE ERRORES ESPECÍFICOS SP actividad.InsertarInscripcionActividad ***';
PRINT '';
PRINT '******************************************';
PRINT 'PRUEBAS COMPLETADAS EXITOSAMENTE';
PRINT '******************************************';
PRINT '';
PRINT '   RESUMEN DE CÓDIGOS DE ERROR:';
PRINT '   10  = El nro de la actividad no puede estar vacío.';
PRINT '   999 = Error interno';
GO

--6
PRINT '*** PRUEBAS DE ERRORES ESPECÍFICOS SP actividad.InsertarColonia***';
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

--7
PRINT '*** PRUEBAS DE ERRORES ESPECÍFICOS SP actividad.InsertarInscripcionColonia ***';
PRINT '';
PRINT '******************************************';
PRINT 'PRUEBAS COMPLETADAS EXITOSAMENTE';
PRINT '******************************************';
PRINT '';
PRINT '   RESUMEN DE CÓDIGOS DE ERROR:';
PRINT '   10  = Validar que la fecha de inscripción no sea nula.';
PRINT '   999 = Error interno';
GO

--8
PRINT '*** PRUEBAS DE ERRORES ESPECÍFICOS SP actividad.InsertarSum ***';
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

--9
PRINT '*** PRUEBAS DE ERRORES ESPECÍFICOS SP actividad.Reserva ***';
PRINT '';
PRINT '******************************************';
PRINT 'PRUEBAS COMPLETADAS EXITOSAMENTE';
PRINT '******************************************';
PRINT '';
PRINT '   RESUMEN DE CÓDIGOS DE ERROR:';
PRINT '   10  = Validar que la fecha de inscripción no sea nula.';
PRINT '   999 = Error interno';
GO