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

-- Pruebas de Store Procedures de Modificación - SolNorte

USE Com2900G15;
GO

-- =====================
-- 1. usuarios.ModificarRol
-- =====================
PRINT '==== usuarios.ModificarRol - Prueba positiva 1 ====';
PRINT '-- Esperado: Modifica nombre y descripción de TestRolA a TestRolA_mod';
DECLARE @id_rolA INT = (SELECT id_rol FROM usuarios.Rol WHERE nombre = N'TestRolA');
EXEC usuarios.ModificarRol @id_rol = @id_rolA, @nombre = N'TestRolA_mod', @descripcion = N'Rol modificado A';
PRINT '==== usuarios.ModificarRol - Prueba positiva 2 ====';
PRINT '-- Esperado: Modifica nombre y descripción de TestRolB a TestRolB_mod';
DECLARE @id_rolB INT = (SELECT id_rol FROM usuarios.Rol WHERE nombre = N'TestRolB');
EXEC usuarios.ModificarRol @id_rol = @id_rolB, @nombre = N'TestRolB_mod', @descripcion = N'Rol modificado B';
PRINT '==== usuarios.ModificarRol - Prueba negativa 1 ====';
PRINT '-- Esperado: Falla por id_rol inexistente (-1)';
EXEC usuarios.ModificarRol @id_rol = -1, @nombre = N'NoExiste', @descripcion = N'No existe';
PRINT '==== usuarios.ModificarRol - Prueba negativa 2 ====';
PRINT '-- Esperado: Falla por nombre duplicado (TestRolA_mod)';
EXEC usuarios.ModificarRol @id_rol = @id_rolB, @nombre = N'TestRolA_mod', @descripcion = N'Duplicado';
PRINT '';

-- =====================
-- 2. usuarios.ModificarUsuario
-- =====================
PRINT '==== usuarios.ModificarUsuario - Prueba positiva 1 ====';
PRINT '-- Esperado: Modifica usuario testuserA a testuserA_mod';
DECLARE @id_userA INT = (SELECT id_usuario FROM usuarios.Usuario WHERE usuario = N'testuserA');
EXEC usuarios.ModificarUsuario @id_usuario = @id_userA, @usuario = N'testuserA_mod', @contraseña = N'passA_mod', @fecha_vigencia_contraseña = '2026-01-01', @id_rol = @id_rolA;
PRINT '==== usuarios.ModificarUsuario - Prueba positiva 2 ====';
PRINT '-- Esperado: Modifica usuario testuserB a testuserB_mod';
DECLARE @id_userB INT = (SELECT id_usuario FROM usuarios.Usuario WHERE usuario = N'testuserB');
EXEC usuarios.ModificarUsuario @id_usuario = @id_userB, @usuario = N'testuserB_mod', @contraseña = N'passB_mod', @fecha_vigencia_contraseña = '2026-01-01', @id_rol = @id_rolB;
PRINT '==== usuarios.ModificarUsuario - Prueba negativa 1 ====';
PRINT '-- Esperado: Falla por id_usuario inexistente (-1)';
EXEC usuarios.ModificarUsuario @id_usuario = -1, @usuario = N'noexiste', @contraseña = N'pass', @fecha_vigencia_contraseña = '2026-01-01', @id_rol = @id_rolA;
PRINT '==== usuarios.ModificarUsuario - Prueba negativa 2 ====';
PRINT '-- Esperado: Falla por nombre de usuario duplicado (testuserA_mod)';
EXEC usuarios.ModificarUsuario @id_usuario = @id_userB, @usuario = N'testuserA_mod', @contraseña = N'pass', @fecha_vigencia_contraseña = '2026-01-01', @id_rol = @id_rolB;
PRINT '';

