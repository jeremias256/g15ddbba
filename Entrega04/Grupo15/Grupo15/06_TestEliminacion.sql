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

-- =============================================
-- Pruebas de SPs de Eliminación - SolNorte
-- =============================================

USE Com2900G15;
GO

-- 1. Prueba usuarios.EliminarRol
PRINT '==== usuarios.EliminarRol - Prueba negativa (rol con usuarios asociados) ====';
EXEC usuarios.EliminarRol @id_rol = 1; -- Debe fallar si hay usuarios asociados
PRINT '==== usuarios.EliminarRol - Prueba positiva ====';
EXEC usuarios.EliminarRol @id_rol = 9999; -- Debe eliminar si existe y no tiene usuarios asociados
PRINT '';

-- 2. Prueba usuarios.EliminarUsuario
PRINT '==== usuarios.EliminarUsuario - Prueba negativa (usuario asociado a socio o empleado) ====';
EXEC usuarios.EliminarUsuario @id_usuario = 1; -- Debe fallar si está asociado
PRINT '==== usuarios.EliminarUsuario - Prueba positiva ====';
EXEC usuarios.EliminarUsuario @id_usuario = 9999; -- Debe eliminar si no está asociado
PRINT '';

-- 3. Prueba socios.EliminarCategoriaSocio
PRINT '==== socios.EliminarCategoriaSocio - Prueba negativa (categoría con socios asociados) ====';
EXEC socios.EliminarCategoriaSocio @id_categoria = 1; -- Debe fallar si hay socios asociados
PRINT '==== socios.EliminarCategoriaSocio - Prueba positiva ====';
EXEC socios.EliminarCategoriaSocio @id_categoria = 9999; -- Debe eliminar si no tiene socios asociados
PRINT '';

-- 4. Prueba socios.EliminarEmpleado
PRINT '==== socios.EliminarEmpleado - Prueba positiva ====';
EXEC socios.EliminarEmpleado @id_empleado = 9999; -- Debe eliminar si existe
PRINT '';

-- 5. Prueba socios.EliminarSocio
PRINT '==== socios.EliminarSocio - Prueba negativa (socio con inscripciones o facturas) ====';
EXEC socios.EliminarSocio @id_socio = 1; -- Debe fallar si tiene inscripciones/facturas
PRINT '==== socios.EliminarSocio - Prueba positiva ====';
EXEC socios.EliminarSocio @id_socio = 9999; -- Debe eliminar si no tiene dependencias
PRINT '';

-- 6. Prueba actividades.EliminarActividad
PRINT '==== actividades.EliminarActividad - Prueba negativa (actividad con clases o inscripciones) ====';
EXEC actividades.EliminarActividad @id_actividad = 1; -- Debe fallar si tiene dependencias
PRINT '==== actividades.EliminarActividad - Prueba positiva ====';
EXEC actividades.EliminarActividad @id_actividad = 9999; -- Debe eliminar si no tiene dependencias
PRINT '';
