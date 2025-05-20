-- Enunciado: Entrega 4- Documento de instalación y configuración
-- Fecha de entrega: 19/05/2025
-- Comisión: 2900
-- Grupo: 15
-- Materia: Bases de Datos Aplicada
-- Integrantes:
--   - Yerimen Lombardo - DNI 42115925
--   - Jeremias Menacho - DNI 37783029
--   - Ivan Morales     - DNI 39772619
--   - Nicolas Pioli    - DNI 43781515

-- Pruebas de Store Procedures de Inserción - SolNorte

USE Com2900G15;
GO

-- =====================
-- 1. usuarios.InsertarRol
-- =====================
PRINT '==== usuarios.InsertarRol - Prueba positiva 1 ====';
PRINT '-- Esperado: Inserta rol "TestRolA" correctamente';
EXEC usuarios.InsertarRol @nombre = N'TestRolA', @descripcion = N'Rol de prueba A';
PRINT '==== usuarios.InsertarRol - Prueba positiva 2 ====';
PRINT '-- Esperado: Inserta rol "TestRolB" correctamente';
EXEC usuarios.InsertarRol @nombre = N'TestRolB', @descripcion = N'Rol de prueba B';

PRINT '==== usuarios.InsertarRol - Prueba negativa 1 ====';
PRINT '-- Esperado: Falla por nombre duplicado (TestRolA)';
EXEC usuarios.InsertarRol @nombre = N'TestRolA', @descripcion = N'Duplicado';
PRINT '==== usuarios.InsertarRol - Prueba negativa 2 ====';
PRINT '-- Esperado: Falla por nombre NULL';
EXEC usuarios.InsertarRol @nombre = NULL, @descripcion = N'Nombre nulo';
PRINT '';

-- =====================
-- 2. usuarios.InsertarUsuario
-- =====================
PRINT '==== usuarios.InsertarUsuario - Prueba positiva 1 ====';
PRINT '-- Esperado: Inserta usuario "testuserA" correctamente';
EXEC usuarios.InsertarUsuario @usuario = N'testuserA', @contraseña = N'passA', @fecha_vigencia_contraseña = '2025-12-31', @id_rol = 1;
PRINT '==== usuarios.InsertarUsuario - Prueba positiva 2 ====';
PRINT '-- Esperado: Inserta usuario "testuserB" correctamente';
EXEC usuarios.InsertarUsuario @usuario = N'testuserB', @contraseña = N'passB', @fecha_vigencia_contraseña = '2025-12-31', @id_rol = 2;
PRINT '==== usuarios.InsertarUsuario - Prueba negativa 1 ====';
PRINT '-- Esperado: Falla por usuario duplicado (testuserA)';
EXEC usuarios.InsertarUsuario @usuario = N'testuserA', @contraseña = N'passC', @fecha_vigencia_contraseña = '2025-12-31', @id_rol = 1;
PRINT '==== usuarios.InsertarUsuario - Prueba negativa 2 ====';
PRINT '-- Esperado: Falla por id_rol inexistente (9999)';
EXEC usuarios.InsertarUsuario @usuario = N'testuserC', @contraseña = N'passD', @fecha_vigencia_contraseña = '2025-12-31', @id_rol = 9999;
PRINT '';

-- =====================
-- 3. socios.InsertarCategoriaSocio
-- =====================
DECLARE @res INT;
PRINT '==== socios.InsertarCategoriaSocio - Prueba positiva 1 ====';
PRINT '-- Esperado: Inserta categoría "CatTestA" correctamente';
EXEC socios.InsertarCategoriaSocio @nombre = N'CatTestA', @edad_min = 10, @edad_max = 20, @costo_membresia = 100, @fecha_vigencia = '2025-01-01', @resultado = @res OUTPUT;
PRINT 'Resultado: ' + CAST(@res AS NVARCHAR);
PRINT '==== socios.InsertarCategoriaSocio - Prueba positiva 2 ====';
PRINT '-- Esperado: Inserta categoría "CatTestB" correctamente';
EXEC socios.InsertarCategoriaSocio @nombre = N'CatTestB', @edad_min = 21, @edad_max = 30, @costo_membresia = 200, @fecha_vigencia = '2025-01-01', @resultado = @res OUTPUT;
PRINT 'Resultado: ' + CAST(@res AS NVARCHAR);
PRINT '==== socios.InsertarCategoriaSocio - Prueba negativa 1 ====';
PRINT '-- Esperado: Falla por edad inválida (min>max)';
EXEC socios.InsertarCategoriaSocio @nombre = N'CatTestC', @edad_min = 40, @edad_max = 30, @costo_membresia = 100, @fecha_vigencia = '2025-01-01', @resultado = @res OUTPUT;
PRINT 'Resultado: ' + CAST(@res AS NVARCHAR);
PRINT '==== socios.InsertarCategoriaSocio - Prueba negativa 2 ====';
PRINT '-- Esperado: Falla por nombre duplicado (CatTestA)';
EXEC socios.InsertarCategoriaSocio @nombre = N'CatTestA', @edad_min = 10, @edad_max = 20, @costo_membresia = 100, @fecha_vigencia = '2025-01-01', @resultado = @res OUTPUT;
PRINT 'Resultado: ' + CAST(@res AS NVARCHAR);
PRINT '';