-- =====================
-- 3. socios.ModificarCategoriaSocio
-- =====================
PRINT '==== socios.ModificarCategoriaSocio - Prueba positiva 1 ====';
PRINT '-- Esperado: Modifica nombre y rango de CatTestA a CatTestA_mod';
DECLARE @id_catA INT = (SELECT id_categoria FROM socios.CategoriaSocio WHERE nombre = N'CatTestA');
EXEC socios.ModificarCategoriaSocio @id_categoria = @id_catA, @nombre = N'CatTestA_mod', @edad_min = 11, @edad_max = 21, @costo_membresia = 150, @fecha_vigencia = '2026-01-01';
PRINT '==== socios.ModificarCategoriaSocio - Prueba positiva 2 ====';
PRINT '-- Esperado: Modifica nombre y rango de CatTestB a CatTestB_mod';
DECLARE @id_catB INT = (SELECT id_categoria FROM socios.CategoriaSocio WHERE nombre = N'CatTestB');
EXEC socios.ModificarCategoriaSocio @id_categoria = @id_catB, @nombre = N'CatTestB_mod', @edad_min = 22, @edad_max = 32, @costo_membresia = 250, @fecha_vigencia = '2026-01-01';
PRINT '==== socios.ModificarCategoriaSocio - Prueba negativa 1 ====';
PRINT '-- Esperado: Falla por id_categoria inexistente (-1)';
EXEC socios.ModificarCategoriaSocio @id_categoria = -1, @nombre = N'NoExiste', @edad_min = 1, @edad_max = 2, @costo_membresia = 1, @fecha_vigencia = '2026-01-01';
PRINT '==== socios.ModificarCategoriaSocio - Prueba negativa 2 ====';
PRINT '-- Esperado: Falla por nombre duplicado (CatTestA_mod)';
EXEC socios.ModificarCategoriaSocio @id_categoria = @id_catB, @nombre = N'CatTestA_mod', @edad_min = 22, @edad_max = 32, @costo_membresia = 250, @fecha_vigencia = '2026-01-01';
PRINT '==== socios.ModificarCategoriaSocio - Prueba negativa 3 ====';
PRINT '-- Esperado: Falla por rango de edad inválido (min>max)';
EXEC socios.ModificarCategoriaSocio @id_categoria = @id_catA, @nombre = N'CatTestA_mod', @edad_min = 50, @edad_max = 10, @costo_membresia = 100, @fecha_vigencia = '2026-01-01';
PRINT '==== socios.ModificarCategoriaSocio - Prueba negativa 4 ====';
PRINT '-- Esperado: Falla por costo negativo';
EXEC socios.ModificarCategoriaSocio @id_categoria = @id_catA, @nombre = N'CatTestA_mod', @edad_min = 10, @edad_max = 20, @costo_membresia = -100, @fecha_vigencia = '2026-01-01';
PRINT '';

-- =====================
-- 4. socios.ModificarSocio
-- =====================
PRINT '==== socios.ModificarSocio - Prueba positiva 1 ====';
PRINT '-- Esperado: Modifica nombre y mail de S1001 a S1001_mod';
DECLARE @id_socioA INT = (SELECT id_socio FROM socios.Socio WHERE numero_socio = N'S1001');
EXEC socios.ModificarSocio @id_socio = @id_socioA, @numero_socio = N'S1001_mod', @id_usuario = 1, @nombre = N'JuanMod', @apellido = N'Perez', @dni = N'12345678', @email = N'juanmod@test.com', @fecha_nacimiento = '2000-01-01', @id_categoria = 1, @Estado = 1;
PRINT '==== socios.ModificarSocio - Prueba positiva 2 ====';
PRINT '-- Esperado: Modifica nombre y mail de S1002 a S1002_mod';
DECLARE @id_socioB INT = (SELECT id_socio FROM socios.Socio WHERE numero_socio = N'S1002');
EXEC socios.ModificarSocio @id_socio = @id_socioB, @numero_socio = N'S1002_mod', @responsable_id = 1, @nombre = N'MariaMod', @apellido = N'Gomez', @dni = N'87654321', @email = N'mariamod@test.com', @fecha_nacimiento = '2010-01-01', @id_categoria = 1, @Estado = 1;
PRINT '==== socios.ModificarSocio - Prueba negativa 1 ====';
PRINT '-- Esperado: Falla por id_socio inexistente (-1)';
EXEC socios.ModificarSocio @id_socio = -1, @numero_socio = N'NoExiste', @id_usuario = 1, @nombre = N'NoExiste', @apellido = N'NoExiste', @dni = N'00000000', @email = N'noexiste@test.com', @fecha_nacimiento = '2000-01-01', @id_categoria = 1, @Estado = 1;
PRINT '==== socios.ModificarSocio - Prueba negativa 2 ====';
PRINT '-- Esperado: Falla por numero_socio duplicado (S1001_mod)';
EXEC socios.ModificarSocio @id_socio = @id_socioB, @numero_socio = N'S1001_mod', @responsable_id = 1, @nombre = N'MariaMod', @apellido = N'Gomez', @dni = N'87654321', @email = N'mariamod@test.com', @fecha_nacimiento = '2010-01-01', @id_categoria = 1, @Estado = 1;
PRINT '';

