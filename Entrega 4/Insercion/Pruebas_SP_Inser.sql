-- Pruebas de Store Procedures - SolNorte
-- Este script ejecuta pruebas positivas y negativas para cada SP del sistema.
-- Cada bloque incluye comentarios sobre el caso y el resultado esperado.

USE SolNorte;
GO

-- =====================
-- 1. Insertar Rol
-- =====================
PRINT '==== USUARIOS - usp_InsertarRol - Caso positivo ====';
EXEC usuarios.usp_InsertarRol @nombre = 'Administrador', @descripcion = 'Rol con todos los permisos';
PRINT '==== FIN USUARIOS - usp_InsertarRol - Caso positivo ====';
PRINT '';

PRINT '==== USUARIOS - usp_InsertarRol - Caso negativo ====';
PRINT 'Se espera error: No se puede insertar un rol con nombre duplicado (Administrador).';
EXEC usuarios.usp_InsertarRol @nombre = 'Administrador', @descripcion = 'Otro desc';
PRINT '==== FIN USUARIOS - usp_InsertarRol - Caso negativo ====';
PRINT '';

-- =====================
-- 2. Insertar Usuario
-- =====================
DECLARE @id_rol INT = (SELECT TOP 1 id_rol FROM usuarios.Rol WHERE nombre = 'Administrador');

PRINT '==== USUARIOS - usp_InsertarUsuario - Caso positivo ====';
EXEC usuarios.usp_InsertarUsuario 
    @usuario = 'usuario1',
    @contraseña = 'pass123',
    @fecha_vigencia_contraseña = '2025-12-31',
    @id_rol = @id_rol;
PRINT '==== FIN USUARIOS - usp_InsertarUsuario - Caso positivo ====';
PRINT '';

PRINT '==== USUARIOS - usp_InsertarUsuario - Caso negativo ====';
PRINT 'Se espera error: No se puede insertar un usuario con nombre duplicado (usuario1).';
EXEC usuarios.usp_InsertarUsuario 
    @usuario = 'usuario1',
    @contraseña = 'pass123',
    @fecha_vigencia_contraseña = '2025-12-31',
    @id_rol = @id_rol;
PRINT '==== FIN USUARIOS - usp_InsertarUsuario - Caso negativo ====';
PRINT '';

-- =====================
-- 3. Insertar Categoría Socio
-- =====================
DECLARE @resultado INT;

PRINT '==== SOCIOS - categoria_insertar - Caso positivo ====';
EXEC socios.categoria_insertar 
    @nombre = 'Menor',
    @edad_min = 0,
    @edad_max = 17,
    @costo_membresia = 1000,
    @fecha_vigencia = '2025-01-01',
    @resultado = @resultado OUTPUT;
IF @resultado > 0
    PRINT 'Resultado OK: id_categoria insertado = ' + CAST(@resultado AS NVARCHAR);
ELSE
    PRINT 'ERROR: resultado = ' + CAST(@resultado AS NVARCHAR);
PRINT '==== FIN SOCIOS - categoria_insertar - Caso positivo ====';
PRINT '';

PRINT '==== SOCIOS - categoria_insertar - Caso negativo ====';
PRINT 'Se espera error: No se puede insertar una categoría con nombre duplicado (Menor).';
EXEC socios.categoria_insertar 
    @nombre = 'Menor',
    @edad_min = 0,
    @edad_max = 17,
    @costo_membresia = 1000,
    @fecha_vigencia = '2025-01-01',
    @resultado = @resultado OUTPUT;
IF @resultado = -3
    PRINT 'Resultado OK: Se detectó nombre duplicado (resultado = -3)';
ELSE
    PRINT 'ERROR: resultado inesperado = ' + CAST(@resultado AS NVARCHAR);
PRINT '==== FIN SOCIOS - categoria_insertar - Caso negativo ====';
PRINT '';

-- =====================
-- 4. Insertar Usuario para Socio
-- =====================
PRINT '==== USUARIOS - usp_InsertarUsuario (para Socio) ====';
DECLARE @id_usuario_socio INT;
EXEC usuarios.usp_InsertarUsuario 
    @usuario = 'socio1',
    @contraseña = 'pass123',
    @fecha_vigencia_contraseña = '2025-12-31',
    @id_rol = @id_rol;
SELECT @id_usuario_socio = id_usuario FROM usuarios.Usuario WHERE usuario = 'socio1';
PRINT '==== FIN USUARIOS - usp_InsertarUsuario (para Socio) ====';
PRINT '';

-- =====================
-- 5. Insertar Socio
-- =====================
DECLARE @id_categoria INT = (SELECT TOP 1 id_categoria FROM socios.CategoriaSocio WHERE nombre = 'Menor');