-- =====================
-- 4. socios.InsertarSocio
-- =====================
PRINT '==== socios.InsertarSocio - Prueba positiva 1 ====';
PRINT '-- Esperado: Inserta socio "S1001" con id_usuario correctamente';
EXEC socios.InsertarSocio @numero_socio = N'S1001', @id_usuario = 1, @nombre = N'Juan', @apellido = N'Perez', @dni = N'12345678', @email = N'juan@test.com', @fecha_nacimiento = '2000-01-01', @id_categoria = 1, @Estado = 1;
PRINT '==== socios.InsertarSocio - Prueba positiva 2 ====';
PRINT '-- Esperado: Inserta socio "S1002" con responsable_id correctamente';
EXEC socios.InsertarSocio @numero_socio = N'S1002', @responsable_id = 1, @nombre = N'Maria', @apellido = N'Gomez', @dni = N'87654321', @email = N'maria@test.com', @fecha_nacimiento = '2010-01-01', @id_categoria = 1, @Estado = 1;
PRINT '==== socios.InsertarSocio - Prueba negativa 1 ====';
PRINT '-- Esperado: Falla por ambos id_usuario y responsable_id NULL';
EXEC socios.InsertarSocio @numero_socio = N'S1003', @nombre = N'Error', @apellido = N'Null', @dni = N'00000000', @email = N'err@test.com', @fecha_nacimiento = '2010-01-01', @id_categoria = 1, @Estado = 1;
PRINT '==== socios.InsertarSocio - Prueba negativa 2 ====';
PRINT '-- Esperado: Falla por ambos id_usuario y responsable_id NO NULL';
EXEC socios.InsertarSocio @numero_socio = N'S1004', @id_usuario = 1, @responsable_id = 1, @nombre = N'Error', @apellido = N'Doble', @dni = N'00000001', @email = N'err2@test.com', @fecha_nacimiento = '2010-01-01', @id_categoria = 1, @Estado = 1;
PRINT '';

-- =====================
-- 5. socios.InsertarEmpleado
-- =====================
PRINT '==== socios.InsertarEmpleado - Prueba positiva 1 ====';
PRINT '-- Esperado: Inserta empleado "EmpleadoA" correctamente';
EXEC socios.InsertarEmpleado @id_usuario = 1, @nombre = N'EmpleadoA', @apellido = N'ApellidoA', @dni = N'11111111', @email = N'empA@test.com';
PRINT '==== socios.InsertarEmpleado - Prueba positiva 2 ====';
PRINT '-- Esperado: Inserta empleado "EmpleadoB" correctamente';
EXEC socios.InsertarEmpleado @id_usuario = 2, @nombre = N'EmpleadoB', @apellido = N'ApellidoB', @dni = N'22222222', @email = N'empB@test.com';
PRINT '==== socios.InsertarEmpleado - Prueba negativa 1 ====';
PRINT '-- Esperado: Falla por id_usuario inexistente (9999)';
EXEC socios.InsertarEmpleado @id_usuario = 9999, @nombre = N'EmpleadoC', @apellido = N'ApellidoC', @dni = N'33333333', @email = N'empC@test.com';
PRINT '==== socios.InsertarEmpleado - Prueba negativa 2 ====';
PRINT '-- Esperado: Falla por email NULL';
EXEC socios.InsertarEmpleado @id_usuario = 1, @nombre = N'EmpleadoD', @apellido = N'ApellidoD', @dni = N'44444444', @email = NULL;
PRINT '';

-- =====================
-- 6. actividades.InsertarActividad
-- =====================
DECLARE @resultado_actividad INT;
PRINT '==== actividades.InsertarActividad - Prueba positiva 1 ====';
PRINT '-- Esperado: Inserta actividad "NatacionA" correctamente';
EXEC actividades.InsertarActividad @nombre = N'NatacionA', @costo_mensual = 2000, @fecha_vigencia = '2025-01-01', @resultado = @resultado_actividad OUTPUT;
PRINT 'Resultado: ' + CAST(@resultado_actividad AS NVARCHAR);
PRINT '==== actividades.InsertarActividad - Prueba positiva 2 ====';
PRINT '-- Esperado: Inserta actividad "NatacionB" correctamente';
EXEC actividades.InsertarActividad @nombre = N'NatacionB', @costo_mensual = 2500, @fecha_vigencia = '2025-01-01', @resultado = @resultado_actividad OUTPUT;
PRINT 'Resultado: ' + CAST(@resultado_actividad AS NVARCHAR);
PRINT '==== actividades.InsertarActividad - Prueba negativa 1 ====';
PRINT '-- Esperado: Falla por nombre duplicado (NatacionA)';
EXEC actividades.InsertarActividad @nombre = N'NatacionA', @costo_mensual = 2000, @fecha_vigencia = '2025-01-01', @resultado = @resultado_actividad OUTPUT;
PRINT 'Resultado: ' + CAST(@resultado_actividad AS NVARCHAR);
PRINT '==== actividades.InsertarActividad - Prueba negativa 2 ====';
PRINT '-- Esperado: Falla por costo negativo';
EXEC actividades.InsertarActividad @nombre = N'NatacionC', @costo_mensual = -100, @fecha_vigencia = '2025-01-01', @resultado = @resultado_actividad OUTPUT;
PRINT 'Resultado: ' + CAST(@resultado_actividad AS NVARCHAR);
PRINT '';