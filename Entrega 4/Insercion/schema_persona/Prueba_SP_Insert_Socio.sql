-- PRUEBAS DEL STORED PROCEDURE: persona.InsertarSocio
-- DESCRIPCIÓN: Conjunto pruebas para validar el funcionamiento
-- AUTOR: GRUPO 15
-- FECHA: 22 de Junio de 2025
-- VERSIÓN: 1.0

USE Com2900G15;
GO

-- Limpiar datos de pruebas anteriores antes de comenzar.
--DELETE FROM persona.Socio;
GO 

PRINT '*** PRUEBAS DEL SP persona.InsertarSocio ***';
PRINT '';
PRINT 'REGLAS DE NEGOCIO:';
PRINT '- El número de socio debe ser único.';
PRINT '- El DNI debe ser válido y no duplicado.';
PRINT '- La fecha de nacimiento debe ser válida y no futura.';
PRINT '';
GO

PRINT '*** PRUEBAS EXITOSAS ***';
PRINT '';
GO

PRINT '*** PRUEBA 1: Inserción de socio MAYOR válido ***';
EXEC persona.InsertarSocio 
    @numero_socio = 1004,
    @nombre = 'Juan',
    @apellido = 'Pérez',
    @dni = '37783029',
    @email = 'jere12.menacho@gmail.com',
    @fecha_nacimiento = '1990-01-01',
    @telefono = '1135961687',
    @telefono_emergencia = '1122334455',
    @obra_social = 'Obra Social Ejemplo',
    @nro_obra_social = 'OS123456',
    @tel_emergencia_obra_social = '1144556677',
    @estado = 1,
    @id_socio_responsable = NULL,
    @id_responsable_pago = NULL,
    @id_inscripcion = 1,-- 1 es el ID de la inscripción creada previamente
    @id_cuota = NULL,
    @id_categoria = 102;--101 menor 102 cadete 103 mayor
GO

PRINT '*** PRUEBA 2: Inserción de socio válido MENOR de edad + su responsable de pago***';
EXEC persona.InsertarSocio 
    @numero_socio = 1001,
    @nombre = 'Tiago',
    @apellido = 'Menacho',
    @dni = '45783029',
    @email = 'jere.menacho@gmail.com',
    @fecha_nacimiento = '2010-01-01',
    @telefono = '1135961687',
    @telefono_emergencia = '1122334455',
    @obra_social = 'Obra Social Ejemplo',
    @nro_obra_social = 'OS123456',
    @tel_emergencia_obra_social = '1144556677',
    @estado = 1,
    @id_socio_responsable = NULL,
    @id_responsable_pago = NULL,
    @id_inscripcion = 1,-- 1 es el ID de la inscripción creada previamente
    @id_cuota = NULL,
    @id_categoria = 102,--101 menor 102 cadete 103 mayor
    --DATOS SI EL SOCIO ES MENOR DE EDAD, CARGAMOS DATOS DEL RESPONSABLE
    @nombre_responsable = 'Pedro',
    @apellido_responsable = 'Menacho',
    @dni_responsable = '12345678',
    @email_responsable = 'pedro.menacho@gmail.com',
    @fecha_nacimiento_responsable = '1980-01-01',
    @telefono_responsable = '1122334455',
    @parentesco = 'Padre';
GO

PRINT '*** PRUEBA 3: Inserción de socio MENOR con socio responsable ***';
EXEC persona.InsertarSocio 
    @numero_socio = 1005,
    @nombre = 'Hijo',
    @apellido = 'Pérez',
    @dni = '55783029',
    @email = 'hijo.menacho@gmail.com',
    @fecha_nacimiento = '2020-01-01',
    @telefono = '1135961687',
    @telefono_emergencia = '1122334455',
    @obra_social = 'Obra Social Ejemplo',
    @nro_obra_social = 'OS123456',
    @tel_emergencia_obra_social = '1144556677',
    @estado = 1,
    @id_socio_responsable = 2,
    @id_responsable_pago = NULL,
    @id_inscripcion = 1,-- 1 es el ID de la inscripción creada previamente
    @id_cuota = NULL,
    @id_categoria = 101;--101 menor 102 cadete 103 mayor
GO



PRINT '*** PRUEBAS DE ERRORES ESPECÍFICOS ***';
PRINT '';
GO

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