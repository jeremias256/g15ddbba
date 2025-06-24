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
PRINT '*** CARGA DE LA TABLA persona.Inscripcion ***';
PRINT '';
PRINT 'REGLAS DE NEGOCIO:';
PRINT '- FECHA: fecha debe ser válida y no futura';
PRINT '';
PRINT '*** PRUEBAS EXITOSAS ***';
PRINT '';
PRINT '*** PRUEBA 1: Fecha válida (hoy) ***';
EXEC persona.InsertarInscripcionSocio @fecha = '2025-06-20';
GO
EXEC persona.InsertarInscripcionSocio @fecha = '2025-06-21';
GO
EXEC persona.InsertarInscripcionSocio @fecha = '2025-06-22';
GO
PRINT '*** FIN DE LA CARGA DE LA TABLA persona.Inscripcion ***';

--2
PRINT '*** CARGA DE LA TABLA persona.CategoriaSocio ***';
PRINT '';
PRINT 'REGLAS DE NEGOCIO:';
PRINT '- MENOR: edad_max <= 12';
PRINT '- CADETE: edad_min >= 13 AND edad_max <= 17';
PRINT '- MAYOR: edad_min >= 18';
PRINT '- Solo nombres: "mayor", "cadete", "menor"';
PRINT '';
PRINT '*** PRUEBAS EXITOSAS ***';
PRINT '';
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
PRINT '*** FIN DE LA CARGA DE LA TABLA persona.CategoriaSocio ***';

--3
PRINT '*** CARGA DE LA TABLA persona.Socio ***';
PRINT '';
PRINT 'REGLAS DE NEGOCIO:';
PRINT '- El número de socio debe ser único.';
PRINT '- El DNI debe ser válido y no duplicado.';
PRINT '- La fecha de nacimiento debe ser válida y no futura.';
PRINT '';
PRINT '*** PRUEBAS EXITOSAS ***';
PRINT '';
PRINT '*** PRUEBA 1: Inserción de socio MAYOR válido ***';
GO
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
PRINT '*** FIN DE LA CARGA DE LA TABLA persona.Socio ***';

--4
PRINT '*** CARGA DE LA TABLA actividad.Actividad ***';
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
PRINT '*** FIN DE LA CARGA DE LA TABLA actividad.Actividad ***';

--5
PRINT '*** CARGA DE LA TABLA actividad.InscripcionActividad ***';
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
PRINT '*** FIN CARGA DE LA TABLA actividad.InscripcionActividad ***';

--6
PRINT '*** CARGA DE LA TABLA actividad.Colonia ***';
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
PRINT '*** FIN CARGA DE LA TABLA actividad.Colonia ***';

--7
PRINT '*** CARGA DE LA TABLA actividad.InscripcionColonia ***';
PRINT '*** PRUEBAS EXITOSAS ***';
PRINT '';
GO

PRINT '*** PRUEBA 1: Inserción ***';
EXEC actividad.InsertarInscripcionColonia 
    @id_colonia = 2,
    @id_socio = 1,
    @fecha_inscripcion = '2025-06-01';
EXEC actividad.InsertarInscripcionColonia 
    @id_colonia = 2,
    @id_socio = 3,
    @fecha_inscripcion = '2025-06-01';
PRINT '*** FIN DE LA CARGA DE LA TABLA actividad.InscripcionColonia ***';

--8
PRINT '*** CARGA DE LA TABLA actividad.Sums ***';
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
PRINT '*** FIN DE LA CARGA DE LA TABLA actividad.Sums ***';

--9
PRINT '*** CARGA DE LA TABLA actividad.Reserva ***';
PRINT '*** PRUEBAS EXITOSAS ***';
PRINT '';
GO

PRINT '*** PRUEBA 1: Inserción ***';
EXEC actividad.InsertarReserva
    @id_sum = 1,
    @id_socio = 1,
    @fecha_inscripcion = '2025-06-01';
EXEC actividad.InsertarReserva
    @id_sum = 2,
    @id_socio = 3,
    @fecha_inscripcion = '2025-06-01';
PRINT '*** FIN DE LACARGA DE LA TABLA actividad.Reserva ***';