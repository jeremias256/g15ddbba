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

USE Com2900G15;
GO
-- =============================================
-- SPs de Eliminación - SolNorte
-- Unificado
-- =============================================

-- =============================================
-- 1. usuarios.EliminarRol
-- =============================================
IF OBJECT_ID('usuarios.EliminarRol', 'P') IS NOT NULL DROP PROCEDURE usuarios.EliminarRol;
GO
CREATE PROCEDURE usuarios.EliminarRol
    @id_rol INT
AS
BEGIN
    SET NOCOUNT ON;
    -- Verificar que no existan usuarios con este rol
    IF EXISTS (SELECT 1 FROM usuarios.Usuario WHERE id_rol = @id_rol)
    BEGIN
        RAISERROR('No se puede eliminar el rol porque existen usuarios asociados.', 16, 1);
        RETURN;
    END
    DELETE FROM usuarios.Rol WHERE id_rol = @id_rol;
END
GO

-- =============================================
-- 2. usuarios.EliminarUsuario
-- =============================================
IF OBJECT_ID('usuarios.EliminarUsuario', 'P') IS NOT NULL DROP PROCEDURE usuarios.EliminarUsuario;
GO
CREATE PROCEDURE usuarios.EliminarUsuario
    @id_usuario INT
AS
BEGIN
    SET NOCOUNT ON;
    -- Verificar que no existan socios o empleados con este usuario
    IF EXISTS (SELECT 1 FROM socios.Socio WHERE id_usuario = @id_usuario)
    BEGIN
        RAISERROR('No se puede eliminar el usuario porque está asociado a un socio.', 16, 1);
        RETURN;
    END
    IF EXISTS (SELECT 1 FROM socios.Empleado WHERE id_usuario = @id_usuario)
    BEGIN
        RAISERROR('No se puede eliminar el usuario porque está asociado a un empleado.', 16, 1);
        RETURN;
    END
    DELETE FROM usuarios.Usuario WHERE id_usuario = @id_usuario;
END
GO

-- =============================================
-- 3. socios.EliminarCategoriaSocio
-- =============================================
IF OBJECT_ID('socios.EliminarCategoriaSocio', 'P') IS NOT NULL DROP PROCEDURE socios.EliminarCategoriaSocio;
GO
CREATE PROCEDURE socios.EliminarCategoriaSocio
    @id_categoria INT
AS
BEGIN
    SET NOCOUNT ON;
    -- Verificar que no existan socios con esta categoría
    IF EXISTS (SELECT 1 FROM socios.Socio WHERE id_categoria = @id_categoria)
    BEGIN
        RAISERROR('No se puede eliminar la categoría porque existen socios asociados.', 16, 1);
        RETURN;
    END
    DELETE FROM socios.CategoriaSocio WHERE id_categoria = @id_categoria;
END
GO

-- =============================================
-- 4. socios.EliminarEmpleado
-- =============================================
IF OBJECT_ID('socios.EliminarEmpleado', 'P') IS NOT NULL DROP PROCEDURE socios.EliminarEmpleado;
GO
CREATE PROCEDURE socios.EliminarEmpleado
    @id_empleado INT
AS
BEGIN
    SET NOCOUNT ON;
    -- Verificar que no existan registros dependientes (agregar validaciones si corresponde)
    DELETE FROM socios.Empleado WHERE id_empleado = @id_empleado;
END
GO

-- =============================================
-- 5. socios.EliminarSocio
-- =============================================
IF OBJECT_ID('socios.EliminarSocio', 'P') IS NOT NULL DROP PROCEDURE socios.EliminarSocio;
GO
CREATE PROCEDURE socios.EliminarSocio
    @id_socio INT
AS
BEGIN
    SET NOCOUNT ON;
    -- Verificar que no existan inscripciones, facturas, etc. asociadas
    IF EXISTS (SELECT 1 FROM actividades.SocioActividad WHERE id_socio = @id_socio)
    BEGIN
        RAISERROR('No se puede eliminar el socio porque tiene inscripciones a actividades.', 16, 1);
        RETURN;
    END
    IF EXISTS (SELECT 1 FROM facturacion.Factura WHERE id_socio = @id_socio)
    BEGIN
        RAISERROR('No se puede eliminar el socio porque tiene facturas asociadas.', 16, 1);
        RETURN;
    END
    DELETE FROM socios.Socio WHERE id_socio = @id_socio;
END
GO

-- =============================================
-- 6. actividades.EliminarActividad
-- =============================================
IF OBJECT_ID('actividades.EliminarActividad', 'P') IS NOT NULL DROP PROCEDURE actividades.EliminarActividad;
GO
CREATE PROCEDURE actividades.EliminarActividad
    @id_actividad INT
AS
BEGIN
    SET NOCOUNT ON;
    -- Verificar que no existan clases o inscripciones asociadas
    IF EXISTS (SELECT 1 FROM actividades.Clase WHERE id_actividad = @id_actividad)
    BEGIN
        RAISERROR('No se puede eliminar la actividad porque tiene clases asociadas.', 16, 1);
        RETURN;
    END
    IF EXISTS (SELECT 1 FROM actividades.SocioActividad WHERE id_actividad = @id_actividad)
    BEGIN
        RAISERROR('No se puede eliminar la actividad porque tiene inscripciones asociadas.', 16, 1);
        RETURN;
    END
    DELETE FROM actividades.Actividad WHERE id_actividad = @id_actividad;
END
GO