PRINT '==== SOCIOS - usp_InsertarSocio - Caso positivo ====';
EXEC socios.usp_InsertarSocio 
    @numero_socio = 'S001',
    @id_usuario = @id_usuario_socio,
    @nombre = 'Juan',
    @apellido = 'Pérez',
    @dni = '12345678',
    @email = 'juan@mail.com',
    @fecha_nacimiento = '2010-05-01',
    @telefono = '1234',
    @telefono_emergencia = '5678',
    @obra_social = 'OSDE',
    @nro_obra_social = 'OS123',
    @tel_emergencia_obra_social = '9999',
    @id_categoria = @id_categoria,
    @responsable_id = NULL,
    @Estado = 1;
PRINT '==== FIN SOCIOS - usp_InsertarSocio - Caso positivo ====';
PRINT '';

PRINT '==== SOCIOS - usp_InsertarSocio - Caso negativo ====';
PRINT 'Se espera error: No se puede insertar un socio con número de socio o DNI duplicado (S001, 12345678).';
EXEC socios.usp_InsertarSocio 
    @numero_socio = 'S001',
    @id_usuario = @id_usuario_socio,
    @nombre = 'Juan',
    @apellido = 'Pérez',
    @dni = '12345678',
    @email = 'juan@mail.com',
    @fecha_nacimiento = '2010-05-01',
    @telefono = '1234',
    @telefono_emergencia = '5678',
    @obra_social = 'OSDE',
    @nro_obra_social = 'OS123',
    @tel_emergencia_obra_social = '9999',
    @id_categoria = @id_categoria,
    @responsable_id = NULL,
    @Estado = 1;
PRINT '==== FIN SOCIOS - usp_InsertarSocio - Caso negativo ====';
PRINT '';

-- =====================
-- 6. Insertar Empleado
-- =====================
PRINT '==== USUARIOS - usp_InsertarUsuario (para Empleado) ====';
DECLARE @id_usuario_empleado INT;
EXEC usuarios.usp_InsertarUsuario 
    @usuario = 'empleado1',
    @contraseña = 'pass123',
    @fecha_vigencia_contraseña = '2025-12-31',
    @id_rol = @id_rol;
SELECT @id_usuario_empleado = id_usuario FROM usuarios.Usuario WHERE usuario = 'empleado1';
PRINT '==== FIN USUARIOS - usp_InsertarUsuario (para Empleado) ====';
PRINT '';

PRINT '==== SOCIOS - usp_InsertarEmpleado - Caso positivo ====';
EXEC socios.usp_InsertarEmpleado 
    @id_usuario = @id_usuario_empleado,
    @nombre = 'Ana',
    @apellido = 'García',
    @dni = '87654321',
    @email = 'ana@mail.com';
PRINT '==== FIN SOCIOS - usp_InsertarEmpleado - Caso positivo ====';
PRINT '';

PRINT '==== SOCIOS - usp_InsertarEmpleado - Caso negativo ====';
PRINT 'Se espera error: No se puede insertar un empleado con usuario o DNI duplicado (empleado1, 87654321).';
EXEC socios.usp_InsertarEmpleado 
    @id_usuario = @id_usuario_empleado,
    @nombre = 'Ana',
    @apellido = 'García',
    @dni = '87654321',
    @email = 'ana@mail.com';
PRINT '==== FIN SOCIOS - usp_InsertarEmpleado - Caso negativo ====';
PRINT '';

-- =====================
-- 7. Insertar Actividad
-- =====================
DECLARE @resultado_actividad INT;

PRINT '==== ACTIVIDADES - actividad_insertar - Caso positivo ====';
EXEC actividades.actividad_insertar 
    @nombre = 'Natación',
    @costo_mensual = 2000,
    @fecha_vigencia = '2025-01-01',
    @resultado = @resultado_actividad OUTPUT;
IF @resultado_actividad > 0
    PRINT 'Resultado OK: id_actividad insertado = ' + CAST(@resultado_actividad AS NVARCHAR);
ELSE
    PRINT 'ERROR: resultado = ' + CAST(@resultado_actividad AS NVARCHAR);
PRINT '==== FIN ACTIVIDADES - actividad_insertar - Caso positivo ====';
PRINT '';

PRINT '==== ACTIVIDADES - actividad_insertar - Caso negativo ====';
PRINT 'Se espera error: No se puede insertar una actividad con nombre duplicado (Natación).';
EXEC actividades.actividad_insertar 
    @nombre = 'Natación',
    @costo_mensual = 2000,
    @fecha_vigencia = '2025-01-01',
    @resultado = @resultado_actividad OUTPUT;
IF @resultado_actividad = -1
    PRINT 'Resultado OK: Se detectó nombre duplicado (resultado = -1)';