-- =====================
-- 5. socios.ModificarEmpleado
-- =====================
PRINT '==== socios.ModificarEmpleado - Prueba positiva 1 ====';
PRINT '-- Esperado: Modifica nombre y mail de EmpleadoA a EmpleadoA_mod';
DECLARE @id_empA INT = (SELECT id_empleado FROM socios.Empleado WHERE nombre = N'EmpleadoA');
EXEC socios.ModificarEmpleado @id_empleado = @id_empA, @id_usuario = 1, @nombre = N'EmpleadoA_mod', @apellido = N'ApellidoA', @dni = N'11111111', @email = N'empA_mod@test.com';
PRINT '==== socios.ModificarEmpleado - Prueba positiva 2 ====';
PRINT '-- Esperado: Modifica nombre y mail de EmpleadoB a EmpleadoB_mod';
DECLARE @id_empB INT = (SELECT id_empleado FROM socios.Empleado WHERE nombre = N'EmpleadoB');
EXEC socios.ModificarEmpleado @id_empleado = @id_empB, @id_usuario = 2, @nombre = N'EmpleadoB_mod', @apellido = N'ApellidoB', @dni = N'22222222', @email = N'empB_mod@test.com';
PRINT '==== socios.ModificarEmpleado - Prueba negativa 1 ====';
PRINT '-- Esperado: Falla por id_empleado inexistente (-1)';
EXEC socios.ModificarEmpleado @id_empleado = -1, @id_usuario = 1, @nombre = N'NoExiste', @apellido = N'NoExiste', @dni = N'00000000', @email = N'noexiste@test.com';
PRINT '==== socios.ModificarEmpleado - Prueba negativa 2 ====';
PRINT '-- Esperado: Falla por id_usuario duplicado (1)';
EXEC socios.ModificarEmpleado @id_empleado = @id_empB, @id_usuario = 1, @nombre = N'EmpleadoB_mod', @apellido = N'ApellidoB', @dni = N'22222222', @email = N'empB_mod@test.com';
PRINT '==== socios.ModificarEmpleado - Prueba negativa 3 ====';
PRINT '-- Esperado: Falla por dni duplicado (11111111)';
EXEC socios.ModificarEmpleado @id_empleado = @id_empB, @id_usuario = 2, @nombre = N'EmpleadoB_mod', @apellido = N'ApellidoB', @dni = N'11111111', @email = N'empB_mod@test.com';
PRINT '';

-- =====================
-- 6. actividades.ModificarActividad
-- =====================
PRINT '==== actividades.ModificarActividad - Prueba positiva 1 ====';
PRINT '-- Esperado: Modifica nombre y costo de NatacionA a NatacionA_mod';
DECLARE @id_actA INT = (SELECT id_actividad FROM actividades.Actividad WHERE nombre = N'NatacionA');
EXEC actividades.ModificarActividad @id_actividad = @id_actA, @nombre = N'NatacionA_mod', @costo_mensual = 2100;
PRINT '==== actividades.ModificarActividad - Prueba positiva 2 ====';
PRINT '-- Esperado: Modifica nombre y costo de NatacionB a NatacionB_mod';
DECLARE @id_actB INT = (SELECT id_actividad FROM actividades.Actividad WHERE nombre = N'NatacionB');
EXEC actividades.ModificarActividad @id_actividad = @id_actB, @nombre = N'NatacionB_mod', @costo_mensual = 2600;
PRINT '==== actividades.ModificarActividad - Prueba negativa 1 ====';
PRINT '-- Esperado: Falla por id_actividad inexistente (-1)';
EXEC actividades.ModificarActividad @id_actividad = -1, @nombre = N'NoExiste', @costo_mensual = 1000;
PRINT '==== actividades.ModificarActividad - Prueba negativa 2 ====';
PRINT '-- Esperado: Falla por nombre duplicado (NatacionA_mod)';
EXEC actividades.ModificarActividad @id_actividad = @id_actB, @nombre = N'NatacionA_mod', @costo_mensual = 2600;
PRINT '';