ELSE
    PRINT 'ERROR: resultado inesperado = ' + CAST(@resultado_actividad AS NVARCHAR);
PRINT '==== FIN ACTIVIDADES - actividad_insertar - Caso negativo ====';
PRINT '';

-- =====================
-- 8. Insertar Clase
-- =====================
DECLARE @id_actividad INT = (SELECT TOP 1 id_actividad FROM actividades.Actividad WHERE nombre = 'Natación');

PRINT '==== ACTIVIDADES - CrearClase - Caso positivo ====';
EXEC actividades.CrearClase 
    @id_actividad = @id_actividad,
    @id_categoria = @id_categoria,
    @dia_semana = 'Lunes',
    @hora_inicio = '10:00',
    @hora_fin = '11:00';
PRINT '==== FIN ACTIVIDADES - CrearClase - Caso positivo ====';
PRINT '';

PRINT '==== ACTIVIDADES - CrearClase - Caso negativo ====';
PRINT 'Se espera error: Hora de inicio mayor o igual a hora de fin (11:00 >= 10:00).';
EXEC actividades.CrearClase 
    @id_actividad = @id_actividad,
    @id_categoria = @id_categoria,
    @dia_semana = 'Lunes',
    @hora_inicio = '11:00',
    @hora_fin = '10:00';
PRINT '==== FIN ACTIVIDADES - CrearClase - Caso negativo ====';
PRINT '';

-- =====================
-- 9. Inscribir Socio en Actividad/Clase
-- =====================
DECLARE @id_socio INT = (SELECT TOP 1 id_socio FROM socios.Socio WHERE nombre = 'Juan');
DECLARE @id_clase INT = (SELECT TOP 1 id_clase FROM actividades.Clase WHERE id_actividad = @id_actividad);

PRINT '==== ACTIVIDADES - InscribirSocioActividad - Caso positivo ====';
EXEC actividades.InscribirSocioActividad 
    @id_socio = @id_socio,
    @id_actividad = @id_actividad,
    @id_clase = @id_clase,
    @fecha_inicio = '2025-05-18';
PRINT '==== FIN ACTIVIDADES - InscribirSocioActividad - Caso positivo ====';
PRINT '';

PRINT '==== ACTIVIDADES - InscribirSocioActividad - Caso negativo ====';
PRINT 'Se espera error: El id_socio no existe (-1).';
EXEC actividades.InscribirSocioActividad 
    @id_socio = -1,
    @id_actividad = @id_actividad,
    @id_clase = @id_clase,
    @fecha_inicio = '2025-05-18';
PRINT '==== FIN ACTIVIDADES - InscribirSocioActividad - Caso negativo ====';
PRINT '';

-- =====================
-- 10. Insertar Factura
-- =====================
PRINT '==== FACTURACION - CrearFactura - Caso positivo ====';
EXEC facturacion.CrearFactura 
    @id_socio = @id_socio,
    @fecha = '2025-05-18',
    @monto_total = 5000,
    @estado = 'Pendiente',
    @fecha_vencimiento = '2025-06-18';
PRINT '==== FIN FACTURACION - CrearFactura - Caso positivo ====';
PRINT '';

PRINT '==== FACTURACION - CrearFactura - Caso negativo ====';
PRINT 'Se espera error: El id_socio no existe (-1).';
EXEC facturacion.CrearFactura 
    @id_socio = -1,
    @fecha = '2025-05-18',
    @monto_total = 5000,
    @estado = 'Pendiente',
    @fecha_vencimiento = '2025-06-18';
PRINT '==== FIN FACTURACION - CrearFactura - Caso negativo ====';
PRINT '';

-- =====================
-- 11. Insertar Pago
-- =====================
DECLARE @id_factura INT = (SELECT TOP 1 id_factura FROM facturacion.Factura WHERE id_socio = @id_socio);

PRINT '==== FACTURACION - spInsertarPago - Caso positivo ====';
EXEC facturacion.spInsertarPago 
    @id_factura = @id_factura,
    @id_detalle = NULL,
    @id_medio = NULL,
    @fecha_pago = '2025-05-18',
    @monto = 5000,
    @tipo = NULL;
PRINT '==== FIN FACTURACION - spInsertarPago - Caso positivo ====';
PRINT '';

PRINT '==== FACTURACION - spInsertarPago - Caso negativo ====';
PRINT 'Se espera error: El id_factura no existe (-1).';
EXEC facturacion.spInsertarPago 
    @id_factura = -1,
    @id_detalle = NULL,
    @id_medio = NULL,
    @fecha_pago = '2025-05-18',
    @monto = 5000,
    @tipo = NULL;
PRINT '==== FIN FACTURACION - spInsertarPago - Caso negativo ====';
PRINT '';
